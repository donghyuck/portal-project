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
				
				createThresholdsStats();
				// END SCRIPT
			}
		}]);
		
		function createThresholdsStats() {
			var renderTo = $("#thresholds-stats-grid");
			if(!common.ui.exists(renderTo)){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/stage/thresholds/list.json?output=json', type:'post' }
						},				
						schema: {
							model: {
								fields: {
									name: {type: "string"},
									updatedDate: { type:"date" }
								}										
							}
						},								
						batch: false
					},
					columns: [
						{ title: "Name", field: "name", width:150,},
						{ title: "Status", field: "status" , width:150, filterable:false,  template:'<i class="status status-#= status #"></i>'},
						{ title: "Value", field: "value" , width:150, format: "{0:##,#}", filterable:false},
						{ title: "Status Change", field: "previousStatus" , width:150, filterable:false, template:'<i class="status status-#= previousStatus #"></i><i class="fa fa-long-arrow-right"></i><i class="status status-#= status #"></i>'},
						{ title: "updatedDate", field: "updatedDate" , width:160, format: "{0:yyyy.MM.dd HH:mm:ss}", filterable:false },
						{ title: "flipCount", field: "flipCount" , format: "{0:##,#}" , width:100, filterable:false},
						{ title: "Path", field: "description", filterable:false}
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh">새로고침</button></div>'),
					pageable: false,	
					resizable: true,
					editable : false,
					filterable: true,
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
				min-height: 500px;
			} 
			
			.status {
				display: inline-block;
				width: 12px;
				height: 12px;
				background: #a3a3a3;
				border-radius: 12px;
				margin-bottom: -2px;
			}		
			.status.status-green {
			    background: #4cd964;
			}
			
			.status.status-orange {
			    background: #ff3b30;
			}
			
			.status.status-red {
			    background: #ff2d55;
			}
			
			.status.status-grey {
			    background: #8e8e93;
			}
			
			.status.status-purple {
			    background: #b44bc4;
			}
			
			.status.status-yellow {
			    background: #ffcc00;
			}
			
			.fa-long-arrow-right {
			font-size: 14px;
			color: #bebebe;
			margin: 0 8px;
			}	
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_6_3") />
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
								<span class="panel-title"><i class="fa fa-info"></i> Thresholds</span>									
							</div>
							<div id="thresholds-stats-grid" class="no-border-hr"></div>
							<div class="panel-body">
									
							</div>
						</div>
					</div>
				</div>					
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->						
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>