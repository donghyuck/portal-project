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
				
				/*
				$('#database-details-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#database-table-tree-view" :
							break;
						case  '#sql-tree-view' :
							createSqlFileTreePanel($(show_bs_tab.attr('href')));
							break;
					}	
				});
				
				$('#database-details-tabs a:first').tab('show');
				*/		
				// END SCRIPT
			}
		}]);		

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
						renderTarget.slideDown();	
						createTableDetailsPanel();				
					}
				});	
				common.ui.bind( renderTo, observable );
				renderTo.data("on", true);
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
			min-height:577px;
		}	
		
		.k-treeview {
			min-height:600px;
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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3_1") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray no-margin-b" style="no-margin-bo">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	

				<div style="height:auto;min-height:100%; border-right: solid 1px #e2e2e2; position:fixed;width:400px;">
					fdsaf
				</div>
									
				<div style="margin-left:400px; min-height:400px;">
				fdsafsad
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