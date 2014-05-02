<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!${request.contextPath}/styles/codedrop/cbpSlidePushMenus.css',
			'css!${request.contextPath}/styles/codedrop/codedrop.overlay.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/pdfobject/pdfobject.js',
			'${request.contextPath}/js/common/common.modernizr.custom.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'],
			complete: function() {			
			
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
				
				// 2.  MEUN LOADING ...
				var slide_effect = kendo.fx($("body div.overlay")).fadeIn();
				$("#personalized-area").data("sizePlaceHolder", { oldValue: 6 , newValue : 6} );	
				
				common.ui.handleActionEvents( $('.personalized-navbar'), {
					handlers : [
						{ selector: "input[name='personalized-area-col-size']",
						  event : 'change',
						  handler : function(){
							var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
							grid_col_size.oldValue = grid_col_size.newValue;
							grid_col_size.newValue = this.value;			
							$(".custom-panels-group").each(function( index ) {
								var custom_panels_group = $(this);				
								custom_panels_group.removeClass("col-sm-" + grid_col_size.oldValue );		
								custom_panels_group.addClass("col-sm-" + grid_col_size.newValue );		
							});
						  }	
						}
					]
				});	
											
				$('.personalized-navbar .nav a.btn-link').click(function(e){
					if( $(this).hasClass('custom-nabvar-hide')){						
						$('body nav').first().removeClass('hide');						
					}else if ($(this).hasClass('custom-nabvar-show-opts')){ 
						$('body').toggleClass('modal-open');						
						if( $('#personalized-controls-section').hasClass("hide") )
							$('#personalized-controls-section').removeClass("hide");							
						$('body div.overlay').toggleClass('hide');							
						slide_effect.play().then(function(){							
							$('#personalized-controls-section').toggleClass('cbp-spmenu-open');
						});	
					}				
				});
				
				$("#personalized-controls-menu-close").on( "click" , function(e){						
					$('body').toggleClass('modal-open');		
					$('#personalized-controls-section').toggleClass('cbp-spmenu-open');					
					setTimeout(function() {
						slide_effect.reverse().then(function(){
							$('body div.overlay').toggleClass('hide');
						});
					}, 100);					
				});

				// 3. ACCOUNTS STATUS LOAD	.. 
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if WebSiteUtils.isAllowedSignIn(action.webSite) ||  !action.user.anonymous>
					template : kendo.template($("#account-template").html()),
					</#if>
					shown : function(e){
						$('#account-navbar').append('<li><a href="#" class="btn btn-link custom-nabvar-hide"><i class="fa fa-angle-double-down fa-lg"></i></a></li>');
						$('#account-navbar').append('<p class="navbar-text hidden-xs">&nbsp;</p>');		
						$('#account-navbar li a.custom-nabvar-hide').on('click', function(){
							$('body nav').first().addClass('hide');
						});	
					},					
					authenticate : function( e ){
						e.token.copy(currentUser);
						if(!currentUser.anonymous){							
							$('body nav').first().addClass('hide');
							createConnectedSocialNav();
						}						
					}				
				});

				// 4. CONTENT LOADING
				createInfoPanel();
				// END SCRIPT 
			}
		}]);	

		<!-- ============================== -->
		<!-- create media streams nav buttons                -->
		<!-- ============================== -->				
		function createConnectedSocialNav(){				
			var myStreams = $('#navbar-btn-my-streams');
			myStreams.find('button[data-action="media-list"]').button('loading');				
			if( myStreams.find('input').length == 0 ){
				myStreams.data( 'dataSource', 
					common.api.social.dataSource({ 
						type : 'list',
						dataBound: function(e){
							myStreams.find('button[data-action="media-list"]').button('reset');
						},
						change : function ( e ) {
							var template = kendo.template('<label class="btn btn-info"><input type="checkbox" value="#:socialAccountId#"><i class="fa fa-#= serviceProviderName #"></i></label>');
							var html = kendo.render(template, this.data());
							myStreams.html(html);						
							common.ui.handleActionEvents( myStreams, {
								handlers : [{
									selector: "input:checkbox",
									event : 'change',
									handler : function(){
										var myStream = myStreams.data( 'dataSource' ).get(this.value);
										if(this.checked){
											displayMediaStream( myStream );
										}else{
											closeMediaStream( myStream );
										}
									}	
								}]
							});
						}
					})
				);				
			}							
		}	
		<!-- ============================== -->
		<!-- display media stream panel                        -->
		<!-- ============================== -->		
		function displayMediaStream(streamsPlaceHolder){					
			var renderToString =  streamsPlaceHolder.serviceProviderName + "-panel-" + streamsPlaceHolder.socialAccountId ;
			var renderToString2 =  streamsPlaceHolder.serviceProviderName + "-streams-" + streamsPlaceHolder.socialAccountId ;				
			if( $("#" + renderToString ).length == 0  ){
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template($("#social-view-panel-template").html());
				$("#personalized-area").append( template( streamsPlaceHolder ) );
				$( '#'+ renderToString ).parent().addClass("col-sm-" + grid_col_size.newValue );	
				common.api.handlePanelHeaderActions( $( '#'+ renderToString), {
					custom : true,
					refresh : function(){
						$( '#'+ renderToString2 ).data('kendoExtMediaStreamView').dataSource.read();
					},
					close : function(){
						$('#navbar-btn-my-streams').find('input[value="' + streamsPlaceHolder.socialAccountId + '"]').click();				
					}
				} );	
								
				if(! common.api.property(streamsPlaceHolder.properties, "options.scrollable", true ) ){					
					$("#" + renderToString).find(".panel-body:first input[name='options-scrollable']:last").click();
				}
				
				$( '#'+ renderToString2 ).extMediaStreamView({ 
					id: streamsPlaceHolder.socialAccountId, 
					media: streamsPlaceHolder.serviceProviderName,
					change : function(e){
						alert($(this).html()); 					
					}
				});				
				
				if( ! $( "#" + renderToString + "-prop-grid" ).data("kendoGrid") ){
					$( "#" + renderToString + "-prop-grid").kendoGrid({
						dataSource : {		
							transport: { 
								read: { url:'/community/get-my-socialnetwork-property.do?output=json', type:'post' },
								create: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post' },
								update: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post'  },
								destroy: { url:'/community/delete-my-socialnetwork-property.do?output=json', type:'post' },
						 		parameterMap: function (options, operation){			
							 		if (operation !== "read" && options.models) {
							 			return { socialNetworkId: $( '#'+ renderToString2 ).data('kendoExtMediaStreamView').id(), items: kendo.stringify(options.models)};
									} 
									return {socialNetworkId :$( '#'+ renderToString2 ).data('kendoExtMediaStreamView').id() }
									}
								},						
								batch: true, 
								schema: {
									data: "socialNetworkProperties",
									model: Property
								},
								error:common.api.handleKendoAjaxError
							},
							columns: [
								{ title: "속성", field: "name" },
								{ title: "값",   field: "value" },
								{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
							],
							pageable: false,
							resizable: true,
							editable : true,
							scrollable: true,
							height: 180,
							toolbar: [
								{ name: "create", text: "추가" },
								{ name: "save", text: "저장" },
								{ name: "cancel", text: "취소" }
							],				     
							change: function(e) {
							}
					});
				}
			}
			kendo.fx($( '#'+ renderToString ).parent()).zoom("in").startValue(0).endValue(1).play();			
		}
				
		function closeMediaStream(streamsPlaceHolder){		
			var renderToString =  streamsPlaceHolder.serviceProviderName + "-panel-" + streamsPlaceHolder.socialAccountId ;
			kendo.fx($( '#'+ renderToString ).parent()).zoom("in").startValue(0).endValue(1).reverse().then( function(e){
				$("#" + renderToString ).parent().remove();
			});							
		}

		<!-- ============================== -->
		<!-- create info alert 										-->
		<!-- ============================== -->							
		function createInfoPanel(){					
			var renderTo = common.api.guid();
			var grid_col_size = $("#personalized-area").data("sizePlaceHolder");			
			$("#personalized-area").extAlert({
				template :  kendo.template($("#alert-panel-template").html()),
				data : { id: renderTo, colSize: grid_col_size.newValue },
				close : function () {
					$( '#'+ renderTo ).remove();
				}
			});
			kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).play();		
		}
	
				
		-->
		</script>		
		<style scoped="scoped">

		.k-tiles-arrange label {
			font-weight : normal;		
		}
		.k-tiles li.k-state-selected {
			border-color: #428bca;
		}
		
		.media, .media .media {
			margin-top: 5px;
		}	
	
		.k-callout-n {
		border-bottom-color: #787878;
		}	
				
		.k-callout-w {
			border-right-color: #787878;
		}
		
		.k-callout-e {
		border-left-color: #787878;
		}	
		
		#photo-gallery-view {
			min-height: 320px;
			min-width: 320px;
			width: 100%;
			padding: 0px;
			border: 0px;
		}	
		
		#personalized-controls {
			position: absolute;
			top: 50px;
			left:0;
			min-height: 300px;
			padding: 10px;
			width: 100%;
			z-index: 1000;
			overflow: hidden;
			background-color: rgba(91,192,222,0.8)		
		}		
		
		#personalized-controls-section{
			margin-top: 0px;
			padding : 0px;
		}
		
		#personalized-controls-section.cbp-spmenu-vertical {
			width: 565px;
		}
		
		#personalized-controls-section.cbp-spmenu-right {
			right: -565px;
			z-index: 2000;
		}
		
		#personalized-controls-section.cbp-spmenu-right.cbp-spmenu-open {
			right : 0px;
			overflow-x:hidden;
			overflow-y:auto;			
		}
				
		.personalized-navbar .btn-link:hover {
		  color: #fff;
		  background-color: #47a3da;
		}

		@media (max-width: 768px ) {
			#personalized-controls-section.cbp-spmenu-vertical {
				width: 100%;
			}			
			#personalized-controls-section.cbp-spmenu-right {
				right: -100%;
			}		
		} 
		
		.cbp-spmenu {
			background : #ffffff;
		}
		
		.cbp-spmenu-vertical header {
			1px solid #258ecd;
			margin : 0px;
			padding : 5px;
			color : #000000;
			background : #5bc0de; /* transparent;        	*/
			height: 90px;        	
		}
				
		.cbp-hsmenu-wrapper .cbp-hsmenu {
			width:100%;
		}
		
		.cbp-hsmenu > li > a {
			color: #fff;
			font-size: 1em;
			line-height: 3em;
			display: inline-block;
			position: relative;
			z-index: 10000;
			outline: none;
			text-decoration: none;
		}
		
		blockquote {
			font-size: 11pt;
		}
		
		.panel .comments-heading {
		
		}
		
		.panel .comments-heading a {
			color: #555;
		}
		
		#photo_overlay nav.navbar {
			margin-bottom: 0px; 
		}
		
		</style>   	
	</head>
	<body id="doc" class="bg-gray">
		<!-- START HEADER -->		
		<#include "/html/common/common-homepage-menu.ftl" >		
		<!-- start of personalized menu -->
		<nav class="personalized-navbar navbar" role="navigation">
			<div class="container">
				<ul class="nav navbar-nav navbar-left">				
					<p class="navbar-text hidden-xs">&nbsp;</p>	
					<p class="navbar-text hidden-xs text-primary"><small>스트림 레이아웃</small></p>						
					<li class="navbar-btn hidden-xs">
						<div class="btn-group navbar-btn" data-toggle="buttons">
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
							</label>
							<label class="btn btn-info active">
						 		<input type="radio" name="personalized-area-col-size"  value="6"> <i class="fa fa-th-large"></i>
							</label>
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size"  value="4"> <i class="fa fa-th"></i>
							</label>
						</div>										
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">	
					<li class="navbar-btn">						
						<div id="navbar-btn-my-streams" class="navbar-btn btn-group" data-toggle="buttons">
							<button type="button" class="btn btn-info" data-action="media-list" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>미디어</button>
						</div>
					</li>	
					<p class="navbar-text hidden-xs">&nbsp;</p>		
					<li><a href="${request.contextPath}/main.do?view=personalized" class="btn btn-link">마이 페이지</a></li>						
					<li><a href="#" class="btn btn-link custom-nabvar-show-opts"><i class="fa fa-cog fa-lg"></i></a></li>
					<li><a href="#" class="btn btn-link custom-nabvar-hide"><i class="fa fa-angle-double-up fa-lg"></i></a></li>
					<p class="navbar-text hidden-xs">&nbsp;</p>
				</ul>
			</div>
		</nav>
		<!-- end of personalized menu -->
		<!-- END HEADER -->	
		<!-- START MAIN CONTENT -->
		<section class="container-fluid" style="min-height:600px;">		
			<div id="personalized-area" class="row blank-top-10"></div>				
		</section>		
		<div class="overlay hide"></div>		
		<!-- start side menu -->
		<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right hide"  id="personalized-controls-section">			
			<header>		
				<!--					
				<div class="btn-group">
					<button type="button" class="btn btn-info"><i class="fa fa-cog"></i></button>
					<button type="button" class="btn btn-info"><i class="fa fa-comment"></i></button>
					<button type="button" class="btn btn-info"><i class="fa fa-envelope"></i></button>
				</div>		
				-->
				<button id="personalized-controls-menu-close" type="button" class="btn-close">Close</button>
			</header>					
			<div class="blank-top-5" ></div>				
		</section>		
		<section id="image-broswer" class="image-broswer"></section>	
		<section id="external-content-widow"></section>
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->
		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="alert-panel-template">
			<div id="#: id #" class="custom-panels-group col-sm-#: colSize#" style="min-height:200px; display:none;" data-role="panel">
				<div data-alert class="alert alert-info">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					<p><i class="fa fa-info"></i> 상단 미디어 버튼을 클릭하면 해당 미디어 소식을 볼 수 있습니다.</p>					
					<p><small>새로운 쇼셜 미디어 연결은 프로필 보기의 쇼셜네트워크 탭에서 지원합니다.</small></p>
					<p><a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-info btn-sm" data-toggle="modal" data-target="\\#myProfileModal">프로필 보기</a></p>
				</div>
			</div>
		</script>								
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>