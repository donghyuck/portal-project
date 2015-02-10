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
				createMemoryStats();
				// END SCRIPT
			}
		}]);
		
		function createMemoryStatsChart(renderTo, dataSource) {
			if(!common.ui.exists(renderTo)){
				renderTo.kendoChart({
					dataSource: dataSource,
	                title: {
	                    text: "Olympic Medals won by USA"
	                },
	                legend: {
	                    visible: false
	                },
	                seriesDefaults: {
	                    type: "bar",
	                    stack: false
	                },
	                series: [{
	                    name: "INIT",
	                    field : "firstStatsValues[0].value",
		                    color: "#f3ac32"
	                }, {
	                    name: "USED",
	                   	field : "firstStatsValues[2].value",
	                    color: "#b8b8b8"
	                }, {
	                    name: "MAX_USED",
	                   	field : "firstStatsValues[3].value",
	                    color: "#bb6e36"
	                }],
	                valueAxis: {
	                    line: {
	                        visible: false
	                    },
	                    minorGridLines: {
	                        visible: true
	                    }
	                },
	                categoryAxis: {
						field: "producerId",
						majorGridLines: {
							visible: false
						}
					},
	                tooltip: {
	                    visible: true,
	                    template: "hello"
	                }
	            });			
			}
		}
		
		function createMemoryStatsGrid (renderTo, className){
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/memory/stats.json?output=json', type:'post' },
							parameterMap: function (options, operation){			
								options.class = className;
								return options ;
							}	
						},						
						batch: false
					},
					columns: [
						{ title: "항목", field: "producerId", width:150},
						{ title: "INIT", field: "firstStatsValues[0].value" , format: "{0:c}" },
						{ title: "MIN_USED", field: "firstStatsValues[1].value" , format: "{0:c}" },
						{ title: "USED", field: "firstStatsValues[2].value" , format: "{0:c}" },
						{ title: "MAX_USED", field: "firstStatsValues[3].value" , format: "{0:c}" },
						{ title: "MIN_COMMITED", field: "firstStatsValues[4].value" , format: "{0:c}" },
						{ title: "COMMITED", field: "firstStatsValues[5].value" , format: "{0:c}" },
						{ title: "MAX_COMMITED", field: "firstStatsValues[6].value" , format: "{0:c}" },
						{ title: "MAX", field: "firstStatsValues[7].value" , format: "{0:c}" }
					],
					pageable: false,	
					resizable: true,
					editable : false,
					scrollable: true,
					height: 300,
					change: function(e) {
					}
				});
			}	
		}
		
		function createMemoryStats (){	
			
			$('#memory-stats-tabs').on( 'show.bs.tab', function (e) {		
				var target = $(e.target);
				switch( target.attr('href') ){
					case "#memory-pool-stats" :						
						createMemoryStatsGrid($("#memory-pool-stats-grid"), "BuiltInMemoryPoolProducer");				
						createMemoryStatsChart($('#memory-pool-stats-grid-chart'), common.ui.grid($("#memory-pool-stats-grid")).dataSource);					
					break;
					case "#virtual-memory-pool-stats" :
						
						createMemoryStatsGrid($("#virtual-memory-pool-stats-grid"), "BuiltInMemoryPoolVirtualProducer");					
						createMemoryStatsChart($('#virtual-memory-pool-stats-chart'), common.ui.grid($("#virtual-memory-pool-stats-grid")).dataSource);		
					break;
					case "#memory-stats" :						
						createMemoryStatsGrid($("#memory-stats-grid"), "BuiltInMemoryProducer");			
						createMemoryStatsChart($('#memory-stats-chart'), common.ui.grid($("#memory-stats-grid")).dataSource);				
					break;
				}					
			});				
			$('#memory-stats-tabs a:first').tab('show');
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
			
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_6") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">
					<div class="col-xs-12 col-lg-6">
					
					
					</div>
				</div><!-- memory status end -->
				<hr class="no-grid-gutter-h grid-gutter-margin-b no-margin-t">				
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i> 메모리</span>
								<ul class="nav nav-tabs nav-tabs-xs" id="memory-stats-tabs">
									<li>
										<a href="#memory-pool-stats" data-toggle="tab">Memory Pool</a>
									</li>
									<li>
										<a href="#virtual-memory-pool-stats" data-toggle="tab">VirtualMemoryPool</a>
									</li>
									<li>
										<a href="#memory-stats" data-toggle="tab">Memory</a>
									</li>							
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->			
							<div class="tab-content">
								<div class="tab-pane" id="memory-pool-stats">
									<div id="memory-pool-stats-chart" ></div>
									<div id="memory-pool-stats-grid" class="no-border"></div>
								</div>
								<div class="tab-pane" id="virtual-memory-pool-stats">
									<div id="virtual-memory-pool-stats-chart" ></div>
									<div id="virtual-memory-pool-stats-grid" class="no-border"></div>
								</div>
								<div class="tab-pane" id="memory-stats">
									<div id="memory-stats-chart" ></div>
									<div id="memory-stats-grid" class="no-border"></div>
								</div>
							</div><!-- tab contents end -->
							<div class="panel-footer no-padding-vr"></div>
						</div><!-- /.panel -->
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<script id="disk-usage-row-template" type="text/x-kendo-template">			
			<tr>
				<td>
					#: absolutePath #
				</td>
				<td>#: common.ui.admin.bytesToSize(totalSpace - freeSpace) #
					<small class="text-light-gray">#= kendo.toString(( totalSpace - freeSpace), '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.ui.admin.bytesToSize(usableSpace) #
					<small class="text-light-gray">#= kendo.toString(usableSpace, '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.ui.admin.bytesToSize(totalSpace) #
					<small class="text-light-gray">#= kendo.toString(totalSpace, '\\#\\#,\\#') #</small>
				</td>
			</tr>
		</script>								
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>