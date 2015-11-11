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
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js" />',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js" />',			
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.data.admin.js" />',
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
						//e.data.copy(targetCompany);
						
						getCodeSetTreeList().dataSource.read();
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
				
				
				createCodeSetTreeList();	
				
				

var dataSource = new kendo.data.TreeListDataSource({
                        data: [
                          { id: 1, Name: "Daryl Sweeney", Position: "CEO", Phone: "(555) 924-9726", parentId: null },
                          { id: 2, Name: "Guy Wooten", Position: "Chief Technical Officer", Phone: "(438) 738-4935", parentId: 1 },
                          { id: 32, Name: "Buffy Weber", Position: "VP, Engineering", Phone: "(699) 838-6121", parentId: 2 },
                          { id: 11, Name: "Hyacinth Hood", Position: "Team Lead", Phone: "(889) 345-2438", parentId: 32 },
                          { id: 60, Name: "Akeem Carr", Position: "Junior Software Developer", Phone: "(738) 136-2814", parentId: 11 },
                          { id: 78, Name: "Rinah Simon", Position: "Software Developer", Phone: "(285) 912-5271", parentId: 11 },
                          { id: 42, Name: "Gage Daniels", Position: "Software Architect", Phone: "(107) 290-6260", parentId: 32 },
                          { id: 43, Name: "Constance Vazquez", Position: "Director, Engineering", Phone: "(800) 301-1978", parentId: 32 },
                          { id: 46, Name: "Darrel Solis", Position: "Team Lead", Phone: "(327) 977-0216", parentId: 43 },
                          { id: 47, Name: "Brian Yang", Position: "Senior Software Developer", Phone: "(565) 146-5435", parentId: 46 },
                          { id: 50, Name: "Lillian Bradshaw", Position: "Software Developer", Phone: "(323) 509-3479", parentId: 46 },
                          { id: 51, Name: "Christian Palmer", Position: "Technical Lead", Phone: "(490) 421-8718", parentId: 46 },
                          { id: 55, Name: "Summer Mosley", Position: "QA Engineer", Phone: "(784) 962-2301", parentId: 46 },
                          { id: 56, Name: "Barry Ayers", Position: "Software Developer", Phone: "(452) 373-9227", parentId: null },
                          { id: 59, Name: "Keiko Espinoza", Position: "Junior QA Engineer", Phone: "(226) 600-5305", parentId: 46 },
                          { id: 61, Name: "Candace Pickett", Position: "Support Officer", Phone: "(120) 117-7475", parentId: null },
                          { id: 63, Name: "Mia Caldwell", Position: "Team Lead", Phone: "(848) 636-6470", parentId: 43 },
                          { id: 65, Name: "Thomas Terry", Position: "Senior Enterprise Support Officer", Phone: "(764) 831-4248", parentId: 63 },
                          { id: 67, Name: "Ruth Downs", Position: "Senior Software Developer", Phone: "(138) 991-1440", parentId: 63 },
                          { id: 70, Name: "Yasir Wilder", Position: "Senior QA Enginner", Phone: "(759) 701-8665", parentId: 63 },
                          { id: 71, Name: "Flavia Short", Position: "Support Officer", Phone: "(370) 133-9238", parentId: 63 },
                          { id: 74, Name: "Aaron Roach", Position: "Junior Software Developer", Phone: "(958) 717-9230", parentId: 63 },
                          { id: 75, Name: "Eric Russell", Position: "Software Developer", Phone: "(516) 575-8505", parentId: 63 },
                          { id: 76, Name: "Cheyenne Olson", Position: "Software Developer", Phone: "(241) 645-0257", parentId: 63 },
                          { id: 77, Name: "Shaine Avila", Position: "UI Designer", Phone: "(844) 435-1360", parentId: 63 },
                          { id: 81, Name: "Chantale Long", Position: "Senior QA Enginner", Phone: "(252) 419-6891", parentId: 63 },
                          { id: 83, Name: "Dane Cruz", Position: "Junior Software Developer", Phone: "(946) 701-6165", parentId: 63 },
                          { id: 84, Name: "Regan Patterson", Position: "Technical Writer", Phone: "(265) 946-1765", parentId: 63 },
                          { id: 85, Name: "Drew Mckay", Position: "Senior Software Developer", Phone: "(327) 293-0162", parentId: 63 },
                          { id: 88, Name: "Bevis Miller", Position: "Senior Software Developer", Phone: "(525) 557-0169", parentId: 63 },
                          { id: 89, Name: "Bruce Mccarty", Position: "Support Officer", Phone: "(936) 777-8730", parentId: 63 },
                          { id: 90, Name: "Ocean Blair", Position: "Team Lead", Phone: "(343) 586-6614", parentId: 43 },
                          { id: 91, Name: "Guinevere Osborn", Position: "Software Developer", Phone: "(424) 741-0006", parentId: 90 },
                          { id: 92, Name: "Olga Strong", Position: "Graphic Designer", Phone: "(949) 417-1168", parentId: 90 },
                          { id: 93, Name: "Robert Orr", Position: "Support Officer", Phone: "(977) 341-3721", parentId: 90 },
                          { id: 95, Name: "Odette Sears", Position: "Senior Software Developer", Phone: "(264) 818-6576", parentId: 90 },
                          { id: 45, Name: "Zelda Medina", Position: "QA Architect", Phone: "(563) 359-6023", parentId: 32 },
                          { id: 3, Name: "Priscilla Frank", Position: "Chief Product Officer", Phone: "(217) 280-5300", parentId: 1 },
                          { id: 4, Name: "Ursula Holmes", Position: "EVP, Product Strategy", Phone: "(370) 983-8796", parentId: 3 },
                          { id: 24, Name: "Melvin Carrillo", Position: "Director, Developer Relations", Phone: "(344) 496-9555", parentId: 3 },
                          { id: 29, Name: "Martha Chavez", Position: "Developer Advocate", Phone: "(140) 772-7509", parentId: 24 },
                          { id: 30, Name: "Oren Fox", Position: "Developer Advocate", Phone: "(714) 284-2408", parentId: 24 },
                          { id: 41, Name: "Amos Barr", Position: "Developer Advocate", Phone: "(996) 587-8405", parentId: 24 }
                        ],

                        schema: {
                            model: {
                                id: "id",
                                expanded: true
                            }
                        }
                    });

                    $("#treelist").kendoTreeList({
                        dataSource: dataSource,
                        height: 540,
                        columns: [
                            { field: "Position" },
                            { field: "Name" },
                            { field: "Phone" }
                        ]
                    });
                    

				
				// END SCRIPT
			}
		}]);		

		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		
		function getCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");
			return renderTo.data('kendoTreeList');
		}
		
		function createCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");			
			if( !renderTo.data('kendoTreeList') ){		
				var companySelector = getCompanySelector();		
				renderTo.kendoTreeList({
					height:"100%",
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/codeset/list.json?output=json" />', type: 'POST'},
							create: { url:'<@spring.url "/secure/data/mgmt/codeset/update.json?output=json" />', type: 'POST', contentType : "application/json" },
							parameterMap: function (options, operation){
								console.log( operation +  " : "+ common.ui.stringify(options) );
								if (operation !== "read") {
									if( operation == "create" ){
										options.objectType = 1 ;
										options.objectId = getCompanySelector().value();
									}
									return kendo.stringify(options);
								} 
								return {companyId: getCompanySelector().value() };
							}
						},
						schema: {
							model:{
								id:'codeSetId',
								expanded: true,
								parentId: 'parentCodeSetId',
							    fields: {
							    	codeSetId: { type: "number"},
							    	parentCodeSetId : { field:"parentCodeSetId", nullable:true },
							    	objectType : { type: "number"},
							    	objectId : { type: "number"},
							    	description:  { type: "string" },
							    	name : { type: "string" },	        
							    	modifiedDate: { type: "date"},
							        creationDate: { type: "date" },
							    	enabled : {type: "boolean" }
							    }	
							}
						},				
						error: common.ui.handleAjaxError					
					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 코드그룹 추가 </button><button class="btn btn-flat btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'">새로고침</button></div>'),
					columns : [
						{field:'name', title:"코드"},
						{field:'description', title:"설명"},
						{ 
							command: [
								{ name: "edit", className: "btn btn-flat", imageClass:false },
								{ name: "createchild", className: "btn btn-flat", imageClass:false }
							], 
						  	width: 180  
						}						
					],
					messages:{
						commands:{
							edit : "변경",
							update : "저장",
							createchild : "추가",
							destory: "삭제",
							canceledit: "취소"						
						}
					},
					editable:true,
					change: function(e) {
					
					}
				});			
				
				renderTo.find("button[data-action=create]").click(function(e){
					common.ui.treelist(renderTo).addRow();
					common.ui.treelist(renderTo).select("tr:eq(1)");
				});	
				
				renderTo.slimScroll({
	                height: 620,
	                railOpacity: 0.9
            	});
			}
		}


		function createSqlFileTreePanel(renderTo){
			if( !renderTo.data('kendoTreeView') ){		
				renderTo.kendoTreeView({
					height:"100%",
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
					filter :{ field:"name", operator:"eq", value:".svn"},
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var filePlaceHolder = getSelectedSqlFile(renderTo);
						showSqlFileDetails(filePlaceHolder);
					}
				});			
				renderTo.slimScroll({
	                height: 620,
	                railOpacity: 0.9
            	});
			}
			$("#database-table-details").find("button.close[data-action='slideUp']").click();
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
			min-height:338px;
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
			width:500px;
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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_7_3") />
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
					<div class="panel-body"><input id="company-dropdown-list" /></div>
					<div id="codeset-treelist" class="no-border" />
				</div>	
				
						<div class="panel panel-transparent">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-code"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="database-details-tabs" role="tablist">
									<!--<li>
										<a href="#database-table-tree-view" data-toggle="tab">테이블</a>
									</li>-->
									<li>
										<a href="#sql-tree-view" data-toggle="tab">SQL</a>
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
						</div>	

				</section>
									
				<section class="right">
				<div id="treelist"></div>
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
						<div id="sql-details" class="panel no-border" style="display:none;">
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
				</section>
				</section>
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
