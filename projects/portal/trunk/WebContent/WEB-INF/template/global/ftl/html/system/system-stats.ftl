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
				
				createSystemStats();
				createMemoryStats();
				createWebStats();
				createOthersStats();
				// END SCRIPT
			}
		}]);
		
		function createMemoryStatsChart(renderTo) {
			if(!common.ui.exists(renderTo)){
				renderTo.kendoChart({
	                title: {
	                    text: "Memory Usage"
	                },
	                legend: {
	                    visible: true
	                },
	                seriesDefaults: {
	                    type: "bar",
	                    stack: false
	                },
	                series: [{
	                    name: "INIT",
	                    field : "INIT",
		                    color: "#5acbfa"
	                }, {
	                    name: "USED",
	                   	field : "USED",
	                    color: "#007aff"
	                }, {
	                    name: "MAX_USED",
	                   	field : "MAX_USED",
	                    color: "#ff3b30"
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
	                     template: "#= series.name #: #= common.bytesToSize(value) #"
	                }
	            });			
			}
		}
		
		function createMemoryStatsGrid (renderTo, className, renderTo2){
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
						{ title: "Name", field: "producerId", width:150},
						{ title: "INIT", field: "firstStatsValues[0].value" , format: "{0:##,#}" },
						{ title: "MIN_USED", field: "firstStatsValues[1].value" , format: "{0:##,#}" },
						{ title: "USED", field: "firstStatsValues[2].value" , format: "{0:##,#}" },
						{ title: "MAX_USED", field: "firstStatsValues[3].value" , format: "{0:##,#}" },
						{ title: "MIN_COMMITED", field: "firstStatsValues[4].value" , format: "{0:##,#}" },
						{ title: "COMMITED", field: "firstStatsValues[5].value" , format: "{0:##,#}" },
						{ title: "MAX_COMMITED", field: "firstStatsValues[6].value" , format: "{0:##,#}" },
						{ title: "MAX", field: "firstStatsValues[7].value" , format: "{0:##,#}" }
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					pageable: false,	
					resizable: true,
					editable : false,
					scrollable: true,
					height: 300,
					change: function(e) {
					},
					dataBound: function(e) {			
						if( common.ui.defined(renderTo2) ){
							var items = [];
							$.each( this.dataSource.view() , function( index , value ) {
								items.push({
									producerId : value.producerId,
									INIT: value.firstStatsValues[0].value,
									MIN_USED: value.firstStatsValues[1].value,
									USED: value.firstStatsValues[2].value,
									MAX_USED: value.firstStatsValues[3].value,
									MIN_COMMITED: value.firstStatsValues[4].value,
									COMMITED: value.firstStatsValues[5].value,
									MAX_COMMITED: value.firstStatsValues[6].value,
									MAX: value.firstStatsValues[7].value
								});							
							} );						
							createMemoryStatsChart(renderTo2);
							renderTo2.data("kendoChart").setDataSource(new kendo.data.DataSource({data: items}));						
						}	
					}					
				});
				renderTo.parent().find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});
			}	
		}
		
		/** SYSTEM STATS **/
		function createSystemStats (){		
			$('#system-stats-tabs').on( 'show.bs.tab', function (e) {		
				var target = $(e.target);
				var renderTo1 =  $(target.attr("href") + "-grid" ); 
				var renderTo2 =  $(target.attr("href") + "-chart" ); 
				switch( target.attr('href') ){
					case "#system-runtime-stats" :						
						createProducerStats ("Runtime", true, false, renderTo1,{
							dataBound : function(e){		
								var hours = this.dataSource.view()[4].value 
								var days = this.dataSource.view()[5].value 
								$(target.attr("href")).find(".counter span").first().html(hours);
								$(target.attr("href")).find(".counter span").last().html(days);
							}
						});														
					break;
					case "#system-disk-usage" :
						if(! common.ui.exists(renderTo1) ){
							common.ui.grid(renderTo1, {
								dataSource: {
									transport: { 
										read: { url:'<@spring.url "/secure/data/stage/disk/list.json?output=json"/>', type:'post' }
									},						
									batch: false
								},
								columns: [
									{ title: "Path", field: "absolutePath", width:150},
									{ title: "USED", field: "usableSpace" , format: "{0:##,#}" },
									{ title: "AVAILABLE", field: "freeSpace" , format: "{0:##,#}" },
									{ title: "TOTAL", field: "totalSpace" , format: "{0:##,#}" }
								],
								toolbar: kendo.template('<div class="p-sm text-right"><small class="text-danger m-r-lg"><i class="fa fa-danger"></i>  사용가능 공간은 자바 가상 머신상에서 사용 가능한 공간을 의미합니다. </small><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
								selectable : "row",
								pageable: false,
								resizable: true,
								editable : false,
								scrollable: false,
								height: 300	,	
								change : function(e){		
									if( common.ui.defined(renderTo2) ){
										if(! common.ui.exists(renderTo2) ){
											renderTo2.kendoChart({
												title : { position: "bottom", text: "Disk Usage" },
												legend: { visible: false },
												seriesDefaults: {
													labels: {
														template: "#= category # - #= common.ui.admin.bytesToSize(value) #",
														position: "insideEnd",
														visible: true,
														background: "transparent"
													}
												},
												chartArea: { background: "" },
												series : [{
													type: "pie",
													startAngle: 150,
													field: "percentage",
													categoryField: "source",
													explodeField: "explode"
												}],
												seriesColors: [ "#8e8e93", "#007aff"],
												tooltip: {
												visible: true,
													template: "#: category # - #: kendo.format( '{0:\\#\\#,\\#}',  value) #"
												}
											});
										}
										var selectedCells = this.select();
										var selectedCell = this.dataItem( selectedCells );			
										var items = [];	
										items.push({ percentage: selectedCell.usableSpace , source: "USED", explode: true });
										items.push({ percentage: selectedCell.freeSpace , source: "FREE", explode: false });		
										renderTo2.data("kendoChart").setDataSource( new kendo.data.DataSource({data: items}) );								
									}	
								}					
							});		
							renderTo1.find("button[data-action=refresh]").click(function(e){
								common.ui.grid(renderTo1).dataSource.read();								
							});					
						}
					break;
					case "#system-os-stats" :
						createProducerStats ("OS", true, false, renderTo1, {							
							columns: [{ title: "이름", field: "name", width:190}, { title: "값", field: "value", format: "{0:##,#}" } ],
							dataBound : function(e){				
								if( common.ui.defined(renderTo2) ){
									if(! common.ui.exists(renderTo2) ){
										renderTo2.kendoChart({
											title : {
												position: "bottom",
												text: "Physical System Memory"
											},
											legend: {
												visible: false
											},
											series : [{
												type: "pie",
												startAngle: 150,
												field: "percentage",
												categoryField: "source",
												explodeField: "explode"
											}],
											seriesColors: [ "#8e8e93", "#5ac8fa"],
											tooltip: {
											visible: true,
												template: "#: category # - #: value #MB"
											}
										});
									}
									var items = [];	
									items.push({ 
										percentage: this.dataSource.view()[3].value - this.dataSource.view()[2].value ,
										source: "USED",
										explode : true
									});
									items.push({ 
										percentage: this.dataSource.view()[2].value,
										source: "FREE",			
										explode: false	
									});
									renderTo2.data("kendoChart").setDataSource(
										new kendo.data.DataSource({data: items})
									);
								}
							}
						});	
						break;
				}					
			});				
			$('#system-stats-tabs a:first').tab('show');		
		}
		
		function createMemoryStats (){				
			$('#memory-stats-tabs').on( 'show.bs.tab', function (e) {		
				var target = $(e.target);
				var renderTo1 =  $(target.attr("href") + "-grid" ); 
				var renderTo2 =  $(target.attr("href") + "-chart" ); 
				switch( target.attr('href') ){
					case "#memory-pool-stats" :						
						createMemoryStatsGrid(renderTo1, "BuiltInMemoryPoolProducer", renderTo2);												
					break;
					case "#virtual-memory-pool-stats" :						
						createMemoryStatsGrid(renderTo1, "BuiltInMemoryPoolVirtualProducer", renderTo2);	
					break;
					case "#memory-stats" :	
						createMemoryStatsGrid(renderTo1, "BuiltInMemoryProducer", renderTo2);										
					break;
				}					
			});				
			$('#memory-stats-tabs a:first').tab('show');
		}			
						
		function createWebStats (){				
			$('#web-stats-tabs').on( 'show.bs.tab', function (e) {		
				var target = $(e.target);
				var renderTo1 =  $(target.attr("href") + "-grid" ); 
				var renderTo2 =  $(target.attr("href") + "-chart" ); 
				switch( target.attr('href') ){
					case "#web-filter-stats" :		
						var renderTo3 = $("#web-filter-single-stats-grid");				
						createProducersStats ("filter", true, false, renderTo1, {							
							dataBound: function(e) {			
								if( renderTo3.is(":visible") ){
									renderTo3.slideUp("slow");
								}	
							},
							change: function(e){
								var selectedCells = this.select();
								var selectedCell = this.dataItem( selectedCells );			
								if( !common.ui.exists(renderTo3) ){
									createProducerStats(selectedCell.producerId, false, true, renderTo3, {
										toolbar:null,
										schema:{
											data: "lines"
										},
										columns: [
											{ title: "Name", field: "statName", width:180},
											{ title: "TR", field: "values[0].value" , format: "{0:##,#}" },
											{ title: "TT", field: "values[1].value" , format: "{0:##,#}" },
											{ title: "CR", field: "values[2].value" , format: "{0:##,#}" },
											{ title: "MCR", field: "values[3].value" , format: "{0:##,#}" },
											{ title: "ERR", field: "values[4].value" , format: "{0:##,#}" },
											{ title: "Last", field: "values[5].value" , format: "{0:##,#}" },
											{ title: "Min", field: "values[6].value" , format: "{0:##,#}" },
											{ title: "Max", field: "values[7].value" , format: "{0:##,#}" },
											{ title: "Avg", field: "values[8].value" , format: "{0:##,#}" }						
										]
									});
								}else{
									common.ui.grid(renderTo3).dataSource.read({producerId:selectedCell.producerId });
								}
								if( !renderTo3.is(":visible") ){
									renderTo3.slideDown("slow");
								}																
							},
							selectable : "row",
							columns: [
							{ title: "Name", field: "producerId", width:180},
							{ title: "TR", field: "firstStatsValues[0].value" , format: "{0:##,#}" },
							{ title: "TT", field: "firstStatsValues[1].value" , format: "{0:##,#}" },
							{ title: "CR", field: "firstStatsValues[2].value" , format: "{0:##,#}" },
							{ title: "MCR", field: "firstStatsValues[3].value" , format: "{0:##,#}" },
							{ title: "ERR", field: "firstStatsValues[4].value" , format: "{0:##,#}" },
							{ title: "Last", field: "firstStatsValues[5].value" , format: "{0:##,#}" },
							{ title: "Min", field: "firstStatsValues[6].value" , format: "{0:##,#}" },
							{ title: "Max", field: "firstStatsValues[7].value" , format: "{0:##,#}" },
							{ title: "Avg", field: "firstStatsValues[8].value" , format: "{0:##,#}" }						
						]})									
					break;
					case "#web-session-stats" :
						createSessionCountStats(renderTo1);	
					break; 
				}					
			});				
			$('#web-stats-tabs a:first').tab('show');		
		}
		
		
		function createSessionCountStats (renderTo){
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/session/stats.json?output=json', type:'post' }
						},						
						batch: false
					},
					columns: [
						{ title: "Name", field: "producerId", width:150},
						{ title: "Cur", field: "firstStatsValues[0].value" , format: "{0:##,#}" },
						{ title: "Min", field: "firstStatsValues[1].value" , format: "{0:##,#}" },
						{ title: "Max", field: "firstStatsValues[2].value" , format: "{0:##,#}" },
						{ title: "New", field: "firstStatsValues[3].value" , format: "{0:##,#}" },
						{ title: "Del", field: "firstStatsValues[4].value" , format: "{0:##,#}" }
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					pageable: false,
					resizable: true,
					editable : false,
					scrollable: true,
					height: 300,
					change: function(e) {
					},
					dataBound: function(e) {			
						
					}					
				});
				renderTo.parent().find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});				
			}	
		}
		
		function createOthersStats (){				
			$('#others-stats-tabs').on( 'show.bs.tab', function (e) {		
				var target = $(e.target);
				var renderTo1 =  $(target.attr("href") + "-grid" ); 
				var renderTo2 =  $(target.attr("href") + "-chart" ); 
				switch( target.attr('href') ){
					case "#others-thread-count-stats" :						
						createProducerStats("ThreadCount", true, false, renderTo1);
					break;
					case "#others-thread-state-stats" :						
						createProducerStats("ThreadStates", false, true, renderTo1, {
							schema:{
								data: "lines"
							},
							columns: [
								{ title: "STATE", field: "statName", width:150},
								{ title: "CUR", field: "values[0].value" , format: "{0:##,#}" },
								{ title: "MIN", field: "values[1].value" , format: "{0:##,#}" },
								{ title: "MAX", field: "values[2].value" , format: "{0:##,#}" }							
							]
						});
					break;					
					case "#others-annotated-stats" :
						var renderTo3 = $("#custom-annotated-single-stats-grid");				
						createProducersStats ("annotated", true, false, renderTo1, { 
							dataBound: function(e) {			
								if( renderTo3.is(":visible") ){
									renderTo3.slideUp("slow");
								}	
							},						
							change: function(e){
								var selectedCells = this.select();
								var selectedCell = this.dataItem( selectedCells );			
								if( !common.ui.exists(renderTo3) ){
									createProducerStats(selectedCell.producerId, false, true, renderTo3, {
										toolbar:null,
										schema:{
											data: "lines"
										},
										columns: [
											{ title: "Name", field: "statName", width:180},
											{ title: "TR", field: "values[0].value" , format: "{0:##,#}" },
											{ title: "TT", field: "values[1].value" , format: "{0:##,#}" },
											{ title: "CR", field: "values[2].value" , format: "{0:##,#}" },
											{ title: "MCR", field: "values[3].value" , format: "{0:##,#}" },
											{ title: "ERR", field: "values[4].value" , format: "{0:##,#}" },
											{ title: "Last", field: "values[5].value" , format: "{0:##,#}" },
											{ title: "Min", field: "values[6].value" , format: "{0:##,#}" },
											{ title: "Max", field: "values[7].value" , format: "{0:##,#}" },
											{ title: "Avg", field: "values[8].value" , format: "{0:##,#}" }						
										]
									});
								}else{
									common.ui.grid(renderTo3).dataSource.read({producerId:selectedCell.producerId });
								}
								if( !renderTo3.is(":visible") ){
									renderTo3.slideDown("slow");
								}																
							},
							selectable : "row",
							columns: [
							{ title: "Class", field: "producerId", width:150},
							{ title: "TR", field: "firstStatsValues[0].value" , format: "{0:##,#}" },
							{ title: "TT", field: "firstStatsValues[1].value" , format: "{0:##,#}" },
							{ title: "CR", field: "firstStatsValues[2].value" , format: "{0:##,#}" },
							{ title: "MCR", field: "firstStatsValues[3].value" , format: "{0:##,#}" },
							{ title: "ERR", field: "firstStatsValues[4].value" , format: "{0:##,#}" },
							{ title: "Last", field: "firstStatsValues[5].value" , format: "{0:##,#}" },
							{ title: "Min", field: "firstStatsValues[6].value" , format: "{0:##,#}" },
							{ title: "Max", field: "firstStatsValues[7].value" , format: "{0:##,#}" },
							{ title: "Avg", field: "firstStatsValues[8].value" , format: "{0:##,#}" }						
						]})	
					break; 
				}					
			});				
			$('#others-stats-tabs a:first').tab('show');		
		}

		var DEFAULT_PRODUCERS_SETTING = {
			schema : {
			},
			toolbar: '<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>',
			//toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
			columns : [],
			selectable : false,
			change : function(e) {},
			dataBound : function(e) {}
		};
						
		function createProducersStats (category, createFirstStats, createAllStats, renderTo, options ){
			options = options || {};
			if(! common.ui.exists(renderTo) ){
				var settings = $.extend(true, {}, DEFAULT_PRODUCERS_SETTING, options ); 						
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/producers/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){			
								options.category = category ;
								options.createFirstStats = createFirstStats ;
								options.createAllStats = createAllStats ;
								return options ;
							}	
						},	
						schema : settings.schema,					
						batch: false,
						error : common.ui.error
					},
					toolbar: settings.toolbar,
					columns: settings.columns,
					selectable : settings.selectable,
					pageable: false,	
					resizable: true,
					editable : false,
					scrollable: true,
					height: 300,
					change: settings.change,
					dataBound:settings.dataBounded			
				});
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});				
			}			
		}
		
		var DEFAULT_PRODUCER_SETTING = {
			schema : { 
				data: "firstStatsValues"
			},
			toolbar: '<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>',
			columns : [{ title: "Name", field: "name", width:190}, { title: "Value", field: "value" } ],
			change : function(e) {},
			selectable : false,
			dataBound : function(e) {}
		};
		
		function createProducerStats (producerId, createFirstStats, createAllStats, renderTo, options){			
			options = options || {};		
			if(! common.ui.exists(renderTo) ){
				var settings = $.extend(true, {}, DEFAULT_PRODUCER_SETTING, options ); 						
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/producers/get.json?output=json', type:'post' },
							parameterMap: function (options, operation){		
								if( !options.producerId )
									options.producerId = producerId ;
								options.createFirstStats = createFirstStats ;
								options.createAllStats = createAllStats ;
								return options ;
							}	
						},
						error : common.ui.error,
						schema: settings.schema,		
						batch: false
					},
					toolbar: settings.toolbar,
					columns: settings.columns,
					selectable : settings.selectable,
					pageable: false,	
					resizable: true,
					editable : false,
					scrollable: true,
					height: 300,
					change: settings.change,
					dataBound: settings.dataBound				
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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_6_1") />
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
								<span class="panel-title"><i class="fa fa-info"></i> SYSTEM</span>
								<ul class="nav nav-tabs nav-tabs-xs" id="system-stats-tabs">
									<li>
										<a href="#system-runtime-stats" data-toggle="tab">Runtime</a>
									</li>
									<li>
										<a href="#system-os-stats" data-toggle="tab">OS</a>
									</li>	
									<li>
										<a href="#system-disk-usage" data-toggle="tab">DISK</a>
									</li>														
								</ul> <!-- / .nav -->							
							</div>
							<div class="tab-content">
								<div class="tab-pane" id="system-runtime-stats">									
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-xs-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-laptop bg-icon bg-icon-left"></i>
											<!-- Extra small text -->								
											<p class="text-xlg m-t-lg"><strong>RUNNING HOURS</strong></p>			
											<div class="counter counter-lg"><span>0</span></div>
											<p class="text-xlg"><strong>RUNNING DAYS</strong></p>			
											<div class="counter counter-lg"><span>0</span></div>											
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-7 no-padding valign-bottom">											
											<div id="system-runtime-stats-grid"></div>			
										</div>
									</div>
								</div>
								<div class="tab-pane" id="system-os-stats">							
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-xs-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-tachometer bg-icon bg-icon-left"></i>
											<!-- Extra small text -->											
											<span id="system-os-stats-chart" class="md-chart"></span>											
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-7 no-padding valign-bottom">											
											<div id="system-os-stats-grid"></div>
										</div>
									</div>		
								</div>				
								<div class="tab-pane" id="system-disk-usage">							
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-xs-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-pie-chart bg-icon bg-icon-left"></i>
											<!-- Extra small text -->											
											<span id="system-disk-usage-chart" class="md-chart"></span>											
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-7 no-padding valign-bottom">											
											<div id="system-disk-usage-grid"></div>
										</div>
									</div>		
								</div>																
							</div>
						</div>
					</div>
				</div>	
				<hr class="no-grid-gutter-h grid-gutter-margin-b">				
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i> Memory</span>
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
									<div id="memory-pool-stats-chart" class="padding-sm" ></div>
									<div id="memory-pool-stats-grid" class="no-border-hr"></div>
								</div>
								<div class="tab-pane" id="virtual-memory-pool-stats">
									<div id="virtual-memory-pool-stats-chart" class="padding-sm"></div>
									<div id="virtual-memory-pool-stats-grid" class="no-border-hr"></div>
								</div>
								<div class="tab-pane" id="memory-stats">
									<div id="memory-stats-chart" class="padding-sm"></div>
									<div id="memory-stats-grid" class="no-border-hr"></div>
								</div>
							</div><!-- tab contents end -->
						</div><!-- /.panel -->
						
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i> Web</span></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="web-stats-tabs">
									<li>
										<a href="#web-filter-stats" data-toggle="tab">Filters</a>
									</li>	
									<li>
										<a href="#web-session-stats" data-toggle="tab">Session</a>
									</li>
								</ul>
							</div> <!-- / .panel-heading -->
							<div class="tab-content">
								<div class="tab-pane" id="web-filter-stats">
									<div id="web-filter-single-stats-grid" class="m-sm" style="display:none; border: solid #34AADC;"></div>
									<div id="web-filter-stats-grid" class="no-border-hr"></div>
								</div>
								<div class="tab-pane" id="web-session-stats">
									<div id="web-session-stats-grid" class="no-border-hr"></div>
								</div>								
							</div><!-- tab contents end -->
						</div><!-- /.panel -->				
					
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i> Threads & Monitors</span></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="others-stats-tabs">
									<li>
										<a href="#others-thread-state-stats" data-toggle="tab">Thread State</a>
									</li>	
									<li>
										<a href="#others-thread-count-stats" data-toggle="tab">Thread Count</a>
									</li>									
									<li>
										<a href="#others-annotated-stats" data-toggle="tab">Annotated Class</a>
									</li>
								</ul>
							</div> <!-- / .panel-heading -->
							<div class="tab-content">
								<div class="tab-pane" id="others-thread-state-stats">
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-sm-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-area-chart bg-icon bg-icon-left"></i>
											<!-- Extra small text -->											
											<span id="others-thread-state-stats-chart" class="md-chart"></span>											
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-12 col-sm-7 no-padding valign-bottom">											
											<div id="others-thread-state-stats-grid"></div>
										</div>
									</div>	
								</div>
								<div class="tab-pane" id="others-thread-count-stats">
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-sm-5 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-area-chart bg-icon bg-icon-left"></i>
											<!-- Extra small text -->											
											<span id="others-thread-count-stats-chart" class="md-chart"></span>											
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-12 col-sm-7 no-padding valign-bottom">											
											<div id="others-thread-count-stats-grid"></div>
										</div>
									</div>
								</div>	
								<div class="tab-pane" id="others-annotated-stats">
									<div id="custom-annotated-single-stats-grid" class="m-sm" style="display:none"></div>
									<div id="others-annotated-stats-grid" class="no-border-hr"></div>
								</div>															
							</div><!-- tab contents end -->
						</div><!-- /.panel -->							
										
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->						
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>