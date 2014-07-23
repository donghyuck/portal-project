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
			'css!${request.contextPath}/styles/jquery.bxslider/jquery.bxslider.css',
			'css!${request.contextPath}/styles/jquery.flexslider/flexslider.css',
			'css!${request.contextPath}/styles/common.plugins/switchery.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
			'css!${request.contextPath}/styles/common.pages/common.onepage.css',
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',			
			'css!${request.contextPath}/styles/codrops/codrops.cbp-spmenu.css',
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/jquery.easing/jquery.easing.1.3.js',		
			'${request.contextPath}/js/jquery.bxslider/jquery.bxslider.min.js',		
			'${request.contextPath}/js/jquery.flexslider/jquery.flexslider-min.js',		
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/common.plugins/switchery.min.js', 		
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
				
			'${request.contextPath}/js/pdfobject/pdfobject.js',			
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],			
			complete: function() {		
				common.ui.setup({
					features:{
						backstretch : true,
						lightbox : true,
						spmenu : true
					}
				});				
				// ACCOUNTS LOAD	
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
						$("#account-navbar").append("<li><a href='#personalized-controls-section' class='btn-control-group navbar-btn-options' data-toggle='spmenu'><i class='fa fa-cloud-upload fa-2x'></i></a></li>");
						$(".navbar .navbar-header").append("<a href='#personalized-controls-section'  data-toggle='spmenu' class='navbar-toggle-inverse visible-xs'><i class='fa fa-cloud-upload fa-2x'></i></a>");			
					}
				});	
				
				// personalized grid setting																																					
				preparePersonalizedArea($("#personalized-area"), 3, 6 );
												
				// photo panel showing				
				createPhotoListView();								
				$('#photo-list-view').data('kendoListView').one('dataBound', function(){
					this.select(this.element.children().first());
				});
																			
				// 4. Right Tabs								
				$('#myTab').on( 'show.bs.tab', function (e) {
					//e.preventDefault();		
					var show_bs_tab = $(e.target);
					if( show_bs_tab.attr('href') == '#my-files' ){					
						createAttachmentListView();
					} else if(show_bs_tab.attr('href') == '#my-photo-stream' ){					
						createPhotoListView();
					}					
				});

				$('#myTab a:first').tab('show') ;

				common.ui.button({
					renderTo: "button[data-action='show-gallery-section']",
					click:function(e){
						createGallerySection();
						common.ui.buttonDisabled($(this));
					}
				});
								
				showNoticePanel();
				// END SCRIPT 				
			}
		}]);	
		<!-- ============================== -->
		<!-- display image gallery                                  -->
		<!-- ============================== -->
		function createGallerySection(){
			var renderTo = "image-gallery";
			if( $( "#" +renderTo).length == 0 ){			
				$(".wrapper .header").after( $("#image-gallery-template").html() );
				var dataSource = new  kendo.data.DataSource({
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
					serverPaging: true,
					change : function(){
						$('#image-gallery-slider').removeData("flexslider");
						$( "#image-gallery-slider ul.slides" ).html(
							kendo.render( kendo.template($("#image-gallery-item-template").html()), this.view() )
						);
						$('#image-gallery-slider').flexslider({
						    animation: "slide"	,
						    controlsContainer: ".flex-container"
						  });
					}
				});
				$(  "#" +renderTo + " .gallery-listview-pager").kendoPager({
					refresh : true,
					buttonCount : 9,
					dataSource : dataSource
				});		
				dataSource.read();							
				common.ui.button({
					renderTo : "#image-gallery-section button[data-dismiss='section'][data-target]"
				});		
			}
			if( $( "#" +renderTo).is(":hidden") ){
				$( "#" +renderTo).show();
			} 			
		}
		<!-- ============================== -->
		<!-- display notice  panel                                  -->
		<!-- ============================== -->
		function showNoticePanel(){
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.panel({
				appendTo: appendTo,
				autoBind: true,
				data: new kendo.data.ObservableObject({
					announce : new Announce(),
					visible : false,
					profilePhotoUrl : "/images/common/anonymous.png"
				}),
				title: "공지 & 이벤트", 
				actions:["Custom", "Minimize", "Close"],
				template: kendo.template($("#notice-viewer-template").html()),   
				custom: function(e){
					var optTemplate = kendo.template($("#notice-options-template").html());
					var heading =  e.target.element.children(".panel-heading");
					var popover = heading.children(".popover");
					if( popover.length === 0 ){
						heading.append(optTemplate({}));
						popover = e.target.element.find(".panel-heading .popover");
						popover.find("button.close").click(function(e){
							popover.hide();
						});
						var grid = e.target.element.find(".panel-body .notice-grid");
						popover.find("input[name='notice-selected-target']").on(
							"change", function(e){
								if( grid.data('kendoGrid')){
									grid.data('kendoGrid').dataSource.read({objectType: this.value });
								}
							}
						);
					}
					popover.show();					
				},
				open: function(e){				
					var grid = e.target.element.find(".panel-body .notice-grid");
					if( grid.length > 0 && !grid.data('kendoGrid') ){
						grid.kendoGrid({
							dataSource : new kendo.data.DataSource({
								transport: {
									read: {
										type : 'POST',
										dataType : "json", 
										url : '${request.contextPath}/community/list-announce.do?output=json'
									},
									parameterMap: function(options, operation) {
										if( typeof options.objectType === "undefined"  ){
											return {objectType: <#if action.user.anonymous >30<#else>1</#if> };	
										}else{			
											return options;		
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
								{field:"subject", title: "제목"}
							],
							pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },									
							selectable: "row",
							change: function(e) { 
								var selectedCells = this.select();
								if( selectedCells.length > 0){
									var selectedCell = this.dataItem( selectedCells );	
									selectedCell.copy( panel.data().announce  );
									panel.data().set("visible", true);
									panel.data().set("profilePhotoUrl", common.api.user.photoUrl (selectedCell.user, 150,150) );
								}
							},
							dataBound:function(e){
								panel.data().set("visible", false);
							}
						});		
					}
				}
			});
		}
		<!-- ============================== -->
		<!-- create my attachment grid							-->
		<!-- ============================== -->									
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
				
					$("#attachment-list-view").on("mouseenter",  ".file-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".file-description")).expand("vertical").stop().play();
					}).on("mouseleave", ".file-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".file-description")).expand("vertical").stop().reverse();
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
													$('#attachment-list-view').data('kendoListView').dataSource.read(); 
												}				
											}
										});						
							}
							$("#my-files .panel-upload").slideToggle(200);			
						},
						'upload-close' : function(e){
							$("#my-files .panel-upload").slideToggle(200);			
						}													 
					}}
				);						
			}		
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
									serverPaging: true
								},
								selectable: "single",									
								change: function(e) {									
									var data = this.dataSource.view() ;
									var current_index = this.select().index();
									var total_index = this.dataSource.view().length -1 ;
									var list_view_pager = $("#photo-list-pager").data("kendoPager");	
									var item = data[current_index];								
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
					$("#my-photo-stream button.btn-control-group"), 
					{event: 'click', handlers: {
						upload : function(e){
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
										$('#my-photo-stream form div.form-group.has-error').removeClass("has-error");								
										if( this.data.sourceUrl == null || this.data.sourceUrl.length == 0 || !common.api.isValidUrl( this.data.sourceUrl) ){
											$('#my-photo-stream form div.form-group').eq(0).addClass("has-error");			
											hasError = true;					
										}else{
											if( $('#my-photo-stream form div.form-group').eq(0).hasClass("has-error") ){
												$('#my-photo-stream form div.form-group').eq(0).removeClass("has-error");
											}											
										}																				
										if( this.data.imageUrl == null || this.data.imageUrl.length == 0 || !common.api.isValidUrl(this.data.imageUrl)  ){
											$('#my-photo-stream form div.form-group').eq(1).addClass("has-error");
											hasError = true;		
										}else{
											if( $('#my-photo-stream form div.form-group').eq(1).hasClass("has-error") ){
												$('#my-photo-stream form div.form-group').eq(1).removeClass("has-error");
											}											
										}				
										if( !hasError ){
											var btn = $(e.target);
											btn.button('loading');												
											common.api.uploadMyImageByUrl({
												data : this.data ,
												success : function(response){
													var photo_list_view = $('#photo-list-view').data('kendoListView');
													photo_list_view.dataSource.read();
													//var selectedCells = photo_list_view.select();
													//photo_list_view.select("tr:eq(1)");			
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
								kendo.bind($("#my-photo-stream form"), uploadModel);
							}							
							$('#my-photo-stream form div.form-group.has-error').removeClass("has-error");
							$("#my-photo-stream .panel-upload").slideToggle(200);			
						},	  
						'upload-close' : function(e){
							$("#my-photo-stream .panel-upload").slideToggle(200);		
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
			.flexslider .slides li {
				position: relative;
			}
			/*.flexslider .slides li img {max-height: 100%}		*/
			.flex-caption {
			    position: absolute;
			    bottom: 0;
			    left: 0;
			    margin: 0;
			    padding: 10px;
			    color: white;
			    width:100%;
			    background-color: rgba(0,0,0,0.5);
			}
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<div class="container-fluid" style="min-height:300px;">		
				<div class="navbar navbar-personalized navbar-inverse padding-sm" role="navigation">
					<ul class="nav navbar-nav pull-right">
							<li><button type="button" class="btn btn-primary navbar-btn" data-toggle="button" data-action="show-gallery-section" >이미지 갤러리 </button></li>
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
							<!--<li><a href="#personalized-controls-section" class="btn-control-group no-padding-b" data-toggle="menu"><i class="fa fa-cloud-upload fa-2x"></i></a></li>-->
					</ul>
				</div><!-- ./navbar-personalized -->
				<div id="personalized-area" class="row"></div>
			</div>		
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- ./END FOOTER -->					
		</div>
				
			<!-- START RIGHT SLIDE MENU -->
			<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">		
				<!-- tab-v1 -->
				<button type="button" class="btn-close" data-dismiss='spmenu' >Close</button>
				<div class="tab-v1" >			
					<h5 class="side-section-title white">My 클라우드 저장소</h5>			
					<ul class="nav nav-tabs" id="myTab" style="padding-left:5px;">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
						</#if>						
					</ul>		
					<!-- tab-content -->		
					<div class="tab-content" style="background-color : #FFFFFF; padding:5px;">
						<!-- start attachement tab-pane -->
						<div class="tab-pane" id="my-files">
								<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
								<div class="panel-heading">
									<strong><i class="fa fa-cloud-upload  fa-lg"></i> 파일 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
								</div>						
									<div class="panel-body">													
										<#if !action.user.anonymous >			
											<div class="page-header text-primary">
												<h5><i class="fa fa-upload"></i>&nbsp;<strong>파일 업로드</strong>&nbsp;<small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
											</div>								
											<input name="uploadAttachment" id="attachment-files" type="file" />												
										</#if>								
									</div>
								</div>
							<div class="panel panel-default">
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small></p>
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
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="attachment-list-view" class="file-listview"></div>
								</div>	
								<div class="panel-footer no-padding">
										<div id="pager" class="file-listview-pager k-pager-wrap"></div>
								</div>
							</div>																				
						</div><!-- end attachements  tab-pane -->		
						<!-- start photos  tab-pane -->
						<div class="tab-pane" id="my-photo-stream">									
												<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
							<div class="panel-heading">
								<strong><i class="fa fa-cloud-upload  fa-lg"></i> 사진 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
							</div>												
													<div class="panel-body">
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

							<div class="panel panel-default">			
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
									</p>	
									</#if>											
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="photo-list-view" class="image-listview" ></div>
								</div>	
								<div class="panel-footer no-padding">
									<div id="photo-list-pager" class="image-listview-pager k-pager-wrap"></div>
								</div>
							</div>	
						</div><!-- end photos  tab-pane -->
					</div><!-- end of tab content -->
				</div>	
			</section>	
			<div class="cbp-spmenu-overlay"></div>			
			<!-- ./END RIGHT SLIDE MENU -->
							
		<!-- START TEMPLATE -->									
	<!-- ============================== -->
	<!-- gallery template                                        -->
	<!-- ============================== -->
	<script type="text/x-kendo-template" id="image-gallery-item-template2">	
	<li data-thumb="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#">
      <img src="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" />
      <p class='flex-caption'>#: name #</p>
    </li>
	/*
	<div class="item">
		<img src="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" alt="">
		<div class="carousel-caption">
			<p>#: name #</p>
		</div>
	</div>
	*/	
	</script>
	<script type="text/x-kendo-template" id="image-gallery-item-template">			
	<li data-thumb="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#">
      <img src="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" />
       <p class='flex-caption'>#: name #</p>
    </li>
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-template">	
	<div id="image-gallery" class="one-page animated bounceInUp  no-padding-t no-border">
		<div class="one-page-inner one-dark">
			<div class="container">	
				<button type="button" class="close fa-3x" data-dismiss="section" data-target="#image-gallery-section" data-switch-target="button[data-action='show-gallery-section']" ><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h1>공지 & 이벤트 
					<small>	</small>
				</h1>
				<div class="row">
					<div class="col-xs-12">		
						<div class="gallery-listview-pager k-pager-wrap no-border-b"></div>
						<div id="#gallery-slider" class="flexslider">
							<ul class="slides">
							</ul>
						</div>	
					</div>	
				</div>
			</div>	
		</div>		
	</div>
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-template2">	
	<div id="image-gallery" class="one-page animated bounceInUp  no-padding-t no-border" >
		<div class="one-page-inner one-blue">
			<div class="container">	
				<button type="button" class="close fa-3x" data-dismiss="section" data-target="\\#image-gallery-section" data-switch-target="button[data-action='show-gallery-section']" ><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h1>이미지 갤러리
				</h1>
				<div class="row">
					<div class="col-xs-12">		
						<div class="flexslider">
							<ul class="slides">
							</ul>
						</div>	
						/*
						<div id="#=guid#" class="carousel slide carousel-v1">			                    
			                <div class="carousel-inner">			                        
			                </div>			                    
			                <div class="carousel-arrow">
			                        <a class="left carousel-control" href="\\##=guid#" data-slide="prev">
			                            <i class="fa fa-angle-left"></i>
			                        </a>
			                        <a class="right carousel-control" href="\\##=guid#" data-slide="next">
			                            <i class="fa fa-angle-right"></i>
			                        </a>
			                </div>
						</div>
						*/						
					</div>	
				</div>
			</div>	
		</div>		
	</div>
	</script>	
	<!-- ============================== -->
	<!-- notice template                                        -->
	<!-- ============================== -->
	<script type="text/x-kendo-template" id="notice-options-template">	
	<div class="popover bottom">
		<div class="arrow"></div>
		<h3 class="popover-title">소스 설정			
			<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
		</h3>
		<div class="popover-content">
			<h5 ><small><i class="fa fa-info"></i>공지 & 이벤트 소스를 변경할수 있습니다.</small></h5>	
			<div class="btn-group btn-group-sm" data-toggle="buttons">
				<label class="btn btn-success <#if action.user.anonymous >active</#if>">
					<input type="radio" class="js-switch" name="notice-selected-target" value="30" >사이트
				</label>
				<label class="btn btn-success <#if !action.user.anonymous >active</#if>">
					<input type="radio" class="js-switch" name="notice-selected-target" value="1">My 회사
				</label>
			</div>
		</div>
	</div>
	</script>
	
	<script type="text/x-kendo-template" id="notice-viewer-template">	
	<div class="panel panel-default no-border no-margin-b" data-bind="visible: visible">
		<div class="panel-heading rounded-top" style="background-color: \\#fff; ">
			<h4 class="panel-title" data-bind="html:announce.subject"></h4>
		</div>
		<div class="panel-body padding-sm">
			<ul class="list-unstyled text-muted">
				<li><span class="label label-primary label-lightweight">게시 기간</span> <span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></li>
				<li><span class="label label-default label-lightweight">생성일</span> <span data-bind="text: announce.formattedCreationDate"></span></li>
				<li><span class="label label-default label-lightweight">수정일</span> <span data-bind="text: announce.formattedModifiedDate"></span></li>
			</ul>	
		<div class="media">
			<a class="pull-left" href="\\#">
				<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
			</a>
			<div class="media-body">
				<h5 class="media-heading">																	
					<p><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span> <code data-bind="text: announce.user.username"></code></p>
					<p data-bind="visible:announce.user.emailVisible, text: announce.user.email"></p>
				</h5>		
			</div>		
		</div>	
		<hr class="devider no-margin-t">
			<div data-bind="html: announce.body " />		
		</div>
	</div>
	<div class="notice-grid" style="min-height: 300px"></div>
	</script>		
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>