<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css" />',
			'css!<@spring.url "/styles/common.plugins/animate.css" />',
			'css!<@spring.url "/styles/jquery.jgrowl/jquery.jgrowl.min.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css" />',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css" />',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js" />',
			'<@spring.url "/js/kendo/kendo.web.min.js" />',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js" />',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js" />',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js" />',			
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.community.js" />',
			'<@spring.url "/js/common/common.ui.admin.js" />',	
			'<@spring.url "/js/ace/ace.js" />'	
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
				createSecurityTabPanels();
				// END SCRIPT
			}
		}]);
		
		function createSecurityTabPanels(){		
			$('#myTab').on( 'show.bs.tab', function (e) {				
				var target = $(e.target);
				if( target.data("action") ){
					switch( target.data("action") ){
						case "role" :
						createSelectBox();
						createRoleGrid();
						break;
					}	
				}			
			});
			$('#myTab a:first').tab('show');							
		}
		
		function createSelectBox(){
		
			if( !$("#perms-company-list").data("kendoDropDownList") ){
						var companies = $("#perms-company-list").kendoDropDownList({
							optionLabel: "회사를 선택하세요...",
							dataTextField: "displayName",
							dataValueField: "companyId",
							dataSource : {
								transport : {
									read: { 
										type : "post", 
										dataType:"json", 
										url : '<@spring.url "/secure/data/mgmt/company/list.json?output=json"/>'
									}	
								},
								schema: {
									total: "totalCount",
									data: "items",
									model : common.ui.data.Company
								}
							}
						});	
			}
			if( !$("#perms-site-list").data("kendoDropDownList") ){									
						var websites = $("#perms-site-list").kendoDropDownList({
							autoBind: false,
							cascadeFrom: "perms-company-list",
							optionLabel: "웹 사이트를 선택하세요.",
							dataTextField: "displayName",
							dataValueField: "webSiteId",							
							dataSource : {
								serverFiltering: true,
								transport : {
									read: { type : "post", dataType:"json", url : '<@spring.url "/secure/data/mgmt/website/list.json?output=json"/>' },	
									parameterMap: function (options, operation){
										return { "company" :  options.filter.filters[0].value }; 
									}									
								},
								schema: {
									total: "totalCount",
									data: "items",
									model : common.ui.data.WebSite
								}
							},
							change:function(){
								if( this.value() > 0 ){
									common.ui.admin.permissions.list({
										objectType : 30 ,
										objectId : this.value(),
										perms:PERMS_NAMES_LEVEN1,
										success:function(data){
											common.ui.stringify(data);
											var renderTo = $('#perms-30-listview');
											var template = kendo.template( $("#perms-30-listview-template").html() );
											renderTo.html( template(data) );
										}
									});
								}
							}						
						}).data("kendoDropDownList");										
			}				
		
		}
		
		function createRoleGrid(){
			var renderTo = $("#security-role-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/role/list.json?output=json"/>', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.Role
						}
					},
					columns: [
						{ title: "ID", field: "roleId",  width:40 },
						{ title: "이름", field: "name" },
						{ title: "설명",   field: "description" },
						{ command: [{ 
							name: "edit",
								className: "btn btn-xs btn-info",
								template : '<a href="\\#" class="btn btn-xs btn-labeled btn-info k-grid-edit btn-selectable"><span class="btn-label icon fa fa-pencil"></span> 변경</a>',
								text: { edit: "변경", update: "저장", cancel: "취소"}
							}
							], 
							title: "&nbsp;", 
							width: 180  
						}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-md btn-danger" data-action="create" data-object-id="0" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-plus"></span> 롤 추가 </button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : 'inline',
					selectable : "row",
					scrollable: true,
					height: 500,
					change: function(e) {
					}	
				});
				renderTo.find("button[data-action=create]").click(function(e){
					common.ui.grid(renderTo).addRow();
					common.ui.grid(renderTo).select("tr:eq(1)");
				});	
			}					
		}
		
		var PERMS_NAMES_LEVEN1 = ["WEBSITE_ADMIN", "MODERATOR", "CREATE_DOCUMENT", "CREATE_COMMENT", "CREATE_IMAGE", "CREATE_FILE", "CREATE_POLL", "VOTE_IN_POLL", "CREATE_ANNOUNCEMENT" ];
		
		-->
		</script> 		 
		<style>

			.stat-cell .k-grid {
				border-top: 1px solid #e4e4e4;
				border-left: 1px solid #e4e4e4;
				border-top-width: 0 !important;
				border-right-width: 0 !important;
				border-bottom-width: 0 !important;				
			}
			.tab-pane .k-grid{
				min-height: 300px;
			} 
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_7_3") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
					
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="myTab">
									<li>
										<a href="#bs-tabdrop-tab1" data-toggle="tab" data-action="role">롤</a>
									</li>			
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->					
							<div class="tab-content">
								<div class="tab-pane p-sm" id="bs-tabdrop-tab1">
								
									<div class="row">
										<div class="col-sm-4">
											<label class="control-label" for="perms-company-list">회 사</label>
											&nbsp;&nbsp;<input id="perms-company-list" />
										</div>
										<div class="col-sm-4">
											<label class="control-label" for="perms-site-list">사이트</label>
											&nbsp;&nbsp;<input id="perms-site-list" />	
										</div>
										<div class="col-sm-4">
										
										</div>
									</div>		
									<div id="perms-30-listview" class="p-sm table-responsive"></div>																					
								</div>								
							</div><!-- tab contents end -->
						</div><!-- /.panel -->
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->							
		<script id="perms-30-listview-template" type="text/x-kendo-template">
			<table class="table" width="100%">
				<thead>
				<tr>
					<th colspan="2" width="24%">&nbsp;</th>
					# for (var i = 0 ; i < PERMS_NAMES_LEVEN1.length; i++ ) { #
						<th class="text-center small" width="#= 75/PERMS_NAMES_LEVEN1.length #%"><span class="label">#: PERMS_NAMES_LEVEN1[i]#</span></th>
					# } #
					<th width="1%">&nbsp;</th>
				</tr>
				<tr>
					<td colspan="#= PERMS_NAMES_LEVEN1.length + 2 #">User Types</td>
					<td>&nbsp;</td>
				</tr>				
				</thead>
				<tbody>
				<tr class="active">
					<td colspan="2">Anonymous</td>
					# for(  var i = 0 ; i < anonymous.length ; i++) {#
					<td>
						<input name="anonymous-#=i#" type="radio" class="k-radio" #if( anonymous[i].additive ){ #checked="checked" # } # id="anonymous-#=i#-additive">
         				<label class="k-radio-label" for="anonymous-#=i#-additive"><span class="k-icon k-i-tick"></span></label>
						<input name="anonymous-#=i#" type="radio" class="k-radio" #if( anonymous[i].negative ){ #checked="checked" # } # id="anonymous-#=i#-negative">
         				<label class="k-radio-label" for="anonymous-#=i#-negative"><span class="k-icon k-i-cancel"></span></label>         				
					</td>
					# } #
					<td>&nbsp;</td>				
				</tr>
				<tr>
					<td colspan="2">Member</td>
					# for(  var i = 0 ; i < member.length ; i++) {#
					<td>
						<input name="member-#=i#" type="radio" class="k-radio" #if( member[i].additive ){ #checked="checked" # } # id="member-#=i#-additive">
         				<label class="k-radio-label" for="member-#=i#-additive"><span class="k-icon k-i-tick"></span></label>
						<input name="member-#=i#" type="radio" class="k-radio" #if( member[i].negative ){ #checked="checked" # } # id="member-#=i#-negative">
         				<label class="k-radio-label" for="member-#=i#-negative"><span class="k-icon k-i-cancel"></span></label>         				
					</td>
					# } #
					<td>&nbsp;</td>				
				</tr>				
				</tbody>
			</table>
		</script>					
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>