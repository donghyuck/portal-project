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
			'<@spring.url "/js/common/common.ui.data.admin.js"/>',
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
				
				createAccumulatorsStats();
				// END SCRIPT
			}
		}]);
				
		function createAccumulatorsStats(){
			var renderTo = $("#accumulator-stats-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/accumulators/list.json?output=json', type:'post' }
						},
						schema : {
							model: common.ui.data.Accumulator
						},
						sort: { field: "name", dir: "asc" },
						serverPaging: false						
					},
					columns: [
						{ title: "ID", field: "id", width:80, sortable: false, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
						{ title: "Name", field: "name", width:250 },
						{ title: "Path", field: "path", sortable: false },
						{ title: "Values", field: "numberOfValues" , width:80,  headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, format: "{0:##,#}", sortable: false },
						{ title: "UPDATE DATE", field: "lastValueDate", width:200, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } }
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					resizable: true,
					editable : false,
					scrollable: true,
					sortable: true,
					pageable: false,
					selectable: 'row',
					change: function(e) {
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						var renderTo2 = $("#accumulator-stats-chart");
						
						var stats = [
                    { value: [30], date: new Date("2011/12/20") },
                    { value: [50], date: new Date("2011/12/21") },
                    { value: [45], date: new Date("2011/12/22") },
                    { value: [40], date: new Date("2011/12/23") },
                    { value: [35], date: new Date("2011/12/24") },
                    { value: [40], date: new Date("2011/12/25") },
                    { value: [42], date: new Date("2011/12/26") },
                    { value: [40], date: new Date("2011/12/27") },
                    { value: [35], date: new Date("2011/12/28") },
                    { value: [43], date: new Date("2011/12/29") },
                    { value: [38], date: new Date("2011/12/30") },
                    { value: [30], date: new Date("2011/12/31") },
                    { value: [48], date: new Date("2012/01/01") },
                    { value: [50], date: new Date("2012/01/02") },
                    { value: [55], date: new Date("2012/01/03") },
                    { value: [35], date: new Date("2012/01/04") },
                    { value: [30], date: new Date("2012/01/05") }
                ];
                
						
						if(! common.ui.exists(renderTo2) ){
							renderTo2.kendoChart({
		                        title: {
		                            text: "Units sold"
		                        },
								dataSource: {
				                    transport: {
				                        read: {
											url: "/secure/data/stage/accumulators/graph_data_only.json?output=json",
											dataType: "json"
										},
										parameterMap: function (options, operation){			
											if( !options.accumulator ) 
												options.accumulator = selectedCell.id;											
											return options ;
										}	
									},
									schema: {
										model: {
											id: "date",
											fields: {
												name: {type: "string"},
												date:{ type:"date"}
											}										
										}
									}
				                },
		                        series: [{
									type: "line",
									aggregate: "avg",
									field: "values[0]",
									categoryField: "date"
								}],
								categoryAxis: {
									baseUnit: "minutes"// "minutes"
								}
							});						
						}
						
					},
					dataBound: function(e) {			
					}					
				});
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});
			}				
		}		
				
		-->
		</script> 		 
		<style>
			.table-light .table thead th {
				text-align: center;
			}
			
			table-light .table-footer {
				margin-top:-20px;
			}

			.k-chart.md-chart {
				display: inline-block;
				width: 250px;
				height: 250px;
			}			
			
			.stat-cell .k-grid {
				border-top: 1px solid #e4e4e4;
				border-left: 1px solid #e4e4e4;
				border-top-width: 0 !important;
				border-right-width: 0 !important;
				border-bottom-width: 0 !important;
			}
			
			.k-grid{
				min-height: 500px;
			} 
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_6_2") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-lg-12">	

									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-xs-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-line-chart bg-icon bg-icon-left"></i>
											<div id="accumulator-stats-chart" class="no-border"></div>										
																					
										</div> <!-- /.stat-cell -->
									</div>	
						
					</div>
				</div>	
				<hr class="no-grid-gutter-h grid-gutter-margin-b">				
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i> 통계</span>								
							</div> <!-- / .panel-heading -->			
							<div id="accumulator-stats-grid" class="no-border"></div>
						</div><!-- /.panel -->
										
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->						
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>