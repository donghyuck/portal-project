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
				
				createCacheStatsGrid();	
				
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
								read: { url:'<@spring.url "/secure/data/config/application/list.json?output=json"/>', type:'post' },
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
						toolbar: [
							{ name: "create", text: "추가" },
							{ name: "save", text: "저장" },
							{ name: "cancel", text: "취소" }
						],				     
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
					$("[data-action='refresh']").click( function(e){
						common.ui.grid(renderTo).dataSource.read();
					});					
				}						
			}
		}
				
		function createCacheStatsGrid(){
			var renderTo = $("#cache-stats-grid");
			if( !common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {	
						transport: { 
							read: { url:'<@spring.url "/secure/data/stage/cache/list.json?output=json"/>', type: 'POST' }
						},
						schema: {
							model : common.ui.data.CacheStats 
						},
						sort: { field: "cacheName", dir: "asc" }
					},
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					columns: [
						{ field: "cacheName", title: "Cache", width:80,  filterable: true, sortable: true , template: '#: cacheName # <button class="btn btn-xs btn-labeled btn-danger pull-right" data-action="cache-removeAll" data-loading-text="<i class=&quot;fa fa-spinner fa-spin&quot;></i>"><span class="btn-label icon fa fa-bolt"></span>캐쉬 비우기</button>' }, 
						{ field: "diskPersistent", title: "Disk Cache", width:20,  filterable: true, sortable: true ,headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center" }},
						{ title: "Effectiveness",  width: 40, template: '#if( cacheHits > 0 ){ # #= kendo.toString( cacheHits / (cacheHits + misses ) , "p") # #}#' , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center" }},
						{ field: "size",    title: "Object",  filterable: true, sortable: true,  width: 30 , template: '#if(diskPersistent){# #:size# / #: (maxEntriesLocalHeap+maxEntriesLocalDisk) # #}else{# #:size# / #: maxEntriesLocalHeap # #}#'  ,headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center" }},
						{ field: "cacheHits",    title: "cacheHits",  width: 30 ,headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center; color:blue;" }},
						{ field: "misses",    title: "misses",  width: 30 ,headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center; color: red;" }},
						{ field: "evictionCount",    title: "evictionCount",  width: 30, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, attributes : {  "class": "table-cell", style: "text-align: center" }}
					],
					sortable: true,
					selectable : "row"
				});
				$("[data-action='refresh']").click( function(e){
					$("#cache-stats-grid").data("kendoGrid").dataSource.read();
				});				
				$(document).on("click", "[data-action='cache-removeAll']", function(e){
					var btn = $(this);
					btn.button("loading");
					common.ui.ajax( "<@spring.url "/secure/data/mgmt/cache/refresh.json?output=json"/>", {
						data : { name:  getSelectedCacheStats().cacheName },
						success : function(response){
							$("#cache-stats-grid").data("kendoGrid").dataSource.read();
						},
						always : function(e){
							btn.button("reset");
						}							
					});					
				});				
			}
		}
				
		function getSelectedCacheStats(){			
			var renderTo = $("#cache-stats-grid");
			var grid = renderTo.data('kendoGrid');			
			var selectedCells = grid.select();			
			if( selectedCells.length == 0){
				return new common.ui.data.CacheStats();
			}else{			
				var selectedCell = grid.dataItem( selectedCells );   
				return selectedCell;
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
				<div class="row">			
					<div class="col-sm-12">				
						<div id="cache-stats-list" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-align-justify"></i> 캐쉬</span>
							</div>
							<div id="cache-stats-grid" class="no-border-hr"></div>
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