<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
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
			'${request.contextPath}/js/common/common.ui.admin.js',
			'${request.contextPath}/js/ace/ace.js'			
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
				
				createDatabasePanel();
				createTablePanel();									
				// END SCRIPT
			}
		}]);		
											
		function createDatabasePanel(){		
				var detailsModel = kendo.observable({
					catalog : "",
					schema : "",
					connecting : true,
					status : 0,
					tableCount : 0
				});	
				var renderTo = $("#database-details");
				renderTo.data("model", detailsModel );
				kendo.bind( renderTo, detailsModel );

				connectDatabase();	
				setInterval(function () {
					if(getDatabaseDetailsModel().get("status") == 1) 
						connectDatabase();
				}, 15000);
								
				$("#database-details ul.list-group").slimScroll({
					height: '550px'
				});
		}
		
		function createTablePanel(){
				var renderTo =  $("#database-table-details");
				var detailsModel = kendo.observable({
					name : "",
					columns : [],
					columnCount : 0,
					visible : false
				});
				renderTo.data("model", detailsModel );
				kendo.bind( renderTo, detailsModel );						
								
				$(document).on("click","[data-table]", function(e){		
					var $this = $(this);		
					common.api.callback({
						url :"${request.contextPath}/secure/get-database-browser-table.do?output=json", 
						data : { targetTableName : $this.data("table") },
						success : function(response){
							detailsModel.set("name", response.targetTable.name);
							detailsModel.set("columns", response.targetTable.columns);
							detailsModel.set("columnCount", response.targetTable.columns.length);
							detailsModel.set("visible", true );						
						}
					}); 		
				});												
		}
											
		function getDatabaseDetailsModel(){
			var renderTo = $("#database-details");
			return renderTo.data("model");
		} 								
									
		
		function connectDatabase(){
			common.api.callback(  
			{
				url :"${request.contextPath}/secure/list-database-browser-tables.do?output=json", 
				data : {  },
				success : function(response){					
					var model = getDatabaseDetailsModel();
					model.set("catalog" , response.catalogFilter);
					model.set("schema", response.schemaFilter); 
					model.set("status", response.taskStatusCode); 
				
					if( response.taskStatusCode == 2 ){
						model.set("connecting" , false);
						model.set("tableCount" , response.tableNames.length );
						var rendorTo = $("#database-details ul.list-group");
						var template = kendo.template('<li class="list-group-item"><i class="fa fa-table"></i> #: name # <button class="btn  btn-primary btn-outline btn-flat btn-xs pull-right" data-table="#= name #" >상세 보기</button></li>');
						$.each( 
							response.tableNames,
							function( index , value ){
								rendorTo.append(template({ "index" : index , "name" : value  }));
							}
						);						
						rendorTo.slideDown();
					}
				}
			}); 						
		}
									
		-->
		</script> 		 
		<style>
		#htmleditor.panel-body{
			min-height:500px;
		}
		#template-details .table > thead > tr > th {
			vertical-align: bottom;
			border-bottom: none;
		}
		#template-details .table > tbody > tr  {
			border-bottom: 1px solid #ddd;
		}		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_2") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-sm-4">
						<div class="btn-group btn-group-justified">
							<button type="button" class="btn btn-outline btn-flat">Left</button>
							<button type="button" class="btn btn-outline btn-flat"><i class="fa fa-database"></i> SQL 워크시트 열기</button>
							<button type="button" class="btn btn-outline btn-flat"><i class="fa fa-table"></i> 테이블 목록 보기</button>
						</div>
						<hr>		
						<div id="database-details" class="panel form-horizontal">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-folder-open"></i> 테이블</span> 
								<div class="panel-heading-controls">
									<span class="label label-danger" data-bind="text:catalog"></span> <span class="label label-danger" data-bind="text:schema"></span>
								</div>
							</div> <!-- / .panel-heading -->
							<ul class="list-group" style="display:none;">
							</ul>	
							<div class="panel-footer">
								테이블 : <span data-bind="text: tableCount">0</span> 
								<div class="panel-heading-controls" style="width: 30%">
									<div class="progress progress-striped active" style="width: 100%" data-bind="visible:connecting">
										<div class="progress-bar progress-bar-danger" style="width: 100%;"></div>
									</div>
								</div>							
							</div>													
						</div>															
					</div>
					<div class="col-sm-8">				
						<div id="database-table-details" class="panel panel-primary" data-bind="visible:visible">
							<div class="panel-heading">
								<i class="fa fa-table"></i> <span data-bind="text:name"></span>
								<div class="panel-heading-controls">	</div>
							</div>			
							<div data-role="grid" data-sortable="true" data-bind="source: columns" data-columns="[ {'field':'primaryKey', 'title':'기본키'}, {'field':'name', 'title':'컬럼'}, {'field':'typeName' ,'title':'타입'}, {'field':'size' ,'title':'크기'}, {'field':'nullable' ,'title':'IS_NULLABLE'}]"  class="no-border" ></div>
							<div class="panel-footer">
								컬럼 : <span data-bind="text: columnCount">0</span> 
							</div>
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