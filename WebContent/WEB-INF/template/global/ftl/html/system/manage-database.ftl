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
				
				$('#database-details-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#database-table-tree-view" :
							createTableTreePanel($(show_bs_tab.attr('href')));
							break;
						case  '#database-sql-tree-view' :
							createSqlFileTreePanel($(show_bs_tab.attr('href')));
							break;
					}	
				});
				
				$('#database-details-tabs a:first').tab('show');		
				
								
				//createDatabasePanel();
				//createTablePanel();									
				// END SCRIPT
			}
		}]);		

		
		function createTableTreePanel(renderTo){			
			if( !renderTo.data("model") ){
				var detailsModel = kendo.observable({
					catalog : "",
					schema : "",
					connecting : true,
					status : 0,
					tableCount : 0,
					showDBTableList : function(e){
						$this = $(e.target);
						$this.button("loading");				
						extractDatabaseTableInfo(renderTo);	
					}
				});	
				renderTo.data("model", detailsModel );
				kendo.bind( renderTo, detailsModel );
				
				renderTo.find("ul.list-group").slimScroll({
					height: '550px'
				});
				createTableDetailsPanel();				
			}		
		}
		
		function getDBDetailsModel(){
			var renderTo = $("#database-table-tree-view");
			return renderTo.data("model");
		} 		
		
		function extractDatabaseTableInfo(renderTo){
			common.api.callback(  
			{
				url :"${request.contextPath}/secure/list-database-browser-tables.do?output=json", 
				data : {  },
				success : function(response){					
					var model = getDBDetailsModel();
					model.set("catalog" , response.catalogFilter);
					model.set("schema", response.schemaFilter); 
					model.set("status", response.taskStatusCode);
					
					if( response.taskStatusCode == 2 ){
						model.set("connecting" , false);
						model.set("tableCount" , response.tableNames.length );
						var renderTarget = renderTo.find("ul.list-group");
						var template = kendo.template('<li class="list-group-item"><i class="fa fa-table"></i> #: name # <button class="btn  btn-primary btn-outline btn-flat btn-xs pull-right" data-table="#= name #" >상세 보기</button></li>');
						$.each( 
							response.tableNames,
							function( index , value ){
								renderTarget.append(template({ "index" : index , "name" : value  }));
							}
						);						
						renderTarget.slideDown();
					}else{
						setInterval(function () {
							extractDatabaseTableInfo(renderTo);
						}, 10000);						
					}
				}
			}); 						
		}

		function createTableDetailsPanel(){
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
				
				renderTo.find("button.close").click(function(e){
					$this = $(this);
					$icon =  $this.children("i");
					if( $icon.hasClass("fa-chevron-up") ){
						$icon.removeClass("")
					
					}else{
					
					
					}
										
					
					renderTo.find("[data-role='grid']").slideUp();
					
					renderTo.find("[data-role='grid']").slideDown();
				});								
		}
		
		function createSqlFileTreePanel(renderTo){
			if( !renderTo.data('kendoTreeView') ){		
				renderTo.kendoTreeView({
					dataSource: {
						transport: { 
							read: { url:'${request.contextPath}/secure/list-sql-files.do?output=json', type: 'POST' }
						},
						schema: {
							data: "targetFiles",					
							model: {
								id: "path",
								hasChildren: "directory"
							}
						},
						error: common.api.handleKendoAjaxError					
					},
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var filePlaceHolder = getSelectedSqlFile(renderTo);
						showSqlFileDetails(filePlaceHolder);
					}
				});			
			}
		}

		function getSelectedSqlFile( renderTo ){			
			var tree = renderTo.data('kendoTreeView');			
			var selectedCells = tree.select();			
			var selectedCell = tree.dataItem( selectedCells );   
			return selectedCell ;
		}
		
		function showSqlFileDetails (filePlaceHolder){							
			var renderTo = $('#sql-details');			
			if(!renderTo.data("model")){					
				var detailsModel = kendo.observable({
					file : new common.models.FileInfo(),
					content : "",
					supportCustomized : false,
					supportUpdate : false,
					supportSvn : true,
					openFileUpdateModal : function(){
						alert("준비중입니다");
						return false;
					}					
				});					
				kendo.bind(renderTo, detailsModel );	
				renderTo.data("model", detailsModel );		
				var editor = ace.edit("xmleditor");		
				editor.getSession().setMode("ace/mode/xml");
				editor.getSession().setUseWrapMode(false);					
			}
						
			renderTo.data("model").file.set("path", filePlaceHolder.path); 
			renderTo.data("model").file.set("customized", filePlaceHolder.customized); 
	    	renderTo.data("model").file.set("absolutePath", filePlaceHolder.absolutePath );
	    	renderTo.data("model").file.set("name", filePlaceHolder.name );
	    	renderTo.data("model").file.set("size", filePlaceHolder.size );
	    	renderTo.data("model").file.set("directory", filePlaceHolder.directory );
	    	renderTo.data("model").file.set("lastModifiedDate", filePlaceHolder.lastModifiedDate );	
	    	
	    	if( !filePlaceHolder.customized && !filePlaceHolder.directory ) 
	    	{
	    		renderTo.data("model").set("supportCustomized", true); 
	    	}else{
	    		renderTo.data("model").set("supportCustomized", false); 
	    	}
	    	
	    	if( filePlaceHolder.path.indexOf( ".svn" ) != -1 ) {
	    		renderTo.data("model").set("supportSvn", false); 
	    	}else{
	    		renderTo.data("model").set("supportSvn", true); 
	    	}  
	    	if(!filePlaceHolder.directory){
				common.api.callback(  
				{
					url :"${request.contextPath}/secure/view-sql-file-content.do?output=json", 
					data : { path:  filePlaceHolder.path },
					success : function(response){
						ace.edit("xmleditor").setValue( response.targetFileContent );	
					}
				}); 
	    	}	    		
		}												
		-->
		</script> 		 
		<style>
		#xmleditor.panel-body{
			min-height:500px;
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
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-database"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="database-details-tabs" role="tablist">
									<li>
										<a href="#database-table-tree-view" data-toggle="tab">스키마</a>
									</li>
									<li>
										<a href="#database-sql-tree-view" data-toggle="tab">SQL</a>
									</li>
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->		
											
							<div class="tab-content">
								<div class="tab-pane fade panel-body padding-sm" id="database-table-tree-view">
									<div class="m-b-sm">
										<span class="label label-warning">카테고리</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:catalog" class="text-muted"></span>	
										<span class="label label-warning">스키마</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:schema" class="text-muted"></span>
										<div class="pull-right margin-buttom-20">
											<span data-bind="text: tableCount, invisible:connecting">0</span>
											<button class="btn btn-flat btn-xs btn-labeled btn-default" data-bind="visible:connecting, click:showDBTableList" data-loading-text="<i class='fa fa-spinner fa-spin'></i> 조회중 ..."><span class="btn-label icon fa fa-bolt"></span>TABLE 목록</button>										
										</div>
									</div>
									<ul class="list-group no-margin-b" style="display:none;"></ul>
									
								</div><!-- ./tab-pane -->
								<div class="tab-pane fade panel-body padding-sm" id="database-sql-tree-view">
								</div><!-- ./tab-pane -->
							</div><!-- /.tab-content -->						
							<div class="panel-footer no-padding-vr"></div>	
						</div>
					</div></!-- /.col-sm-4 -->	
					<div class="col-sm-8">				
						<div id="sql-details" class="panel panel-primary">
							<div class="panel-heading">
								<span data-bind="text:file.name">&nbsp;</span>
									<div class="panel-heading-controls">
										<button class="btn btn-success  btn-xs" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>
									</div>
								</div>			
								<div class="panel-body padding-sm">
									<span class="label label-warning">PATH</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:file.path"></span>
									<div class="pull-right text-muted">
										<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
									</div>
							</div>
							<div id="xmleditor" class="panel-body bordered no-border-hr" data-bind="invisible: file.directory" style="display:none;"></div>
							<div class="panel-footer no-padding-vr"></div>
						</div>						
						<div id="database-table-details" class="panel panel-primary" data-bind="visible:visible">
							<div class="panel-heading">
								<i class="fa fa-table"></i> <span data-bind="text:name"></span>
								<div class="panel-heading-controls"><button class="close"><i class="fa fa-chevron-up"></i></button><button class="close" style="display:none;"><i class="fa fa-chevron-down"></i></button></div>
							</div>			
							<div data-role="grid" data-sortable="true" data-bind="source: columns" data-columns="[ {'field':'primaryKey', 'title':'기본키'}, {'field':'name', 'title':'컬럼'}, {'field':'typeName' ,'title':'타입'}, {'field':'size' ,'title':'크기'}, {'field':'nullable' ,'title':'IS_NULLABLE'}]"  class="no-border" ></div>
							<div class="panel-footer">
								컬럼 : <span data-bind="text: columnCount">0</span> 
							</div>
						</div>					
					</div></!-- /.col-sm-8 -->
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