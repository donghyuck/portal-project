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
							create: { url:'<@spring.url "/secure/create-company.do?output=json"/>', type:'POST' },             
							update: { url:'<@spring.url "/secure/update-company.do?output=json"/>', type:'POST' },
							parameterMap: function (options, operation){	          
								if (operation != "read" && options) {
									return { companyId: options.companyId, item: kendo.stringify(options)};
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
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 회사 추가 </button></div>'),
					columns: [
						{ field: "companyId", title: "ID", width:40,  filterable: false, sortable: false }, 
						{ field: "name", title: "KEY", width:100,  filterable: false, sortable: false }, 
						{ field: "displayName",   title: "이름",  filterable: true, sortable: true,  width: 150 , template:'#:displayName # <button type="button" class="btn btn-xs btn-success pull-right" onclick="javascript:showCompanyDetails(this); return false;">상세보기</button>' }, 
						{ field: "domainName",   title: "도메인",  filterable: true, sortable: false,  width: 100 }, 
						{ field: "description", title: "설명", width: 200, filterable: false, sortable: false },
						{ command: [
							{ 
								name: "detail",
								template : '<a href="\\#" class="btn btn-xs btn-success m-r-sm">상세보기</a>',
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
					}	   
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
				var alwaysShowList = common.ui.admin.switcherEnabled("list-switcher");
				
				$("#company-details").fadeOut("slow", function(){
					if( !alwaysShowList && $("#company-list").is(":hidden") ){
						$("#company-list").fadeIn();
					}
				});
			}	
		}
		
		function showCompanyDetails(e){		
		
			var renderTo = $('#company-details');
			var companyPlaceHolder = getSelectedCompany();

			var alwaysShowList = common.ui.admin.switcherEnabled("list-switcher");			
			
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
				if(alwaysShowList){		
					renderTo.fadeIn("slow", function(){
						$('html,body').animate({scrollTop: renderTo.offset().top - 20 }, 500);	
					});
				}else{
					$("#company-list").fadeOut("slow", function(){
						renderTo.fadeIn("slow");
					});
				}
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
						{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
					],
					pageable: false,
					resizable: true,
					editable : true,
					scrollable: true,
					autoBind: false,
					height: 300,
					toolbar: [
						{ name: "create", text: "추가" },
						{ name: "save", text: "저장" },
						{ name: "cancel", text: "취소" }
					],				     
					change: function(e) {
					}
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
					height: 300,
					filterable: true,
					sortable: true,
					scrollable: true,
					autoBind: false,
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
					selectable: "multiple, row",
					columns: [
						{ field: "userId", title: "ID", width:50,  filterable: false, sortable: false }, 
						{ field: "username", title: "아이디", width: 100 }, 
						{ field: "name", title: "이름", width: 100 }, 
						{ field: "email", title: "메일" },
						{ field: "creationDate", title: "생성일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" } ],
					dataBound:function(e){
						getCompanyDetailsModel().set("memberCount", this.dataSource.total() );
					},
					toolbar: [{ name: "create-groups", text: "선택 사용자 소속 변경하기", imageClass:"k-icon k-i-folder-up" , className: "changeUserCompanyCustomClass" }]
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
						height: 300,
						scrollable: true,
						editable: false,
						autoBind: false,
						columns: [
							{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
							{ field: "name",    title: "KEY",  filterable: true, sortable: true,  width: 100 },
							{ field: "displayName",    title: "그룹",  filterable: true, sortable: true,  width: 100 },
							{ field: "description",    title: "설명",  filterable: false,  sortable: false },
							{ field:"memberCount", title: "멤버", filterable: false,  sortable: false, width:50 }
						],
						dataBound:function(e){
							getCompanyDetailsModel().set("groupCount", this.dataSource.total() );
						},
						toolbar: [{ name: "create-groups", text: "디폴트 그룹 생성하기", imageClass:"k-icon k-i-folder-add" , className: "createGroupsCustomClass" }]
				});		
			}
			renderTo.data("kendoGrid").dataSource.read();
		}				
		
		-->
		</script> 		 
		<style>
			.k-grid-content {
				min-height:150px;
			}
			
			#menu-grid .k-grid-content {
				min-height:350px;
			}
			
			#xml-editor{
				position: absolute;
				top: 0;
				right: 0;
				bottom: 0;
				left: 0;
				min-height:400px;
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
									<h4 class="note-title"><small><i class="fa fa-info"></i> 회사 단위의 독립적인 회원, 그룹, 웹 사이트 운영을 지원합니다.</small></h4>
								</div>	
							</div>									
							<div id="company-grid" class="no-border-hr"></div>	
							<div class="panel-footer no-padding-vr"></div>
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
		
		<script type="text/x-kendo-template" id="menu-modal-template">
		<div class="modal fade" id="menu-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog modal-lg animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">메뉴</h4>
					</div>
					<div class="modal-body no-padding">
						<div class="padding-sm">
							<button class="btn btn-danger btn-flat btn-labeled" data-action="create-menu"><span class="btn-label icon fa fa-plus"></span> <small>새로운 메뉴 만들기</small></button>
						</div>
						<div id="menu-grid" class="no-border-hr no-border-b"></div>
					</div>					
					<div id="menu-editor" style="display:none;" class="modal-body no-padding">
						<div class="padding-sm-vr">
							<form class="form-horizontal">	
									<div class="row no-margin">
										<div class="col-sm-6"><button class="btn btn-primary btn-flat btn-labeled" data-action="editor-close"><span class="btn-label icon fa fa-arrow-left"></span> <small>목록 보기</small></button>	</div>
										<div class="col-sm-3"></div>
										<div class="col-sm-3">
											<h6 class="text-light-gray text-semibold text-xs">줄바꿈 설정/해지</h6>
											<input type="checkbox" name="warp-switcher" data-class="switcher-primary" role="switcher" >	
										</div>
									</div>			
									<div class="row no-margin">
										<div class="col-sm-6">
											<div class="form-group no-margin-hr">
												<input type="text" name="name" class="form-control input-sm" placeholder="이름" data-bind="value: menu.name">
											</div>
										</div><!-- col-sm-6 -->
										<div class="col-sm-6">
											<div class="form-group no-margin-hr">
												<input type="text" name="title" class="form-control input-sm" placeholder="타이틀" data-bind="value: menu.title">
											</div>
										</div><!-- col-sm-6 -->
									</div>
									<div class="row no-margin">
										<div class="col-sm-12">
											<input type="text" name="description" class="form-control input-sm" placeholder="설명"  data-bind="value:menu.description" />
										</div>
									</div>				
							</form>																									
						</div>
						<div id="xml-editor" style="height:400px; position:relative;"></div>	
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary btn-flat disable hidden" data-action="saveOrUpdate" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>저장</button>
					</div>
				</div>
			</div>
		</div>				
		</script>
		
		<script type="text/x-kendo-template" id="role-modal-template">
		<div class="modal fade" id="role-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">권한 & 롤</h4>
					</div>
					<div class="modal-body">
						<div id="role-grid"></div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
						<!--<button type="button" class="btn btn-primary">Save changes</button>-->
					</div>
				</div>
			</div>
		</div>				
		</script>		
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
								<div class="panel colourable">
									<div class="panel-heading">
										<span class="panel-title"><i class="fa fa-info"></i></span>							
										<ul id="myTab" class="nav nav-tabs nav-tabs-xs">
											<li><a href="\\#props" data-toggle="tab">프로퍼티</a></li>
											<li><a href="\\#groups" data-toggle="tab">그룹 <span class="badge badge-success" data-bind="text:groupCount, visible:groupCount ">0</span></a></li>
											<li><a href="\\#users" data-toggle="tab">사용자 <span class="badge badge-success" data-bind="text:memberCount, visible:memberCount">0</span></a></li>
										</ul>	
									</div></!-- /.panel-heading -->								
									<!-- .tab-content -->	
									<div class="tab-content  no-padding">								
										<div class="tab-pane fade" id="props">				
											<div id="company-prop-grid" class="props no-border-hr no-border-t"></div>
										</div>
										<div class="tab-pane fade" id="groups">										
											<div id="company-group-grid"  class="groups no-border-hr no-border-t"></div>					
										</div>
										<div class="tab-pane fade" id="users">	
											<div id="company-user-grid"  class="users no-border-hr no-border-t"></div>
										</div>
									</div><!-- / .tab-content -->
									<div class="panel-footer no-padding-vr"></div>
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