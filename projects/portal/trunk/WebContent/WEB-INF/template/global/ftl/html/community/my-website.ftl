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
			'${request.contextPath}/js/common/common.modernizr.custom.js',				
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
				
			'${request.contextPath}/js/pdfobject/pdfobject.js',			
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common.pages/common.personalized.js',
			'${request.contextPath}/js/ace/ace.js'
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
				
					
				// 3. Notice	
				createNoticeSection();
			
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
			var buttons = common.ui.buttons({
				renderTo: "#notice-target-button",
				type: "radio",
				change: function(e){
					$("#notice-grid").data('kendoGrid').dataSource.read();
				}
			});	
			createNoticeGrid();							
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
						{field: "subject", title: "제목", headerAttributes: { "class": "table-header-cell", style: "text-align: center"}, template: '#: subject # <div class="btn-group"><button type="button" class="btn btn-warning btn-xs" onclick="showNoticeEditor();return false;">편집</a><button type="button" class="btn btn-warning btn-xs" onclick="showNoticeViewer();return false;">보기</a></div>'}, 
					],
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },									
					selectable: "row",
					change: function(e) { 
						var selectedCells = this.select();
						if( selectedCells.length > 0){
							var selectedCell = this.dataItem( selectedCells );								
							//setNoticeEditorSource(selectedCell);
						}
					},
					dataBound: function(e) {
					
					}
				});		
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
		
		function getNoticeEditorSource(){
			if( !$("#notice-editor").data("announcePlaceHolder") ){
				var announcePlaceHolder = new Announce();
				announcePlaceHolder.set("objectType", 30);
				$("#notice-editor").data("announcePlaceHolder", announcePlaceHolder );				
			}
			return $("#notice-editor").data("announcePlaceHolder");			
		}
		
		function setNoticeEditorSource(source){	
			source.copy(getNoticeEditorSource());		
		}
		
		function showNoticeEditor(){			
			var announcePlaceHolder = getNoticeEditorSource();
			var renderTo = $("#notice-editor-panel");			
			if( $('#notice-editor').text().trim().length == 0 ){			
				var template = kendo.template($('#notice-editor-template').html());		
				$('#notice-editor').html( template );	
				var noticeEditorModel =  kendo.observable({ 
					announce : announcePlaceHolder,
					profilePhotoUrl : function(){
						return common.api.user.photoUrl (this.get("announce").user, 150,150);
					},
					isNew : false,
					doSave : function (e) {
						var btn = $(e.target);
						btn.button('loading');
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
					},
					updateRequired : false,
					editable : function(){
						var currentUser = $("#account-navbar").data("kendoExtAccounts").token;
						if( currentUser.hasRole("ROLE_ADMIN") || currentUser.hasRole("ROLE_ADMIN_SITE") ){
							return true;
						}
						return false;
					},
					openNoticeProps : function(e){
					
					},
					closeEditor : function(e){
						kendo.fx(renderTo).expand("vertical").duration(200).reverse();								
						kendo.fx($('#announce-panel > .panel > .panel-body').first()).expand("vertical").duration(200).play();							
					}
				});
				noticeEditorModel.bind("change", function(e){				
					if( e.field.match('^announce.')){ 						
						if( this.announce.subject.length > 0 && this.announce.body.length  > 0 && ( this.announce.startDate <  this.announce.endDate  )  )	{			
							noticeEditorModel.set("updateRequired", true);
						}
					}	
				});	
				kendo.bind(renderTo, noticeEditorModel );
				renderTo.data("model", noticeEditorModel );
				var bodyEditor =  $("#notice-editor-body" );
				createEditor( "notice-editor" , bodyEditor );
			}
			
			renderTo.data("model").set("updateRequired", false);			
			renderTo.data("model").set("isNew", (announcePlaceHolder.announceId < 1 ));
				
			if(announcePlaceHolder.objectType == 30){				
				renderTo.find('input[name="announce-type"]:first').click();
			}else{			
				renderTo.find('input[name="announce-type"]:last').click();
			}

			$('#announce-panel > .panel > .panel-body').hide();
			kendo.fx(renderTo).expand("vertical").duration(200).play();			
		}
		
		<!-- ============================== -->
		<!-- Utils for editor									       -->
		<!-- ============================== -->						
		function createEditor( renderToString, bodyEditor ){
			if(!bodyEditor.data("kendoEditor") ){			
				var imageBroswer = createEditorImageBroswer( renderToString + "-imagebroswer", bodyEditor);				
				var linkPopup = createEditorLinkPopup(renderToString + "-linkpopup", bodyEditor);	
				var htmlEditor = createCodeEditor(renderToString + "-html-editor", bodyEditor);									
				bodyEditor.kendoEditor({
						tools : [ 'bold', 'italic', 'insertUnorderedList', 'insertOrderedList',
							{	
								name: "createLink",
								exec: function(e){
									linkPopup.show();
									return false;
								}},
							'unlink', 
							{	
								name: "insertImage",
								exec: function(e){
									imageBroswer.show();
									return false;
								}},
							{
								name: 'viewHtml',
								exec: function(e){
									htmlEditor.open();
									return false;
								}}							
						],
						stylesheets: [
							"${request.contextPath}/styles/bootstrap/3.1.0/bootstrap.min.css",
							"${request.contextPath}/styles/common/common.ui.css"
						]
				});
			}			
		}

		function createCodeEditor( renderToString, editor ) {		
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"></div>');
			}							
			var renderTo = $("#"+ renderToString);		
			if( !renderTo.data('kendoExtModalWindow') ){						
				renderTo.extModalWindow({
					title : "HTML",
					backdrop : 'static',
					template : $("#code-editor-modal-template").html(),
					refresh : function(e){
						var editor = ace.edit("htmleditor");
						editor.getSession().setMode("ace/mode/xml");
						editor.getSession().setUseWrapMode(true);
					},
					open: function (e){
						ace.edit("htmleditor").setValue(editor.data('kendoEditor').value());
					}					
				});					
				renderTo.find('button.custom-update').click(function () {
					var btn = $(this)			
					editor.data("kendoEditor").value( ace.edit("htmleditor").getValue() );
					renderTo.data('kendoExtModalWindow').close();
				});
			}
			return renderTo.data('kendoExtModalWindow');			
		}
				
		function createEditorImageBroswer(renderToString, editor ){			
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"></div>');
			}					
			var renderTo = $("#"+ renderToString);	
			if(!renderTo.data("kendoExtImageBrowser")){
				var imageBrowser = renderTo.extImageBrowser({
					template : $("#image-broswer-template").html(),
					apply : function(e){						
						editor.data("kendoEditor").exec("inserthtml", { value : e.html } );
						imageBrowser.close();
					}				
				});
			}
			return renderTo.data("kendoExtImageBrowser");
		}
		
		function createEditorLinkPopup(renderToString, editor){		
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"></div>');
			}				
			var renderTo = $("#"+ renderToString);		
			if(!renderTo.data("kendoExtEditorPopup") ){		
				var hyperLinkPopup = renderTo.extEditorPopup({
					type : 'createLink',
					title : "하이퍼링크 삽입",
					template : $("#link-popup-template").html(),
					apply : function(e){						
						editor.data("kendoEditor").exec("inserthtml", { value : e.html } );
						hyperLinkPopup.close();
					}
				});
			}
			return renderTo.data("kendoExtEditorPopup");
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
		.wrapper{
			background-color:transparent;
		}
		
		.wrapper .header {
			background-color: #fff;
		}
		
		#notice-grid .k-grid-content {
			min-height : 300px;
		}
		
		#pdf-view {
			height: 500px;
			margin: 0 auto;
			border: 0px solid #787878;
		}
		
		#pdf-view p {
		   padding: 1em;
		}
		
		#pdf-view object {
		   display: block;
		   border: solid 1px #787878;
		}		
		
		.attach
		{
			float: left;
			position: relative;
			width: 160px;
			height: 160px;
			padding: 0;
			cursor: pointer;
			overflow: hidden;
		}
		
		.attach img
		{
			width: 160px;
			height: 160px;
		}
				
		.attach-description {
			position: absolute;
			top: 0;
			width: 160px	;
			height: 0;
			overflow: hidden;
			background-color: rgba(0,0,0,0.8)
		}
	
		.attach h3
		{
			margin: 0;
			padding: 10px 10px 0 10px;
			line-height: 1.1em;
			font-size : 12px;
			font-weight: normal;
			color: #ffffff;
			word-wrap: break-word;
		}

		.attach p {
			color: #ffffff;
			font-weight: normal;
			padding: 0 10px;
			font-size: 12px;
        }
		
		/** image grid  */		
		#photo-list-view.k-listview ,#attachment-list-view.k-listview {
			width: 100%;
			padding: 0px;
			border: 0px;		
			min-height: 200px;
		}

		.img-wrapper {
			float: left;
			position: relative;
			width: 32.99%;
			height: 170px;
			padding: 0;
			cursor: pointer;
			overflow: hidden;		
		}
		
		.img-wrapper img{
			width: 100%;
			height: 100%;
		}

		
		.image-broswer .img-wrapper.k-state-selected img {
			border-bottom: 5px solid #FF2A68;
			-webkit-transition: all .2s ease-in-out;
			transition: all .2s ease-in-out;
			position: relative;
			margin-top: -5px;
		}
				
		.img-description {
			position: absolute;
			top: 0;
			width: 100%	;
			height: 0;
			overflow: hidden;
			background-color: rgba(0,0,0,0.8)
		}
	
		.img-wrapper h3
		{
			margin: 0;
            padding: 10px 10px 0 10px;
            line-height: 1.1em;
            font-size : 12px;
            font-weight: normal;
            color: #ffffff;
            word-wrap: break-word;
		}

		.img-wrapper p {
			color: #ffffff;
			font-weight: normal;
			padding: 0 10px;
			font-size: 12px;
		}		
		
		
		.k-listview:after, .attach dl:after {
			content: ".";
			display: block;
			height: 0;
			clear: both;
			visibility: hidden;
		}
		
		.k-pager-wrap {
			border : 0px;
			border-width: 0px;
			background : transparent;
		}

				

		table.k-editor {
			height: 400px;
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
		
		.panel .comments-heading a {
			color: #555;
		}
		
		#photo_overlay nav.navbar {
			margin-bottom: 0px; 
		}		
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
			<div class="navbar navbar-personalized navbar-inverse" role="navigation">
						<ul class="nav navbar-nav pull-right">
							<li><button type="button" class="btn btn-primary navbar-btn" data-toggle="button">공지 & 이벤트 </button></li>
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
			<div class="container-fluid">		
				<div id="personalized-area" class="row"></div>				
			</div><!-- ./container-fluid -->	
<div class="one-page">
	<div class="one-page-inner one-default">
		<div class="container">	
			<h1>공지 & 이벤트 
				<small>		
					소스를 선택하세요 	
					<div id="notice-target-button" class="btn-group" data-toggle="buttons">
						<label class="btn btn-info btn-sm active">
							<input type="radio" name="notice-target" value="30" >사이트
						</label>
						<label class="btn btn-info btn-sm ">
							<input type="radio" name="notice-target" value="1">회사
						</label>
					</div>						
				</small>
			</h1>		
			<div class="row ">
				<div class="col-sm-4"><div  id="notice-grid"></div></div>
				<div class="col-sm-8"></div>
			</div>				
		</div>
	</div>	
</div>					
		<div class="container padding-sm" style="min-height:600px;">			
			<div class="row blank-top-10">				
				<div id="announce-panel" class="custom-panels-group col-sm-6" style="display:none;">	
					<div class="panel panel-default">
						<div class="panel-heading"><i class="fa fa-bell-o"></i>&nbsp;공지 & 이벤트
							<div class="k-window-actions panel-header-actions">										
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
											<button type="button" class="btn btn-primary btn-sm btn-control-group" data-action="new-notice"><i class="fa fa-plus"></i> 공지 및 이벤트 추가</button>
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
								<div id="attachment-list-view" class="color4"></div>
							</div>	
							<div class="panel-footer no-padding">
								<div id="pager" class="k-pager-wrap"></div>
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
								<div id="photo-list-view" class="color4" ></div>
							</div>	
							<div class="panel-footer no-padding">
								<div id="photo-list-pager" class="k-pager-wrap"></div>
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

		<script type="text/x-kendo-tmpl" id="attachment-list-view-template">
			<div class="img-wrapper">			
			#if (contentType.match("^image") ) {#
				<img src="${request.contextPath}/community/view-my-attachment.do?width=150&height=150&attachmentId=#:attachmentId#" alt="#:name# 이미지" />
			# } else { #			
				<img src="http://placehold.it/146x146&amp;text=[file]"></a>
			# } #	
				<div class="img-description">
					<h3>#:name#</h3>
					<p>#:size# 바이트</p>
				</div>
			</div>
		</script>	
		<script type="text/x-kendo-tmpl" id="photo-list-view-template">
			<div class="img-wrapper">			
			#if (contentType.match("^image") ) {#
				<img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#:imageId#" alt="#:name# 이미지" />
			# } else { #			
				<img src="http://placehold.it/146x146&amp;text=[file]"></a>
			# } #	
				<div class="img-description">
					<h3>#:name#</h3>
					<p>#:size# 바이트</p>
				</div>
			</div>
		</script>						
		<script type="text/x-kendo-tmpl" id="notice-editor-template">
			<div class="panel panel-default">
				<div class="panel-body"  style="padding:5px;">		
					<div class="page-header text-primary" data-bind="visible: isNew">
						<h5>
							<small><span class="label label-danger">NEW</span> 공지 및 이벤트 생성 대상을 지정하세요. (디폴트는 값은 사이트)</small>
							<div class="btn-group" data-toggle="buttons">
								<label class="btn btn-info btn-sm active"  data-bind="enabled: isNew">
								<input type="radio" name="announce-type" value="30" data-bind="checked: announce.objectType">사이트
								</label>
								<label class="btn btn-info btn-sm" data-bind="enabled: isNew">
								<input type="radio" name="announce-type" value="1" data-bind="checked: announce.objectType">회사
								</label>
							</div>						
						</h5>
					</div>								
					<div  class="form">
						<div class="form-group">
							<label class="control-label"><small>제목</small></label>							
							<input type="text" placeholder="제목을 입력하세요." data-bind="value: announce.subject"  class="form-control" placeholder="제목" />
						</div>
						<div class="form-group">
							<label class="control-label"><small>공지 기간</small></label>
							<div class="col-sm-12" >
								<input data-role="datetimepicker" data-bind="value:announce.startDate"> ~ <input data-role="datetimepicker" data-bind="value:announce.endDate">
								<span class="help-block"><small>지정된 기간 동안만 이벤트 및 공지가 보여집니다. </small></span>
							</div>
						</div>
						<label class="control-label"><small>본문</small></label>
						<textarea id="notice-editor-body" data-bind='value:announce.body'></textarea>
					</div>									
				</div>	
			</div>								
		</script>
		<#include "/html/common/common-homepage-templates.ftl" >	
		<#include "/html/common/common-editor-templates.ftl" >	
		<#include "/html/common/common-personalized-templates.ftl" >	
		<!-- END TEMPLATE -->
	</body>    
</html>