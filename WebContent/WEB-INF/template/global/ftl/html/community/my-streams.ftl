<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.user.company ?? >${action.user.company.displayName }<#else>::</#if></title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!${request.contextPath}/styles/codedrop/cbpSlidePushMenus.css',
			'css!${request.contextPath}/styles/codedrop/codedrop.overlay.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.js',
			'${request.contextPath}/js/kendo/kendo.ko_KR.js',			
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
				common.api.handleNavbarActions( $('.personalized-navbar'), {
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
					],
					onClick : function (e) {												
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
				var currentUser = new User({});			
				var accounts = $("#account-navbar").kendoAccounts({				
					connectorHostname: "${ServletUtils.getLocalHostAddr()}",	
					authenticate : function( e ){
						currentUser = e.token;
						if(!currentUser.anonymous){							
							$('body nav').first().addClass('hide');							
							// trigger connected social media buttons
							createConnectedSocialNav();
						}
					},
					shown : function(e){
						$('#account-navbar').append('<li><a href="#&quot;" class="btn-link custom-nabvar-hide"><img src="${request.contextPath}/images/cross.png" height="18"></a></li>' );	
						$('#account-navbar li a.custom-nabvar-hide').on('click', function(){
							$('body nav').first().addClass('hide');
						});	
					},
					<#if CompanyUtils.isallowedSignIn(action.company) ||  !action.user.anonymous  || action.view! == "personalized" >
					template : kendo.template($("#account-template").html()),
					</#if>
					afterAuthenticate : function(){													
						var validator = $("#login-navbar").kendoValidator({validateOnBlur:false}).data("kendoValidator");						
						$("#login-btn").click( function() { 
							$("#login-status").html("");
							if( validator.validate() )
							{								
								accounts.login({
									data: $("form[name=login-form]").serialize(),
									success : function( response ) {
										var refererUrl = "/main.do";
										if( response.item.referer ){
											refererUrl = response.item.referer;
										}
										$("form[name='login-form']")[0].reset();    
										$("form[name='login-form']").attr("action", refererUrl ).submit();						
									},
									fail : function( response ) {  
										$("#login-password").val("").focus();												
										$("#login-status").kendoAlert({ 
											data : { message: "입력한 사용자 이름 또는 비밀번호가 잘못되었습니다." },
											close : function(){	
												$("#login-password").focus();										
											}
										}); 										
									},		
									error : function( thrownError ) {
										$("form[name='login-form']")[0].reset();                    
										$("#login-status").kendoAlert({ data : { message: "잘못된 접근입니다." } }); 									
									}																
								});															
							}else{	}
						});	
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
			if( myStreams.find('input').length == 0 ){
				myStreams.data( 'dataSource', 
					common.api.social.dataSource({ 
						type : 'list',
						change : function ( e ) {
							var template = kendo.template('<label class="btn btn-info"><input type="checkbox" value="#:socialAccountId#"><i class="fa fa-#= serviceProviderName #"></i></label>');
							var html = kendo.render(template, this.data());
							myStreams.html(html);						
							common.api.handleButtonActions( myStreams, {
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
				if( common.api.property(streamsPlaceHolder.properties, "options.scrollable", true ) ){
					$("#" + renderToString).find(".panel-body:first input[name='options-scrollable']:last").click();
				}
				$( '#'+ renderToString2 ).extMediaStreamView({ id: streamsPlaceHolder.socialAccountId, media: streamsPlaceHolder.serviceProviderName });				
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
				close : function(){
					kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).reverse().then( function(e){							
						$("#" + renderTo ).remove();
					});					
				}
			})			
			kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).play();
		}
		
		<!-- ============================== -->
		<!-- create my photo grid									-->
		<!-- ============================== -->						
		function createPhotoListView(){
			if( !$('#photo-list-view').data('kendoListView') ){
				$("#photo-list-view").kendoListView({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/community/list-my-image.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { imageId :options.imageId };									                            	
											}else{
												 return { startIndex: options.skip, pageSize: options.pageSize }
											}
										}
									},
									pageSize: 12,
									error:common.api.handleKendoAjaxError,
									schema: {
										model: Image,
										data : "targetImages",
										total : "totalTargetImageCount"
									},
									/*sort: { field: "imageId", dir: "desc" },*/
									serverPaging: true
								},
								selectable: "single",									
								change: function(e) {									
									var data = this.dataSource.view() ;
									var current_index = this.select().index();
									var total_index = this.dataSource.view().length -1 ;
									var list_view_pager = $("#photo-list-pager").data("kendoPager");	
									var item = data[current_index];			
									item.manupulate();								
									common.api.pager(item, current_index,total_index, list_view_pager.page(), list_view_pager.totalPages());
									$("#photo-list-view").data( "photoPlaceHolder", item );														
									displayPhotoPanel( ) ;										
								},
								navigatable: false,
								template: kendo.template($("#photo-list-view-template").html()),								
								dataBound: function(e) {;		
								}
							});								
																	
							$("#photo-list-view").on("mouseenter",  ".img-wrapper", function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
								}).on("mouseleave", ".img-wrapper", function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
							});		
																
							$("#photo-list-pager").kendoPager({
								refresh : true,
								buttonCount : 5,
								dataSource : $('#photo-list-view').data('kendoListView').dataSource
							});		
													
							$("#my-photo-stream .btn-group button").each(function( index ) { 
								var control_button = $(this);								
								var control_button_icon = control_button.find("i");				
								if( control_button_icon.hasClass("fa-upload")){
									control_button.click( function(e){			
										if( !$("#photo-files").data("kendoUpload")	){						
											$("#photo-files").kendoUpload({
												 	multiple : true,
												 	width: 300,
												 	showFileList : false,
												    localization:{ select : '사진 선택' , dropFilesHere : '업로드할 사진들을 이곳에 끌어 놓으세요.' },
												    async: {
														saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',							   
														autoUpload: true
												    },
												    upload: function (e) {				
												    	 e.data = {};							
												    },
												    success : function(e) {								    
														if( e.response.targetImage ){
															//e.response.targetImage.imageId;
															// LIST VIEW REFRESH...
															var photo_list_view = $('#photo-list-view').data('kendoListView');
															photo_list_view.dataSource.read();
															var selectedCells = photo_list_view.select();
															photo_list_view.select("tr:eq(1)");															
														}				
													}
											});		
										}										
										$("#my-photo-stream .side1").toggleClass("hide");										
										$("#my-photo-stream .side2").toggleClass("hide");										
									});									
								}else if (control_button_icon.hasClass("fa-th-list")){
									control_button.click( function(e){		
										$("#my-photo-stream .side1").toggleClass("hide");										
										$("#my-photo-stream .side2").toggleClass("hide");										
									});								
								}								
				});
			}
		}
		

		<!-- ============================== -->
		<!-- display photo  panel                                  -->
		<!-- ============================== -->
				
		function displayPhotoPanel(){					
			var renderToString =  "photo-panel-0";	
			var photoPlaceHolder = $("#photo-list-view").data( "photoPlaceHolder");		
			if( $("#" + renderToString ).length == 0  ){			
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template('<div id="#: panelId #" class="custom-panels-group col-sm-#: colSize#" style="display:none;"></div>');				
				$("#personalized-area").append( template( {panelId:renderToString, colSize: grid_col_size.newValue } ) );	
			}				
			
			if( !$("#" + renderToString ).data("extPanel") ){					
				$("#" + renderToString ).data("extPanel", 
					$("#" + renderToString ).extPanel({
						template : kendo.template($("#photo-panel-template").html()),
						data : photoPlaceHolder,
						commands:[
							{ selector :   "#" + renderToString + " .panel-body:first .btn", 
							  handler : function(e){
								e.preventDefault();
								var _ele = $(this);
								if( _ele.hasClass( 'custom-delete') ){
									//alert( $("#photo-list-view").data( "photoPlaceHolder").imageId );
									/**
									$.ajax({
										dataType : "json",
										type : 'POST',
										url : '${request.contextPath}/community/delete-my-image.do?output=json',
										data : { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId },
										success : function( response ){
											$("#" + renderToString ).remove();
										},
										error:common.api.handleKendoAjaxError
									});
									*/								
								}
							}}
						],						
					}).bind('open', function( e ) {
						// start open event handler  	
						common.api.streams.details({
							imageId : $("#photo-list-view").data( "photoPlaceHolder").imageId ,
							success : function( data ) {
								if( data.photos.length > 0 ){
									$("#photo-list-view").data( "photoPlaceHolder").shared = true ;
									$("input[name='photo-public-shared']").first().click();
								}else{
									$("#photo-list-view").data( "photoPlaceHolder").shared = false ;
									$("input[name='photo-public-shared']").last().click();
								}
							}
						});						
						if( ! $('#photo-prop-grid').data("kendoGrid") ){
							$('#photo-prop-grid').kendoGrid({
								dataSource : {		
									transport: { 
										read: { url:'/community/get-my-image-property.do?output=json', type:'post' },
										create: { url:'/community/update-my-image-property.do?output=json', type:'post' },
										update: { url:'/community/update-my-image-property.do?output=json', type:'post'  },
										destroy: { url:'/community/delete-my-image-property.do?output=json', type:'post' },
								 		parameterMap: function (options, operation){			
									 		if (operation !== "read" && options.models) {
									 			return { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId, items: kendo.stringify(options.models)};
											} 
											return { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId }
										}
									},						
									batch: true, 
									schema: {
										data: "targetImageProperty",
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
						// start open event handler 
					})													
				);	

				$("input[name='photo-public-shared']").on("change", function () {
					var newValue = ( this.value == 1 ) ;
					var oldValue =  $("#photo-list-view").data( "photoPlaceHolder").shared ;					
					if( oldValue != newValue){
						if(newValue){
							common.api.streams.add({
								imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});							
						}else{
							common.api.streams.remove({
								imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});					
						}
					}					
				});												
				$("#update-photo-file").kendoUpload({
					showFileList: false,
					multiple: false,
					async: {
						saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',
						autoUpload: true
					},
					localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
					upload: function (e) {				
						e.data = { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId };
					},
					success: function (e) {				
						if( e.response.targetImage ){
							$('#photo-list-view').data('kendoListView').dataSource.read();								
							var item = e.response.targetImage;
							item.index = $("#photo-list-view").data( "photoPlaceHolder" ).index;			
							item.page = $("#photo-list-view").data( "photoPlaceHolder" ).page;		
							// need fix!!
							$("#photo-list-view").data( "photoPlaceHolder",  item );
							displayPhotoPanel();
						}
					} 
				});																
				var overlay  = $("#" + renderToString ).find('.overlay').extOverlay();					
				// start define over nav events				
				common.api.handleButtonActions( $("#" + renderToString ), {
					handlers : [
						{selector: ".panel-body:last >figure", event : 'click', handler : function(e){
							e.preventDefault();
							overlay.toggleOverlay();
						}},						
						{selector: ".overlay  a.btn", event : 'click', handler : function(e){
							e.preventDefault();
							var _command = $(this);
							if( _command.hasClass('custom-previous') ){
								previousPhoto();
							}else if ( _command.hasClass('custom-next') ) {
								nextPhoto();
							}
						}},
						{selector: ".overlay  input[name='lightning-box-photo-scale']", event : 'change', handler : function(e){
							e.preventDefault();		
							var newValue = this.value ;
							var _img = $("#" + renderToString ).find(".panel-body:last figure.img-full-width img");
							if( newValue == 0 ){
								if( _img.hasClass('img-full-height') )
									_img.removeClass('img-full-height'); 		
								if( _img.hasClass('img-full-width') )
									_img.removeClass('img-full-width'); 			
								_img.addClass('img-fit-screen-width'); 										
							}else if ( newValue == 1 ) {
								if( _img.hasClass('img-full-height') )
									_img.removeClass('img-full-height'); 			
								if( _img.hasClass('img-fit-screen-width') )
									_img.removeClass('img-fit-screen-width'); 															
								_img.addClass('img-full-width');								
							}else if ( newValue == 2 ){
								if( _img.hasClass('img-full-width') )
									_img.removeClass('img-full-width'); 			
								if( _img.hasClass('img-fit-screen-width') )
									_img.removeClass('img-fit-screen-width'); 																
								_img.addClass('img-full-height');
							}
						}}						
					]
				});				
			}else{
				$("#" + renderToString ).data("extPanel").data(photoPlaceHolder);
				kendo.bind($("#" + renderToString ).data("extPanel").body(), $("#" + renderToString ).data("extPanel").data());
			}			
			var panel = $("#" + renderToString ).data("extPanel");
			panel.show();			
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
			<div class="container-fluid">
				<ul class="nav navbar-nav navbar-left">				
					<p class="navbar-text hidden-xs">&nbsp;</p>	
					<p class="navbar-text hidden-xs">&nbsp;</p>						
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
					<p class="navbar-text text-primary hidden-xs">미디어</p>
					<li class="navbar-btn">
						<div id="navbar-btn-my-streams" class="btn-group navbar-btn" data-toggle="buttons"><i class="fa-li fa fa-spinner fa-spin"></i></div>						
					</li>			
					<p class="navbar-text hidden-xs">&nbsp;</p>	
					<li><a href="#" class="btn-link custom-nabvar-show-opts"><i class="fa fa-cog fa-lg"></i></a></li>
					<li><a href="#&quot;" class="btn-link custom-nabvar-hide"><img src="${request.contextPath}/images/cross.png" height="18"/></a></li>
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
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->
		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="alert-panel-template">
			<div id="#: id #" class="custom-panels-group col-sm-#: colSize#" style="min-height:200px; display:none;" data-role="panel">
				<div class="alert alert-danger">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					새로운 미디어 연결은 프로필 보기의 쇼셜네트워크 탭에서 지원합니다.
					<a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-info" data-toggle="modal" data-target="\\#myProfileModal">프로필 보기</a>
				</div>
			</div>
		</script>								
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>