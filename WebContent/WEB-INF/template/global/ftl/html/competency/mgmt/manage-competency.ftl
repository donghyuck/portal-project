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
			'<@spring.url "/js/common/common.ui.data.competency.js" />',
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
						getCompetencyGrid().dataSource.read();
					}
				});	
				createCompetencyGrid();									
				// END SCRIPT
			}
		}]);		

		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		function getCompetencyGrid(){
			var renderTo = $("#competency-grid");
			return common.ui.grid(renderTo);
		}		
		function createCompetencyGrid(){
			var renderTo = $("#competency-grid");
			if(! common.ui.exists(renderTo) ){
				
				var companySelector = getCompanySelector();		
				
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {companyId: companySelector.value() };
							}
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.competency.Competency
						}
					},
					columns: [
						{ title: "Name", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					height: 591,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	  
	                    	console.log(common.ui.stringify(selectedCell));
	                    }   
					},
					dataBound: function(e) {

					}
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){
					common.ui.grid(renderTo).addRow();					
				});		
							
			}
		}  
		
		function getCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");
			return common.ui.treelist(renderTo);
		}
		
		function createCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");			
			if( !renderTo.data('kendoTreeList') ){		
				var companySelector = getCompanySelector();		
				renderTo.kendoTreeList({
					height:"591",
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
						  	width: 200  
						}						
					],
					selectable: true,
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
						
						var selectedRows = this.select();
						var dataItem = this.dataItem(selectedRows[0]);
						createCodeSetPanel( dataItem );
					}
				});			
				
				renderTo.find("button[data-action=create]").click(function(e){
					getCodeSetTreeList.addRow();
					common.ui.treelist(renderTo).select("tr:eq(1)");
				});	
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.treelist(renderTo).dataSource.read();
				});	
			}
		}

		function createCodeSetPanel(source){
			var renderTo = $(".layout > .right > .panel:first");
			if( !renderTo.data('model') ){
				var observable =  common.ui.observable({
					codeset : new common.ui.data.CodeSet(),
					setSource : function(source){
						this.codeset.set('name', source.name );			
						this.codeset.set('description', source.description );				
					}				
				});				
				renderTo.data("model", observable);			
				common.ui.bind( renderTo, observable );	
			}			
			if( source ){
				renderTo.data("model").setSource( source ) ;	
			}
			if(renderTo.is(":hidden")){				
				renderTo.show();
			}	
		}

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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_2") />
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
						<div id="competency-grid" class="no-border"></div>
					</div>
				</section>									
				<section class="right">
					<div class="panel panel-default" data-bind="visible:visible" style="display:none;">
						<div class="panel-heading">
							<span data-bind="text:codeset.name"></span>
							<small data-bind="text:codeset.description" class="text-muted"></small>
						</div>	
						
					</div>
					
					
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
