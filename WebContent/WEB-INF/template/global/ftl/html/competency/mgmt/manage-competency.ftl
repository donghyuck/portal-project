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
						{ title: "역량/능력단위", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량/(능력단위) 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
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
	                    	openCompetencyEditor(selectedCell);
	                    }   
					},
					dataBound: function(e) {

					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){		
					getCompetencyGrid().clearSelection();			
					openCompetencyEditor(new common.ui.data.competency.Competency());				
				});		
							
			}
		}  
		
		function openCompetencyEditor(source){
			var renderTo = $("#competency-details");
			if( !renderTo.data("model")){									
				var  observable = kendo.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,					
					competency : new common.ui.data.competency.Competency(),
					view : function(e){
						var $this = this;		
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
						return false;
					},
					edit : function(e){
						var $this = this;					
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);
						renderTo.find("input[name=competency-name]").focus();
						return false;
					},
					delete : function(e){
						var $this = this;
						return false;
					},
					saveOrUpdate : function(e){
						var $this = this;
						var btn = $(e.target);	
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.competency ),
								contentType : "application/json",
								success : function(response){																											
									$this.setSource(new common.ui.data.competency.Competency(response));								
									getCompetencyGrid().dataSource.read();
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
								}
							}
						);	
						return false;
					},
					setSource : function(source){
						var $this = this;
						renderTo.find("form")[0].reset();
						source.copy($this.competency);	
						if($this.competency.get("competencyId") == 0)
						{
							$this.competency.set("objectType", 1);
							$this.competency.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);	
							renderTo.find("input[name=competency-name]").focus();
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);				
							common.ui.grid( renderTo.find(".essential-element") ).dataSource.read({competencyId:$this.competency.competencyId});			
							renderTo.find("ul.nav.nav-tabs a:first").tab('show')						
						}
					}		
				});
				renderTo.data("model", observable );
				kendo.bind(renderTo, observable );		
				createEssentialElementGrid(renderTo.find(".essential-element"));
			}			
			if( source ){
				renderTo.data("model").setSource( source );	
				if (!renderTo.is(":visible")) 
					renderTo.show();		
			}			
		}
		
		function createCompetencyDetailsTabs(renderTo){	
			renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("action") ){
					case "properties" :
					createCompetencyPropertiesGrid(renderTo.find(".properties"), renderTo.data("model").competency );
					break;
					case "elements" :
					createEssentialElementGrid(renderTo.find(".essential-element"), renderTo.data("model").competency );
					break;	
				}	
			});			
		}
		
		function createEssentialElementGrid( renderTo ){	
			if( ! renderTo.data("kendoGrid") ){
				common.ui.grid( renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/competency/element/list.json?output=json" />', type:'post' }
						},
						schema: {
							model: common.ui.data.competency.Competency
						}
					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 하위요소(능력단위 요소) 추가 </button>'),
					columns: [
						{ title: "속성", field: "name" },
						{ title: "레벨", field: "level", width: 100 }
					],
					resizable: true,
					editable : false,	
					selectable : "row",
					scrollable: true,					
					height: 400,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	  
	                    	createEssentialElementModal(selectedCell);
	                    } 					
					}
				});	
				
				renderTo.find("button[data-action=create]").click(function(e){		
					common.ui.grid( renderTo ).clearSelection();			
					common.ui.grid( renderTo ).addRow();		
				});	
			}
		}
				
		function createEssentialElementModal(source){
			var parentRenderTo = $("#competency-details");
			var renderTo = $("#essential-element-edit-modal");
			if( !renderTo.data('bs.modal') ){
				var observable =  common.ui.observable({
					competency : parentRenderTo.data("model").competency				
				});				
				kendo.bind(renderTo, observable );
				renderTo.data("model", observable);	
			}
			
			renderTo.modal('show');	
			
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
		    min-height: 663px;
		    height:100%;
		    width:100%;
		    position: static;
		    left:0px;
		    
		    border-radius: 4px;
		}
		
		#content-wrapper section.layout:after, #content-wrapper section.layout:before{
			clear:both;
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			box-sizing:border-box;
			display:table;
		} 
		
		section.left, section.right, section.bottom {
			display:block;
		}
		
		section.left:after, section.right:after, section.left:before, section.right:before,  {
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			box-sizing:border-box;		
		}
		
		#content-wrapper section.left {
			width:500px;
			position: absolute;
			height:auto;
			min-height: 100%;			
			border-right: solid 1px #e2e2e2;
		}
		
		.left.fixed {
			position: fixed!important;
			right : 0 ;
			top : 0;
		}
		
		#content-wrapper section.right {
			margin-left:500px;
			height:100%;			
		}
		
		#content-wrapper section.left > .panel, #content-wrapper section.right > .panel{
			border-width:0;
			margin-bottom:0px;
    	}
    	
		#content-wrapper section.bottom{
			padding: 10px 15px;
			background-color: #f5f5f5;
			border-top: 1px solid #ddd;
			border-bottom-right-radius: 3px;
			border-bottom-left-radius: 3px
		}
		
		.essential-element {
			border-top : 0;
			border-top-left-radius:0;
			border-top-right-radius:0;
		}
		.no-shadow{
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
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
						<div id="competency-grid" class="no-border no-shadow"></div>
					</div>
				</section>									
				<section class="right">		
					
					<div id="competency-details" class="panel panel-default" style="display:none;">
						<form>
						<div class="panel-heading"><span class="panel-title" data-bind="{text: competency.name, visible:visible}"></span>
							<input type="text" class="form-control input-sm" name="competency-name" data-bind="{value: competency.name, visible:editable }" placeholder="역량/능력단위" />
						</div>
						<div class="panel-body no-padding-b">	
							<p class="p-sm" data-bind="{text: competency.description, visible:visible}"></p>
							<textarea class="form-control" rows="4"  name="competency-description"  data-bind="{value: competency.description, visible:editable}" placeholder="역량/능력단위 정의"></textarea>
							
							<p class="help-block m-t-md text-danger">능력단위분류 코드(NCS 관련 코드)</p>
							<p class="p-sm" data-bind="{text: competency.properties.competencyUnitCode, visible:visible}"></p>
							<input type="text" class="form-control input-sm" name="competency-unit-code" data-bind="{value: competency.properties.competencyUnitCode, visible:editable }" placeholder="능력단위분류번호" />
							<div class="p-sm text-right">
								<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
								<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
								<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
								<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
							</div>
						</div>
						</form>
						<div class="panel-body no-padding-t" data-bind="{visible:deletable}">						
							<ul class="nav nav-tabs nav-tabs-xs">
								<li class="m-l-sm"><a href="#competency-details-tabs-0" data-toggle="tab" data-action="elements">하위요소/능력단위요소</a></li>
								<li><a href="#competency-details-tabs-2" data-toggle="tab" data-action="variable-range">적용범위 및 작업상황</a></li>
								<li><a href="#competency-details-tabs-3" data-toggle="tab" data-action="assessment-guide">평가지침</a></li>
								<li><a href="#competency-details-tabs-4" data-toggle="tab" data-action="key-competency">직업기초능력</a></li>
							</ul>							
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-0">
									<div class="essential-element" ></div>
								</div>
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-2">
								</div>
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-3">
								</div>	
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-4">
								</div>																
							</div>						
						</div>					
					</div>											
				</section><!-- / .right -->
				<section class="bottom"></div><!-- / .bottom -->				
				</section><!-- / .layout -->
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		
		<div id="essential-element-edit-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-view-form">	
					<div class="modal-header">
						<h2 class="modal-title"><span data-bind="text:competency.name"></span></h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">

					</div>
				</div>
			</div>
		</div>			
		
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
