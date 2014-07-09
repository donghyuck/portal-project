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
				
				showNoticePanel();
				// END SCRIPT 				
			}
		}]);	

		
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
				template: kendo.template($("#notice-view-template").html()),   
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
								kendo.bind($("#my-photo-stream form"), uploadModel);
							}							
							$('#my-photo-stream form div.form-group.has-error').removeClass("has-error");
							$("#my-photo-stream .custom-upload").toggleClass("hide");				
						},	  
						'upload-close' : function(e){
							$("#my-photo-stream .custom-upload").toggleClass("hide");		
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

		.wrapper{
			background-color:transparent;
		}
		
		.wrapper .header {
			background-color: #fff;
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

		.image-grid {
			padding-top:2px;
			padding-buttom:0px;
			padding-right:2px;
			padding-left:0px;
		}
		
		.image-grid img {
			display: block;
			max-width: 100%;
			height: 350px;
		}
				

		blockquote {
			font-size: 11pt;
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
	<body id="doc" class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<div class="container"> 
				<div class="col-xs-5 col-xs-offset-7 no-padding-hr">
					<div class="navbar navbar-personalized navbar-inverse" role="navigation">
						<ul class="nav navbar-nav pull-right">
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
					</div><!-- ./navbar -->
				</div><!-- ./col-sm-6 col-sm-offset-6 -->
			</div><!-- ./container -->

			<div class="container-fluid padding-sm" style="min-height:600px;">		
				<div id="personalized-area" class="row"></div>				
			</div>		
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- ./END FOOTER -->					
		</div>
				
			<!-- START RIGHT SLIDE MENU -->
			<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">		
				<!-- header -->	
				<!--<header>				
					
				</header>	-->
				<!-- ./header -->
				<!-- tab-v1 -->
				<button type="button" class="btn-close">Close</button>
				<div class="tab-v1" >			
					<h5 class="side-section-title">My 클라우드 저장소</h5>			
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
							</section>
							<div class="panel panel-default">
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-sm btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
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
								<div class="panel-body color4" style="max-height:450px;">
									<div id="attachment-list-view" class="color4"></div>
								</div>	
								<div class="panel-footer no-padding">
										<div id="pager" class="k-pager-wrap"></div>
								</div>
							</div>																				
						</div><!-- end attachements  tab-pane -->		
						<!-- start photos  tab-pane -->
						<div class="tab-pane" id="my-photo-stream">									
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
							</section>	
							<div class="panel panel-default">			
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
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
						</div><!-- end photos  tab-pane -->
					</div><!-- end of tab content -->
				</div>	
			</section>	
			<div class="cbp-spmenu-overlay"></div>			
			<!-- ./END RIGHT SLIDE MENU -->
							
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
		<#include "/html/common/common-homepage-templates.ftl" >		
		<#include "/html/common/common-personalized-templates.ftl" >
		<!-- ./END TEMPLATE -->
	</body>    
</html>