<#ftl encoding="UTF-8"/>
<html decorator="secure">
	<head>
		<title>웹사이트관리</title>
<#compress>	
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />	
		<script type="text/javascript"> 
		yepnope([{
			load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			'css!${request.contextPath}/styles/perfect-scrollbar/perfect-scrollbar-0.4.9.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',			
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',						
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',						
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/perfect-scrollbar/perfect-scrollbar-0.4.9.min.js', 			
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js',			
			'${request.contextPath}/js/ace/ace.js'
			],    	   
			complete: function() {               
				
				// 1-1.  셋업
				var currentUser = new User();			
				common.ui.admin.setup({	
					menu : {toggleClass : "mmc"},
					authenticate: function(e){
						e.token.copy(currentUser);
					}
				});		
																		
				// 3.MENU LOAD 
				var detailsModel = kendo.observable({
					website: new common.models.WebSite( {webSiteId: ${ action.targetWebSite.webSiteId}} ),
					isEnabled : false,
					openMenuModal : function(e){
						openMenuSettingWindow( this.website );
					},
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'${request.contextPath}/secure/list-website-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-website-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-website-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-website-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { targetSiteId: detailsModel.website.webSiteId, items: kendo.stringify(options.models)};
								} 
								return { targetSiteId: detailsModel.website.webSiteId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetWebSiteProperty",
							model: Property
						},
						error : common.api.handleKendoAjaxError
					}),
					teleport : function(e){
						var action = $(e.target).attr('data-action');
						if(action === 'go-group'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-group.do',
								companyId : this.get('website').company.companyId
							});							
						}else if (action === 'go-user'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-user.do',
								companyId: this.get('website').company.companyId
							});		
						}else if (action === 'back'){			
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-site.do',
								companyId: this.get('website').company.companyId
							});			
						}else if (action === 'go-pages'){			
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/view-website-pages.do',
								targetSiteId: this.get('website').webSiteId
							});																	
						}
					}						
				});					
				
				detailsModel.bind("change", function(e){		
					var sender = e.sender ;
					if( e.field.match('^website.name')){ 
						if( sender.website.webSiteId > 0 ){
							this.set("logoUrl", "/download/logo/site/" + sender.website.name );			
						}
					}else if( e.field.match('^website.user')){ 
						this.set("profileUrl", "/download/profile/" + sender.website.user.username  + "?width=100&height=150");
						this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  sender.website.createionDate ));      
						this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  sender.website.modifiedDate ));									
					}					
				});								
				
				$("#website-details").data("model", detailsModel );			
								
				common.api.callback({
					url :"${request.contextPath}/secure/get-site.do?output=json", 
					data : { targetSiteId:  detailsModel.website.webSiteId },
					success : function(response){
						var site = new common.models.WebSite(response.targetWebSite);
						site.copy( detailsModel.website );
						detailsModel.isEnabled = true;						
						kendo.bind($("#website-details"), detailsModel );						
						displayWebsiteDetails();	
					},
					requestStart : function(){
						kendo.ui.progress($("#website-details"), true);
					},
					requestEnd : function(){
						kendo.ui.progress($("#website-details"), false);
					}
				}); 										
			}	
		}]);

		function getSelectedWebSite(){
			return $("#website-details").data("model").website;
		}	
						
		function getSelectedCompany(){
			var setup = common.ui.admin.setup();
			return setup.companySelector.dataItem(setup.companySelector.select());
		}	
			
		function displayWebsiteDetails(){
			$('#website-tabs').on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.attr('href') ){
					case "#website-tabs-props" :						
						break;
					case  '#website-tabs-images' :
						createImagePane();
						break;
					case  '#website-tabs-files' :	
						createFilePane();
						break;	
					case  '#website-tabs-timeline' :	
						createTimelinePane();
						break;	
					case  '#website-tabs-networks' :	
						createSocialPane();
						break;															
					}	
				});				
			$('#website-tabs a:first').tab('show') ;						
		}

		function openMenuSettingWindow (site){
			var renderToString = "menu-setting-modal";
			var renderTo = $( '#' + renderToString );							
			if( renderTo.length === 0 ){		
				var template = kendo.template($('#menu-setting-modal-template').html());
				$("#main-wrapper").append( template({uid:renderToString}) );				
				renderTo = $('#' + renderToString );
			}			
			var editor = ace.edit("xml-editor");			
			if( !renderTo.data('model') ){				
				var editorModel  =  kendo.observable({ 
					menu : new Menu(),
					onSave : function (e) {
						var btn = $(e.target);			
						var menuToUse = this.menu;			
						if( menuToUse.menuData.length != editor.getValue().length ){
							menuToUse.set('menuData',  editor.getValue() );
							common.api.callback(  
							{
								url :"${request.contextPath}/secure/update-site-menu.do?output=json", 
								data : { targetSiteId:  site.webSiteId, item: kendo.stringify(menuToUse) },
								success : function(response){
									common.ui.notification({title:"메뉴 저장", message: "메뉴 데이터가 정상적으로 입력되었습니다.", type: "success" });
									var updateWebsite = new common.models.WebSite(response.targetWebSite);	
									updateWebsite.copy( getSelectedWebSite() );									
									//window.location.reload( true );								
								},
								fail: function(){								
									common.ui.notification({title:"메뉴 생성 오류", message: "시스템 운영자에게 문의하여 주십시오." });
								},
								requestStart : function(){
									kendo.ui.progress($("#"+ renderToString ), true);
									btn.button('loading');	
								},
								requestEnd : function(){
									kendo.ui.progress($( "#"+ renderToString ), false);
									btn.button('reset');
								}
							});												
						}else{
							alert( "do nothing" ) ;
						}
					}
				});				
				kendo.bind(renderTo, editorModel);	
				renderTo.data('model', editorModel) ;				
				editor.setTheme("ace/theme/monokai");
				editor.getSession().setMode("ace/mode/xml");
				var switcher = renderTo.find('input[role="switcher"][name="warp-switcher"]');
				if( switcher.length > 0 ){
					$(switcher).switcher();
					$(switcher).change(function(){
						editor.getSession().setUseWrapMode($(this).is(":checked"));
					});		
				}					
				renderTo.modal({
					backdrop: 'static'
				});		
				renderTo.on('show.bs.modal', function(e){				
					editor.setValue(renderTo.data("model").menu.menuData);
				});			
				renderTo.on('hidden.bs.modal', function(e){
				
				});											
			}
			var m = new Menu (site.menu);
			m.copy( renderTo.data('model').menu );
			renderTo.modal('show');	
		} 

		function createSocialPane(){
			var selectedCompany = $("#navbar").data("companyPlaceHolder");
						if( ! $("#social-grid").data("kendoGrid") ){								
							$("#social-grid").kendoGrid({
								dataSource: {
									dataType: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/list-social-account.do?output=json', type: 'POST' },
										update: { url:'${request.contextPath}/secure/update-social-account.do?output=json', type:'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { objectType: 30, objectId : $("#site-info").data("sitePlaceHolder").webSiteId , item: kendo.stringify(options)};									                            	
											}else{
												return { startIndex: options.skip, pageSize: options.pageSize, objectType: 30, objectId: $("#site-info").data("sitePlaceHolder").webSiteId }
											}
										} 
									},
									schema: {
										data: "targetSocialAccounts",
										model : SocialAccount
									},
									pageSize: 15,
									serverPaging: false,
									serverFiltering: false,
									serverSorting: false,                        
									error: common.api.handleKendoAjaxError
								},
								columns:[
									{ field: "socialAccountId", title: "ID",  width: 50, filterable: false, sortable: false },
									{ field: "serviceProviderName", title: "쇼셜", width: 100 },
									{ field: "signedIn", title: "로그인",  width: 80 },
									{ field: "accessSecret", title: "Access Secret", sortable: false },
									{ field: "accessToken", title: "Access Token", sortable: false },
									{ field: "creationDate", title: "생성일", width: 100, format: "{0:yyyy.MM.dd}" },
									{ field: "modifiedDate", title: "수정일", width: 100, format: "{0:yyyy.MM.dd}" },
									{ command: [ {  text: "상세" , click: function(e){										
										e.preventDefault();										
										selectedSocial =  this.dataItem($(e.currentTarget).closest("tr"));											
										if(! $("#social-detail-window").data("kendoWindow")){       
											// WINDOW 생성
											$("#social-detail-window").kendoWindow({
												actions: ["Close"],
												resizable: false,
												modal: true,
												visible: false,
												minWidth: 300,
												minHeight: 300
											});
										}																				
										// load social template ...										
										var socialWindow = $("#social-detail-window").data("kendoWindow");
										var socialMediaName = selectedSocial.serviceProviderName ;										
										var template = kendo.template($('#social-details-template').html());											
										socialWindow.title( socialMediaName + ' 연결정보' );
										socialWindow.content(template({ 'socialAccount' : selectedSocial }));
										$.ajax({
											type : 'POST',
											url : '${request.contextPath}/social/get-' + socialMediaName + '-profile.do?output=json',
											data: { socialAccountId: selectedSocial.socialAccountId },
											beforeSend: function(){																					
												socialWindow.center();
												socialWindow.open();
												kendo.ui.progress($("#social-detail-window"), true);												
											},
											success : function(response){
												if( response.error ){
													// 오류 발생..
													socialWindow.content( template( { 'socialAccount' : selectedSocial, 'error': response.error } ) );
												} else {														
													socialWindow.content( template(response) );
												}										
												$('#connect-social-btn').click( function(e){
													socialWindow.close();													
													var w = window.open(
														selectedSocial.authorizationUrl, 
														"_blank",
														"toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=500, height=400"
													);
													w.focus();
												});		
											},
											error: function(){
												socialWindow.close();
												common.api.handleKendoAjaxError();
											},
											dataType : 'json'
										});	
										
									}}, { name: "destroy", text: "삭제" } ], title: " ", width: "230px"  }
								],
								filterable: true,
								editable: "inline",
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								//height: 500,
								dataBound: function(e) {								
								},
								change: function(e) {          
									var selectedCells = this.select();     
								}
							});
						}			
		}

		function createFilePane(){				
			if( ! $("#attach-upload").data("kendoUpload") ){	
				$("#attach-upload").kendoUpload({
					multiple : false,
					showFileList : true,
					localization : { 
						select: '첨부파일 업로드', remove:'삭제', dropFilesHere : '업로드할 첨부 파일을 이곳에 끌어 놓으세요.' , 
						uploadSelectedFiles : '이미지 업로드',
						cancel: '취소' 
					},
					async: {
						saveUrl:  '${request.contextPath}/secure/save-attachments.do?output=json',							   
						autoUpload: true
					},
					upload:  function (e) {		
						e.data = { objectType: 30, objectId : getSelectedWebSite().webSiteId, attachmentId:'-1' };		
					},
					success : function(e) {	
						$('#attach-grid').data('kendoGrid').dataSource.read(); 
					}
				}).css('min-width','300');
			}				
						
			if( ! $("#attach-grid").data("kendoGrid") ){	
							$("#attach-grid").kendoGrid({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/get-attachements.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { objectType: 30, objectId :  getSelectedWebSite().webSiteId , item: kendo.stringify(options)};									                            	
											}else{
												return { startIndex: options.skip, pageSize: options.pageSize, objectType: 30, objectId:  getSelectedWebSite().webSiteId }
											}
										} 
									},
									schema: {
										total: "totalTargetAttachmentCount",
										data: "targetAttachments",
										model : Attachment
									},
									pageSize: 15,
									serverPaging: true,
									serverFiltering: false,
									serverSorting: false,                        
									error: common.api.handleKendoAjaxError
								},
								columns:[
									{ field: "attachmentId", title: "ID",  width: 50, filterable: false, sortable: false },
									{ field: "name", title: "파일", width: 250 },
								/*	{ field: "contentType", title: "파일 유형",  width: 100 },*/
									{ field: "size", title: "파일크기",  width: 100 , format: "{0:##,###}" },
									{ field: "creationDate", title: "생성일", width: 80, format: "{0:yyyy.MM.dd}" },
									{ field: "modifiedDate", title: "수정일", width: 80, format: "{0:yyyy.MM.dd}" },
									{ command: [ { name: "destroy", text: "삭제" } ], title: " ", width: "160px"  }
								],
								filterable: true,
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								//selectable: 'row',
								//height: 500,
								detailTemplate: kendo.template( $("#attach-details-template").html() ),
								detailInit : function(e){
									//var detailRow = e.detailRow;
								},		
								dataBound: function(e) {
								
								},
								change: function(e) {          
									var selectedCells = this.select();       
									this.expandRow(selectedCells);
								}
							});
			}			
		}
		
		function createImagePane(){							
						if( ! $("#image-upload").data("kendoUpload") ){	
							$("#image-upload").kendoUpload({
								multiple : false,
								showFileList : true,
								localization : { 
									select: '이미지 업로드', remove:'삭제', dropFilesHere : '업로드할 이미지 파일을 이곳에 끌어 놓으세요.' , 
									uploadSelectedFiles : '이미지 업로드',
									cancel: '취소' 
								},
								async: {
									saveUrl:  '${request.contextPath}/secure/update-image.do?output=json',							   
									autoUpload: true
								},
								upload:  function (e) {		
									e.data = { objectType: 30, objectId : getSelectedWebSite().webSiteId, imageId:'-1' };		
								},
								success : function(e) {	
									$('#image-grid').data('kendoGrid').dataSource.read(); 
								}
							}).css('min-width','300');
						}				
						
						if( ! $("#image-grid").data("kendoGrid") ){	
							$("#image-grid").kendoGrid({
								dataSource: {
									dataType: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/list-image.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {
												return { objectType: 30, objectId : getSelectedWebSite().webSiteId , item: kendo.stringify(options)};	
											}else{
												return { startIndex: options.skip, pageSize: options.pageSize, objectType: 30, objectId: getSelectedWebSite().webSiteId }
											}
										} 
									},
									schema: {
										total: "totalTargetImageCount",
										data: "targetImages",
										model : Image
									},
									pageSize: 15,
									serverPaging: true,
									serverFiltering: false,
									serverSorting: false,
									error: common.api.handleKendoAjaxError
								},
								columns:[
									{ field: "imageId", title: "ID",  width: 50, filterable: false, sortable: false  },
									{ field: "name", title: "파일", width: 350 },
									/*{ field: "contentType", title: "이미지 유형",  width: 100 },*/
									{ field: "size", title: "파일크기",  width: 100, format: "{0:##,###}" },
									{ field: "creationDate", title: "생성일", width: 100, format: "{0:yyyy.MM.dd}" },
									{ field: "modifiedDate", title: "수정일", width: 100, format: "{0:yyyy.MM.dd}" }/**,
									{ command: [ { name: "destroy", text: "삭제" } ], title: " ", width: "160px"  }**/
								],
								filterable: true,
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								selectable: 'row',
								dataBound: function(e) {
									if( 	!$('#image-details').hasClass('hide') )
										$('#image-details').addClass('hide')
								},
								change: function(e) {
									var selectedCells = this.select();
									if( selectedCells.length == 1){
										var selectedCell = this.dataItem( selectedCells );	
										$("#image-details").data("imagePlaceHolder", selectedCell );
										displayImageDetails();
									}
								}
							});
						}
		}	
		
		function displayImageDetails(){			
			var template = kendo.template("${request.contextPath}/secure/view-image.do?width=150&height=150&imageId=#=imageId#");						
			var imagePlaceHolder = $("#image-details").data( "imagePlaceHolder");						
			if( typeof imagePlaceHolder.imgUrl == 'undefined' ){				
				imagePlaceHolder.imgUrl = template(imagePlaceHolder);
			}					
			common.api.streams.details({
				imageId :imagePlaceHolder.imageId ,
				success : function( data ) {
					if( data.photos.length > 0 ){
						imagePlaceHolder.shared = true ;
						$('#image-details').find("input[name='image-public-shared']").first().click();
					}else{
						imagePlaceHolder.shared = false ;
						$('#image-details').find("input[name='image-public-shared']").last().click();
					}
				}
			});																
			if( $('#image-details').find('.panel-body').length == 0 ){			
				$('#image-details').html( $("#image-details-template").html() );			
				$('#image-details').find("input[name='image-public-shared']").on("change", function () {
					var newValue = ( this.value == 1 ) ;
					var oldValue =  $("#image-details").data( "imagePlaceHolder").shared ;					
					if( oldValue != newValue){
						if(newValue){
							common.api.streams.add({
								imageId: $("#image-details").data( "imagePlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});							
						}else{
							common.api.streams.remove({
								imageId: $("#image-details").data( "imagePlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});					
						}
					}					
				});					
				 common.ui.handleButtonActionEvents(
					$('#image-details button.btn-control-group'), 
					{event: 'click', handlers: {
						top : function(e){
							$('html,body').animate({scrollTop: $("#myTab").offset().top - 55 }, 300);
						}  						  						 
					}}
				);																			
				$("#update-image-file").kendoUpload({
					showFileList: false,
					multiple: false,
					async: {
						saveUrl:  '${request.contextPath}/secure/update-image.do?output=json',
						autoUpload: true
					},
					localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
					upload: function (e) {				
						e.data = { imageId: $("#image-details").data( "imagePlaceHolder").imageId };
					},
					success: function (e) {				
						if( e.response.targetImage ){
							displayImageDetails();
						}
					} 
				});						
				if( ! $('#image-prop-grid').data("kendoGrid") ){
					$('#image-prop-grid').kendoGrid({
						dataSource : {		
							transport: { 
								read: { url:'${request.contextPath}/secure/get-image-property.do?output=json', type:'post' },
								create: { url:'${request.contextPath}/secure/update-image-property.do?output=json', type:'post' },
								update: { url:'${request.contextPath}/secure/update-image-property.do?output=json', type:'post'  },
								destroy: { url:'${request.contextPath}/secure/delete-image-property.do?output=json', type:'post' },
						 		parameterMap: function (options, operation){			
							 		if (operation !== "read" && options.models) {
							 			return { imageId: $("#image-details").data( "imagePlaceHolder").imageId, items: kendo.stringify(options.models)};
									} 
									return { imageId: $("#image-details").data( "imagePlaceHolder").imageId }
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
			}
			$('#image-prop-grid').data("kendoGrid").dataSource.read();			
			kendo.bind($('#image-details'), imagePlaceHolder );						
			if( 	$('#image-details').hasClass('hide') )
				$('#image-details').removeClass('hide')	;				
			$('html,body').animate({scrollTop: $("#image-details").offset().top - 55 }, 300);				
		}
				
				
		function showWebsiteSetting(){		
			var renderToString = "website-setting-modal";
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"/>');
				$("#"+ renderToString).data("websitePlaceHolder", new common.models.WebSite() );
			}
			var websiteSetting = $("#"+ renderToString);
			var websitePlaceHolder = $("#"+ renderToString).data("websitePlaceHolder");
			$("#site-info").data("sitePlaceHolder").copy(websitePlaceHolder);
				
			if( !websiteSetting.data('kendoExtModalWindow') ){
				var websiteSettingViewModel =  kendo.observable({ 
					onSave : function(e){
						$.ajax({
							type : 'POST',
							url : '${request.contextPath}/secure/update-website.do?output=json',
							data: { targetSiteId : this.get('website').webSiteId, item : kendo.stringify( this.get('website') ) },
							success : function(response){
								common.ui.notification({title:"정보변경", message: "웹 사이트 정보가 정상적으로 저장되었습니다.", type: "success" });
								var websiteToUse = new common.models.WebSite(response.targetWebSite);																
								websiteToUse.copy( $("#site-info").data("sitePlaceHolder") );								
								$("#"+ renderToString ).data('kendoExtModalWindow').close();	
							},
							error:common.api.handleKendoAjaxError,
							dataType : "json"
						});
					},
					isVisible: true,
					website: websitePlaceHolder,
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'${request.contextPath}/secure/list-website-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-website-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-website-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-website-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { targetSiteId: websitePlaceHolder.webSiteId, items: kendo.stringify(options.models)};
								} 
								return { targetSiteId: websitePlaceHolder.webSiteId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetWebSiteProperty",
							model: Property
						},
						error : common.api.handleKendoAjaxError
					})
				} );						
				websiteSetting.extModalWindow({
					title : "웹사이트 정보 변경",
					template : $("#website-setting-modal-template").html(),
					data :  websiteSettingViewModel,
					change : function (e) {
						if( e.field.match('^website.')){							
							$(e.element).find('.modal-footer .btn.custom-update').removeAttr('disabled');
						}
					}
				});			
			}				
			websiteSetting.data('kendoExtModalWindow')._modal().find('.modal-footer .btn.custom-update').attr('disabled', 'disabled');	
			websiteSetting.data('kendoExtModalWindow').open();	
		}
		
		
		</script>
		<style type="text/css" media="screen">

		.k-grid-content{
			height:300px;
		}		
		
		#image-grid .k-grid-content{
			height:400px;
		}				
		 	
		#xml-editor {
			position: absolute;
			top: 0;
			right: 0;
			bottom: 0;
			left: 0;
			min-height: 450px;
		}
		.page-details .left-col {
			float: left;
			width: 290px;
		}		
		</style>		
</#compress>		
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_3") />
				<ul class="breadcrumb breadcrumb-page">
					<!--<div class="breadcrumb-label text-light-gray">You are here: </div>-->
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>
				<div class="page-header bg-dark-gray">		
					<div class="row">
						<h1 class="col-xs-12 col-sm-6 text-center text-left-sm"><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}
							<p><small><i class="fa fa-quote-left"></i> ${selectedMenu.description} <i class="fa fa-quote-right"></i></small></p>
						</h1>
					</div><!-- ./row -->				
				</div><!-- / .page-header -->
				<!-- details-row -->
				<div id="website-details" class="page-details" style="">				
					<div class="details-row no-margin-t">					
						<div class="left-col left-col-nav">
							<div class="details-block no-margin-t">								
								<div class="details-photo">
									<img data-bind="attr: { src: logoUrl }" alt="" src="/download/logo/company/inkium">
								</div>
								<br>
								<div class="btn-group">
									<button type="button" class="btn btn-success btn-flat btn-control-group pull-left" data-action="back" title="웹사이트 목록으로 이동"  data-bind="enabled: isEnabled, click:teleport"><i class="fa fa-level-up"></i></button>    
									<button type="button" class="btn btn-success btn-flat btn-control-group" data-action="update-company" data-toggle="button" data-bind="enabled: isEnabled, click:toggleOptionPanel" ><i class="fa fa-pencil"></i> 사이트 정보변경</button>
								</div>												
							</div>				
							
							<div class="panel panel-transparent">
								<div class="panel-heading">
									<span class="panel-title">
										기본정보											
									</span>
								</div>								
								<table class="table">
									<tbody>						
										<tr>
											<th class="text-center" width="75">회사</th>								
											<td><span data-bind="text: website.company.displayName"></span> <span class="label label-primary"><span data-bind="text: website.company.name"></span></span> <code><span data-bind="text: website.company.companyId"></span></code></td>
										</tr>	
										<tr>											
											<th class="text-center">도메인</th>												
											<td><span data-bind="text: website.company.domainName"></span></td>
										</tr>	
										<tr>
											<th class="text-center">사이트</th>								
											<td>
												<span data-bind="text: website.displayName"></span> 												
												<code><span data-bind="text: website.webSiteId">1</span></code>
											</td>
										</tr>				
										<tr>
											<th class="text-center">보안</th>	
											<td>
												<i class="fa fa-lock fa-lg" data-bind="invisible: website.allowAnonymousAccess" style="display: none;"></i>
												<i class="fa fa-unlock fa-lg" data-bind="visible: website.allowAnonymousAccess"></i>														
											</td>
										</tr>							
										<tr>
											<th  class="text-center">메뉴</th>	
											<td><span data-bind="text: website.menu.title"></span> 
												<span class="label label-warning"><span data-bind="text: webiste.menu.name"></span></span> 
												<code><span data-bind="text: website.menu.menuId"></span></code>
											</td>
										</tr>																																									
										<tr>
											<th  class="text-center">생성일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>	
										<tr>
											<th  class="text-center">수정일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>																								
									</tbody>
								</table>
								<div class="panel-footer no-border">
									<h6 class="text-light-gray text-semibold text-xs">담당자</h6>
									<div class="media">
										<a class="pull-left" href="#">
											<img class="media-object" data-bind="attr: { src: profileUrl }" alt="...">
										</a>
										<div class="media-body">
											<h5 class="media-heading">
												<span data-bind="text: website.user.name"></span>(<span data-bind="text: website.user.username"></span>)
											</h5>
										</div>
									</div>				
								</div>								
							</div>														
						</div>
						<div class="right-col">
							<hr class="details-content-hr no-grid-gutter-h"/>						
							<div class="details-content">							
								<div class="row" >
									<div class="col-sm-12 m-b-sm">
										<div class="pull-right">
											<div class="btn-group">									
												<button type="button" class="btn btn-info btn-flat btn-control-group" data-action="update-menu" data-bind="enabled: isEnabled, click:openMenuModal"><i class="fa fa-sitemap"></i> 매뉴변경</button>
												<button type="button" class="btn btn-info btn-flat btn-control-group" data-action="go-pages" data-bind="enabled: isEnabled, click:teleport"><i class="fa fa-file"></i> 웹 페이지 관리</button>
											</div>				
										</div>
									</div>
								</div>
								<div class="note note-danger">
									<h4 class="note-title">"웹 페이지 관리" 버튼을 클릭하면 웹사이트 페이지들을 생성/수정할 수 있습니다.</h4>									
								</div>								
								<div class="panel colourable">
										<div class="panel-heading">	
										<span class="panel-title"><span class="label label-warning" data-bind="text: website.name"></span> <small style="text-muted" data-bind="text:website.description"></small></span>
											<ul id="website-tabs" class="nav nav-tabs nav-tabs-xs">
												<li><a href="#website-tabs-props" data-toggle="tab">프로퍼티</a></li>
												<li><a href="#website-tabs-images" data-toggle="tab">이미지</a></li>
												<li><a href="#website-tabs-files" data-toggle="tab">파일</a></li>
												<li><a href="#website-tabs-timeline" data-toggle="tab">타임라인</a></li>
											</ul>	
										</div> <!-- / .panel-heading -->
									<div class="tab-content">								
										<div class="tab-pane fade" id="website-tabs-props">
											<div data-role="grid"
												class="no-border"
												data-scrollable="false"
												data-editable="true"
												data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
												data-columns="[
													{ 'title': '이름',  'field': 'name', 'width': 200 },
													{ 'title': '값', 'field': 'value' },
													{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
												]"
												data-bind="source: properties, visible: isEnabled"
												style="min-height: 300px"></div>
																						
										</div>									
										<div class="tab-pane fade" id="website-tabs-images">
											<div class="panel panel-transparent no-margin-b">
												<div class="row no-margin-hr" style="background:#f5f5f5;" >
													<div class="col-md-4"><input name="image-upload" id="image-upload" type="file" /></div>
													<div class="col-md-8 no-padding-hr" style="border-left : solid 1px #ccc;" ><div id="image-details" class="hide animated padding-sm fadeInRight"></div></div>
												</div>
												<div id="image-grid" class="no-border-hr no-border-b"></div>							
											</div>	
										</div>			
										<div class="tab-pane fade" id="website-tabs-files">
											<div class="panel panel-transparent no-margin-b">
												<div class="panel-body">
													<input name="attach-upload" id="attach-upload" type="file" />
												</div>																																		
											</div>
											<div id="attach-details" class="no-padding-t  hide"></div>										
											<div id="attach-grid" class="no-border-hr no-border-b"></div>												
										</div>			
										<div class="tab-pane fade" id="website-tabs-timeline">
										</div>																																							
							</div>
						</div>				
					</div>							
				</div>
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg"></div>
		</div> <!-- / #main-wrapper -->	
				
		
		
  
		<!-- Modal -->
		<div id="social-detail-window" style="display:none;"></div>
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							<h4 class="modal-title">Modal title</h4>
					</div>
					<div class="modal-body">
					</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">Save changes</button>
			</div>
	      </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	  </div><!-- /.modal -->
  		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->
		
		<script id="menu-setting-modal-template" type="text/x-kendo-template">		
		<div id="#=uid#"class="modal fade" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog modal-lg animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">메뉴</h4>
					</div>
					<div class="modal-body border-t no-padding-hr no-padding-t no-margin-t menu-editor-group">
						<div class="panel panel-transparent no-margin-b">
							<div class="panel-body">
								<div class="row">
									<div class="col-xs-6">
									</div>
									<div class="col-xs-6">
										<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">줄 바꿈 설정</h6>
										<input type="checkbox" name="warp-switcher" data-class="switcher-primary" role="switcher" >	
									</div>
								</div>	
							</div>						
						</div>					
						<form class="form-horizontal">				
							<div class="row no-margin">
								<div class="col-sm-6">
									<div class="form-group no-margin-hr">
										<input type="text" name="name" class="form-control input-sm" placeholder="이름" data-bind="value: menu.name">
									</div>
								</div><!-- col-sm-6 -->
								<div class="col-sm-6">
									<div class="form-group no-margin-hr">
										<input type="text" name="title" class="form-control input-sm" placeholder="타이틀" data-bind="value: menu.title">
									</div>
								</div><!-- col-sm-6 -->
							</div>
							<div class="row no-margin">
								<div class="col-sm-12">
									<input type="text" name="description" class="form-control input-sm" placeholder="설명"  data-bind="value:menu.description" />
								</div>
							</div>				
						</form>							
					</div>					
					<div class="modal-body no-padding" style="height:450px;">
						<div id="xml-editor">												
						</div>							
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary btn-flat" data-bind="click:onSave" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >저장</button>
					</div>
				</div>
			</div>
		</div>	
				
		</script> 
		
		<script id="image-details-template" type="text/x-kendo-template">				
			<div class="panel panel-transparent">
				<div class="panel-body">											
					<div class="row">
						<div class="col-lg-4 col-xs-4">
							<p><span class="label label-info" data-bind="text: contentType"></span></p>
							<img data-bind="attr:{src: imgUrl}" class="img-rounded img-responsive" />							
						</div>
						<div class="col-lg-8 col-xs-8">
							<div class="panel-group" id="website-tabs-image-accordion">
								<div class="panel">
									<div class="panel-heading ">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#website-tabs-image-accordion" href="\\#website-tabs-image-accordion-collapse1">
											<i class="fa fa-info"></i> 속성
										</a>
									</div> <!-- / .panel-heading -->
									<div id="website-tabs-image-accordion-collapse1" class="panel-collapse collapse in" style="height: auto;">
										<div class="panel-body no-padding">
											<div class="note note-default no-border no-padding-b">
												<h5><small>수정한 다음에는 저장 버튼을 클릭하여야 반영됩니다.</small></h5>
											</div>											
											<div id="image-prop-grid" class="no-border-hr no-border-b"></div>						
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->	
								<div class="panel">
									<div class="panel-heading">
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#website-tabs-image-accordion" href="\\#website-tabs-image-accordion-collapse2">
											<i class="fa fa-share"></i>  공유
										</a>
									</div> <!-- / .panel-heading -->
									<div id="website-tabs-image-accordion-collapse2" class="panel-collapse collapse" style="height: 0px;">
										<div class="panel-body">
											<h5><small>모두에게 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h5>	

											<div class="btn-group" data-toggle="buttons">
												<label class="btn btn-primary">
												<input type="radio" name="image-public-shared" value="1">모두에게 공개
												</label>
												<label class="btn btn-primary active">
												<input type="radio" name="image-public-shared" value="0"> 비공개
												</label>
											</div>
											
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->		
								<div class="panel">
									<div class="panel-heading">
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#website-tabs-image-accordion" href="\\#website-tabs-image-accordion-collapse3">
											<i class="fa fa-upload"></i> 이미지 업로드
										</a>
									</div> <!-- / .panel-heading -->
									<div id="website-tabs-image-accordion-collapse3" class="panel-collapse collapse" style="height: 0px;">
										<div class="panel-body">
											<h5><small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
											<input name="update-image-file" type="file" id="update-image-file" class="pull-right" />
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->													
							</div>											
						</div>						
					</div>								
				</div>
			</div>					
		</script>
		
		<script id="social-details-template" type="text/x-kendo-template">				
				#if ( typeof (twitterProfile)  == "object" ){ #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="#=twitterProfile.profileImageUrl#" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h4 class="media-heading">#=twitterProfile.screenName# (#=twitterProfile.name#)</h4>
						#=twitterProfile.description#</br>
						</br>
						트위터 URL : #=twitterProfile.profileUrl#</br>
						표준시간대: #=twitterProfile.timeZone#</br>	
						웹 사이트: #=twitterProfile.url#</br>	
						언어: #=twitterProfile.language#</br>	
						위치: #=twitterProfile.location#</br>	
					</div>			
				</div>
				</br>
				<ul class="list-group">
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.statusesCount#</span>
					트윗
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.friendsCount#</span>
					팔로잉
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.followersCount#</span>
					팔로워
					</li>		
				</ul>			
				# } else if ( typeof (facebookProfile)  == "object" ) { #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="http://graph.facebook.com/#=facebookProfile.id#/picture" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h4 class="media-heading">#=facebookProfile.name# (#=facebookProfile.firstName#, #=facebookProfile.lastName#)</h4>
						</br>
						URL : #=facebookProfile.link#</br>
						로케일 : #=facebookProfile.locale#</br>
						위치 : #=facebookProfile.location.name#</br>
					</div>		
				</div>
								
				# } else if ( typeof (error)  == "object" ) { #
				<div class="alert alert-danger">
					#=socialAccount.serviceProviderName# 쇼셜계정에 접근할 수 없습니다. <BR/>
					연결하기 버튼을 클릭하여	<BR/>
					다시 연결하여 주십시오.	<BR/>					
					<img src="${request.contextPath}/images/common/twitter-bird-dark-bgs.png" alt="Twitter Logo" class="img-rounded">					
				</div>
				<input id="connect-social-id" type="hidden" value="#=socialAccount.socialAccountId #" />
				<div style="margin-top:-50px;">
				<button id="connect-social-btn" type="button" class="btn btn-primary btn-block">#=socialAccount.serviceProviderName#  연결하기</button>
				</div>
				# } else { #	
					# if ( socialAccount.serviceProviderName == "facebook" ) { #
					<img src="${request.contextPath}/images/common/FB-f-Logo__blue_512.png" alt="Facebook Logo" class="img-rounded">	
					# } else{ #
					<img src="${request.contextPath}/images/common/twitter-bird-light-bgs.png" alt="Twitter Logo" class="img-rounded">	
					# } #	
				# } #					
		</script>
		<#include "/html/common/common-system-templates.ftl" >		
	</body>
</html>