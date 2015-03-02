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
		
		
		function selectedAccumulator(){
			var renderTo = $("#accumulator-stats-grid");
			var grid = common.ui.grid(renderTo);
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );	
			return selectedCell;
		}
				
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
						{ title: "ID", field: "id", width:80, sortable: false, filterable: false, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
						{ title: "Name", field: "name", width:250 },
						{ title: "Path", field: "path", sortable: false,  filterable: false },
						{ title: "Values", field: "numberOfValues" , width:80,  headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, format: "{0:##,#}", sortable: false,  filterable: false },
						{ title: "UPDATE DATE", field: "lastValueDate", width:200, headerAttributes: { "class": "table-header-cell", style: "text-align: center" },  filterable: false }
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					resizable: true,
					editable : false,
					scrollable: true,
					sortable: true,
					height:550,
					pageable: false,
					filterable: true,
					selectable: 'row',
					change: function(e) {
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						var renderTo2 = $("#accumulator-stats-chart");					
						if(! common.ui.exists(renderTo2) ){
							renderTo2.kendoChart({
								title: {
									text: ""
								},
								dataSource: {
									transport: {
										read: {
											url: "/secure/data/stage/accumulators/graph_data_only.json?output=json",
											dataType: "json"
										},
										parameterMap: function (options, operation){
											if( !options.accumulator ) 
												options.accumulator = selectedAccumulator().id;											
											return options ;
										}	
									},
									group: {
										field: "name"
									},
									sort: {
										field: "date",
										dir: "asc"
									},
									schema: {
										model: {
											fields: {
												name: {type: "string"},
												firstValue: { type: "number", defaultValue: 0 },
												date:{ type:"date"}
											}										
										}
									}
								},
								seriesDefaults: {
									type: "scatterLine",
									style: "smooth",
									color: "#007aff",
									markers: {
										visible:true,										
										size: 1
									}							
								},
								series: [{
									yField: "firstValue",
									xField: "date"									
								}],
								legend: {
									position: "bottom"
								},								
								yAxis: {
									labels: {
										format: "{0:##,#}"
									},
								},												
								/*					                
				                seriesDefaults: {
				                    type: "line",
				                    style: "smooth"
				                },
		                        series: [{
									aggregate: "avg",
									field: "values[0]",
									categoryField: "date"
								}],
								categoryAxis: {
									//baseUnit: "hours", // "minutes",
									 labels: {
				                        rotation: -90
				                    },
				                    crosshair: {
				                        visible: true
				                    }
								},
								valueAxis: {
				                    type: "log",
				                    labels: {
				                        format: "{0:##,#}"
				                    },
				                    minorGridLines: {
				                        visible: true
				                    }
				                },*/
								tooltip: {
									visible: true,
									template: "#= dataItem.name  #<br> #= dataItem.date # <br> #= dataItem.firstValue #"
								}
							});						
						}else{
							renderTo2.data("kendoChart").dataSource.read();
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
						<div class="stat-panel no-margin-b bordered">
							<div class="stat-cell col-xs-5 text-center">
								<!-- Stat panel bg icon -->
								<i class="fa fa-line-chart bg-icon bg-icon-left"></i>
								<div id="accumulator-stats-chart" class="no-border" style="min-height:200px"></div>										
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