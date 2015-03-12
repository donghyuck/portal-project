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
			'<@spring.url "/js/kendo/jszip.min.js"/>',
			'<@spring.url "/js/kendo/pako_deflate.min.js"/>',	
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
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>',	
			'<@spring.url "/js/ace/ace.js"/>'
			],
			complete: function() {

				common.ui.admin.setup({					 
					authenticate : function(e){
						createCompanyUserGrid();								
					}
				});		
											
				// END SCRIPT
			}
		}]);
		
		function getCompany(){
			return new common.ui.data.Company( common.ui.admin.setup().token.company );
		}		
		
		function createCompanyUserGrid(){
			var renderTo = $("#company-user-grid");
			if(!common.ui.exists(renderTo)){
				common.ui.grid(renderTo, {
					dataSource: {	
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/users/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, operation){	          
								if (operation != "read" && options) {
									return kendo.stringify(options);
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize, companyId:getCompany().companyId  }
								}
							}
						},
						schema: {
							total: "totalCount",
							data: "items",
							model : common.ui.data.User
						},
						pageSize: 15,
						serverPaging: true
					},					
					toolbar : kendo.template('<div class="p-xs"><a href="\\#" class="btn btn-flat btn-sm btn-outline btn-labeled btn-primary k-grid-pdf"><span class="btn-label icon fa fa-file-pdf-o"></span>PDF</a> <a href="\\#" class="btn btn-flat btn-sm btn-outline btn-labeled btn-primary k-grid-excel"><span class="btn-label icon fa fa-file-excel-o"></span>Excel</a></div>'),
					excel: {
						fileName: "Users Export.xlsx",	
						proxyURL: "<@spring.url "/download/export"/>",
						filterable: true				
					},
					pdf: {
						fileName: "Users Export.pdf",
						proxyURL: "<@spring.url "/download/export"/>",
						creator:"${action.user.name}"
					},
					columns: [
						{ field: "username", title: "아이디" , template:'<img width="25" height="25" class="img-circle no-margin" src="/download/profile/#= username #?width=150&amp;height=150" style="margin-right:10px;"> #: username #'}, 
						{ field: "name", title: "이름", template: '#if (nameVisible) { # #: name#  #} else{ # **** # } #  ' }, 
						{ field: "email", title: "메일", template: '#if (emailVisible) { # #: email#  #} else{ # **** # } #  ' },
						{ field: "enabled", title: "사용여부", width: 100 },
						{ field: "creationDate", title: "등록일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" },
						{ field: "modifiedDate", title: "수정일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" },
						{ field: "lastLoggedIn", title: "마지막 로그인", filterable: false,  width: 150, format: "{0:yyyy/MM/dd HH:mm}" },
						{ command: [
							{ 
								name: "detail",
								template : '<a href="\\#" class="btn btn-xs btn-success m-r-xs btn-selectable" data-action="details">상세보기</a>',
							}], 
							title: "&nbsp;", 
							width: 180  
						}
					], 		
					detailTemplate: kendo.template($("#company-details-template").html()),		
					detailInit: detailInit,		
					filterable: true,
					editable: "inline",
					selectable: 'row',
					height: '600',
					batch: false,              
					pageable: { refresh:true, pageSizes:true,  messages: { display: ' {1} / {2}' }  },					
					change: function(e) {
						// 1-1 SELECTED EVENT  
						var selectedCells = this.select();
						if( selectedCells.length === 0){								
						}
					},
					cancel: function(e){							
					},
					edit: function(e){	
					},
					dataBound: function(e){   
						var $this = this;
						renderTo.find("a[data-action=details]").click(function(e){
							//showCompanyDetails();
							$this.expandRow($this.select());
						});							
					}	   
				})	
			}			
		}
		
		function detailInit(e) {
			var detailRow = e.detailRow;			
			var renderTo = $("#company-user-grid");
			var data = e.data;			
			
			detailRow.find("[data-action=collapses]").click(function(e){
				common.ui.grid(renderTo).collapseRow(detailRow.prev());
			});				
			
			detailRow.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("action") ){
						case "properties" :
							createUserPropertiesGrid(detailRow.find(".properties"), data);
							break;
						case "groups" :
							createUserGroupGrid(detailRow.find(".groups"), data);
							break;	
						case "roles" :
							createUserRolePanel	(detailRow.find(".roles"), data);
							break
						case "profile" :
							//createCompanyLogoGrid	(detailRow.find(".logos"), detailRow.find("[name=logo-file]"), data);
							break	
				}	
			});			
			detailRow.find(".nav-tabs a:first").tab('show');		
		}
		
		function createUserRolePanel(renderTo, data){		
			if(!common.ui.defined( common.ui.admin.setup().element.data("role-datasource") ) ){
				common.ui.admin.setup().element.data("role-datasource", 
					common.ui.datasource('<@spring.url "/secure/data/mgmt/role/list.json?output=json"/>',{
						schema: { 
							data: "items",
							total: "totalCount",
							model: common.ui.data.Role						
						}
					})				
				);
			}
			var renderTo1 = renderTo.find("#user-" + data.userId + "-group-roles");
			var renderTo2 = renderTo.find("#user-" + data.userId + "-user-roles");
			var dataSource = common.ui.admin.setup().element.data("role-datasource").fetch(function(){
				var $data = this.data();
				if(!renderTo1.data('kendoMultiSelect')){
					var multiSelect1 = renderTo1.kendoMultiSelect({
						placeholder: "롤을 선택하세요.",
						dataTextField: "name",
						dataValueField: "roleId",
						dataSource: $data,
						dataBound:function(e){
							$this = this;
							common.ui.ajax("<@spring.url "/secure/data/mgmt/user/roles/list_from_groups.json?output=json"/>", {
								data: { userId : data.userId },
								success : function(response){
									$this.value(response); 
									var IDs = [] ;
									$.each(response, function(index, row){  
										IDs.push(row.roleId);
									});
									$this.value(IDs);	
								}
							});	
						},
						enable: false
					});	
					
				}
				if(!renderTo2.data('kendoMultiSelect')){
					renderTo2.kendoMultiSelect({
						placeholder: "롤을 선택하세요.",
						dataTextField: "name",
						dataValueField: "roleId",
						dataSource: $data,
						change: function(e){
							$this = this;
							var list = new Array();			                        		                  		
							$.each($this.value(), function(index, row){  
								var item =  $this.dataSource.get(row);
								list.push(item);			                        			
							});	
							common.ui.ajax('<@spring.url "/secure/data/mgmt/user/roles/update.json?output=json&userId="/>' + data.userId , {
								contentType : "application/json",
								data : kendo.stringify( list ) ,
								success : function( response ){		
									
								}
							});										
							
						},
						dataBound:function(e){
							$this = this;
							common.ui.ajax("<@spring.url "/secure/data/mgmt/user/roles/list_from_user.json?output=json"/>", {
								data: { userId : data.userId },
								success : function(response){
									$this.value(response); 
									var IDs = [] ;
									$.each(response, function(index, row){  
										IDs.push(row.roleId);
									});
									$this.value(IDs);	
								}
							});	
						}
					});	
				}
			});					
		}
		
		function createUserPropertiesGrid(renderTo, data){		
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/user/properties/list.json?output=json&userId="/>' + data.userId , type:'post' },
							create: { url:'<@spring.url "/secure/data/mgmt/user/properties/update.json?output=json&userId="/>' + data.userId , type:'post', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/user/properties/update.json?output=json&userId="/>' + data.userId, type:'post', contentType : "application/json"  },
							destroy: { url:'<@spring.url "/secure/data/mgmt/user/properties/delete.json?output=json&userId="/>' + data.userId, type:'post', contentType : "application/json" },
							parameterMap: function (options, operation){			
								if (operation !== "read" && options.models) {
									return kendo.stringify(options.models);
								}else{ 
									return { userId: data.userId }
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
		}
				
		function createUserGroupGrid(renderTo, data){
			if( ! renderTo.data("kendoGrid") ){	
					renderTo.kendoGrid({
						dataSource: {
							type: "json",
							transport: {
								read: { url:'<@spring.url "/secure/data/mgmt/user/groups/list_with_membership.json?output=json"/>', type: 'POST' },
								destroy: { url:'<@spring.url "/secure/data/mgmt/company/groups/delete.json?output=json"/>', type:'post', contentType : "application/json" },	
								parameterMap: function (options, operation){
									if (operation != "read" && options) {
												return kendo.stringify(options);
									}else{
										return { userId: data.userId }
									}
								}
							},
							schema: {
								model: kendo.data.Model.define({
									id : "groupId",
									fields: { 
										groupId: { type: "number", defaultValue: 0 },
										name: { type: "string", defaultValue: "" },
										displayName: { type: "string", defaultValue: "" },
										description: { type: "string", defaultValue: "" },
										membership: { type: "boolean", defaultValue: false }
									}
								})	
							}
						},
						scrollable: true,
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
									template : '<a href="\\#" class="btn btn-xs btn-labeled btn-info k-grid-edit btn-selectable"><span class="btn-label icon fa fa-pencil"></span> 변경</a>#: name#',
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
						toolbar: kendo.template('<div class="p-xs"><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>')
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
		/*
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

					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-success disabled" data-action="move" data-object-id="0"><span class="btn-label icon fa fa-exchange"></span> 선택 사용자 회사 변경</button></div>')
				});												
			}	
			renderTo.data("kendoGrid").dataSource.fetch();
		}	
		*/

						
				
		function getSelectedCompany(){
			var renderTo = $("#company-grid");
			var grid = renderTo.data('kendoGrid');
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );   
			return selectedCell;
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

			#company-grid.k-grid .k-selectable tr.k-state-selected{
				background-color: #4cd964;
				border-color: #4cd964;
			}	
			
			#company-user-grid.k-grid .k-selectable tr.k-state-selected{
				background-color: #5ac8fa;
				border-color: #34aadc;			
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
					
			#company-grid .properties a.btn, #company-grid .logos button.btn {
				cursor: pointer;
				pointer-events: auto;
				opacity: 1;
				filter: none;
				-webkit-box-shadow: none;
				box-shadow: none;				
			} 		
			
			#company-grid .k-dropzone {
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
				<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_6") />
				<ul class="breadcrumb breadcrumb-page">
					<!--<div class="breadcrumb-label text-light-gray">You are here: </div>-->
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>
				<div class="page-header bg-dark-gray">		
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>		
				</div><!-- / .page-header -->
				<div class="row">				
					<div class="col-sm-12">					
						<!-- details -->
						<div id="company-list" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-align-justify"></i> 목록</span>
							</div>
							<div class="panel-body padding-sm">
								<div class="note note-info no-margin-b">
									<h4 class="note-title"><small><i class="fa fa-info"></i> 회사 단위의 독립적인 회원, 그룹, 웹 사이트 운영을 지원합니다. 상세보기 버튼을 클릭하면 보다 많은 정보를 조회/수정 할 수 있습니다.</small></h4>
								</div>	
							</div>									
							<div id="company-user-grid" class="no-border-hr"></div>
						</div>
						<!-- /details -->
					</div>	
				</div>				
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->	
	
		<script type="text/x-kendo-template" id="company-details-template">		
		<div class="panel" style="border: 2px solid \\#34aadc; ">		
			<div class="panel-body padding-sm">
				<button class="close" data-action="collapses" data-object-id="#= userId #"><i class="fa fa-angle-up fa-lg"></i></button>				
				<div class="tab-v1">
					<ul class="nav nav-tabs nav-tabs-xs">
						<li class=""><a href="\\#user-#= userId#-tab-1" data-toggle="tab" data-action="logos">기본정보</a></li>
						<li class=""><a href="\\#user-#= userId#-tab-2" data-toggle="tab" data-action="groups">그룹</a></li>
						<li class=""><a href="\\#user-#= userId#-tab-3" data-toggle="tab" data-action="roles">롤</a></li>
						<li class=""><a href="\\#user-#= userId#-tab-4" data-toggle="tab" data-action="properties">속성</a></li>
					</ul>	
					<div class="tab-content">
						<div class="tab-pane fade" id="user-#= userId#-tab-1">
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
						<div class="tab-pane fade" id="user-#= userId#-tab-2">
							<div class="groups"></div>
						</div>
						<div class="tab-pane fade" id="user-#= userId#-tab-3">
							<div class="roles p-xs">
								<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">다음은 맴버로 가입된 그룹으로 부터 상속된 롤입니다. 그룹에서 상속된 롤은 그룹 관리에서 변경할 수 있습니다.</h6>
								<div id="user-#= userId#-group-roles"></div>
								<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">다음은 사용자에게 직접 부여된 롤입니다. 그룹에서 부여된 롤을 제외한 롤들만 아래의 선택박스에서 사용자에게 부여 또는 제거하세요.</h6>
								<div id="user-#= userId#-user-roles"></div>
							</div>
						</div>
						<div class="tab-pane fade" id="user-#= userId#-tab-4">
							 <div class="properties"></div>
						</div>
																							
					</div>
				</div>
			</div>
		</div>			
		</script>			
		
		<script type="text/x-kendo-template" id="company-details-template2">		
		<div class="panel">
			<div class="panel-heading">
				<span class="panel-title"><span class="label label-primary" data-bind="text: company.name"></span> <span class="text-semibold" data-bind="text:company.displayName"></span></span>
				<button type="button" class="close" aria-hidden="true">&times;</button>
			</div>			
			<div class="panel-body">
					<div class="details-row no-margin-t">					
						<div class="left-col">
							<div class="details-block no-margin-t">
								<div class="details-photo">
									<img data-bind="attr: { src: logoUrl }" alt="" src="<@spring.url "/images/common/loader/loading-transparent-bg.gif"/>">
								</div>
								<br>
								<!--
								<a href="\\#" class="btn btn-success"><i class="fa fa-check"></i> Following</a> 
								<a href="\\#" class="btn"><i class="fa fa-comment"></i></a>-->
							</div>				
							<div class="panel panel-transparent">
								<div class="panel-heading">
									<span class="panel-title"  data-bind="text:company.description"></span>
								</div>
								<table class="table">
									<tbody>						
										<tr>
											<th><small>도메인</small></th>								
											<td><span data-bind="text:company.domainName"></span></td>
										</tr>	
										<tr>
											<th><small>생성일</small></th>								
											<td><span data-bind="text:formattedCreationDate"></span></td>
										</tr>	
										<tr>
											<th><small>수정일</small></th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>														
									</tbody>
								</table>
							</div>
						</div>
						<div class="right-col">
							<hr class="details-content-hr no-grid-gutter-h">	
							<div class="details-content">
								<div class="panel panel-transparent">
									<div class="panel-heading">
										<span class="panel-title">&nbsp;</span>							
										<ul id="myTab" class="nav nav-tabs nav-tabs-simple">
											<li><a href="\\#props" data-toggle="tab">프로퍼티</a></li>
											<li><a href="\\#groups" data-toggle="tab">그룹 <span class="badge badge-success" data-bind="text:groupCount, visible:groupCount ">0</span></a></li>
											<li><a href="\\#users" data-toggle="tab">사용자 <span class="badge badge-success" data-bind="text:memberCount, visible:memberCount">0</span></a></li>
										</ul>	
									</div></!-- /.panel-heading -->								
									<!-- .tab-content -->	
									<div class="tab-content  no-padding">								
										<div class="tab-pane fade" id="props">				
											<div id="company-prop-grid" class="props no-border-t no-border-hr"></div>
										</div>
										<div class="tab-pane fade" id="groups">										
											<div id="company-group-grid"  class="groups no-border-t no-border-hr"></div>					
										</div>
										<div class="tab-pane fade" id="users">	
											<div id="company-user-grid"  class="users no-border-t no-border-hr"></div>
										</div>
									</div><!-- / .tab-content -->
								</div><!-- / .panel -->
							</div><!-- / .details-content -->
						</div><!-- / .right-col -->
					</div><!-- / .details-row -->	
			</div>
			<div class="panel-footer no-padding-vr"></div>
		</div>			
		</script>				
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>