<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo/kendo.dataviz.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',			
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',			
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',
			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js'
			],
			complete: function() {
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();
				var targetCompany = new Company();	
				common.ui.admin.setup({
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(targetCompany);
					}
				});					
				
				createCacheStatsGridAndChart();	
				// END SCRIPT
			}
		}]);		
		
		function createCacheStatsDataSource(){
			return new kendo.data.DataSource({
				transport: { 
					read: { url:'${request.contextPath}/secure/list-cache-stats.do?output=json', type: 'POST' }
				},
				schema: {
					data: "allCacheStats",
					model : common.models.CacheStats 
				},
				sort: { field: "cacheName", dir: "asc" },
				error: common.api.handleKendoAjaxError				
			});
		}
				
		function createCacheStatsGridAndChart(){
			
			var sharedDataSource = createCacheStatsDataSource();			
			if( !$("#cache-stats-grid").data("kendoGrid") ){
				$("#cache-stats-grid").kendoGrid({
					dataSource: sharedDataSource,
					autoBind: false,
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
					common.api.callback({
						url :"${request.contextPath}/secure/remove-cache-stats.do?output=json", 
						data : { targetName:  getSelectedCacheStats().cacheName },
						success : function(response){
							$("#cache-stats-grid").data("kendoGrid").dataSource.read();
						},
						always : function(e){
							btn.button("reset");
						}							
					});					
				});				
			}			
			if( !$("#cache-stats-chart").data("kendoChart") ){
				$("#cache-stats-chart").kendoChart({
					dataSource : sharedDataSource,
					autoBind: false,
					title: {
						text: "Object Cache Usage"
					},
					legend: {
						position: "buttom"
					},
					seriesDefaults: {
						type: "bar", stack: true
					},		
					series: [
						{field: "size", name: "Cached Object"},
						{field: "maxEntriesLocalHeap", name: "Memory"},
						{field: "maxEntriesLocalDisk", name: "Disk"},
					],
					categoryAxis:{
						field:"cacheName",
						name : "Cache"
					},
					valueAxis: {
	                    line: {
	                        visible: false
	                    },
	                    minorGridLines: {
	                        visible: true
	                    }
	                },	
				});			
			}
			sharedDataSource.read();
		}
		
		
		function displayCacheStatsChart(){
		
			if( !$("#cache-stats-chart").data("kendoChart") ){
				$("#cache-stats-chart").kendoChart({
					dataSource : $("#cache-stats-grid").data("kendoGrid").dataSource,
					autoBind: false,
					title: {
						text: "Object Cache Usage"
					},
					legend: {
						position: "buttom"
					},
					seriesDefaults: {
						type: "bar"
					},		
					series: [
						{field: "size", name: "Cached Object"},
						{field: "maxEntriesLocalHeap", name: "Memory"},
						{field: "maxEntriesLocalDisk", name: "Disk"},
					],
					categoryAxis:{
						field:"cacheName",
						name : "Cache"
					}	
				});			
			}		
		}
		
		function displayCacheStatsGrid(){
			if( !$("#cache-stats-grid").data("kendoGrid") ){
			
			
				$("#cache-stats-grid").kendoGrid({
					dataSource: {	
						transport: { 
							read: { url:'${request.contextPath}/secure/list-cache-stats.do?output=json', type: 'POST' }
						},
						schema: {
							data: "allCacheStats",
							model : common.models.CacheStats 
						},
						sort: { field: "cacheName", dir: "asc" },
						error: common.api.handleKendoAjaxError
					},
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
					common.api.callback({
						url :"${request.contextPath}/secure/remove-cache-stats.do?output=json", 
						data : { targetName:  getSelectedCacheStats().cacheName },
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
				return new common.models.CacheStats();
			}else{			
				var selectedCell = grid.dataItem( selectedCells );   
				return selectedCell;
			}
		}	
				
		-->
		</script> 		 
		<style>
		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_4") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-sm-12">				
						<div id="cache-stats-list" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-align-justify"></i> 캐쉬 통계</span>
								<div class="panel-heading-controls">
									<button class="btn btn-info btn-xs btn-outline" data-action="refresh"><span class="k-icon k-si-refresh"></span> 새로고침</button>
								</div>
							</div>
							<div class="panel-body">
								<div id="cache-stats-chart"></div>
							</div>
							<div id="cache-stats-grid" class="no-border-hr"></div>	
							<div class="panel-footer no-padding-vr"></div>
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