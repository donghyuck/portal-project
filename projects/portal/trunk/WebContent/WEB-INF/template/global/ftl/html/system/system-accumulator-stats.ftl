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
				
				// END SCRIPT
			}
		}]);
				
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
							<div class="panel-footer no-padding-vr"></div>
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
									<div id="web-filter-single-stats-grid" class="m-sm" style="display:none"></div>
									<div id="web-filter-stats-grid" class="no-border-hr"></div>
								</div>
								<div class="tab-pane" id="web-session-stats">
									<div id="web-session-stats-grid" class="no-border-hr"></div>
								</div>								
							</div><!-- tab contents end -->
							<div class="panel-footer no-padding-vr"></div>
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
									<div id="others-thread-state-stats-grid" class="no-border-hr"></div>
								</div>
								<div class="tab-pane" id="others-thread-count-stats">
									<div id="others-thread-count-stats-grid" class="no-border-hr"></div>
								</div>	
								<div class="tab-pane" id="others-annotated-stats">
									<div id="custom-annotated-single-stats-grid" class="m-sm" style="display:none"></div>
									<div id="others-annotated-stats-grid" class="no-border-hr"></div>
								</div>															
							</div><!-- tab contents end -->
							<div class="panel-footer no-padding-vr"></div>
						</div><!-- /.panel -->							
										
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->						
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>