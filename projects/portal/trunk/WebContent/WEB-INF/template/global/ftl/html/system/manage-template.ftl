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
			'css!${request.contextPath}/styles/jquery.jgrowl/jquery.jgrowl.min.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/jquery.jgrowl/jquery.jgrowl.min.js',			
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
				
				
				//createCacheStatsGrid();	
				createPathFinder();
				// END SCRIPT
			}
		}]);		
		
		function createPathFinder(){
		
			var finderDataSource = new kendo.data.HierarchicalDataSource({
				transport: { 
					read: { url:'${request.contextPath}/secure/list-template-files.do?output=json', type: 'POST' }
				},
				schema: {
					data: "targetFiles",					
					model: {
						id: "path",
						hasChildren: "directory"
					}
				},
				error: common.api.handleKendoAjaxError
			});
			
			$("#template-tree-view").kendoTreeView({
				dataSource: finderDataSource,
				template: kendo.template($("#treeview-template").html()),
				dataTextField: "name",
				change: function(e) {
					showTemplateDetails();
				}
			});
		}		

		function getSelectedTemplateFile(){			
			var renderTo = $("#template-tree-view");
			var tree = renderTo.data('kendoTreeView');			
			var selectedCells = tree.select();			
			var selectedCell = tree.dataItem( selectedCells );   
			return selectedCell ;
		}
		
		function showTemplateDetails (){			
			var renderTo = $('#template-details');
			var filePlaceHolder = getSelectedTemplateFile();				
			alert( kendo.stringify(filePlaceHolder) );
			if(!renderTo.data("model")){	
				
				var detailsModel = kendo.observable({
					file : new common.models.FileInfo()
				});	
				kendo.bind(renderTo, detailsModel );	
				renderTo.data("model", detailsModel );		
			}
			
			renderTo.data("model").file.path = filePlaceHolder.path; 
	    	renderTo.data("model").file.set("absolutePath", filePlaceHolder.absolutePath );
	    	renderTo.data("model").file.set("name", filePlaceHolder.name );
	    	renderTo.data("model").file.set("size", filePlaceHolder.size );
	    	renderTo.data("model").file.set("directory", filePlaceHolder.directory );
	    	renderTo.data("model").file.set("lastModifiedDate", filePlaceHolder.lastModifiedDate );	
	    		
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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-sm-4">					
						<div class="panel colourable">
							<div class="panel-body">
								<div id="template-tree-view" ></div>	
							</div>
						</div>						
					</div>
					<div class="col-sm-8">				
						<div id="template-details" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title" data-bind="text:file.path"></span>
								<div class="panel-heading-controls">
									<span class="panel-heading-text"><em>Just some text with <a href="#">link</a></em>&nbsp;&nbsp;<span style="color: #ccc">|</span>&nbsp;&nbsp;</span>
									<button class="btn btn-primary  btn-xs">수정</button>
								</div>
							</div>			
							<table class="table table-hover">
								<thead>
									<tr>
										<th>이름</th>
										<th>크기</th>
										<th>수정일</th>
										<th>Username</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td data-bind="text:file.name"></td>
										<td data-bind="text:file.formattedSize"></td>
										<td data-bind="text:file.formattedLastModifiedDate"></td>
										<td data-bind="text:file.path"></td>
									</tr>
								</tbody>
							</table>										
							<div class="panel-body">
								<span class="header-2">File</span>
								<div class="note note-info">
								<ul class="list-unstyled">
								  <li>위치: <span data-bind="text:file.path"></span></li>
								  <li>크기: <span data-bind="text:file.formattedSize"></span></li>
								  <li>마지막 수정일: <span data-bind="text:file.formattedLastModifiedDate"></span></li>    
								</ul>
								</div>
							</div>
							<div class="panel-footer no-padding-vr"></div>
						</div>					
					</div></!-- /.col-sm-12 -->
				</div><!-- /.row -->	
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