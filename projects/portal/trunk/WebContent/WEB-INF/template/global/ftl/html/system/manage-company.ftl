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
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});		
				
				createCompanyGrid();															
				// END SCRIPT
			}
		}]);
		
		
		function createCompanyGrid(){
			var renderTo = $("#company-grid");
			if(!common.ui.exists(renderTo)){
				common.ui.grid(renderTo, {
					dataSource: {	
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/company/list.json?output=json"/>', type: 'POST' },
							create: { url:'<@spring.url "/secure/data/mgmt/company/create.json?output=json"/>', type:'POST', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/company/update.json?output=json"/>', type:'POST', contentType : "application/json" },
							parameterMap: function (options, operation){	          
								alert( kendo.stringify(options) );
								if (operation != "read" && options) {
									//return { companyId: options.companyId, item: kendo.stringify(options)};
									return kendo.stringify(options.models);
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize }
								}
							}
						},
						schema: {
							total: "totalCount",
							data: "items",
							model : common.ui.data.Company
						},
						pageSize: 15,
						serverPaging: true
					},
					toolbar: kendo.template('<div class="p-xs"><a href="\\#" class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger k-grid-add" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 회사 추가 </a></div>'),
					columns: [
						{ field: "companyId", title: "ID", width:40,  filterable: false, sortable: false }, 
						{ field: "name", title: "KEY", width:100,  filterable: false, sortable: false }, 
						{ field: "displayName",   title: "이름",  filterable: true, sortable: true,  width: 150 }, 
						{ field: "domainName",   title: "도메인",  filterable: true, sortable: false,  width: 100 }, 
						{ field: "description", title: "설명", width: 200, filterable: false, sortable: false },
						{ command: [
							{ 
								name: "detail",
								template : '<a href="\\#" class="btn btn-xs btn-success m-r-xs" data-action="details">상세보기</a>',
							},{ 
								name: "edit",
								template : '<a href="\\#" class="btn btn-xs btn-labeled btn-info k-grid-edit"><span class="btn-label icon fa fa-pencil"></span> 변경</a>',
								text: { edit: "변경", update: "저장", cancel: "취소"}
							}], 
							title: "&nbsp;", 
							width: 180  
						}
					], 						
					filterable: true,
					editable: "inline",
					selectable: 'row',
					height: '500',
					batch: false,              
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
						renderTo.find("a[data-action=details]").click(function(e){
							showCompanyDetails();
						});	
					}	   
				});		
				renderTo.find("a[data-action=create]").click(function(e){
					common.ui.grid(renderTo)
				});			
			}
			
		}
				
		function getSelectedCompany(){
			var renderTo = $("#company-grid");
			var grid = renderTo.data('kendoGrid');
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );   
			return selectedCell;
		}
		
		function getCompanyDetailsModel () {
			var renderTo = $('#company-details');
			var model = renderTo.data("model");
			return model;
		}
		
		function hideCompanyDetails(){			
			if( $("#company-details").text().length > 0 && $("#company-details").is(":visible") ){
				$("#company-details").fadeOut("slow", function(){
					if( $("#company-list").is(":hidden") ){
						$("#company-list").fadeIn();
					}
				});
			}	
		}
		
		function showCompanyDetails(){		
		
			var renderTo = $('#company-details');
			var companyPlaceHolder = getSelectedCompany();

			if( renderTo.text().length === 0 ){
				renderTo.html(kendo.template($('#company-details-template').html()));
				var detailsModel = kendo.observable({
					company : new common.ui.data.Company(),
					logoUrl : "",
					memberCount : 0 ,
					groupCount : 0 
				});					
				detailsModel.bind("change", function(e){		
					if( e.field.match('^company.name')){ 						
						var sender = e.sender ;
						if( sender.company.companyId > 0 ){
							var dt = new Date();
							this.set("logoUrl", "/download/logo/company/" + sender.company.name + "?" + dt.getTime() );
							this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.creationDate ));      
							this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.modifiedDate ));
						}
					}	
				});
				kendo.bind(renderTo, detailsModel );	
				renderTo.data("model", detailsModel );		
				$('#myTab').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#props" :
							createCompanyPropsPane($("#company-prop-grid"));
							break;
						case  '#users' :
							createCompanyMembersPane($('#company-user-grid'));
							break;
						case  '#groups' :	
							createCompanyGroupsPane($('#company-group-grid'));
							break;
					}	
				});
				renderTo.find(".panel-heading > button.close").click(function(e){
					hideCompanyDetails();
				});
			}
			companyPlaceHolder.copy( renderTo.data("model").company );
			
			$('#myTab a:first').tab('show');		
			
			if(renderTo.is(':hidden')){
				$("#company-list").fadeOut("slow", function(){
						renderTo.fadeIn("slow");
					});
			}
						
			return false;
		}
		
		function createCompanyPropsPane(renderTo){
			var companyPlaceHolder = getSelectedCompany();
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/get-company-property.do?output=json"/>', type:'post' },
							create: { url:'<@spring.url "/secure/update-company-property.do?output=json"/>', type:'post' },
							update: { url:'<@spring.url "/secure/update-company-property.do?output=json"/>', type:'post'  },
							destroy: { url:'<@spring.url "/secure/delete-company-property.do?output=json"/>', type:'post' },
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
							model: common.ui.data.Property
						},
						error:common.ui.handleAjaxError
					},
					columns: [
						{ title: "속성", field: "name", width: 250 },
						{ title: "값",   field: "value" },
						{ command:  { name: "destroy", template:'<a href="\\#" class="btn btn-xs btn-labeled btn-danger k-grid-delete"><span class="btn-label icon fa fa-trash"></span> 삭제</a>' },  title: "&nbsp;", width: 80 }
					],
					pageable: false,
					resizable: true,
					editable : true,
					scrollable: true,
					autoBind: false,
					toolbar: kendo.template('<div class="p-sm"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
					change: function(e) {
					}
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});	
			}
			renderTo.data("kendoGrid").dataSource.read();
		}
		
		function createCompanyMembersPane(renderTo){
			var companyPlaceHolder = getSelectedCompany();
			if( ! renderTo.data("kendoGrid") ){	
				renderTo.kendoGrid({
					dataSource: {
						type: "json",
						transport: { 
							read: { url:'<@spring.url "/secure/list-user.do?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  companyId: getSelectedCompany().companyId }
							}
						},
						schema: {
							total: "totalUserCount",
							data: "users",
							model: common.ui.data.User
						},
						error:common.ui.handleAjaxError,
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
						{ field: "userId", title: "ID", width:50,  filterable: false, sortable: false }, 
						{ field: "username", title: "아이디"}, 
						{ field: "name", title: "이름" }, 
						{ field: "email", title: "메일" },
						{ field: "creationDate", title: "등록일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" } ],
					dataBound:function(e){
						getCompanyDetailsModel().set("memberCount", this.dataSource.total() );
					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-success disabled" data-action="move" data-object-id="0"><span class="btn-label icon fa fa-exchange"></span> 선택 사용자 회사 변경</button></div>')
					/*	
					toolbar: [{ name: "create-groups", text: "선택 사용자 소속 변경하기", imageClass:"k-icon k-i-folder-up" , className: "changeUserCompanyCustomClass" }]*/
				});												
			}	
			renderTo.data("kendoGrid").dataSource.read();
		}	
		
		function createCompanyGroupsPane(renderTo){
			var companyPlaceHolder = getSelectedCompany();
			if( ! renderTo.data("kendoGrid") ){	
					renderTo.kendoGrid({
						dataSource: {
							type: "json",
							transport: {
								read: { url:'<@spring.url "/secure/list-company-group.do?output=json"/>', type:'post' },
								destroy: { url:'<@spring.url "/secure/remove-group-members.do?output=json"/>', type:'post' },
								parameterMap: function (options, operation){
									if (operation !== "read" && options.models) {
										return { companyId: getSelectedCompany().companyId, items: kendo.stringify(options.models)};
									}
									return { companyId: getSelectedCompany().companyId }
								}
							},
							schema: {
								data: "companyGroups",
								model: common.ui.data.Group
							},
							error:common.ui.handleAjaxError
						},
						scrollable: true,
						editable: false,
						autoBind: false,
						columns: [
							{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
							{ field: "name",  title: "KEY",  filterable: true, sortable: true },
							{ field: "displayName",    title: "이름",  filterable: true, sortable: true},
							{ field: "description",    title: "설명",  filterable: false,  sortable: false },
							{ field:"memberCount", title: "인원", filterable: false,  sortable: false, width:50 }
						],
						dataBound:function(e){
							getCompanyDetailsModel().set("groupCount", this.dataSource.total() );
						},
						toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-success m-r-xs" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-gift"></span> 디폴트 그룹 자동 생성</button> <button class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 그룹 추가 </button></div>')
						/**									
						toolbar: [{ name: "create-groups", text: "디폴트 그룹 생성하기", imageClass:"k-icon k-i-folder-add" , className: "createGroupsCustomClass" }]**/
				});		
			}
			renderTo.data("kendoGrid").dataSource.read();
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
							<div id="company-grid" class="no-border-hr"></div>
						</div>
						<!-- /details -->
						<!-- list -->
						<div id="company-details" class="page-details" style="display:none;"></div><!-- /company details -->		
						<!-- /list -->
					</div>	
				</div>				
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
	
		<script type="text/x-kendo-template" id="company-details-template">		
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