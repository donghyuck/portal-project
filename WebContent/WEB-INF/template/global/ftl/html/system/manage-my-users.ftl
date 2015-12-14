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
			'<@spring.url "/js/kendo/jszip.min.js"/>',
			'<@spring.url "/js/kendo/pako_deflate.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js"/>',	
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
						
					},
					change: function(e){						
						getCompanyUserGrid().dataSource.read();
					}
				});		
				createCompanyUserGrid();							
				// END SCRIPT
			}
		}]);
		
		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		
		function getCompanyUserGrid(){
			var renderTo = $("#company-user-grid");			
			return common.ui.grid(renderTo);
		}
		function createCompanyUserGrid(){
			var renderTo = $("#company-user-grid");			
			if(!common.ui.exists(renderTo)){
				var companySelector = getCompanySelector();	
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {	
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/users/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, operation){	          
							
								console.log(companySelector.value() + "__");
								if (operation != "read" && options) {
									return kendo.stringify(options);
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize, companyId:companySelector.value() }
								}
							}
						},
						schema: {
							total: "totalCount",
							data: "items",
							model : common.ui.data.User
						},
						pageSize: 15,
						serverPaging: true,
						error:common.ui.handleAjaxError
					},					
					toolbar : kendo.template('<div class="p-xxs"><a href="\\#" class="btn btn-flat btn-outline btn-labeled btn-primary k-grid-pdf"><span class="btn-label icon fa fa-file-pdf-o"></span>PDF</a> <a href="\\#" class="btn btn-flat btn-outline btn-labeled btn-primary k-grid-excel"><span class="btn-label icon fa fa-file-excel-o"></span>Excel</a></div>'),
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
						{ field: "lastLoggedIn", title: "마지막 로그인", filterable: false,  width: 150, format: "{0:yyyy/MM/dd HH:mm}" }
					], 		
					detailTemplate: kendo.template($("#company-user-details-template").html()),		
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
						//renderTo.find("a[data-action=details]").click(function(e){
							//showCompanyDetails();
							//$this.expandRow($this.select());
						//});							
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
			if( ! common.ui.exists(renderTo) ){	
					common.ui.grid(renderTo, {
						dataSource: {
							type: "json",
							transport: {
								read: { url:'<@spring.url "/secure/data/mgmt/user/roles/list_with_ownership.json?output=json"/>', type: 'POST' },
								parameterMap: function (options, operation){
									if (operation != "read" && options) {
												return { userId: data.userId, roleId : options.objectId  };
									}else{
										return { userId: data.userId };
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
							{ field: "inherited", title: "그룹권한", width:100,  filterable: false, sortable: false, template:'#if (inherited){ #<input type="checkbox" class="k-checkbox" checked="checked" disabled="disabled"><label class="k-checkbox-label">&nbsp;</label>#}#' }, 
							{ field: "ownership", title: "권한부여됨", width:100,  filterable: false, sortable: false, template:'<input id="#=uid#-role-#=objectId#" type="checkbox" data-object-id="#=objectId#" class="k-checkbox" #if (ownership){ #checked="checked" #}# #if (inherited){# disabled="disabled" #}#><label for="#=uid#-role-#=objectId#"class="k-checkbox-label">&nbsp;</label>' }, 
						],
						dataBound:function(e){
							renderTo.find(".k-checkbox").change(function(e){
								var $this = $(this);
								var objectId = $this.data("object-id");
								var checked = $this.is(":checked");
								common.ui.ajax(
								checked?"<@spring.url "/secure/data/mgmt/user/roles/add.json"/>":"<@spring.url "/secure/data/mgmt/user/roles/remove.json"/>",
								{
									type : 'POST',
									data: { userId : data.userId, roleId: objectId },
									success : function(response){
										renderTo.data("kendoGrid").dataSource.read();		
									},
									complete: function(){
									}
								});															
							});
						},
						toolbar: kendo.template('<div class="p-xxs pull-right"><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm" data-action="refresh">새로고침</button></div>')
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});				
			}
			common.ui.grid(renderTo).dataSource.fetch();					
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
					toolbar: kendo.template('<div class="p-xxs"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
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
							{ field: "name",  title: "그룹",  filterable: true, sortable: true, template: '<span class="#if (membership){ #text-primary# }else{ #text-default#}#"><i class="fa fa-users"></i></span> #: displayName #(#: name #) ' },
							{ field: "membership",  width:100, title: "멤버쉽",  filterable: true, sortable: true, template: '#if (membership){ #<a href="\\#" class="btn btn-xs btn-labeled btn-danger k-grid-edit" data-action="remove" data-object-id="#=groupId#" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> ...\'"><span class="btn-label icon fa fa-user-times"></span> 탈퇴</a>#}else{#<a href="\\#" class="btn btn-xs btn-labeled btn-success k-grid-edit" data-action="add" data-object-id="#=groupId#" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> ...\'"><span class="btn-label icon fa fa-user-plus"></span> 가입</a>#}#' }
						],
						saveChanges: function(e) {
							this.dataSource.read();						
						},
						dataBound:function(e){
							renderTo.find("[data-action=add],[data-action=remove]").click(function(e){
								var $this = $(this);
								var $btn = $this.button('loading');
								
								var membership = $this.data("action") == "add" ;
								var objectId = $this.data("object-id");
								
								common.ui.ajax(
									membership ? "<@spring.url "/secure/data/mgmt/group/users/remove.json"/>" : "<@spring.url "/secure/data/mgmt/user/groups/remove.json"/>" ,
									{
										type : 'POST',
										data: { groupId : objectId, userId:data.userId },
										success : function(response){
											common.ui.grid(renderTo).dataSource.read();
										},
										complete: function(){
											$btn.button('reset');
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
							
		-->
		</script> 		 
		<style>
			.k-grid-content {
				min-height:150px;
			}
			
			#xml-editor{
				position: absolute;
				top: 0;
				right: 0;
				bottom: 0;
				left: 0;
				min-height:400px;
			}
			

			.k-checkbox:disabled+.k-checkbox-label:hover:before {
				content:none;
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
						<div id="company-user-list" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<input id="company-dropdown-list" />
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
	
		<script type="text/x-kendo-template" id="company-user-details-template">		
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
							<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">그룹으로 부터 상속된 롤들은 변경할 수 없습니다. 그룹에서 부여된 롤을 제외한 롤들만 아래의 선택박스에서 사용자에게 부여 또는 제거하세요.</h6>
							<div class="roles"></div>
						</div>
						<div class="tab-pane fade" id="user-#= userId#-tab-4">
							<div class="properties"></div>
						</div>
																							
					</div>
				</div>
			</div>
		</div>			
		</script>		
					
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>