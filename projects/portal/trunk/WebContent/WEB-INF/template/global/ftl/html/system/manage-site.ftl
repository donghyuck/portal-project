<#ftl encoding="UTF-8"/>
<html decorator="secure">
	<head>
		<title>시스템 정보</title>
<#compress>		
		<script type="text/javascript"> 
		yepnope([{
			load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			 
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js', 
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.system.js'],        	   
			complete: function() {               
				
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
										
				// 2. ACCOUNTS LOAD		
				var currentUser = new User({});
				var accounts = $("#account-panel").kendoAccounts({
					visible : false,
					authenticate : function( e ){
						currentUser = e.token;						
					}
				});				
				$("#navbar").data("companyPlaceHolder", new Company({ companyId: ${action.user.companyId} }));
				
				var selectedSocial = {};																	
				// 3.MENU LOAD 
				var currentPageName = "MENU_1_2";
				var topBar = $("#navbar").extTopNavBar({ 
					menu:"SYSTEM_MENU",
					template : kendo.template($("#topnavbar-template").html() ),
					items: [
						{ 
							name:"companySelector", 	selector: "#companyDropDownList", value: ${action.user.companyId},
							change : function(data){
								$("#navbar").data("companyPlaceHolder", data) ;
								kendo.bind($("#company-info"), data );
							}
						},
						{	name:"getMenuItem", menu: currentPageName, handler : function( data ){ 
								kendo.bind($(".page-header"), data );   
							} 
						}
					]
				});
								 
				 // 4. PAGE MAIN		
				 $("#website-grid").data("sitePlaceHolder", new common.models.WebSite() );
				 
				 createSiteGrid();
				 
				 common.ui.handleButtonActionEvents(
					$("button.btn-control-group"), 
					{event: 'click', handlers: {
						setting : function(e){
							showCompanySetting();					
						},
						group : function(e){
							topBar.go('main-group.do');				
						}, 	
						user : function(e){
							topBar.go('main-user.do');			
						}, 							
						details : function(e){
							$('#company-details').toggleClass('hide');
						},
						connect : function(e){
							alert("social modal");	 					
						}			  						 
					}}
				);
								
				$('#myTab').on( 'show.bs.tab', function (e) {		
					//e.preventDefault();			
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#template-mgmt" :
							createTemplatePane();
							break;
						case  '#image-mgmt' :
							createImagePane();
							break;
						case  '#attachment-mgmt' :	
							createAttachPane();
							break;	
						case  '#social-mgmt' :	
							createSocialPane();
							break;								
					}	
				});				
				$('#myTab a:first').tab('show') ;
			}	
		}]);

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

		function createAttachPane(){		
			var selectedCompany = $("#navbar").data("companyPlaceHolder");
			
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
		
			var selectedCompany = $("#navbar").data("companyPlaceHolder");
		
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
			var selectedCompany = $("#navbar").data("companyPlaceHolder");
			if( ! $("#website-grid").data("kendoGrid") ){	
				$('#website-grid').kendoGrid({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/list-site.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { targetCompanyId: selectedCompany.companyId , item: kendo.stringify(options)};									                            	
											}else{
												return { targetCompanyId: selectedCompany.companyId }
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
									{ field: "webSiteId", title: "ID",  width: 50, filterable: false, sortable: false, locked: true, lockable: false },
									{ field: "name", title: "키", width: 150, locked: true, template: '<button type="button" class="btn btn-warning btn-xs btn-block" onclick="goSite(this); return false;">#: name #</a>'},									
									{ field: "displayName", title: "이름",  width: 100 },
									{ field: "description", title: "설명",  width: 200 },
									{ field: "url", title: "URL",  width: 150, locked: true },
									{ field: "enabled", title: "사용여부",  width: 100 },
									{ field: "allowAnonymousAccess", title: "공개여부",  width: 100 },
									{ field: "creationDate", title: "생성일", width: 90, format: "{0:yyyy/MM/dd}" },
									{ field: "modifiedDate", title: "수정일", width: 90, format: "{0:yyyy/MM/dd}" },
								/*	{ command: [ {name: "destroy", text: "삭제" }, {name:"edit",  text: { edit: "수정", update: "저장", cancel: "취소"}  }  ], title: "&nbsp;", width: 180  }	*/
								], 
								editable: "inline",
								batch: false,
								filterable: true,
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								selectable: 'row',
								dataBound: function(e) {
								
								},
								change: function(e) {          
									var selectedCells = this.select();
									if( selectedCells.length > 0 ){
										var selectedCell = this.dataItem( selectedCells );			
										selectedCell.copy( $("#website-grid").data("sitePlaceHolder"));										
									}
								}				
				});
				
			
			}
		}
		
		function goSite (){					
			$("form[name='navbar-form'] input[name='targetSiteId']").val( $("#website-grid").data("sitePlaceHolder").webSiteId );
			$("#navbar").data("kendoExtTopNavBar").go("view-site.do");							
		}
		
		function showCompanySetting(){
			var renderToString = "company-setting-modal";
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"/>');
			}			

			var companySetting = $("#"+ renderToString);
			if( !companySetting.data('kendoExtModalWindow') ){			
				var companyPlaceHolder = $("#navbar").data("companyPlaceHolder");
				companySetting.extModalWindow({
					title : "회사 정보 변경",
					template : $("#company-setting-modal-template").html(),
					data : companyPlaceHolder,
					items : [
						{ name : "grid" , renderTo : "company-prop-grid" }
					],
					dataSource: {
						transport: { 
							read: { url:'${request.contextPath}/secure/get-company-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-company-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { companyId: companyPlaceHolder.companyId, items: kendo.stringify(options.models)};
								} 
								return { companyId: companyPlaceHolder.companyId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetCompanyProperty",
							model: Property
						}
					}
				});			
			}						
			companySetting.data('kendoExtModalWindow').show();
		
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
		<!-- START HEADER -->
		<section id="navbar"></section>
		<!-- END HEADER -->
		<!-- START MAIN CONTNET -->
		
		<div class="container-fluid">		
			<div class="row">			
				<div class="page-header">
					<h1><span data-bind="text: title"></span>     <small><i class="fa fa-quote-left"></i>&nbsp;<span data-bind="text: description"></span>&nbsp;<i class="fa fa-quote-right"></i></small></h1>
				</div>			
			</div>	
			<div class="row">	
				<div class="col-lg-12">
					<div class="panel panel-default" style="min-height:300px;">
						<div class="panel-heading" style="padding:5px;">						
							<div class="btn-group">
								<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="setting"><i class="fa fa-cog"></i> 회사 정보변경</button>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="group"><i class="fa fa-users"></i> 그룹관리</button>
								<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="user"><i class="fa fa-user"></i> 사용자관리</button>
							</div>								
						</div>
						<div class="panel-body" style="padding:5px;">						
														
							<div class="row">
								<div class="col-lg-5 col-xs-12" id="company-info">					
									<div class="page-header page-nounderline-header text-primary">
										<h5 >
											<small><i class="fa fa-info"></i> 미디어관리 버튼을 클릭하면 회사가 보유한 미디어(이미지, 파일 등)을 관리할 수 있습니다.</small>
											<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="details">미디어 관리</button>
										</h5>
									</div>											
									<table class="table table-hover">
											<tbody>						
												<tr>
													<th><small>회사</small></th>								
													<td><span data-bind="text: displayName"></span> <span class="label label-primary"><span data-bind="text: name"></span></span> <code><span data-bind="text: companyId"></span></code></td>
												</tr>	
												<tr>
													<th><small>도메인</small></th>								
													<td><span data-bind="text: domainName"></span></td>
												</tr>		
												<tr>
													<th><small>설명</small></th>
													<td><span data-bind="text: description"></span></td>
												</tr>	
												<tr>
													<th><small>등록일</small></th>
													<td><span data-bind="text: creationDate"></span></td>
												</tr>				
												<tr>
													<th><small>수정일</small></th>
													<td><span data-bind="text: modifiedDate"></span></td>
												</tr>												
										 	</tbody>
									</table>
								</div>
								<div class="col-lg-7 col-xs-12 hide" id="company-details">														
									<ul class="nav nav-tabs" id="myTab">
									  <li><a href="#image-mgmt" data-toggle="tab">이미지</a></li>
									  <li><a href="#attachment-mgmt" data-toggle="tab">첨부파일</a></li>
									  <li><a href="#social-mgmt" data-toggle="tab">쇼셜</a></li>
									</ul>
									<div class="tab-content">
										<div class="tab-pane fade " id="image-mgmt">
											<div class="col-sm-12 body-group marginless paddingless">
												<input name="image-upload" id="image-upload" type="file" />
												<div class="blank-top-15"></div>	
												<div id="image-grid"></div>	
											</div>
											<div id="image-details" class="col-sm-12 body-group marginless paddingless hide" style="padding-top:5px;">									
											</div>
										</div>								
										<div class="tab-pane fade" id="attachment-mgmt">
											<div class="col-sm-12 body-group marginless paddingless">
												<input name="attach-upload" id="attach-upload" type="file" />
												<div class="blank-top-15"></div>
												<div id="attach-grid"></div>
											</div>
										</div>
										<div class="tab-pane fade" id="social-mgmt">
											<span class="help-block">
												<small><i class="fa fa-info"></i> 쇼셜연결 버튼을 클릭하여 회사 쇼셜 계정을 연결하세요. </small>
												<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="connect"> 쇼셜연결</button>
											</span>
											<div id="social-grid"></div>
										</div>								
									</div>								
								</div>
							</div>							
						</div>					
						<div class="panel-body" style="padding:5px;">		
							<div class="page-header page-nounderline-header text-primary">
								<h5 >
										<small><i class="fa fa-info"></i> 키 컬럼의 버튼을 클릭하면 해당하는 사이트를 관리할 수 있습니다.</small>
								</h5>
							</div>								
							<div id="website-grid"></div>						
						</div>
						<div class="panel-body" style="padding:5px;"></div>
					</div>	
				</div>
			</div>
		</div>				
		<div id="account-panel" ></div>
  
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
		
		<script id="image-details-template" type="text/x-kendo-template">				
			<div class="panel panel-default">
				<div class="panel-body paddingless pull-right">
					<button type="button" class="btn btn-link btn-control-group" data-action="top"><i class="fa fa-angle-double-up fa-lg"></i></button>
				</div>
				<div class="panel-body">											
					<div class="row">
						<div class="col-lg-6 col-xs-6">
							<img data-bind="attr:{src: imgUrl}" class="img-rounded" />
						</div>
						<div class="col-lg-6 col-xs-6">
							<div class="panel-header text-primary">
								<h5 ><i class="fa fa-share"></i>&nbsp;<strong>이미지 공유</strong>&nbsp;<small>모두에게 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h5>
							</div>	
							<div class="btn-group" data-toggle="buttons">
								<label class="btn btn-primary">
								<input type="radio" name="image-public-shared" value="1">모두에게 공개
								</label>
								<label class="btn btn-primary active">
								<input type="radio" name="image-public-shared" value="0"> 비공개
								</label>
							</div>						
						</div>						
					</div>	
					<div class="row">
						<div class="col-lg-6 col-xs-12">
							<div class="panel-header text-primary">
								<h5 ><i class="fa fa-info"></i>&nbsp;<strong>이미지 속성</strong> <small>수정한 다음에는 저장 버튼을 클릭하여야 반영됩니다.</small></h5>
							</div>		
							<div id="image-prop-grid"></div>									
						</div>
						<div class="col-lg-6 col-xs-12">
							<div class="panel-header text-primary">
								<h5 ><i class="fa fa-upload"></i>&nbsp;<strong>이미지 변경</strong>&nbsp;<small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
							</div>
							<input name="update-image-file" type="file" id="update-image-file" class="pull-right" />								
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