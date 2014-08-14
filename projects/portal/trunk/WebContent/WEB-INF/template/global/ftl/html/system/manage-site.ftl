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
			
			'css!${request.contextPath}/styles/common/common.ui.ibox.css',
			
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
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();	
				
				var detailsModel = kendo.observable({
					company : new Company(),
					isEnabled : false,
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'${request.contextPath}/secure/get-company-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-company-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { companyId: getSelectedCompany().companyId, items: kendo.stringify(options.models)};
								} 
								return { companyId: getSelectedCompany().companyId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetCompanyProperty",
							model: Property
						},
						error : common.api.handleKendoAjaxError
					}),
					toggleOptionPanel:function(e){					
						var action = $(e.target).attr('data-action');
						if( action === 'upload-logo' ){						
							openLogoUploadModal();//toggleLogoUploadPanel();
						} else if( action === 'update-company' ){
							openCompanyUpdateModal(); //toggleCompanyUpdatePanel();
						}
					},
					onSave : function(e){					
						$.ajax({
							type : 'POST',
							url : '${request.contextPath}/secure/update-company.do?output=json',
							data: { companyId : this.get('company').companyId, item : kendo.stringify( this.get('company') ) },
							success : function(response){
								window.location.reload( true );
							},
							error:common.api.handleKendoAjaxError,
							dataType : "json"
						});
					},
					teleport : function(e){
						var action = $(e.target).attr('data-action');
						if(action === 'go-group'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-group.do',
								companyId : this.get('company').companyId
							});							
						}else if (action === 'go-user'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-user.do',
								companyId : this.get('company').companyId
							});								
						}
					}										
				});	
				
				detailsModel.bind("change", function(e){		
					if( e.field.match('^company.name')){ 						
						var sender = e.sender ;
						if( sender.company.companyId > 0 ){
							this.set("logoUrl", "/download/logo/company/" + sender.company.name );
							this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.creationDate ));      
							this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.modifiedDate ));
						}						
					}	
				});
				
				$("#company-details").data("model", detailsModel );
				
				common.ui.admin.setup({
					authenticate: function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(detailsModel.company);
						detailsModel.isEnabled = true;		
						
						kendo.bind($("#company-details"), detailsModel );				
						displayCompanyDetails();	
					}
				});	 
				 // 4. PAGE MAIN		

			}	
		}]);
		
		
		function displayCompanyDetails (){				
				$('#company-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#company-tabs-props" :						
							break;
						case  '#company-tabs-images' :
							createImagePane();
							break;
						case  '#company-tabs-files' :	
							createFilePane();
							break;	
						case  '#company-tabs-timeline' :	
							createTimelinePane();
							break;	
						case  '#company-tabs-networks' :	
							createSocialPane();
							break;															
					}	
				});				
				$('#company-tabs a:first').tab('show') ;				
				createSiteGrid();	
		}
		
		function getSelectedCompany(){
			var setup = common.ui.admin.setup();
			return setup.companySelector.dataItem(setup.companySelector.select());
		}
		
		function openLogoUploadModal(){
			var renderToString = "logo-upload-modal";
			var renderTo = $( '#' + renderToString );
			if( renderTo.length === 0 ){		
				$("#main-wrapper").append( kendo.template($('#logo-upload-modal-template').html()) );				
				renderTo = $('#' + renderToString );
				renderTo.modal({
					backdrop: 'static',
					show : false
				});
			}			
			renderTo.modal('show');				
		}

		function openCompanyUpdateModal(){
			var renderToString = "company-update-modal";
			var renderTo = $( '#' + renderToString );
			if( renderTo.length === 0 ){		
				$("#main-wrapper").append( kendo.template($('#company-update-modal-template').html()) );				
				renderTo = $('#' + renderToString );
				kendo.bind($("#company-details"), $("#company-details").data("model") );								
				renderTo.modal({
					backdrop: 'static',
					show : false
				});
			}			
			renderTo.modal('show');				
		}
				
		function toggleLogoUploadPanel(){
			
			if( !$('#logo-file').data('kendoUpload') ){
				$("#logo-file").kendoUpload({
					multiple : false,
					width: 300,
				 	showFileList : false,
					localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '${request.contextPath}/secure/add-logo-image.do?output=json',							   
						autoUpload: true
					},
					upload: function (e) {								         
						e.data = {
							objectType : 1,
							objectId: getSelectedCompany().companyId
						};														    								    	 		    	 
					},
					success : function(e) {								    
						if( e.response.targetPrimaryLogoImage ){
							//e.response.targetAttachment.attachmentId;
							// LIST VIEW REFRESH...
							$('#logo-grid').data('kendoGrid').dataSource.read(); 
						}
					}
				});						
			}		
				
			if(!$('#logo-grid').data('kendoGrid')){				
				$("#logo-grid").kendoGrid({
					dataSource: {
						dataType: 'json',
						transport: {
							read: { url:'${request.contextPath}/secure/list-logo-image.do?output=json', type: 'POST' },
							parameterMap: function (options, operation){
								return { objectType: 1, objectId: getSelectedCompany().companyId }
							} 
						},
						schema: {
							data: "targetLogoImages",
							total: "targetLogoImageCount",
							model : common.models.Logo
						},
						error: common.api.handleKendoAjaxError
					},
					autoBind: false,
					height: 200,
					columns:[
						{ field: "logoId", title: "ID",  width: 30, filterable: false, sortable: false },
						{ field: "filename", title: "파일", width: 250, template:"#:filename# <small><span class='label label-info'>#: imageContentType #</span></small>" },
						{ field: "imageSize", title: "파일크기",  width: 100 , format: "{0:##,### bytes}" }
					]				
				});
			}
			
			var renderTo = $('.panel[data-action="upload-logo"]');
			
			if( !renderTo.is(":visible") ){
				$('#logo-grid').data('kendoGrid').dataSource.read();
				common.ui.animate_v3(renderTo, "fadeInDown").show();
			}else{
				common.ui.animate_v3(renderTo, "fadeOutUp").show();
			}							
		}

		function toggleCompanyUpdatePanel(){		
			var renderTo = $('.panel[data-action="update-company"]');				
			if( !renderTo.is(":visible") ){
				common.ui.animate_v3(renderTo, "fadeInDown").show();
			}else{
				common.ui.animate_v3(renderTo, "fadeOutUp").show();
			}	
		}

		function createSocialPane(){
			var selectedCompany = getSelectedCompany();
			if( ! $("#social-grid").data("kendoGrid") ){
				$("#social-grid").kendoGrid({
					dataSource: {
						dataType: 'json',
						transport: {
							read: { url:'${request.contextPath}/secure/list-social-account.do?output=json', type: 'POST' },
							update: { url:'${request.contextPath}/secure/update-social-account.do?output=json', type:'POST' },
							parameterMap: function (options, operation){
								if (operation != "read" && options) {
									return { objectType: 1, objectId : selectedCompany.companyId , item: kendo.stringify(options)};
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize, objectType: 1, objectId: selectedCompany.companyId }
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
						{ field: "creationDate", title: "생성일", width: 100, format: "{0:yyyy/MM/dd}" },
						{ field: "modifiedDate", title: "수정일", width: 100, format: "{0:yyyy/MM/dd}" },
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
			var selectedCompany = getSelectedCompany();			
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
						e.data = { objectType: 1, objectId : selectedCompany.companyId, attachmentId:'-1' };		
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
												return { objectType: 1, objectId : selectedCompany.companyId , item: kendo.stringify(options)};									                            	
											}else{
												return { startIndex: options.skip, pageSize: options.pageSize, objectType: 1, objectId: selectedCompany.companyId }
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
									{ field: "name", title: "파일", width: 150 },
									{ field: "contentType", title: "파일 유형",  width: 100 },
									{ field: "size", title: "파일크기",  width: 100 },
									{ field: "creationDate", title: "생성일", width: 80, format: "{0:yyyy/MM/dd}" },
									{ field: "modifiedDate", title: "수정일", width: 80, format: "{0:yyyy/MM/dd}" },
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
			var selectedCompany = getSelectedCompany();		
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
									e.data = { objectType: 1, objectId : selectedCompany.companyId, imageId:'-1' };		
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
												return { objectType: 1, objectId : selectedCompany.companyId , item: kendo.stringify(options)};									                            	
											}else{
												
												return { startIndex: options.skip, pageSize: options.pageSize, objectType: 1, objectId: selectedCompany.companyId }
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
									{ field: "name", title: "파일", width: 200 },
									{ field: "contentType", title: "이미지 유형",  width: 100 },
									{ field: "size", title: "파일크기",  width: 100 },
									{ field: "creationDate", title: "생성일", width: 90, format: "{0:yyyy.MM.dd}" },
									{ field: "modifiedDate", title: "수정일", width: 90, format: "{0:yyyy.MM.dd}" },
									{ command: [ { name: "destroy", text: "삭제" } ], title: " ", width: "160px"  }
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
			
		
		function createSiteGrid(){			
			
			if( ! $("#website-grid").data("kendoGrid") ){	
				$('#website-grid').kendoGrid({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/list-site.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { targetCompanyId: getSelectedCompany().companyId , item: kendo.stringify(options)};									                            	
											}else{
												return { targetCompanyId: getSelectedCompany().companyId }
											}
										} 
									},
									pageSize: 15,
									schema: {
										total: "targetWebSiteCount",
										data: "targetWebSites",
										model : common.models.WebSite
									},
									error: common.api.handleKendoAjaxError
								},
								/* toolbar: [ { name: "create", text: "웹 사이트 추가" } ],      */
								columns:[
									{ field: "webSiteId", title: "ID",  width: 50, filterable: false, sortable: false},
									{ field: "name", title: "키", width: 200, template: '<button type="button" class="btn btn-warning btn-xs" onclick="goSite(this); return false;">#: name #</a>'},									
									{ field: "displayName", title: "이름",  width: 100 },
									{ field: "description", title: "설명",  width: 200 },
									{ field: "url", title: "URL",  width: 150 },
									{ field: "enabled", title: "사용여부",  width: 100 },
									{ field: "allowAnonymousAccess", title: "공개여부",  width: 100 },
									{ field: "creationDate", title: "생성일", width: 120, format: "{0:yyyy/MM/dd}" },
									{ field: "modifiedDate", title: "수정일", width: 120, format: "{0:yyyy/MM/dd}" },
								/*	{ command: [ {name: "destroy", text: "삭제" }, {name:"edit",  text: { edit: "수정", update: "저장", cancel: "취소"}  }  ], title: "&nbsp;", width: 180  }	*/
								], 
								editable: "inline",
								batch: false,
								filterable: true,
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								selectable: 'row',
								autoBind: false,
								dataBound: function(e) {
								
								},
								change: function(e) {          
									var selectedCells = this.select();
									if( selectedCells.length > 0 ){
										var selectedCell = this.dataItem( selectedCells );	
									}
								}				
				});
			}
			
			$("#website-grid").data("kendoGrid").dataSource.read(); 
		}
		
		function getSelectedSite(){			
			var renderTo = $("#website-grid");
			var grid = renderTo.data('kendoGrid');			
			var selectedCells = grid.select();			
			if( selectedCells.length == 0){
				return new common.models.WebSite();
			}else{			
				var selectedCell = grid.dataItem( selectedCells );   
				return selectedCell;
			}
		}		
		
		function goSite (){					
			common.api.teleportation().teleport({
				action : '${request.contextPath}/secure/view-site.do',
				targetSiteId : getSelectedSite().webSiteId
			});						
		}
		

		
		
		</script>
		<style>					
		
		.k-grid-content{
			height:200px;
		}		
		</style>
</#compress>		
	</head>
	<body>
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
					</div>				
				</div><!-- / .page-header -->
				<!-- details-row -->
				<div id="company-details" class="page-details" style="">				
					<div class="details-row no-margin-t">					
						<div class="left-col">
							<div class="details-block no-margin-t">
								<div class="details-photo">
									<img data-bind="attr: { src: logoUrl }" alt="" src="/download/logo/company/inkium">
								</div>
								<br>
								<div class="btn-group">
									<button type="button" class="btn btn-success btn-flat btn-control-group" data-action="upload-logo" data-toggle="button" data-bind="enabled: isEnabled, click:toggleOptionPanel"><i class="fa fa-upload" ></i> 로고 변경</button>
									<button type="button" class="btn btn-success btn-flat btn-control-group" data-action="update-company" data-toggle="button" data-bind="enabled: isEnabled, click:toggleOptionPanel" ><i class="fa fa-pencil"></i> 정보변경</button>
								</div>			
							</div>				
							<div class="panel panel-transparent">
								<div class="panel-heading">
									<span class="panel-title" data-bind="text:company.description"></span>									
								</div>
								<table class="table">
									<tbody>						
										<tr>
											<th class="text-center">회사</th>								
											<td><span data-bind="text: company.displayName"></span><code><span data-bind="text: company.companyId"></span></code></td>
										</tr>	
										<tr>
											<th class="text-center">도메인</th>								
											<td><span data-bind="text: company.domainName"></span></td>
										</tr>	
										<tr>
											<th class="text-center">생성일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>	
										<tr>
											<th class="text-center">수정일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>																								
									</tbody>
								</table>
							</div>
						</div>
						<div class="right-col">
							<hr class="details-content-hr no-grid-gutter-h"/>						
							<div class="details-content">			
								<div class="row" >
									<div class="col-sm-12">
										<div class="pull-right">
											<div class="btn-group">
												<button type="button" class="btn btn-info btn-flat btn-control-group" data-action="go-group" data-bind="enabled: isEnabled, click:teleport"" ><i class="fa fa-users"></i> 그룹관리</button>
												<button type="button" class="btn btn-info btn-flat btn-control-group" data-action="go-user" data-bind="enabled: isEnabled, click:teleport""><i class="fa fa-user"></i> 사용자 관리</button>
											</div>														
										</div>
									</div>
								</div>	
								<hr/>
								<div class="row" >
									<div class="col-lg-6">		
												<!-- logo upload panel -->									
												<div class="panel panel-default" data-action="upload-logo" style="display:none;">
													<div class="panel-heading">
														<button type="button" class="close btn-control-group"  data-action="upload-logo" data-bind="click:toggleOptionPanel">×</button>
														<span class="panel-title">로고 업로드</span>
													</div>
													<div class="panel-body">											
														<input name="logo-file" id="logo-file" type="file" />											
													</div>
													<div class="panel-body scrollable" style="max-height:450px;">
														<p> <strong>파일 선택</strong> 버튼을 클릭하여 로고 이미지를 직접 선택하거나, 이미지파일을 끌어서 놓기(Drag & Drop)를 하세요.</p>
														<div id="logo-grid"></div>
													</div>																						
												</div>
												<!-- ./logo upload panel -->			
											</div>
									<div class="col-lg-6">		
												<!-- company setting panel -->				
												<div class="panel form-horizontal" data-action="update-company" style="display:none;">
													<div class="panel-heading">														
														<button type="button" class="close btn-control-group" data-action="update-company"  data-bind="click:toggleOptionPanel">×</button>
														<span class="panel-title">회사 정보 변경</span>
													</div>
													<div class="panel-body">
															<div class="row form-group">
																<label class="col-sm-4 control-label">이름:</label>
																<div class="col-sm-8">
																	<input type="text" name="name" class="form-control" data-bind="value:company.displayName">
																</div>
															</div>
															<div class="row form-group">
																<label class="col-sm-4 control-label">설명:</label>
																<div class="col-sm-8">
																	<input type="text" name="name" class="form-control" data-bind="value:company.description">
																</div>
															</div>																
															<div class="row form-group">
																<label class="col-sm-4 control-label">도메인:</label>
																<div class="col-sm-8">
																	<input type="text" class="form-control" data-bind="value:company.domainName">
																</div>
															</div>															

													</div>
													<div class="panel-footer text-right">
														<button class="btn btn-primary btn-flat" data-bind="click: onSave, enabled: isEnabled" >확인</button>
													</div>
												</div>
											<!-- ./company setting panel -->				
									</div>
								</div><!-- ./row -->
									
									<!-- company-tabs -->	
									<div class="panel colourable">
										<div class="panel-heading">
											<span class="panel-title"><span class="label label-primary" data-bind="text: company.name"></span></span>
											<ul id="company-tabs" class="nav nav-tabs nav-tabs-xs">
												<li><a href="#company-tabs-props" data-toggle="tab">프로퍼티</a></li>
												<li><a href="#company-tabs-images" data-toggle="tab">이미지</a></li>
												<li><a href="#company-tabs-files" data-toggle="tab">파일</a></li>
												<li><a href="#company-tabs-timeline" data-toggle="tab">타임라인</a></li>
											</ul>	
										</div> <!-- / .panel-heading -->		
										<div class="tab-content">								
											<div class="tab-pane fade" id="company-tabs-props">
												<div data-role="grid"
													class="no-border"
													date-scrollable="false"
													data-editable="true"
													data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
													data-columns="[
														{ 'title': '이름',  'field': 'name', 'width': 200 },
														{ 'title': '값', 'field': 'value' },
														{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
													]"
													data-bind="source: properties, visible: isEnabled"
													style="height: 300px"></div>																				
													
											</div>
											<div class="tab-pane fade" id="company-tabs-images" >
												<div class="row no-margin-hr" style="background:#f5f5f5;" >
													<div class="col-md-4"><input name="image-upload" id="image-upload" type="file" /></div>
													<div class="col-md-8" style="border-left : solid 1px #ccc;" ><div id="image-details" class="hide animated padding-sm fadeInRight"></div></div>
												</div>
												<div id="image-grid" class="no-border-hr no-border-b"></div>		
											</div>
											<div class="tab-pane fade" id="company-tabs-files">
												<div class="panel panel-transparent no-margin-b">
													<div class="panel-body">
														<input name="attach-upload" id="attach-upload" type="file" />
													</div>												
												</div>
												<div id="attach-grid" class="no-border-hr no-border-b"></div>
											</div>
											<div class="tab-pane fade" id="company-tabs-timeline">											
											</div>																																								
										</div>	
									</div>
								<!-- / .website-tabs -->				
								<div class="row">				
									<div class="col-sm-12 ">		
										<h4>
											<small><i class="fa fa-info"></i> 키 컬럼의 버튼을 클릭하면 해당하는 사이트를 관리할 수 있습니다.</small>
										</h4>		
										<div id="website-grid" ></div>
									</div>
								</div>		
							</div><!-- / .details-content -->
						</div><!-- / .right-col -->
					</div><!-- / .details-row -->	
	
				</div>
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
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

		<script type="text/x-kendo-template" id="logo-upload-modal-template">
		<div class="modal fade" id="logo-upload-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">로고 업로드</h4>
					</div>
					<div class="modal-body no-padding">

					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>				
		</script>

		<script type="text/x-kendo-template" id="company-update-modal-template">
		<div class="modal fade" id="company-update-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">회사 정보 변경</h4>
					</div>
					<div class="modal-body padding-sm">
						<div class=" form-horizontal" >
							<div class="row form-group">
								<label class="col-sm-4 control-label">이름:</label>
								<div class="col-sm-8">
									<input type="text" name="name" class="form-control" data-bind="value:company.displayName">
								</div>
							</div>
							<div class="row form-group">
								<label class="col-sm-4 control-label">설명:</label>
								<div class="col-sm-8">
									<input type="text" name="name" class="form-control" data-bind="value:company.description">
								</div>
							</div>																
							<div class="row form-group">
								<label class="col-sm-4 control-label">도메인:</label>
								<div class="col-sm-8">
									<input type="text" class="form-control" data-bind="value:company.domainName">
								</div>
							</div>	
						</div>
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat disable hidden" data-bind="click: onSave, enabled: isEnabled" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>확인</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>				
		</script>
				
		<script id="image-details-template" type="text/x-kendo-template">				
		
					<div class="row">
						<div class="col-sm-3">
							<p><span class="label label-info" data-bind="text: contentType"></span></p>
							<img data-bind="attr:{src: imgUrl}" class="img-responsive img-thumbnail " />						
						</div>
						<div class="col-sm-9">	
							<div class="panel-group" id="company-tabs-image-accordion">
								<div class="panel">
									<div class="panel-heading ">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse1">
											<i class="fa fa-info"></i> 속성
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse1" class="panel-collapse collapse in" style="height: auto;">
										<div class="panel-body no-padding">									
											<div id="image-prop-grid" class="no-border-hr no-border-b"></div>						
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->
	
								<div class="panel">
									<div class="panel-heading">
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse2">
											<i class="fa fa-share"></i>  공유
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse2" class="panel-collapse collapse" style="height: 0px;">
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
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse3">
											<i class="fa fa-upload"></i> 이미지 업로드
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse3" class="panel-collapse collapse" style="height: 0px;">
										<div class="panel-body">
											<h5><small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
											<input name="update-image-file" type="file" id="update-image-file" class="pull-right" />
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->
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