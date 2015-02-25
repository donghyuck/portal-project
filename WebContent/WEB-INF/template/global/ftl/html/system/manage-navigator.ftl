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
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js" />',			
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
				
				
				$('#database-details-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#database-table-tree-view" :
							
							break;
						case  '#sql-tree-view' :
							
							break;
					}	
				});
				
				$('#database-details-tabs a:first').tab('show');		
				// END SCRIPT
			}
		}]);		
										
		-->
		</script> 		 
		<style>
		#xmleditor.panel-body{
			min-height:500px;
		}	

		.list-and-detail{
			margin: -18px -18px 18px -18px;
		
		}
		.list-and-detail .list-and-detail-nav {
			border-color: #e2e2e2;
			background: #f6f6f6;
			border: 0 solid;
		}
		
		@media (min-width: 992px) {
			.list-and-detail .list-and-detail-nav {
				width: 400px;
				border-bottom: 0;
				/*position: absolute;*/
				height: auto;
				border-right-width: 1px;		
				border-color: #e2e2e2;
				float: left;
			}

			.list-and-detail .list-and-detail-contanier {
				margin-left: 400px;
			}
		}		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3_5") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				<div class="list-and-detail">
					<div class="list-and-detail-nav p-xs">
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-code"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="database-details-tabs" role="tablist">
									<li>
										<a href="#sql-tree-view" data-toggle="tab">MENU</a>
									</li>
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->												
							<div class="tab-content">
								<div class="tab-pane fade panel-body padding-sm" id="database-table-tree-view">
								<div class="table-light">
									<div class="table-header">
										<div class="table-caption">
											&nbsp;
											<span data-bind="text:catalog" class="text-muted"></span>	 <span data-bind="text:schema" class="text-muted"></span>
											<div class="pull-right margin-buttom-20">											
												<button class="btn btn-flat btn-xs btn-labeled btn-default" data-bind="visible:connecting, click:showDBTableList" data-loading-text="<i class='fa fa-spinner fa-spin'></i> 조회중 ..."><span class="btn-label icon fa fa-bolt"></span>TABLE 조회</button>										
											</div>
										</div>
									</div>
									<table class="table table-bordered">
										<thead>
											<tr>
												<th>테이블</th>
												<th width="45">보기</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>&nbsp; </td>
												<td>&nbsp; </td>
											</tr>
										</tbody>
									</table>
									<div class="table-footer">
										<span data-bind="text: tableCount, invisible:connecting">0</span> 개
									</div>
								</div>								
								
								</div><!-- ./tab-pane -->
								<div class="tab-pane fade panel-body padding-sm" id="sql-tree-view">
								</div><!-- ./tab-pane -->
							</div><!-- /.tab-content -->						
							<div class="panel-footer no-padding-vr"></div>	
						</div>					
					</div>
					<div class="list-and-detail-contanier p-xs">					
						<div id="database-table-details" class="panel panel-default" data-bind="visible:visible" style="display:none;">
							<div class="panel-heading">
								<i class="fa fa-table"></i> <span data-bind="text:name"></span>
								<div class="panel-heading-controls">
									<button class="close" data-action="slideUp"><i class="fa fa-chevron-up"></i></button>
									<button class="close" data-action="slideDown"  style="display:none;"><i class="fa fa-chevron-down"></i></button>								
								</div>
							</div>			
							<div data-role="grid" 
								data-sortable="true" 
								data-bind="source: columns" 
								data-columns="[ {'field':'primaryKey', 'title':'기본키'}, {'field':'name', 'title':'컬럼'}, {'field':'typeName' ,'title':'타입'}, {'field':'size' ,'title':'크기'}, {'field':'nullable' ,'title':'IS_NULLABLE'}]"  class="no-border" ></div>
							<div class="panel-footer">
								컬럼 : <span data-bind="text: columnCount">0</span> 
							</div>
						</div>	
						<div id="sql-details" class="panel colourable" style="display:none;">
							<div class="panel-heading">
								<span data-bind="text:file.name">&nbsp;</span>
									<div class="panel-heading-controls">
										<button class="btn btn-success  btn-xs" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>					
									</div>
								</div>			
								<div class="panel-body padding-sm" style="height: 43px;">
									<span class="label label-warning">PATH</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:file.path"></span>
									<div class="pull-right text-muted">
										<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
									</div>
							</div>
							<div id="xmleditor" class="panel-body bordered no-border-hr" data-bind="invisible: file.directory" style="display:none;"></div>
							<div class="panel-footer no-padding-vr"></div>
						</div>						
					
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<script id="treeview-template" type="text/kendo-ui-template">
			#if(item.directory){#<i class="fa fa-folder-open-o"></i> # }else{# <i class="fa fa-file-code-o"></i> #}#
            #: item.name # 
            # if (!item.items) { #
                <a class='delete-link' href='\#'></a> 
            # } #
        </script>									
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>