<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
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
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo/kendo.dataviz.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/fastclick.js"/>', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>'
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
								
				$('#config-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);					
					switch( show_bs_tab.attr('href') ){
						case "#config-tab-setup" :
							createApplicationPropertiesGrid($(show_bs_tab.attr('href')), false);
							break;
						case  '#config-tab-application' :
							createApplicationPropertiesGrid($(show_bs_tab.attr('href')), true);
							break;
					}	
				});
				
				$('#config-tabs a:first').tab('show');		
				
				// END SCRIPT
			}
		}]);		
		
		function createApplicationPropertiesGrid(renderTo, usingDatabase){			
			if( !common.ui.exists(renderTo) ){
				if( usingDatabase ){
					common.ui.grid(renderTo, {
						dataSource: {
							transport: { 
								read: { url:'<@spring.url "/secure/data/config/application/list.json?output=json"/>', type:'post', contentType : "application/json" },
								create: { url:'<@spring.url "/secure/data/config/application/update.json?output=json"/>', type:'post',  contentType : "application/json" },
								update: { url:'<@spring.url "/secure/data/config/application/update.json?output=json"/>', type:'post',  contentType : "application/json"  },
								destroy: { url:'<@spring.url "/secure/data/config/application/delete.json?output=json"/>', type:'post',  contentType : "application/json" },
								parameterMap: function (options, operation){			
									if (operation !== "read" && options.models) {
										return kendo.stringify(options.models);
									} 
								}
							},						
							batch: true, 
							sort: { field: "name", dir: "asc" },
							schema: {
								model: common.ui.data.Property
							}
						},
						columns: [
							{ title: "속성", field: "name", width: 250 },
							{ title: "값",   field: "value", filterable: false, sortable:false },
							{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
						],
						editable : true,
						scrollable: true,
						filterable: true,
						sortable: true,
						height:500,
						toolbar: kendo.template('<div class="p-sm"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
						change: function(e) {
						}
					});
					common.ui.grid(renderTo).dataSource.read();				
				}else{
					common.ui.grid(renderTo, {
						dataSource: {	
							transport: { 
								read: { url:'<@spring.url "/secure/data/config/setup/list.json?output=json"/>', type: 'POST' }
							},
							schema: {
								model : common.ui.data.Property 
							},
							sort: { field: "name", dir: "asc" }
						},
						toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
						columns: [
							{ title: "속성", field: "name" },
							{ title: "값",   field: "value", filterable: false, sortable:false }
						],
						height:500,
						filterable: true,
						sortable: true,
						scrollable: true,
						selectable : "row"
					});					
				}		
				$("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});									
			}
		}				
		-->
		</script> 		 
		<style>	
			.tab-pane.k-grid{
				height:500px;
			}		
			
			.tab-pane.k-grid .k-selectable tr.k-state-selected{
				background-color: #4cd964;
				border-color: #4cd964;
			}		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_1") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-sm-12">
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-cog"></i> Config</span>								
								<ul class="nav nav-tabs nav-tabs-xs" id="config-tabs">
									<li>
										<a href="#config-tab-setup" data-toggle="tab">Setup</a>
									</li>
									<li>
										<a href="#config-tab-application" data-toggle="tab">Application</a>
									</li>						
								</ul>					
							</div>
							<div class="tab-content">
								<div class="tab-pane" id="config-tab-setup">	
								</div>	
								<div class="tab-pane" id="config-tab-application">	
								</div>													
							</div>
							
						</div>
							
					</div></!-- /.col-sm-12 -->
				</div><!-- /.row -->						

			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<script id="disk-usage-row-template" type="text/x-kendo-template">			
			<tr>
				<td>
					#: absolutePath #
				</td>
				<td>#: common.api.bytesToSize(totalSpace - freeSpace) #
					<small class="text-light-gray">#= kendo.toString(( totalSpace - freeSpace), '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.api.bytesToSize(usableSpace) #
					<small class="text-light-gray">#= kendo.toString(usableSpace, '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.api.bytesToSize(totalSpace) #
					<small class="text-light-gray">#= kendo.toString(totalSpace, '\\#\\#,\\#') #</small>
				</td>
			</tr>
		</script>												
		
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>