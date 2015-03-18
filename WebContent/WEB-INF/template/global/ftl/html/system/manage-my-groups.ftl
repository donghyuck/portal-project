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
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
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
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>',	
			'<@spring.url "/js/ace/ace.js"/>'
			],
			complete: function() {
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				common.ui.admin.setup({					 
					authenticate : function(e){
						e.token.copy(currentUser);
						createCompanyGroupGrid();
						$("#company-group-list .panel-heading .panel-title ").html(kendo.template('<i class="fa fa-align-justify"></i> #: displayName # <span class="label label-primary"> #: name#</span>')(getCompany()));
					},
					change: function(e){
						e.data.copy(targetCompany);						
					}
				});		
				
				//createCompanyGrid();															
				// END SCRIPT
			}
		}]);
		
		function getCompany(){
			return new common.ui.data.Company( common.ui.admin.setup().token.company );
		}
				
		function createCompanyGroupGrid(){			
			var renderTo = $("#company-group-grid");			
			if(!common.ui.exists(renderTo)){
				common.ui.grid(renderTo, {
					dataSource: {	
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/groups/list.json?output=json"/>', type: 'POST' },
							create: { url:'<@spring.url "/secure/data/mgmt/company/groups/create.json?output=json"/>', type:'post', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/company/groups/update.json?output=json"/>', type:'post', contentType : "application/json"  },
							destroy: { url:'<@spring.url "/secure/data/mgmt/company/groups/delete.json?output=json"/>', type:'post', contentType : "application/json" },	
							parameterMap: function (options, operation){
								if (operation != "read" && options) {
									if( operation == "create" )
									{
										options.companyId = getCompany().companyId;
										options.company = getCompany();
									}	
									return kendo.stringify(options);
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize, companyId:getCompany().companyId }
								}
							}
						},
						schema: {
							total: "totalCount",
							data: "items",
							model : common.ui.data.Group
						},
						pageSize: 15,
						serverPaging: true
					},
					toolbar: kendo.template('<div class="p-xs"><a href="\\#" class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger k-grid-add" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 그룹만들기 </a></div>'),
					columns: [
						{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
						{ field: "name", title: "키", width:150,  filterable: true, sortable: true }, 
						{ field: "displayName",   title: "이름",  filterable: true, sortable: true,  width: 150 }, 
						{ field: "description",   title: "설명",  filterable: false, sortable: false,  width: 150 }, /*
						{ field: "creationDate", title: "등록일", filterable: false,  width: 80, format: "{0:yyyy/MM/dd}" },
						{ field: "modifiedDate", title: "수정일", filterable: false,  width: 80, format: "{0:yyyy/MM/dd}" },*/
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
					detailTemplate: kendo.template($("#group-details-template").html()),		
					detailInit: detailInit,		
					filterable: true,
					editable: "inline",
					selectable: 'row',
					batch: false,              
					scrollable: false,
					/*height: 600,*/
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },					
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
							$this.expandRow($this.select());
						});							
					}	   
				});		
				renderTo.find("a[data-action=create]").click(function(e){
					common.ui.grid(renderTo)
				});			
			}			
		}
		
		
		function detailInit(e) {
			var detailRow = e.detailRow;
			var renderTo = $("#company-grid");
			var data = e.data;			
			detailRow.find("[data-action=collapses]").click(function(e){
				common.ui.grid(renderTo).collapseRow(detailRow.prev());
			});			
			detailRow.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.data("action") ){
						case "properties" :
							createGroupPropertiesGrid(detailRow.find(".properties"), data);
							break;
						case "users" :
							createGroupUserGrid(detailRow.find(".users"), data);
							break;	
						case "roles" :
							createGroupRolePanel(detailRow.find(".roles"), data);
							break
						case "basic" :
						//	createCompanyLogoGrid	(detailRow.find(".logos"), detailRow.find("[name=logo-file]"), data);
							break	
					}	
				});			
			detailRow.find(".nav-tabs a:first").tab('show');		
		}		


		function createGroupUserGrid(renderTo, data){
			if( ! common.ui.exists(renderTo)){	
				common.ui.grid(renderTo, {
					dataSource: {
						type: "json",
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/group/users/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  groupId: data.groupId }
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
					toolbar: kendo.template('<div class="p-xs"><div class="btn-group"><a class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="add" href="\\#"><span class="btn-label icon fa fa-user-plus"></span> 멤버 추가 </a><a class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="remove" href="\\#" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> ...\'"><span class="btn-label icon fa fa-user-times"></span> 멤버 삭제 </a></div></div>'),
					columns: [
						{ headerTemplate: '<input type="checkbox" id="group-'+data.groupId+'-select-all-members" class="k-checkbox" /> <label class="k-checkbox-label" for="group-'+data.groupId+'-select-all-members">&nbsp</label>', template: '<input type="checkbox" id="group-'+ data.groupId +'-selected-member-#= userId #" class="k-checkbox" data-object-id="#=userId#"/> <label class="k-checkbox-label membership" for="group-'+data.groupId+'-selected-member-#= userId #">&nbsp</label>', width: 50},
						{ field: "username", title: "아이디" , template:'<img width="25" height="25" class="img-circle no-margin" src="/download/profile/#= username #?width=150&amp;height=150" style="margin-right:10px;"> #: username #'}, 
						{ field: "name", title: "이름", template: '#if (nameVisible) { # #: name#  #} else{ # **** # } #  ' }, 
						{ field: "email", title: "메일", template: '#if (emailVisible) { # #: email#  #} else{ # **** # } #  ' },
						{ field: "creationDate", title: "등록일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" } ],
					dataBound:function(e){

					}
				});		
				// checkbox
				renderTo.find("#group-" + data.groupId +  "-select-all-members").change( function(e){
					if($(this).is(":checked")) {
						renderTo.find("input.k-checkbox[data-object-id]").prop("checked", true);						
					}else{
						renderTo.find("input.k-checkbox[data-object-id]").prop("checked", false);	
					}					
				});			
				// buttons
				renderTo.find(".btn[data-action=add]").click( function(e){ 
					openMembershipModal(data);
				});
				
				renderTo.find(".btn[data-action=remove]").click( function(e){ 
					var selected = renderTo.find("input.k-checkbox[data-object-id]:checked");
					var members = [];
					$.each( selected , function( index, row ){
						members.push( $(row).data("object-id") );					
					});					
					
					if( members.length == 0 ){
						alert( "선택된 사용자가 없습니다." );
						return false;
					}
					var $this = $(this);		
					var $btn = $this.button('loading');
										
					common.ui.ajax("<@spring.url "/secure/data/mgmt/group/users/remove.json?output=json"/>" , {
						type : 'POST',
						data: { groupId : data.groupId, userIds: members },
						success : function(response){
							renderTo.data("kendoGrid").dataSource.read();
						},
						complete: function(){
							$btn.button('reset');
						}
					});
				});												
			}	
			renderTo.data("kendoGrid").dataSource.fetch();
		}	
		
		function createGroupRolePanel(renderTo, data){		
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
			if( ! common.ui.exists(renderTo) ){	
					common.ui.grid(renderTo, {
						dataSource: {
							type: "json",
							transport: {
								read: { url:'<@spring.url "/secure/data/mgmt/group/roles/list_with_ownership.json?output=json"/>', type: 'POST' },
								parameterMap: function (options, operation){
									if (operation != "read" && options) {
												return { groupId: data.groupId, roleId : options.objectId  };
									}else{
										return { groupId: data.groupId };
									}
								}
							},
							schema: {
								model: kendo.data.Model.define({
									id : "objectId",
									fields: { 
										objectId: { type: "number", defaultValue: 0 },
										name: { type: "string", defaultValue: "" },
										displayName: { type: "string", defaultValue: "" },
										description: { type: "string", defaultValue: "" },
										ownership: { type: "boolean", defaultValue: false },
										inherited: { type: "boolean", defaultValue: false }
									}
								})	
							},
							error:common.ui.handleAjaxError
						},
						scrollable: true,
						autoBind: false,
						selectable: 'row',
						columns: [
							{ field: "objectId", title: "ID", width:40,  filterable: false, sortable: false }, 
							{ field: "name",  title: "권한",  filterable: true, sortable: true, template: '<span class="#if (inherited){ #text-default# }else{ #text-primary#}#"><i class="fa fa-key"></i></span> #: name #' },
							{ field: "ownership", title: "권한부여됨", width:100,  filterable: false, sortable: false, template:'<input id="#=uid#-role-#=objectId#" type="checkbox" data-object-id="#=objectId#" class="k-checkbox" #if (ownership){ #checked="checked" #}# #if (inherited){# disabled="disabled" #}#><label for="#=uid#-role-#=objectId#"class="k-checkbox-label">&nbsp;</label>' }, 
						],
						dataBound:function(e){
							renderTo.find(".k-checkbox").change(function(e){
								var $this = $(this);
								var objectId = $this.data("object-id");
								var checked = $this.is(":checked");
								common.ui.ajax(
								checked?"<@spring.url "/secure/data/mgmt/group/roles/add.json"/>":"<@spring.url "/secure/data/mgmt/group/roles/remove.json"/>",
								{
									type : 'POST',
									data: { groupId : data.groupId, roleId: objectId },
									success : function(response){
										renderTo.data("kendoGrid").dataSource.read();		
									},
									complete: function(){
									}
								});															
							});
						},
						toolbar: kendo.template('<div class="p-xs pull-right"><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm" data-action="refresh">새로고침</button></div>')
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});				
			}
			common.ui.grid(renderTo).dataSource.fetch();					
		}
					
		
		function createGroupPropertiesGrid(renderTo, data){		
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/group/properties/list.json?output=json&groupId="/>' + data.groupId , type:'post' },
							create: { url:'<@spring.url "/secure/data/mgmt/group/properties/update.json?output=json&groupId="/>' + data.groupId , type:'post', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/group/properties/update.json?output=json&groupId="/>' + data.groupId, type:'post', contentType : "application/json"  },
							destroy: { url:'<@spring.url "/secure/data/mgmt/group/properties/delete.json?output=json&groupId="/>' + data.groupId, type:'post', contentType : "application/json" },
							parameterMap: function (options, operation){			
								if (operation !== "read" && options.models) {
									return kendo.stringify(options.models);
								}else{ 
									return { groupId: data.groupId }
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

		function openMembershipModal(data){			
			var renderToString = "#my-membership-modal";			
			if( $(renderToString).length === 0 ){	
				$("#main-wrapper").append( kendo.template($('#my-membership-modal-template').html()) );				
				var observable = kendo.observable({
					group : new common.ui.data.Group(),
					setGroup : function(data){
						alert( kendo.stringify(data) );
						data.copy(this.group);
					}
				});				
				kendo.bind($(renderToString), observable );
				$(renderToString).data("model", observable );
				$(renderToString).modal({
					backdrop: 'static',
					show : false
				});
			}	
			$(renderToString).data("model").setGroup( data );		
			$(renderToString).modal('show');	
		}
							
				
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
			
			
			#company-group-grid > .k-grid-content {
				min-height: 500px;
			}
						
			#company-group-grid.k-grid .k-selectable tr.k-state-selected{
				background-color: #4cd964;
				border-color: #4cd964;
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
						<div id="company-group-list" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-align-justify"></i> 목록</span>
							</div>
							<div class="panel-body padding-sm">
								<div class="note note-info no-margin-b">
									<h4 class="note-title"><small><i class="fa fa-info"></i> 상세보기 <i class="k-icon k-plus"></i> 를 클릭하면 보다 많은 그룹관련 정보를 조회/변경 할 수 있습니다.</small></h4>
								</div>	
							</div>									
							<div id="company-group-grid" class="no-border-hr"></div>
							<div id="company-grid" class="no-border-hr"></div>
						</div>
						<!-- /details -->
					</div>	
				</div>				
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->	
	
		<script type="text/x-kendo-template" id="group-details-template">		
		<div class="panel" style="border: 2px solid \\#34aadc; ">		
			<div class="panel-body padding-sm">
				<button class="close" data-action="collapses" data-object-id="#= groupId#"><i class="fa fa-angle-up fa-lg"></i></button>				
				<div class="tab-v1">
					<ul class="nav nav-tabs nav-tabs-xs">
						<li class=""><a href="\\#group-#= groupId#-tab-1" data-toggle="tab" data-action="basic">기본정보</a></li>
						<li class=""><a href="\\#group-#= groupId#-tab-2" data-toggle="tab" data-action="users">멤버</a></li>
						<li class=""><a href="\\#group-#= groupId#-tab-3" data-toggle="tab" data-action="roles">롤</a></li>
						<li class=""><a href="\\#group-#= groupId#-tab-4" data-toggle="tab" data-action="properties">속성</a></li>
					</ul>	
					<div class="tab-content">
						<div class="tab-pane fade" id="group-#= groupId#-tab-1">
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
						<div class="tab-pane fade" id="group-#= groupId#-tab-2">
							<div class="users"></div>
						</div>
						<div class="tab-pane fade" id="group-#= groupId#-tab-3">
							<div class="roles"></div>
						</div>
						<div class="tab-pane fade" id="group-#= groupId#-tab-4">
							 <div class="properties"></div>
						</div>
																							
					</div>
				</div>
			</div>
		</div>			
		</script>	
		
		<script type="text/x-kendo-template" id="my-membership-modal-template">
		<div id="my-membership-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog">	
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title"><span data-bind="text: group.displayName" ></span> 멤버 추가</h4>
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
						<button type="button" class="btn btn-primary btn-flat" data-bind="click: save, enabled: editable" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>추가</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>					
				</div>
			</div>
		</div>	
		</script> 				
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>