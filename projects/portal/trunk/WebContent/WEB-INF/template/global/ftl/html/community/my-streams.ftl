<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
						
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.modernizr.custom.js',				
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],
			complete: function() {			
			
				common.ui.setup({
					features:{
						backstretch : true
					}
				});
				var currentUser = new User();		
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if action.isAllowedSignIn() ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);
					},				
					shown : function(e){							
						createConnectedSocialNav();	
					}
				});										
				preparePersonalizedArea($("#personalized-area"), 3, 6 );				
				createInfoPanel();
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
							var template = kendo.template('<label class="btn btn-primary"><input type="checkbox" value="#:socialAccountId#"><i class="fa fa-#= serviceProviderName #"></i></label>');
							var html = kendo.render(template, this.data());
							myStreams.html(html);						
							common.ui.handleActionEvents( myStreams, {
								handlers : [{
									selector: "input:checkbox",
									event : 'change',
									handler : function(){
										var myStream = myStreams.data( 'dataSource' ).get(this.value);
										if(this.checked){
											displayMediaPanel( myStream );
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
		function mediaEditorSource (media){			
			var modal = $('#media-editor-modal').data("kendoExtModalWindow");			
			if(  typeof media === 'undefined' ){
				if( modal ){
					return modal.data().media
				}else{
					return new SocialNetwork();
				}
			}else{
				if( modal ){
					media.copy( modal.data().media);
				}
			}
		}
				
		function displayMediaPanel(media){				
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.panel({ 
				appendTo: appendTo,
				title: "<i class='fa fa-" + media.serviceProviderName + " fa-fw'></i>" + media.serviceProviderName , 
				actions:["Custom", "Minimize", "Refresh", "Close"],
				data: media,
				template: kendo.template("<ul class='media-list'></ul>"),
				close: function(e) {
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("disabled");	
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("active");	
				},
				refresh: function(e){
					var streams = e.target.element.find(".panel-body ul.media-list");
					if( streams.length > 0 && streams.data('kendoExtMediaStreamView') ){
						streams.data('kendoExtMediaStreamView').dataSource.read();
					}
				},
				custom: function(e){
					var modal = common.ui.modal({
						renderTo : "media-editor-modal",
						data: new kendo.data.ObservableObject({
							media : mediaEditorSource(),
							scrollable:false
						}),
						open: function(e){			
							var renderTo = e.target.element;
							var grid = renderTo.find(".modal-body .media-props-grid");		
							var scrollable =  renderTo.find(".modal-body input[name='options-scrollable']");
							if( grid.length > 0 && !grid.data('kendoGrid') ){	
								
								scrollable.on("change", function(e){
									var isSlimscroll = panel.element.find(".panel-body").parent().hasClass("slimScrollDiv");									
									if( this.value == 1 && !isSlimscroll ){									
										panel.element.find(".panel-body").slimscroll({ height: "500px"});
									}else if ( this.value == 0 && isSlimscroll ){
										panel.element.find(".panel-body").slimscroll({ destroy:"destroy" });										
									}
								});							
																	
								grid.kendoGrid({
									dataSource : {		
										transport: { 
											read: { url:'/community/get-my-socialnetwork-property.do?output=json', type:'post' },
											create: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post' },
											update: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post'  },
											destroy: { url:'/community/delete-my-socialnetwork-property.do?output=json', type:'post' },
											parameterMap: function (options, operation){			
										 		if (operation !== "read" && options.models) {
										 			return { socialNetworkId: mediaEditorSource().socialAccountId, items: kendo.stringify(options.models)};
												} 
												return { socialNetworkId: mediaEditorSource().socialAccountId }				
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
									autoBind: false,
									toolbar: [
										{ name: "create", text: "추가" },
										{ name: "save", text: "저장" },
										{ name: "cancel", text: "취소" }
									],				     
									change: function(e) {
									}
								});		
							}
							grid.data('kendoGrid').dataSource.read();
						},
						template: kendo.template($("#media-editor-modal-template").html())
					});
					
					if( common.api.property( e.target.data().properties, "options.scrollable", false ) ){
						modal.data().set("scrollable", 1);
					}else{
						modal.data().set("scrollable", 0);
					}
					mediaEditorSource( e.target.data() );					
					modal.open();							
				},
				open: function(e){					
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("disabled");					
					var streams = e.target.element.find(".panel-body ul.media-list");
					if( streams.length > 0 && !streams.data('kendoExtMediaStreamView') ){
						streams.extMediaStreamView({
							id:  e.target.data().socialAccountId,
							media: e.target.data().serviceProviderName,
							change : function(e){		
								streams.find('button.custom-upload-by-url').click(function(e){
									var btn = $(this) ;
									btn.parent().toggleClass('active');
									btn.button('loading');
									common.api.uploadMyImageByUrl({
										data : {sourceUrl: btn.attr('data-source'), imageUrl: btn.attr('data-url')} ,
										success : function(response){
											btn.attr("disabled", "disabled");
											btn.addClass('hide');
										},
										always : function(){
											btn.parent().toggleClass('active');
											btn.button('reset');
										}
									});
								});								
							}
						});
					}
				}
			});			
		}
		
		
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
									$( '#'+ renderToString2 ).find('button.custom-upload-by-url').click(function(e){
										var btn = $(this) ;
										btn.parent().toggleClass('active');
										btn.button('loading');
										common.api.uploadMyImageByUrl({
											data : {sourceUrl: btn.attr('data-source'), imageUrl: btn.attr('data-url')} ,
											success : function(response){
												btn.attr("disabled", "disabled");
												btn.addClass('hide');
											},
											always : function(){
												btn.parent().toggleClass('active');
												btn.button('reset');
											}
										});
							
						});
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
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var renderTo = common.api.guid();
			appendTo.extAlert({
				template :  kendo.template($("#alert-panel-template").html()),
				data : { id: renderTo },
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
	<body id="doc" class="bg-dark">
		<div class="wrapper">
		<!-- START HEADER -->		
		<#include "/html/common/common-homepage-menu.ftl" >		
		<!-- END HEADER -->	
		<!-- START MAIN CONTENT -->
			
			<div class="container"> 
				<div class="col-xs-5 col-xs-offset-7 col-sm-6 col-sm-offset-6 no-padding-hr">
					<div class="navbar navbar-personalized navbar-inverse" role="navigation">
						<ul class="nav navbar-nav pull-right">
							<li class="hidden-xs">
								<p class="navbar-text">레이아웃</p>
								<div class="btn-group navbar-btn" data-toggle="buttons">
									<label class="btn btn-info">
										<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
									</label>
									<label class="btn btn-info active">
								 		<input type="radio" name="personalized-area-col-size" value="6"> <i class="fa fa-th-large"></i>
									</label>
									<label class="btn btn-info">
										<input type="radio" name="personalized-area-col-size" value="4"> <i class="fa fa-th"></i>
									</label>
								</div>
							</li> 
							<li>
								<div id="navbar-btn-my-streams" class="navbar-btn btn-group" data-toggle="buttons">
									<button type="button" class="btn btn-primary" data-action="media-list" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>미디어</button>
								</div>
							</li>		
						</ul>
					</div><!-- ./navbar -->
				</div><!-- ./col-sm-6 col-sm-offset-6 -->
			</div><!-- ./container -->					
			<div class="container-fluid padding-sm" style="min-height:600px;">		
				<div id="personalized-area" class="row"></div>				
			</div>			
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->
		</div>						
		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="alert-panel-template">
				<div  id="#: id #" data-alert class="alert alert-info" style="min-height:50px; display:none;">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					<p> 상단 메뉴에서 <i class="fa fa-briefcase fa-lg"></i> 버튼을 클릭하면 연결된 미디어 목록을 확인할 수 있습니다.</p>				
					<p><small>새로운 쇼셜 미디어 연결은 프로필 보기의 쇼셜네트워크 탭에서 지원합니다.</small></p>
					<p><a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-info btn-sm" data-toggle="modal" data-target="\\#myProfileModal">프로필 보기</a></p>
				</div>
		</script>								
		<#include "/html/common/common-homepage-templates.ftl" >		
		<#include "/html/common/common-social-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>