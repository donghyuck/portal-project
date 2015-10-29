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
						case "#database-schema-view" :
							createDatabaseSchemaTableGrid(); //	createDatabaseTablePanel($(show_bs_tab.attr('href')));
							break;
						case  '#database-datasource-view' :
							createDatabaseGrid();
							break;
					}	
				});
				
				$('#database-details-tabs a:first').tab('show');		
				// END SCRIPT
			}
		}]);		
		
		function createDatabaseGrid(){		
			var renderTo = $("#database-datasource-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/view-system-databases.do?output=json', type:'post' }
						},						
										batch: false, 
										schema: {
											data: "databaseInfos",
											model: common.ui.data.Database
										}
									},
									columns: [
										{ title: "Database", field: "databaseVersion"},
										{ title: "JDBC Driver", field: "driverName + ' ' + driverVersion" },
										{ title: "ISOLATION", field: "isolationLevel", width:90 },
									],
									pageable: false,
									resizable: true,
									editable : false,
									scrollable: true,
									height: 618,
									change: function(e) {
					}
				});
			}										
		}
		
		function createDatabaseSchemaTableGrid(){
			var renderTo = $("#database-schema-table-grid");
			if( !common.ui.exists(renderTo)){				
				var $btn = renderTo.find("button[data-action=refresh]");				
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/stage/jdbc/schema/list.json?output=json" />', type:'post' }
						},						
						batch: false, 
						schema: {
							data: "tables"
						},
						requestStart: function(e) {
							$btn.button('loading');
						},
						requestEnd: function(e) {
							$btn.button('reset');
						}
					},
					columns: [
						{ title: "Table", template: '<i class="fa fa-table"></i> #: value #'},
						{ title: "", width:80, template: '<button class="btn  btn-default btn-outline btn-flat btn-xs pull-left" data-table="#= value #">View</button>'}
					],
					toolbar: kendo.template('<div class="p-sm text-right"><button class="btn btn-info btn-sm btn-outline btn-flat" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
					pageable: false,
					resizable: true,
					editable : false,
					scrollable: true,
					height: 618,
					change: function(e) {
					}
				});
				createTableDetailsPanel();
				$btn.click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});
			}
		}

		function createTableDetailsPanel(){
				var renderTo =  $("#database-table-details");				
				var observable = kendo.observable({
					name : "",
					columns : [],
					columnCount : 0,
					visible : false
				});
				common.ui.bind( renderTo, observable );				
				var btnSlideUp = renderTo.find("button.close[data-action='slideUp']");				
				var btnSlideDown = renderTo.find("button.close[data-action='slideDown']");				
				btnSlideUp.click(function(e){
					renderTo.find("[data-role='grid']").slideUp();
					btnSlideUp.hide();
					btnSlideDown.show();
				});				
				btnSlideDown.click(function(e){
					renderTo.find("[data-role='grid']").slideDown();
					btnSlideDown.hide();
					btnSlideUp.show();
				});	
								
				$(document).on("click","[data-table]", function(e){		
					var $this = $(this);		
					common.ui.ajax(
					"<@spring.url "/secure/data/stage/jdbc/schema/get.json?output=json" />",
					{
						data : { table : $this.data("table") },
						success : function(response){
							observable.set("name", response.name);
							observable.set("columns", response.columns);
							observable.set("columnCount", response.columns.length);
							observable.set("visible", true );				
							if( btnSlideDown.is(":visible") ){
								btnSlideDown.click();
							} 		
						}
					}); 		
				});		
		}
		
		function extractDatabaseSchema( renderTo, model ){		
			common.ui.ajax("<@spring.url "/secure/data/stage/jdbc/schema/list.json?output=json" />", {
				success : function(response){	
					if( response.status ){
						model.set("status", response.status );
						if( response.status === 2 ){
							model.set("connecting", false );						
							model.set("catalog", response.catalog );
							model.set("schema", response.schema );
							model.set("tables", response.tables );
							model.set("tableCount", response.tables.length );
						}else{
							setInterval(function () {
								extractDatabaseSchema(renderTo, model);
							}, 10000);				
						}					
					}
				}			
			});
		}
				
		function createDatabaseTablePanel(renderTo){						
			if( !common.ui.defined(renderTo.data("on")) || !renderTo.data("on") ){
				var observable = kendo.observable({
					catalog : "",
					schema : "",
					connecting : true,
					status : 0,
					tables : [],
					tableCount : 0,
					showDBTableList : function(e){
						$that = this;
						$this = $(e.target);
						$this.button("loading");		
						extractDatabaseSchema(renderTo, $that);	
					}
				});
				observable.bind("change", function(e){		
					var sender = e.sender ;				
					if( e.field === 'tables' && sender.tables.length > 0 ){
						var renderTarget = renderTo.find("table > tbody");
						renderTarget.html("");
						var template = kendo.template('<tr><td><i class="fa fa-table"></i> #: name #</td><td><button class="btn  btn-default btn-outline btn-flat btn-xs pull-right" data-table="#= name #">보기</button></td></tr>');
						$.each(sender.tables, function( index , value ){
							renderTarget.append(template({ "index" : index , "name" : value  }));
						});												
						renderTo.find("table").slideDown();	
						createTableDetailsPanel();				
					}
				});	
				common.ui.bind( renderTo, observable );
				renderTo.data("on", true);
			} 
		}

		
		function createSqlFileTreePanel(renderTo){
			if( !renderTo.data('kendoTreeView') ){		
				renderTo.kendoTreeView({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/sql/list.json?output=json" />', type: 'POST' }
						},
						schema: {					
							model: {
								id: "path",
								hasChildren: "directory"
							}
						},
						error: common.ui.handleAjaxError					
					},
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var filePlaceHolder = getSelectedSqlFile(renderTo);
						showSqlFileDetails(filePlaceHolder);
					}
				});			
			}
			$("#database-table-details").find("button.close[data-action='slideUp']").click();
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
					file : new common.ui.data.FileInfo(),
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
				common.ui.ajax(  
				"<@spring.url "/secure/data/mgmt/sql/get.json?output=json" />", 
				{					
					data : { path:  filePlaceHolder.path },
					success : function(response){
						ace.edit("xmleditor").setValue( response.fileContent );	
					}
				}); 
	    	}
	    	if (!$('#sql-details').is(":visible")) 
	    		$('#sql-details').fadeIn();	    		
		}												
		-->
		</script> 		 
		<style>
		#xmleditor.panel-body{
			min-height:500px;
		}	
		
		#content-wrapper section.layout {
		    border: 1px solid #e2e2e2;
		    background-color: #f6f6f6;		 
		    min-height: 662px;
		    height:100%;
		    width:100%;
		    position: relative;
		    border-radius: 4px;
		}
		
		#content-wrapper section.left {
			height:100%;
			float: left;
			border-right: solid 1px #e2e2e2;
			position: relative;
			width:400px;
		}
		#content-wrapper section.right {
			/*margin-left:400px; */
			height:100%;
			overflow:hidden;
			position:relative;
		}
		#content-wrapper section.left > .panel, #content-wrapper section.right > .panel{
			border-width:0;
			margin-bottom:0px;
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
					
				<section class="layout">
					<section class="left">
						<div class="panel panel-transparent">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-database"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="database-details-tabs" role="tablist">
									<li>
										<a href="#database-schema-view" data-toggle="tab">Schema</a>
									</li>
									<li>
										<a href="#database-datasource-view" data-toggle="tab">DataSource</a>
									</li>
									<li>
										<a href="#imp_and_exp-view" data-toggle="tab">Import & Export</a>
									</li>									
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->												
							<div class="tab-content">								
								<div class="tab-pane fade in" id="database-schema-view">
									<div id="database-schema-table-grid" class="no-border"></div>
								</div>
								<div class="tab-pane fade" id="database-datasource-view">
									<div id="database-datasource-grid" class="no-border"></div>
								</div><!-- ./tab-pane -->
								<div class="tab-pane fade" id="imp_and_exp-view">
									데이터 익스포트  <br>
									파일 형식 : Excel, Xml<br>
									대상 소스 : User<br>	
								</div><!-- ./tab-pane -->								
							</div><!-- /.tab-content -->
						</div>						
					</section>	
					<section class="right">
					
					</section>	
				</section>	
				<div class="list-and-detail">
					<div class="list-and-detail-nav p-xs">						
				
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
								data-columns="[ {'field':'primaryKey', 'title':'Primary Key'}, {'field':'name', 'title':'Column'}, {'field':'typeName' ,'title':'Type'}, {'field':'size' ,'title':'Size'}, {'field':'nullable' ,'title':'IS_NULLABLE'}]"  class="no-border" ></div>
							<div class="panel-footer">
								컬럼 : <span data-bind="text: columnCount">0</span> 
							</div>
						</div>	
						<div id="sql-details" class="panel panel-transparent" style="display:none;">
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
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>