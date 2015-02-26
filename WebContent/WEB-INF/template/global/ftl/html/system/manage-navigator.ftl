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
				
				
				$('#navigator-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#navigator-menu-view" :
							createMenuGrid();
							break;
					}	
				});
				
				$('#navigator-tabs a:first').tab('show');		
				// END SCRIPT
			}
		}]);		
		
		function createMenuGrid(){
			var renderTo = $("#navigator-menu-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/navigator/list.json?output=json', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.Menu
						}
					},
					columns: [
						{ title: "Menu", field: "name"},
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-info" data-action="update" data-object-id="#=menuId#"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 메뉴 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : false,
					/*selectable : "row",*/
					scrollable: true,
					height: 600,
					change: function(e) {
					}
				});
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				$(document).on("click","[data-action=update],[data-action=create]", function(e){		
					var $this = $(this);		
					alert( $this.html()  );
				});			
			}	
		}
		
		function openEditor(){
		
		}				
						
										
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
								<span class="panel-title"><i class="fa fa-sitemap"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="navigator-tabs" role="tablist">
									<li>
										<a href="#navigator-menu-view" data-toggle="tab">MENU</a>
									</li>
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->												
							<div class="tab-content">
								<div class="tab-pane fade" id="navigator-menu-view">
									<div id="navigator-menu-grid" class="no-border-hr"></div>
								</div>																
								</div><!-- ./tab-pane -->
							</div><!-- /.tab-content -->
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