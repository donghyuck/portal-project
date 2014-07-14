<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
			'css!${request.contextPath}/styles/common.pages/common.page_one.css',
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',			
			'css!${request.contextPath}/styles/codrops/codrops.cbp-spmenu.css',
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/headroom/headroom.min.js',
			'${request.contextPath}/js/headroom/jquery.headroom.min.js',
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',	
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
				
			'${request.contextPath}/js/pdfobject/pdfobject.js',			
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common.pages/common.personalized.js',			
			'${request.contextPath}/js/ace/ace.js',
			'${request.contextPath}/js/common.pages/common.code-editor.js',
			],        	   
			complete: function() {			
				
				// SETUP COMMON
				common.ui.setup({
					features:{
						backstretch : true,
						lightbox : true,
						spmenu : true
					}
				});	
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if WebSiteUtils.isAllowedSignIn(action.webSite) ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);					
					},
					shown : function(e){				
						$("#account-navbar").append("<li><a href='#personalized-controls-section' class='btn-control-group navbar-btn-options' data-toggle='spmenu'><i class='fa fa-cloud-upload fa-2x'></i></a></li>");
						$(".navbar .navbar-header").append("<a href='#personalized-controls-section'  data-toggle='spmenu' class='navbar-toggle-inverse visible-xs'><i class='fa fa-cloud-upload fa-2x'></i></a>");															
					},									
				});	
				preparePersonalizedArea($("#personalized-area"), 3, 4 );
				
				// 2. SPMenu Right Tabs								
				$('#myTab').on( 'show.bs.tab', function (e) {
					//e.preventDefault();		
					var show_bs_tab = $(e.target);
					if( show_bs_tab.attr('href') == '#my-files' ){					
						createAttachmentListView();
					} else if(show_bs_tab.attr('href') == '#website-photo-stream' ){					
						createPhotoListView();
					}					
				});
				
				// 3. Notice	 Section
				common.ui.button({
					renderTo: "button[data-action='show-notice-section']",
					click:function(e){
						createNoticeSection();
						common.ui.buttonDisabled($(this));
					}
				}).click();
					
				
				//createNoticeSection();
			
				// 4-1. Announces 							
				//$("#announce-panel").data( "announcePlaceHolder", new Announce () );	
				
				//createNoticeGrid();
																			

				$('#myTab a:first').tab('show') ;
				// END SCRIPT 
			}
		}]);	
		
		<!-- ============================== -->
		<!-- Notice 											       -->
		<!-- ============================== -->				
		function createNoticeSection(){	
		
			if( !$("#notice-grid").data('kendoGrid') ){
				var buttons = common.ui.buttons({
					renderTo: "#notice-target-button",
					type: "radio",
					change: function(e){
						$("#notice-grid").data('kendoGrid').dataSource.read();
					}
				});	
				common.ui.button({
					renderTo: "button[data-action='new-notice']",
					click: function(e){				
						setNoticeEditorSource(new Announce());
						getNoticeEditorSource().objectType = getNoticeTarget();
						$(this).prop("disabled", true);
						openNoticeEditorPanel();
					}
				});
				common.ui.button({
					renderTo : "button[data-dismiss='section'][data-target]"
				});
				createNoticeGrid();
			}	
			if(	!$("#notice-section").is(":visible") ){
				$("#notice-section").show();
			}	
		}
		
		function getNoticeTarget (){
			var renderTo = "#notice-target-button";
			return $(renderTo).data("kendoExtRadioButtons").value;
		}
		
		function createNoticeGrid(){
			if( !$("#notice-grid").data('kendoGrid') ){				
				$("#notice-grid").data('announceTargetPlaceHolder', 30);				
				$("#notice-grid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport: {
							read: {
								type : 'POST',
								dataType : "json", 
								url : '${request.contextPath}/community/list-announce.do?output=json'
							},
							parameterMap: function(options, operation) {
								if (operation != "read" && options.models) {
									return {models: kendo.stringify(options.models)};
								}else{								
									return {objectType: getNoticeTarget() };								
								}
							} 
						},
						pageSize: 10,
						error:common.api.handleKendoAjaxError,
						schema: {
							data : "targetAnnounces",
							model : Announce,
							total : "totalAnnounceCount"
						}
					}),
					sortable: true,
					columns: [ 
						{field:"creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}", attributes: { "class": "table-cell", style: "text-align: center " }} ,
						{field: "subject", title: "제목", headerAttributes: { "class": "table-header-cell", style: "text-align: center"}}, 
					],
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },									
					selectable: "row",
					change: function(e) { 
						var selectedCells = this.select();
						if( selectedCells.length > 0){
							var selectedCell = this.dataItem( selectedCells );								
							showNoticePanel();
						}
					},
					dataBound: function(e) {
						if( $("#notice-view").data("model") ){	
							$("#notice-view").data("model").set("visible", false);
						}
					}
				});		
			}	
		}	
		
		function selectedNotice(){
			var grid = $("#notice-grid").data('kendoGrid');
			var selectedCells = grid.select();
			if( selectedCells.length > 0){
				return grid.dataItem( selectedCells );						
			}else{
				return new Announce ();
			}
		}
		
		function showNoticePanel(){
			var renderTo = "#notice-view";
			var noticeToUse = selectedNotice();
			if( !$(renderTo).data("model") ){	
				$(renderTo).html($("#notice-view-template").html());
				var model =  kendo.observable({ 
					announce : new Announce (),
					profilePhotoUrl : "",
					visible : false,
					editable:false,
					edit: function(e){
						if(this.editable){
							setNoticeEditorSource(this.announce);
							openNoticeEditorPanel();
						}
					},
					close: function(e){
						this.set("visible", false );
					},
					delete: function(e){
						
					}
				});	
				model.bind("change", function(e){
					if( e.field == "visible" ){ 				
						if(this.visible && $("#notice-editor").data("model")){
							$("#notice-editor").data("model").set("visible", false);
						}					
					}
				});
				$(renderTo).data("model", model);
				kendo.bind($(renderTo), model );
			}			
			noticeToUse.copy( $(renderTo).data("model").announce  );
			$(renderTo).data("model").set("visible", true);
			$(renderTo).data("model").set("editable", hasPermissions(noticeToUse.user));
			$(renderTo).data("model").set("profilePhotoUrl", common.api.user.photoUrl (noticeToUse.user, 150,150) );			
		}
						
		function hasPermissions(user){
			var hasPermission = false;
			var userToUse =  $("#account-navbar").data("kendoExtAccounts").token;
			if( userToUse.company.companyId == ${ webSite.company.companyId } ){
				if( userToUse.hasRole("ROLE_ADMIN") || userToUse.hasRole("ROLE_ADMIN_SITE") ){
					hasPermission = true;
				}				
			}			
			if( typeof user == "object" && userToUse.userId == user.userId ){
				hasPermission = true;
			}			
			return hasPermission;
		}			

		function getNoticeEditorSource(){
			var renderTo = "#notice-editor"; 
			if( !$(renderTo).data("noticePlaceHolder") ){
				var noticePlaceHolder = new Announce();
				noticePlaceHolder.set("objectType", getNoticeTarget());
				$(renderTo).data("noticePlaceHolder", noticePlaceHolder );				
			}
			return $(renderTo).data("noticePlaceHolder");			
		}
		
		function setNoticeEditorSource(source){	
			source.copy(getNoticeEditorSource());		
		}

		function openNoticeEditorPanel(){			
			var noticeToUse = getNoticeEditorSource();
			var renderTo = "#notice-editor";			
			if($("#notice-view").data("model")){
				$("#notice-view").data("model").set("visible", false);	
			}
			if(!$(renderTo).data("model")){
				$(renderTo).html($("#notice-edit-template").html());
				var model =  kendo.observable({ 
					announce : new Announce (),
					profilePhotoUrl : "",
					isNew : false,
					update : function (e) {
						var btn = $(e.target);
						btn.button('loading');
						if( this.announce.subject.length ==0 || this.announce.body.length  ){
							common.ui.notification({
								title:"공지 입력 오류", 
								message: "제목 또는 본문을 입력하세요." ,
								hide:function(e){
									btn.button('reset');
								}
							});
							return ;
						}
						if( this.announce.startDate >= this.announce.endDate  ){
							common.ui.notification({
								title:"공지 기간 입력 오류", 
								message: "시작일자가 종료일자보다 이후일 수 없습니다." ,
								hide:function(e){
									btn.button('reset');
								}
							});
							return ;
						}
						common.api.callback({  
							url : '${request.contextPath}/community/update-announce.do?output=json',
							data : { item: kendo.stringify( this.announce.clone() ) },
							success : function(response){
								$("#notice-grid").data('kendoGrid').dataSource.read();
							},
							fail: function(){								
								common.ui.notification({
									title:"저장 오류", 
									message: "시스템 운영자에게 문의하여 주십시오." ,
									hide:function(e){
										btn.button('reset');
									}
								});								
							},
							requestStart : function(){
								kendo.ui.progress($(renderTo), true);
							},
							requestEnd : function(){
								kendo.ui.progress($(renderTo), false);
							},
							always : function(e){
								btn.button('reset');
							}
						});
						
						
						/*
						var template = kendo.template('<p class="text-danger">#:message#</p>');
						if( this.announce.startDate >= this.announce.endDate  ){
							common.ui.notification({title:"공지 & 이베트", message: "시작일자가 종료일자보다 이후일 수 없습니다." });
							return ;
						}			

						common.api.callback({  
							url : '${request.contextPath}/community/update-announce.do?output=json',
							data : { item: kendo.stringify( this.announce ) },
							success : function(response){
								common.ui.notification({title:"공지 & 이베트", message: "정상적으로 저장되었습니다.", type: "success" });
								this.set("visible", false);	
								$("#announce-grid").data('kendoGrid').dataSource.read();
							},
							fail: function(){								
								common.ui.notification({title:"공지 & 이베트", message: "시스템 운영자에게 문의하여 주십시오." });
							},
							requestStart : function(){
								kendo.ui.progress(renderTo, true);
							},
							requestEnd : function(){
								kendo.ui.progress(renderTo, false);
							},
							always : function(e){
								btn.button('reset');
								this.closeEditor(e);
							}
						});
						*/
					},
					visible: false,
					changed : false,
					close : function(e){
						this.set("visible", false);	
						if( $("#notice-view").data("model") && $("#notice-view").data("model").announce.announceId == this.announce.announceId	){
							$("#notice-view").data("model").set("visible", true);	
						}		
					}
				});
				model.bind("change", function(e){
					if( e.field == "visible" ){ 				
						if(!this.visible ){
							$("button[data-action='new-notice'][disabled]").prop("disabled", false);
						}					
					}
				});				
				kendo.bind($(renderTo), model );
				$(renderTo).data("model", model );
				var bodyEditor =  $("#notice-editor-body" );
				createEditor( "notice-editor" , bodyEditor );				
			}	
			noticeToUse.copy( $(renderTo).data("model").announce  );	
			$(renderTo).data("model").set("changed", false);			
			$(renderTo).data("model").set("visible", true);			
			$(renderTo).data("model").set("isNew", (noticeToUse.announceId < 1 ));			
		}
		
		<!-- ============================== -->
		<!-- Notice viewer , editor 						       -->
		<!-- ============================== -->					
		function showNoticeViewer(){
			var announcePlaceHolder = getNoticeEditorSource();
			if( announcePlaceHolder.announceId > 0 ){					
				if( $('#notice-viewer').text().trim().length == 0 ){			
					var template = kendo.template($('#announcement-viewer-template').html());		
					$('#notice-viewer').html( template );				
					var noticeViewerModel =  kendo.observable({ 
						announce : announcePlaceHolder,
						profilePhotoUrl : function(){
							return common.api.user.photoUrl (this.get("announce").user, 150,150);
						},
						editable : function(){
							var currentUser = $("#account-navbar").data("kendoExtAccounts").token;
							if( currentUser.hasRole("ROLE_ADMIN") || currentUser.hasRole("ROLE_ADMIN_SITE") ){
								return true;
							}
							return false;
						},
						openNoticeEditor : showNoticeEditor,
						closeViewer : function(e){
							kendo.fx($("#notice-viewer-panel")).expand("vertical").duration(200).reverse();								
							kendo.fx($('#announce-panel > .panel > .panel-body').first()).expand("vertical").duration(200).play();							
						}
					});						
					kendo.bind($("#notice-viewer-panel"), noticeViewerModel );
				}			
				$('#announce-panel > .panel > .panel-body').first().hide();
				kendo.fx($("#notice-viewer-panel")).expand("vertical").duration(200).play();			
			}
		}
		
		

		
	



								
		function createNoticeGrid2(){
			if( !$("#notice-grid").data('kendoGrid') ){				
				$("#notice-grid").data('announceTargetPlaceHolder', 30);				
				$("#notice-grid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport: {
							read: {
								type : 'POST',
								dataType : "json", 
								url : '${request.contextPath}/community/list-announce.do?output=json'
							},
							parameterMap: function(options, operation) {
								if (operation != "read" && options.models) {
									return {models: kendo.stringify(options.models)};
								}else{								
									return {objectType: $("#announce-grid").data('announceTargetPlaceHolder') };								
								}
							} 
						},
						pageSize: 10,
						error:common.api.handleKendoAjaxError,
						schema: {
							data : "targetAnnounces",
							model : Announce,
							total : "totalAnnounceCount"
						}
					}),
					sortable: true,
					columns: [ 
						{field:"creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}", attributes: { "class": "table-cell", style: "text-align: center " }} ,
						{field: "subject", title: "제목", headerAttributes: { "class": "table-header-cell", style: "text-align: center"}, template: '#: subject # <div class="btn-group"><button type="button" class="btn btn-warning btn-xs" onclick="showNoticeEditor();return false;">편집</a><button type="button" class="btn btn-warning btn-xs" onclick="showNoticeViewer();return false;">보기</a></div>'}, 
					],
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },									
					selectable: "row",
					change: function(e) { 
						var selectedCells = this.select();
						if( selectedCells.length > 0){
							var selectedCell = this.dataItem( selectedCells );								
							setNoticeEditorSource(selectedCell);
						}
					},
					dataBound: function(e) {
					}
				});		
				
				common.api.handlePanelHeaderActions($("#announce-panel"));
				common.ui.handleButtonActionEvents($("#announce-panel button.btn-control-group"), 	{event: 'click', handlers: {
						'new-notice' : function(e){
							var announcePlaceHolder = new Announce();
							announcePlaceHolder.set("objectType", 30);
							setNoticeEditorSource(announcePlaceHolder);		
							showNoticeEditor();			
						}
					}}				
				);
				
				common.ui.handleActionEvents( $('input[name="announce-selected-target"]'), { event: 'change' , handler: function(e){				
					var oldSelectedSource = $("#announce-grid").data('announceTargetPlaceHolder');
					if( oldSelectedSource != this.value ){
						$("#announce-grid").data('announceTargetPlaceHolder', this.value );
						$("#announce-grid").data('kendoGrid').dataSource.read();
					}					
				}});					
				$("#announce-panel" ).show();
			}	
		}	
		
				
						
		function createAttachmentListView(){			
			if( !$('#attachment-list-view').data('kendoListView') ){														
				var attachementTotalModle = kendo.observable({ 
					totalAttachCount : "0",
					totalImageCount : "0",
					totalFileCount : "0"							
				});							
				kendo.bind($("#attachment-list-filter"), attachementTotalModle );													
					$("#attachment-list-view").kendoListView({
						dataSource: {
							type: 'json',
							transport: {
								read: { url:'${request.contextPath}/community/list-my-attachement.do?output=json', type: 'POST' },		
								destroy: { url:'${request.contextPath}/community/delete-my-attachment.do?output=json', type:'POST' },                                
								parameterMap: function (options, operation){
									if (operation != "read" && options) {										                        								                       	 	
										return { attachmentId :options.attachmentId };									                            	
									}else{
										 return { startIndex: options.skip, pageSize: options.pageSize }
									}
								}
							},
							pageSize: 12,
							error:common.api.handleKendoAjaxError,
							schema: {
								model: Attachment,
								data : "targetAttachments",
								total : "totalTargetAttachmentCount"
							},
							sort: { field: "attachmentId", dir: "desc" },
							filter :  { field: "contentType", operator: "neq", value: "" }
						},
						selectable: "single",									
						change: function(e) {									
							var data = this.dataSource.view() ;
							var item = data[this.select().index()];		
							$("#attachment-list-view").data( "attachPlaceHolder", item );												
							displayAttachmentPanel( ) ;	
						},
						navigatable: false,
						template: kendo.template($("#attachment-list-view-template").html()),								
						dataBound: function(e) {
							var attachment_list_view = $('#attachment-list-view').data('kendoListView');
							var filter =  attachment_list_view.dataSource.filter().filters[0].value;
							var totalCount = attachment_list_view.dataSource.total();
							if( filter == "image" ) 
							{
								attachementTotalModle.set("totalImageCount", totalCount);
							} else if ( filter == "application" ) {
								attachementTotalModle.set("totalFileCount", totalCount);
							} else {
								attachementTotalModle.set("totalAttachCount", totalCount);
							}
						}
					});																	
				
					$("#attachment-list-view").on("mouseenter",  ".img-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
					}).on("mouseleave", ".img-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
					});															
														
					$("input[name='attachment-list-view-filters']").on("change", function () {
						var attachment_list_view = $('#attachment-list-view').data('kendoListView');
						switch(this.value){
							case "all" :
								attachment_list_view.dataSource.filter(  { field: "contentType", operator: "neq", value: "" } ) ; 
								break;
							case "image" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "image" }) ; 
								break;
							case "file" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "application" }) ; 
								break;
						}
					});
							
					$("#pager").kendoPager({
						refresh : true,
						buttonCount : 5,
						dataSource : $('#attachment-list-view').data('kendoListView').dataSource
					});								


				common.ui.handleButtonActionEvents(
					$("#my-files button.btn-control-group"), 
					{event: 'click', handlers: {
						upload : function(e){
							if( !$('#attachment-files').data('kendoUpload') ){		
										$("#attachment-files").kendoUpload({
										 	multiple : false,
										 	width: 300,
										 	showFileList : false,
										    localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
										    async: {
												saveUrl:  '${request.contextPath}/community/save-my-attachments.do?output=json',							   
												autoUpload: true
										    },
										    upload: function (e) {								         
										    	 e.data = {};														    								    	 		    	 
										    },
										    success : function(e) {								    
												if( e.response.targetAttachment ){
													e.response.targetAttachment.attachmentId;
													// LIST VIEW REFRESH...
													$('#attachment-list-view').data('kendoListView').dataSource.read(); 
												}				
											}
										});						
							}
							$("#my-files .custom-upload").toggleClass("hide");				
						},
						'upload-close' : function(e){
							$("#my-files .custom-upload").toggleClass("hide");		
						}													 
					}}
				);						
			}		
		}
		
		<!-- ============================== -->
		<!-- create website photo grid									-->
		<!-- ============================== -->						
		function createPhotoListView(){
			if( !$('#photo-list-view').data('kendoListView') ){			
				$("#photo-list-view").kendoListView({
					dataSource: {
						type: 'json',
							transport: {
								read: { url:'${request.contextPath}/community/list-my-website-image.do?output=json', type: 'POST' },
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
						serverPaging: true
					},
					selectable: "single",									
					change: function(e) {									
						var data = this.dataSource.view() ;
						var current_index = this.select().index();
						var total_index = this.dataSource.view().length -1 ;
						var list_view_pager = $("#photo-list-pager").data("kendoPager");	
						var item = data[current_index];			
						//item.manupulate();								
						//common.api.pager(item, current_index,total_index, list_view_pager.page(), list_view_pager.totalPages());
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
				
				common.ui.handleButtonActionEvents(
					$("#website-photo-stream button.btn-control-group"), 
					{event: 'click', handlers: {
						upload : function(e){
							if( !$("#photo-files").data("kendoUpload")	){					
								$("#photo-files").kendoUpload({
									multiple : true,
									width: 300,
									showFileList : false,
									localization:{ select : '사진 선택' , dropFilesHere : '업로드할 사진들을 이곳에 끌어 놓으세요.' },
									async: {
										saveUrl:  '${request.contextPath}/community/update-my-website-image.do?output=json',							   
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
								var uploadModel = kendo.observable({
									data : {
										sourceUrl : null, 
										imageUrl : null
									},
									reset: function(e){
										this.data.sourceUrl = null;
										this.data.imageUrl = null;
									},
									upload: function(e) {
										e.preventDefault();	
										var hasError = false;	
										$('#website-photo-stream form div.form-group.has-error').removeClass("has-error");								
										if( this.data.sourceUrl == null || this.data.sourceUrl.length == 0 || !common.api.isValidUrl( this.data.sourceUrl) ){
											$('#website-photo-stream form div.form-group').eq(0).addClass("has-error");			
											hasError = true;					
										}else{
											if( $('#website-photo-stream form div.form-group').eq(0).hasClass("has-error") ){
												$('#website-photo-stream form div.form-group').eq(0).removeClass("has-error");
											}											
										}																				
										if( this.data.imageUrl == null || this.data.imageUrl.length == 0 || !common.api.isValidUrl(this.data.imageUrl)  ){
											$('#website-photo-stream form div.form-group').eq(1).addClass("has-error");
											hasError = true;		
										}else{
											if( $('#website-photo-stream form div.form-group').eq(1).hasClass("has-error") ){
												$('#website-photo-stream form div.form-group').eq(1).removeClass("has-error");
											}											
										}				
										if( !hasError ){
											var btn = $(e.target);
											btn.button('loading');												
											common.api.uploadMyImageByUrl({
												url :  '${request.contextPath}/community/upload-my-website-by-url.do?output=json',	
												data : this.data ,
												success : function(response){
													var photo_list_view = $('#photo-list-view').data('kendoListView');
													photo_list_view.dataSource.read();
													var selectedCells = photo_list_view.select();
													photo_list_view.select("tr:eq(1)");			
												},
												always : function(){
													btn.button('reset');
													$('#my-photo-stream form')[0].reset();
													uploadModel.reset();
												}
											});		
										}				
										return false;
									}
								});
								kendo.bind($("#website-photo-stream form"), uploadModel);
							}							
							$('#website-photo-stream form div.form-group.has-error').removeClass("has-error");
							$("#website-photo-stream .custom-upload").toggleClass("hide");				
						},	  
						'upload-close' : function(e){
							$("#website-photo-stream .custom-upload").toggleClass("hide");		
						}													 
					}}
				);
			}
		}

		<!-- ============================== -->
		<!-- display attachement panel                          -->
		<!-- ============================== -->			
		function displayAttachmentPanel(){					
			var renderToString =  "attachement-panel-0";	
			var attachPlaceHolder = $("#attachment-list-view").data( "attachPlaceHolder" );					
			if( $("#" + renderToString ).length == 0  ){			
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template('<div id="#: panelId #" class="custom-panels-group col-sm-#: colSize#" style="display:none;"></div>');				
				$("#personalized-area").append( template( {panelId:renderToString, colSize: grid_col_size.newValue } ) );	
			}							
			if( !$( "#" + renderToString ).data("extPanel") ){					
				$("#" + renderToString ).data("extPanel", 
					$("#" + renderToString ).extPanel({
						template : kendo.template($("#file-panel-template").html()),
						data : attachPlaceHolder,
						refresh : true, 
						afterChange : function ( data ){
							if( data.contentType == "application/pdf" ){
								var loadSuccess = new PDFObject({ url: "${request.contextPath}/community/view-my-attachment.do?attachmentId=" + data.attachmentId, pdfOpenParams: { view: "FitV" } }).embed("pdf-view");				
							}									
							$("#update-attach-file").kendoUpload({
								multiple: false,
								async: {
									saveUrl:  '${request.contextPath}/community/update-my-attachment.do?output=json',							   
									autoUpload: true
								},
								localization:{ select : '파일 변경하기' , dropFilesHere : '새로운 파일을 이곳에 끌어 놓으세요.' },	
								upload: function (e) {				
									e.data = { attachmentId: $("#attach-view-panel").data( "attachPlaceHolder").attachmentId };														    								    	 		    	 
								},
								success: function (e) {				
									if( e.response.targetAttachment ){
										 $("#attach-view-panel").data( "attachPlaceHolder",  e.response.targetAttachment  );
										kendo.bind($("#attach-view-panel"), e.response.targetAttachment );
									}
								} 
							});												
						},
						commands:[
							{ selector :   "#" + renderToString + " .panel-body:first .btn", 
							  handler : function(e){
								e.preventDefault();
								var _ele = $(this);
								if( _ele.hasClass( 'custom-delete') ){
									alert( $("#attachment-list-view").data( "attachPlaceHolder" ).attachmentId );
									/**
									$.ajax({
										dataType : "json",
										type : 'POST',
										url : '${request.contextPath}/community/delete-my-attachment.do?output=json',
										data : { attachmentId: attachPlaceHolder.attachmentId },
										success : function( response ){
											$('#' + renderToString ).remove();
										},
										error:common.api.handleKendoAjaxError
									});
									*/								
								}
							}}
						]
					})
				 );				 
			}else{
				$("#" + renderToString ).data("extPanel").data(attachPlaceHolder);
			}			
			//CHANGE
			var panel = $("#" + renderToString ).data("extPanel");
			panel.show();		
		}	
						
		<!-- ============================== -->
		<!-- display photo  panel                                  -->
		<!-- ============================== -->		
		function displayPhotoSource(photo){
			if(  typeof photo === 'undefined' ){
				var photoPlaceHolder = $("#photo-list-view").data( "photoPlaceHolder");
				if( !photoPlaceHolder ){
					photoPlaceHolder = new Image();
				}
				return photoPlaceHolder;
			}
		}
		
		function photoEditorSource (photo){			
			var modal = $('#photo-editor-modal').data("kendoExtModalWindow");			
			if(  typeof photo === 'undefined' ){
				if( modal ){
					return modal.data().image
				}else{
					return new Image();
				}
			}else{
				if( modal ){
					photo.copy( modal.data().image);
				}
			}
		}
		
		function displayPhotoPanel(){			
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));			
			var photoPlaceHolder = displayPhotoSource();
			common.ui.panel({
				appendTo: appendTo,
				title: photoPlaceHolder.name, 
				actions:["Custom", "Minimize", "Refresh", "Close"],
				template: kendo.template($("#photo-view-template").html()),   
				data: photoPlaceHolder, 
				close: function(e) {

				},
				custom: function(e){					
					var modal = common.ui.modal({
						renderTo : "photo-editor-modal",
						data: new kendo.data.ObservableObject({
							image : new Image(e.target.data())
						}),
						open: function(e){											
							var grid = e.target.element.find(".modal-body .photo-props-grid");							
							var shared = e.target.element.find(".modal-body input[name='photo-public-shared']");
							var upload = e.target.element.find(".modal-body input[name='update-photo-file']");
							
							if( grid.length > 0 && !grid.data('kendoGrid') ){
							
								grid.kendoGrid({
									dataSource : {		
										transport: { 
											read: { url:'/community/get-my-image-property.do?output=json', type:'post' },
											create: { url:'/community/update-my-image-property.do?output=json', type:'post' },
											update: { url:'/community/update-my-image-property.do?output=json', type:'post'  },
											destroy: { url:'/community/delete-my-image-property.do?output=json', type:'post' },
									 		parameterMap: function (options, operation){			
										 		if (operation !== "read" && options.models) {
										 			return { imageId: photoEditorSource().imageId, items: kendo.stringify(options.models)};
												} 
												return { imageId: photoEditorSource().imageId }
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
									autoBind: false,
									height: 180,
									toolbar: [
										{ name: "create", text: "추가" },
										{ name: "save", text: "저장" },
										{ name: "cancel", text: "취소" }
									],				     
									change: function(e) {
									}
								});										
								if(shared.length > 0){
									shared.on("change", function () {
										var newValue = ( this.value == 1 ) ;
										var oldValue =  photoEditorSource().shared ;					
										if( oldValue != newValue){
											if(newValue){
												common.api.streams.add({
													imageId: photoEditorSource().imageId,
													success : function( data ) {
														photoEditorSource().shared = true ;
													}
												});							
											}else{
												common.api.streams.remove({
													imageId: photoEditorSource().imageId,
													success : function( data ) {
														photoEditorSource().shared = false ;
													}
												});					
											}
										}					
									});					
								}
								if( upload.length > 0 ){								
									upload.kendoUpload({
										showFileList: false,
										multiple: false,
										async: {
											saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',
											autoUpload: true
										},
										localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
										upload: function (e) {				
											e.data = { imageId: photoEditorSource().imageId };
										},
										success: function (e) {				
											if( e.response.targetImage ){
												$('#photo-list-view').data('kendoListView').dataSource.read();
											}
										} 
									});														
								}									
							}									
							grid.data('kendoGrid').dataSource.read();							
							common.api.streams.details({
								imageId : photoEditorSource().imageId ,
								success : function( data ) {
									if( data.photos.length > 0 ){
										photoEditorSource().shared = true ;
										shared.first().click();
									}else{
										photoEditorSource().shared = false ;
										shared.last().click();
									}
								}
							});												
						},
						template: kendo.template($("#photo-editor-modal-template").html())
					});
					photoEditorSource(  e.target.data() );
					modal.open();
				}
			});			
		}					
		-->
		</script>		
		<style scoped="scoped">
		
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-gray">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- END HEADER -->	
			<!-- START MAIN CONTENT -->
			<div class="container-fluid">		
				<div class="navbar navbar-personalized navbar-inverse" role="navigation">
							<ul class="nav navbar-nav pull-right">
								<li><button type="button" class="btn btn-primary navbar-btn" data-toggle="button" data-action="show-notice-section" >공지 & 이벤트 </button></li>
								<li class="hidden-xs"><p class="navbar-text">레이아웃</p> </li>
								<li class="hidden-xs">
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
							</ul>
				</div><!-- ./navbar-personalized -->		
				<div id="personalized-area" class="row" style="min-height:10px;"></div>				
			</div><!-- ./container-fluid -->	
			
			<div id="notice-section" class="one-page">
				<div class="one-page-inner one-default">
					<div class="container">	
						<button type="button" class="close fa-3x" data-dismiss="section" data-target="#notice-section" data-switch-target="button[data-action='show-notice-section']" ><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h1>공지 & 이벤트 
							<small>		
								소스를 선택하세요.
							</small>
						</h1>		
						<div class="row ">
							<div class="col-sm-4">
								<div class="one-page-btn">
									<div id="notice-target-button" class="btn-group" data-toggle="buttons">
										<label class="btn btn-info btn-sm active">
											<input type="radio" name="notice-target" value="30" >사이트
										</label>
										<label class="btn btn-info btn-sm ">
											<input type="radio" name="notice-target" value="1">회사
										</label>
									</div>
									<button type="button"	class="btn-u btn-u-red pull-right" data-action="new-notice"><i class="fa fa-plus"></i> 공지 추가</button>
								</div>		
								<div  id="notice-grid"></div>
							</div>
							<div class="col-sm-8">
								<div  id="notice-view"></div>
								<div  id="notice-editor"></div>	
							</div>
						</div>				
					</div>
				</div>	
			</div><!-- ./ong-page -->		
			
			
							
		<div class="container padding-sm" style="min-height:600px;">			
			<div class="row blank-top-10">				
				<div id="announce-panel" class="custom-panels-group col-sm-6" style="display:none;">	
					<div class="panel panel-default">
						<div class="panel-heading"><i class="fa fa-bell-o"></i>&nbsp;공지 & 이벤트
							<div class="k-window-actions panel-header-controls">										
								<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
								<a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
								<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>										
								<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-close">Close</span></a>
							</div>
							</div>
							<div class="panel-body" style="padding:5px;">
								<div class="page-header text-primary" style="height:100px;">
									<h5>
										<small><i class="fa fa-info"></i> 사이트(${webSite.displayName})/회사(${user.company.displayName}) 버튼을 클릭하면 해당하는 공지 & 이벤트 목록이 보여집니다.</small>
										<p>
											<div  id="announce-grid"></div>		
										</p>
									</h5>
									<#if request.isUserInRole("ROLE_ADMIN") || request.isUserInRole("ROLE_ADMIN_SITE") >
										<div class="pull-right">
											<button type="button" class="btn btn-primary btn-sm btn-control-group" data-action="new"><i class="fa fa-plus"></i> 공지 및 이벤트 추가</button>
										</div>											
									</#if>
								</div>								
								
							</div>
							<div  id="notice-viewer-panel" class="panel-body" style="display:none;">
									<div class="row">
										<div class="col-lg-12">
											<div class="page-header page-nounderline-header text-primary" style="min-height: 45px;">
												<h5 >
													<small><i class="fa fa-info"></i> 닫기 버튼을 클릭하면 목록이 보여집니다.</small>
												</h5>
												<div class="pull-right">
													<div class="btn-group">
														<button type="button" class="btn btn-primary btn-sm" data-bind="click: openNoticeEditor, enabled: editable" >편집</button>													
													</div>						
													<button type="button" class="btn btn-primary btn-notice-control-group btn-sm" data-bind="click: closeViewer">&times;  닫기</button>
												</div>
											</div>																		
										</div>
									</div>		
									<div class="row">
										<div class="col-lg-12">
											<div class="panel panel-default" style="margin-bottom: 20px;">
												<div class="panel-body">													
															<div  id="notice-viewer"></div>																						
												</div>
											</div>												
										</div>																		
									</div>
							</div>
							<div  id="notice-editor-panel" class="panel-body" style="display:none;">
								<div class="page-header page-nounderline-header text-primary" style="min-height: 45px;">
									<h5 >
										<small><i class="fa fa-info"></i> 닫기 버튼을 클릭하면 목록이 보여집니다.</small>
									</h5>
									<div class="pull-right">
										<div class="btn-group">
											<button type="button" class="btn btn-primary btn-sm" data-bind="click: doSave, enabled: updateRequired" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >저장</button>			
											<button type="button" class="btn btn-primary btn-sm" data-toggle="button"  data-bind="click: openNoticeProps, enabled: editable, invisible:isNew">프로퍼티</button>
										</div>						
										<button type="button" class="btn btn-primary btn-notice-control-group btn-sm" data-bind="click: closeEditor">&times;  닫기</button>
									</div>
								</div>								
								<div  id="notice-editor"></div>	
							</div>
						</div>		
					</div>
				</div>		
			</div>				
		</section>		

		<!-- start side menu -->
		<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">			
			<button type="button" class="btn-close" data-dismiss='spmenu' >Close</button>
			<!-- tab-v1 -->
			<div class="tab-v1" >			
				<h5 class="side-section-title white">${webSite.description} 클라우드 저장소</h5>	
				<ul class="nav nav-tabs" id="myTab" style="padding-left:5px;">
				<#if !action.user.anonymous >	
					<li><a href="#website-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
					<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
				</#if>						
				</ul>	<!-- ./nav-tabs -->
				<div class="tab-content" style="background-color : #FFFFFF; padding:5px;">
					<div class="tab-pane" id="my-files">
						<section class="custom-upload hide">
							<div class="panel panel-default">
								<div class="panel-body">		
								<button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>															
								<#if !action.user.anonymous >			
								<div class="page-header text-primary">
									<h5><i class="fa fa-upload"></i>&nbsp;<strong>파일 업로드</strong>&nbsp;<small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
								</div>								
								<input name="uploadAttachment" id="attachment-files" type="file" />												
								</#if>								
								</div>
							</div>
						</section><!-- ./custom-upload -->											
						<div class="panel panel-default">
							<div class="panel-body">
								<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 페이지 영역에 선택한 파일이 보여집니다.</small></p>
								<#if !action.user.anonymous >		
								<p class="pull-right">				
									<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
								</p>	
								</#if>																										
								<div class="btn-group" data-toggle="buttons" id="attachment-list-filter">
									<label class="btn btn-sm btn-warning active">
										<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
									</label>
									<label class="btn btn-sm btn-warning">
										<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
									</label>
									<label class="btn btn-sm btn-warning">
										<input type="radio" name="attachment-list-view-filters"  value="file"><i class="fa fa-filter"></i> 파일
									</label>	
								</div>												
							</div>
							<div class="panel-body" style="max-height:450px;">
								<div id="attachment-list-view" class="file-listview"></div>
							</div>	
							<div class="panel-footer no-padding">
								<div id="pager" class="image-listview-pager k-pager-wrap"></div>
							</div>
						</div>																				
					</div><!-- ./tab-pane -->	
					<div class="tab-pane" id="website-photo-stream">									
						<section class="custom-upload hide">
												<div class="panel panel-default">
													<div class="panel-body">
														<button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
														<#if !action.user.anonymous >			
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>사진 업로드</strong>&nbsp;<small>아래의 <strong>사진 선택</strong> 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
														</div>
														<div id="my-photo-upload">	
															<input name="uploadPhotos" id="photo-files" type="file" />					
														</div>
														<div class="blank-top-5" ></div>
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>URL 사진 업로드</strong>&nbsp;<small>사진이 존재하는 URL 을 직접 입력하여 주세요.</small></h5>
														</div>						
														<form name="photo-url-upload-form" class="form-horizontal" role="form">
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>출처</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.sourceUrl">
																	<span class="help-block"><small>사진 이미지 출처 URL 을 입력하세요.</small></span>
																</div>
															</div>
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>사진</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.imageUrl">
																	<span class="help-block"><small>사진 이미지 경로가 있는 URL 을 입력하세요.</small></span>
																</div>
															</div>														
															<div class="form-group">
																<div class="col-sm-offset-2 col-sm-10">
																	<button type="submit" class="btn btn-primary btn-sm btn-control-group" data-bind="events: { click: upload }" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-cloud-upload"></i> &nbsp; URL 사진 업로드</button>
																</div>
															</div>
														</form>
														</#if>
													</div>
												</div>	
						</section><!-- ./custom-upload -->	
						<div class="panel panel-default">			
							<div class="panel-body">
								<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 페이지 영역에 선택한 사진이 보여집니다.</small></p>
								<#if !action.user.anonymous >		
								<p class="pull-right">				
									<button type="button" class="btn btn-info btn-sm btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
								</p>	
								</#if>											
							</div>
							<div class="panel-body color4" style="max-height:450px;">
								<div id="photo-list-view" class="image-listview" ></div>
							</div>	
							<div class="panel-footer no-padding">
								<div id="photo-list-pager" class="image-listview-pager k-pager-wrap"></div>
							</div>
						</div>	
					</div><!-- ./tab-pane -->
				</div><!-- ./tab-content-->	
			</div><!-- ./tab-v1 -->		
		</section>		
		<div class="cbp-spmenu-overlay"></div>		
		
		<section id="image-broswer" class="image-broswer"></section>
		<section id="editor-popup"></section>
		<section id="announce-editor"></section>
		
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->			
		<!-- START TEMPLATE -->					
		<script type="text/x-kendo-tmpl" id="notice-edit-template">		
		<div class="animated fadeInLeft" data-bind="visible:visible">
			<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:update}"  data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> <button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
			<h5 data-bind="visible: isNew">
				<small><span class="label label-danger">NEW</span> 모든 항목을 입력하여 주세요.</small>
			</h5>		
			<div class="panel panel-default">
					<div class="panel-heading padding-xxs-hr rounded-top" style="background-color: \\#fff; ">
						<h4 class="panel-title"><input type="text" placeholder="제목을 입력하세요." data-bind="value: announce.subject"  class="form-control" placeholder="제목" /></h4>		
					</div>			
					<div class="panel-body"  style="padding:5px;">									
						<div  class="form">
							<div class="form-group">
								<label class="control-label">공지 기간</label>
								<div class="col-sm-12" >
									<input data-role="datetimepicker" data-bind="value:announce.startDate"> ~ <input data-role="datetimepicker" data-bind="value:announce.endDate">
									<span class="help-block">지정된 기간 동안만 이벤트 및 공지가 보여집니다.</span>
								</div>
							</div>
							<label class="control-label">본문</label>
							<textarea id="notice-editor-body" class="no-border" data-bind='value:announce.body'></textarea>
						</div>						
					</div>					
			</div>					
			<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> <button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
		</div>		
		</script>
		<#include "/html/common/common-homepage-templates.ftl" >	
		<#include "/html/common/common-editor-templates.ftl" >	
		<#include "/html/common/common-personalized-templates.ftl" >	
		<!-- END TEMPLATE -->
	</body>    
</html>