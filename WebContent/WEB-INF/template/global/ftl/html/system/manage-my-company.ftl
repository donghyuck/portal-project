<#ftl encoding="UTF-8"/>	
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
<#compress>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css"/>',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css"/>',	
			'css!<@spring.url "/styles/perfect-scrollbar/perfect-scrollbar-0.4.9.min.css"/>',
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',	
			'<@spring.url "/js/bootstrap/3.3.1/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/fastclick.js"/>', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 
			'<@spring.url "/js/perfect-scrollbar/perfect-scrollbar-0.4.9.min.js"/>', 			
			'<@spring.url "/js/common.admin/pixel.admin.min.js"/>',			
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.admin.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>',	
			'<@spring.url "/js/ace/ace.js"/>'
			],
			complete: function() {
			
				var renderTo = $("#my-company-details");
				var observable = common.ui.observable({
					company : new common.ui.data.EditableCompany(),
					editable : false,
					logoUrl: '<@spring.url "/images/common/loader/loading-transparent-bg.gif"/>',
					setCompany:function(company){
						$this = this;						
						company.copy($this.company);
						var dt = new Date();
						$this.set("logoUrl", "<@spring.url "/download/logo/company/"/>" + $this.company.name + "?" + dt.getTime() );
						$this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  $this.company.creationDate ));
						$this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  $this.company.modifiedDate ));
						$this.set("editable", true);												
						renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
								var show_bs_tab = $(e.target);
								switch( show_bs_tab.data("action") ){
									case "company" :
										createCompanyDetails(renderTo.find(".company"), $this.company);
										break;
									case "properties" :
										createCompanyPropertiesGrid(renderTo.find(".properties"), $this.company);
										break;
									/**
									case "users" :
										createCompanyUserGrid(renderTo.find(".users"), $this.company);
										break;	
									case "groups" :
										createCompanyGroupGrid	(renderTo.find(".groups"), $this.company);
										break;
									*/	
									case "logos" :
										createCompanyLogoGrid	(renderTo.find(".logos"), renderTo.find("[name=logo-file]"), $this.company);
										break	
								}	
							});			
						renderTo.find(".nav-tabs a:first").tab('show');						
					},
					modal: function(e){
						var btn = $(e.target);						
						if( btn.data("action") === 'edit' ){
							openCompanyEditModal(this); 
						}
					},
					save : function(e){						
						var btn = $(e.target);
						btn.button('loading');
						common.ui.ajax('<@spring.url "/secure/data/mgmt/company/update.json?output=json"/>', {
							contentType : "application/json",
							data: kendo.stringify( this.get('company') ) ,
							complete: function(jqXHR, textStatus ){					
								btn.button('reset');
							}
						});					
						return false;
					}	
				});					
				common.ui.bind(renderTo, observable );					
				common.ui.admin.setup({					 
					authenticate : function(e){						
						observable.setCompany(getCompany());						
					}
				});					
														
				// END SCRIPT
			}
		}]);

		function openCompanyEditModal(observable){
			var renderToString = "#my-company-edit-modal";
			if( $(renderToString).length === 0 ){		
				$("#main-wrapper").append( kendo.template($('#my-company-edit-modal-template').html()) );				
				$(renderToString).modal({
					backdrop: 'static',
					show : false
				});				
				kendo.bind($(renderToString), observable );
			}			
			$(renderToString).modal('show');	
		}
		
						
		function getCompany(){
			return new common.ui.data.EditableCompany( common.ui.admin.setup().token.company );
		}
						
		function getSelectedCompany(){
			var renderTo = $("#company-grid");
			var grid = renderTo.data('kendoGrid');
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );   
			return selectedCell;
		}
				
		function createCompanyDetails(renderTo, data){
		
		}
		
		
		function createCompanyGroupGrid(renderTo, data){
			if( ! renderTo.data("kendoGrid") ){	
					renderTo.kendoGrid({
						dataSource: {
							type: "json",
							transport: {
								read: { url:'<@spring.url "/secure/data/mgmt/company/groups/list.json?output=json"/>', type: 'POST' },
								create: { url:'<@spring.url "/secure/data/mgmt/company/groups/create.json?output=json"/>', type:'post', contentType : "application/json" },
								update: { url:'<@spring.url "/secure/data/mgmt/company/groups/update.json?output=json"/>', type:'post', contentType : "application/json"  },
								destroy: { url:'<@spring.url "/secure/data/mgmt/company/groups/delete.json?output=json"/>', type:'post', contentType : "application/json" },	
								parameterMap: function (options, operation){
									if (operation != "read" && options) {
										if( operation == "create" )
										{
											options.companyId = data.companyId;
											options.company = data;
										}	
										return kendo.stringify(options);
									}else{
										return { companyId: data.companyId }
									}
								}
							},
							schema: {
								total: "totalCount",
								data: "items",
								model: common.ui.data.Group
							}
						},
						scrollable: true,
						editable: "inline",
						autoBind: false,
						selectable: 'row',
						columns: [
							{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
							{ field: "name",  title: "KEY",  filterable: true, sortable: true },
							{ field: "displayName",    title: "이름",  filterable: true, sortable: true},
							{ field: "description",    title: "설명",  filterable: false,  sortable: false },
							{ command: [
								{ 
									name: "edit",
									template : '<a href="\\#" class="btn btn-xs btn-labeled btn-info k-grid-edit btn-selectable"><span class="btn-label icon fa fa-pencil"></span> 변경</a>',
									text: { edit: "변경", update: "저장", cancel: "취소"}
								}], 
								title: "&nbsp;", 
								width: 180  
							}
						],
						saveChanges: function(e) {
							this.dataSource.read();						
						},
						dataBound:function(e){
							//getCompanyDetailsModel().set("groupCount", this.dataSource.total() );							
						},
						toolbar: kendo.template('<div class="p-xs"><a class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger k-grid-add" href="\\#"><span class="btn-label icon fa fa-plus"></span> 그룹 추가 </a><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>')
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});				
			}
			renderTo.data("kendoGrid").dataSource.fetch();
		}				
		
		/**
		 * function for create logo grid
		 */
		function createCompanyLogoGrid(renderTo, renderTo2,  data){
			if( !common.ui.exists(renderTo2)){
				renderTo2.kendoUpload({
					multiple : false,
					width: 300,
				 	showFileList : false,
					localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '<@spring.url "/secure/data/mgmt/logo/upload.json?output=json"/>',							   
						autoUpload: true
					},
					upload: function (e) {								         
						e.data = {
							objectType : 1,
							objectId: data.companyId
						};														    								    	 		    	 
					},
					success : function(e) {								    
						if( e.response.success ){
							common.ui.grid(renderTo).dataSource.read();
						}
					}
				});								
			}						
			if( ! common.ui.exists(renderTo)){	
				common.ui.grid(renderTo,{
					dataSource: {
						type: "json",
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/logo/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { objectType: 1, objectId: data.companyId }
							}
						},
						schema: {
							data: "items",
							total: "totalCount",
							model : common.ui.data.Logo
						},
						batch: false
					},
					toolbar: kendo.template('<div class="p-xs pull-right"><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm" data-action="refresh">새로고침</button></div>'),    
					filterable: true,
					sortable: true,
					scrollable: true,
					selectable: false,
					columns:[
							{ title: "&nbsp;",  width:150, filterable: false, sortable: false, template:'<div class="text-center"><img alt="" class="img-thumbnail" src="<@spring.url "/secure/download/logo/#= logoId #?width=120&height=120" />"></div>' },
							{ field: "filename", title: "파일", template:'#:filename# <small><span class="label label-info">#: imageContentType #</span></small> #if( !primary ){ # <button class="btn btn-flat btn-xs btn-labeled btn-danger" data-action="primary" data-object-id="#= logoId#"><span class="btn-label icon fa fa-check-square"></span>선택</button> #}#' },
							{ field: "imageSize", title: "파일크기",  width: 150 , format: "{0:##,### bytes}" }
						],
					dataBound:function(e){
						renderTo.find("[data-action=primary]").click(function(e){
							var logoId = $(this).data("object-id");
							common.ui.ajax(
								"<@spring.url "/secure/data/mgmt/logo/set_primary.json"/>",
								{
									type : 'POST',
									url : '/data/streams/photos/delete.json?output=json' ,
									data: { logoId : logoId },
									success : function(response){
										renderTo.data("kendoGrid").dataSource.read();		
									},
									complete: function(){
										kendo.ui.progress(renderTo, false);
									}
							});		
						});
					}						
				});	
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});
				
			}	
			renderTo.data("kendoGrid").dataSource.fetch();		
		}
		
		function createCompanyUserGrid(renderTo, data){
			if( ! common.ui.exists(renderTo)){	
				common.ui.grid(renderTo, {
					dataSource: {
						type: "json",
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/users/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  companyId: data.companyId }
							}
						},
						schema: {
							total: "totalCount",
							data: "items",
							model: common.ui.data.User
						},
						batch: false,
						pageSize: 10,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false 
					},
					filterable: true,
					sortable: true,
					scrollable: true,
					autoBind: false,
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
					selectable: "multiple, row",
					columns: [
						{ field: "username", title: "아이디" , template:'<img width="25" height="25" class="img-circle no-margin" src="/download/profile/#= username #?width=150&amp;height=150" style="margin-right:10px;"> #: username #'}, 
						{ field: "name", title: "이름", template: '#if (nameVisible) { # #: name#  #} else{ # **** # } #  ' }, 
						{ field: "email", title: "메일", template: '#if (emailVisible) { # #: email#  #} else{ # **** # } #  ' },
						{ field: "creationDate", title: "등록일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" } ],
					dataBound:function(e){

					}
				});												
			}	
			renderTo.data("kendoGrid").dataSource.fetch();
		}	
		
		function createCompanyPropertiesGrid(renderTo, data){		
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/properties/list.json?output=json&companyId="/>' + data.companyId , type:'post' },
							create: { url:'<@spring.url "/secure/data/mgmt/company/properties/update.json?output=json&companyId="/>' + data.companyId , type:'post', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/company/properties/update.json?output=json&companyId="/>' + data.companyId, type:'post', contentType : "application/json"  },
							destroy: { url:'<@spring.url "/secure/data/mgmt/company/properties/delete.json?output=json&companyId="/>' + data.companyId, type:'post', contentType : "application/json" },
							parameterMap: function (options, operation){			
								if (operation !== "read" && options.models) {
									return kendo.stringify(options.models);
								}else{ 
									return { companyId: data.companyId }
								}
							}
						},						
						batch: true, 
						schema: {
							model: common.ui.data.Property
						},
						error:common.ui.handleAjaxError
					},
					columns: [
						{ title: "속성", field: "name", width: 250 },
						{ title: "값",   field: "value" },
						{ command:  { name: "destroy", template:'<a href="\\#" class="btn btn-xs btn-labeled btn-danger k-grid-delete"><span class="btn-label icon fa fa-trash"></span> 삭제</a>' },  title: "&nbsp;", width: 80 }
					],
					editable : true,
					scrollable: true,
					filterable: true,
					sortable: true,
					toolbar: kendo.template('<div class="p-xs"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
					change: function(e) {
					}
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});	
			}			
			renderTo.data("kendoGrid").dataSource.fetch();
		}
						

	
		-->
		</script> 		 
		<style>
			.k-grid-content {
				min-height:300px;
			}
			
			#xml-editor{
				position: absolute;
				top: 0;
				right: 0;
				bottom: 0;
				left: 0;
				min-height:400px;
			}

			#my-company-details .k-grid .k-selectable tr.k-state-selected{
				background-color: #4cd964;
				border-color: #4cd964;
			}	
			
			
			.panel .tab-content {
				padding:5px!important;
			}
			
			button.close {
				z-index: 1000;
				float: none;
				right: 25px;
				top: 5px;
				position: absolute;
			}
					
			#my-company-details .properties a.btn, #company-grid .logos button.btn {
				cursor: pointer;
				pointer-events: auto;
				opacity: 1;
				filter: none;
				-webkit-box-shadow: none;
				box-shadow: none;				
			} 		
			
			#my-company-details .k-dropzone {
				border-radius: 8px !important;
				background: #f5f5f5;
				height: 100px;
			}
							
		</style>
</#compress>		
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_1") />
				<ul class="breadcrumb breadcrumb-page">
					<!--<div class="breadcrumb-label text-light-gray">You are here: </div>-->
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>
				<div class="page-header bg-dark-gray">		
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>		
				</div><!-- / .page-header -->
				<!-- details-row -->
				<div id="my-company-details" class="page-details" style="">				
					<div class="details-row no-margin-t">					
						<div class="left-col">
							
						</div>
						<div class="right-col">
							<hr class="details-content-hr no-grid-gutter-h"/>						
							<div class="details-content">									
									
								<div class="panel panel colourable" style="border: 2px solid #34aadc; ">		
									<div class="panel-heading">
										<span class="panel-title">&nbsp</span>
											<ul class="nav nav-tabs nav-tabs-xs">
												<li class=""><a href="#my-company-tabs-0" data-toggle="tab" data-action="company">기본정보</a></li>
												<li class=""><a href="#my-company-tabs-1" data-toggle="tab" data-action="logos">로고</a></li>
												<!--
												<li class=""><a href="#my-company-tabs-2" data-toggle="tab" data-action="groups">그룹</a></li>
												<li class=""><a href="#my-company-tabs-3" data-toggle="tab" data-action="users">사용자</a></li>
												-->
												<li class=""><a href="#my-company-tabs-4" data-toggle="tab" data-action="properties">속성</a></li>
											</ul>	
									</div>						
								
											<div class="tab-content">
												<div class="tab-pane fade" id="my-company-tabs-0">

<div class="details-block no-margin-t">
								<div class="details-photo">
									<img data-bind="attr: { src: logoUrl }" alt="" src="<@spring.url "/images/common/loader/loading-transparent-bg.gif"/>">
								</div>
								<br>
								<button type="button" class="btn btn-success btn-flat btn-control-group" data-action="edit" data-toggle="button" data-bind="enabled: editable, click:modal" ><i class="fa fa-pencil"></i> 변경</button>											
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
											<th class="text-center">키</th>								
											<td><span class="label label-primary" data-bind="text: company.name"></span></td>
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
												<div class="tab-pane fade" id="my-company-tabs-1">
													<div class="stat-panel no-margin-b">
														<div class="stat-cell col-sm-3 hidden-xs text-center">
															<input name="logo-file" type="file">
															<i class="fa fa-upload bg-icon bg-icon-left"></i>	
														</div> <!-- /.stat-cell -->
														<div class="stat-cell col-sm-9 no-padding">		
															<div class="logos"></div>
														</div>
													</div>							
												</div>
												<div class="tab-pane fade" id="my-company-tabs-2">
													<div class="groups"></div>
												</div>
												<div class="tab-pane fade" id="my-company-tabs-3">
													<div class="users"></div>
												</div>
												<div class="tab-pane fade" id="my-company-tabs-4">
													 <div class="properties"></div>
												</div>
																													
											</div>
									</div>		
								</div>			
							</div><!-- / .details-content -->
						</div><!-- / .right-col -->
					</div><!-- / .details-row -->	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg"></div>
		</div> <!-- / #main-wrapper -->	
		
		<script type="text/x-kendo-template" id="my-company-edit-modal-template">
		<div id="my-company-edit-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog">	
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">회사 정보 변경</h4>
					</div>					
					<div class="modal-body">
						<div class=" form-horizontal padding-sm" >
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
						<button type="button" class="btn btn-primary btn-flat" data-bind="click: save, enabled: editable" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>저장</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>					
				</div>
			</div>
		</div>	
		<!--	
		<div class="modal fade" id="company-update-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">회사 정보 변경</h4>
					</div>
					<div class="modal-body no-padding">
						<div class=" form-horizontal padding-sm" >
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
							<h5><small><i class="fa fa-info"></i> <strong>파일 선택</strong> 버튼을 클릭하여 로고 이미지를 직접 선택하거나, 이미지파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
							<input name="logo-file" id="logo-file" type="file" />	
							<div id="logo-grid"></div>							
						</div>
					</div>																		
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat" data-bind="click: onSave, enabled: isEnabled" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>저장</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>		
		-->		
		</script>				
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>