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
						console.log( kendo.stringify( e ) );			
						getJobGrid().dataSource.read();
						getClassifiedMajoritySelector().dataSource.read({codeSetId:1});						
					}
				});	
				createJobGrid();									
				// END SCRIPT
			}
		}]);		

		function getClassifiedMajoritySelector(){
			var renderTo = $("#classified-majority-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					optionLabel: "대분류",
					autoBind:false,
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});				
				getClassifiedMiddleSelector();
				getClassifiedMinoritySelector();
			}
			return renderTo.data('kendoDropDownList');
		}


		function getClassifiedMiddleSelector(){
			var renderTo = $("#classified-middle-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-majority-dorpdown-list",
					optionLabel: "중분류",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}

		function getClassifiedMinoritySelector(){
			var renderTo = $("#classified-minority-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-middle-dorpdown-list",
					optionLabel: "소분류",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}
				
		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		
		function getJobGrid(){
			var renderTo = $("#job-grid");
			return common.ui.grid(renderTo);
		}	
			
		function createJobGrid(){
			var renderTo = $("#job-grid");
			if(! common.ui.exists(renderTo) ){				
				var companySelector = getCompanySelector();						
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/job/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								console.log( kendo.stringify(options) );
								return {
									companyId: companySelector.value(),
									classifiedMajorityId:getClassifiedMajoritySelector().value(),
									classifiedMiddleId:getClassifiedMiddleSelector().value(),
									classifiedMinorityId:getClassifiedMinoritySelector().value(), 
									startIndex:options.skip, 
									pageSize: options.pageSize 
								};
							}
						},						
						batch: false, 
						pageSize: 15,
						serverPaging: true,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.competency.Job
						}
					},
					columns: [
						{ title: "직무", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 직무 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
					pageable: { 
						refresh:true, 
						pageSizes:false,  
						buttonCount: 5,
						messages: { display: ' {1} / {2}' }  
					},		
					resizable: true,
					editable : false,					
					selectable : "row",
					scrollable: true,
					height: 600,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	  
	                    	createJobDetails(selectedCell);
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){		
					getJobGrid().clearSelection();			
					createJobDetails(new common.ui.data.competency.Job());				
				});		
							
			}
		}  
		
		function createJobDetails( source ) {
			var renderTo = $("#job-details");
			if( !renderTo.data("model")){		
				var  observable = kendo.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,					
					job: new common.ui.data.competency.Job(),
					classifiedMajorityDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  1 }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}),	
					classifiedMiddleDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}),		
					classifiedMinorityDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}),										
					view : function(e){
						var $this = this;		
						if($this.competency.competencyId < 1){
							renderTo.hide();	
						}
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
					
					
					
					
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.job);	
						if($this.job.get("jobId") == 0)
						{
							$this.job.set("objectType", 1);
							$this.job.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);	
							renderTo.find("input[name=job-name]").focus();
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);														
						}
					}						
				});
				renderTo.data("model", observable );
				kendo.bind(renderTo, observable );	
			}
			if( source ){
				renderTo.data("model").setSource( source );	
				if (!renderTo.is(":visible")) 
					renderTo.show();		
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
						if($this.competency.competencyId < 1){
							renderTo.hide();	
						}
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
									getJobGrid().dataSource.read();
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
		
		function getEssentialElementGrid(){
			var renderTo = $("#competency-details .essential-element");
			return common.ui.grid(renderTo);
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
							model: common.ui.data.competency.EssentialElement
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
					createEssentialElementModal(new common.ui.data.competency.EssentialElement());		
				});	
			}
		}
				
		function createEssentialElementModal(source){
			var parentRenderTo = $("#competency-details");
			var renderTo = $("#essential-element-edit-modal");
			if( !renderTo.data('bs.modal') ){
				var observable =  common.ui.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,	
					keepCreating : false,
					view : function(e){
						var $this = this;		
						if($this.essentialElement.essentialElementId < 1){
							renderTo.modal('hide');						
						}						
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
						$("#input-essential-element-name").focus();
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
							'<@spring.url "/secure/data/mgmt/competency/element/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.essentialElement ),
								contentType : "application/json",
								success : function(response){																	
									if( $this.keepCreating ){
										$this.setSource(new common.ui.data.competency.EssentialElement());	
									}else{
										$this.setSource(new common.ui.data.competency.EssentialElement(response));								
									}
									getEssentialElementGrid().dataSource.read({competencyId:$this.competency.competencyId});
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
								}
							}
						);							
						return false;
					},									
					competency : parentRenderTo.data("model").competency,
					essentialElement : new common.ui.data.competency.EssentialElement(),
					setSource: function(source){
						var $this = this;						
						//renderTo.find("form")[0].reset();		
						source.copy($this.essentialElement);					
						if($this.essentialElement.get("essentialElementId") == 0)
						{
							$this.essentialElement.set("competencyId", $this.competency.competencyId);
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);	
							$("#input-essential-element-name").focus();
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);							
						}
					}
				});				
				kendo.bind(renderTo, observable );
				renderTo.data("model", observable);	
			}				
			if( source ){
				renderTo.data("model").setSource( source );		
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
			width:600px;
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
			margin-left:600px;
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
		
		.no-shadow .k-pager-wrap {
			border-bottom-width : 0;
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
		}
		.modal-dialog .close  {
			position: absolute;
			top: 0;
			right: 10px;
			line-height: 50px;
			font-size: 40px;
			display: block;
			width: 50px;
			height: 50px;
			text-align: center;
			background: url(/images/common/grey-cross.png) no-repeat center;
			background-size: 25px;
			content: "";
			display: block;
			opacity: .5;
			z-index: 1047;
		}
		
		label.k-checkbox-label {
			display: inline;
			font-weight: normal;
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
							<div class="panel-heading">
								<input id="company-dropdown-list" />	
							</div>
							<div class="panel-body">
							 	<h5>직무분류</h5>
							 		<div class="m-b-xs">
							 			<input id="classified-majority-dorpdown-list" />
							 		</div>
							 		<div class="m-b-xs">
							 			<input id="classified-middle-dorpdown-list" />
							 		</div>
							 		<div class="m-b-xs">
							 			<input id="classified-minority-dorpdown-list" />
							 		</div>													
								<div id="job-grid" class="no-border no-shadow"></div>
							</div>
						</div>				
					</section>
					<section class="right">	
						<div id="job-details" class="panel panel-default" style="display:none;">
							<div class="panel-heading"><span class="panel-title" data-bind="{text: job.name, visible:visible}"></span>
								<input type="text" class="form-control input-sm" name="job-name" data-bind="{value: job.name, visible:editable }" placeholder="직무" />
							</div>					
							<div class="panel-body no-padding-b">	
								<h5>직무분류</h5>		
								<div class="m-b-sm">													
								<input id="job-details-classified-majority-dorpdown-list"
									data-role="dropdownlist"
				                  	data-auto-bind="true"
				                   	data-text-field="name"
				                   	data-value-field="codeSetId"
				                   	data-bind=" value: job.classification.classifiedMajorityId, source: classifiedMajorityDataSource }" />		
								<input id="job-details-classified-middle-dorpdown-list" 
									data-role="dropdownlist"
									data-auto-bind="false"
				                   	data-cascade-from="job-details-classified-majority-dorpdown-list"
				                   	data-text-field="name"
				                   	data-value-field="codeSetId"
				                   	data-bind=" value: job.classification.classifiedMiddleId, source: classifiedMiddleDataSource }" />	
								<input 
									data-role="dropdownlist"
									data-auto-bind="false"
				                   	data-cascade-from="job-details-classified-middle-dorpdown-list"
				                   	data-text-field="name"
				                   	data-value-field="codeSetId"
				                   	data-bind=" value: job.classification.classifiedMinorityId, source: classifiedMinorityDataSource }" />		
								</div>
								
								<p class="p-sm" data-bind="{text: job.description, visible:visible}"></p>								
								<textarea class="form-control" rows="4"  name="job-description"  data-bind="{value: job.description, visible:editable}" placeholder="직무 정의"></textarea>
								
								<div class="p-sm text-right">
									<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
									<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
									<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
									<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
								</div>
																				                   				                   						                   					
							</div>
						</div>
					</section>
				</section>
				
				
				<section class="layout">
				<section class="left">				
					
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
								<div class="p-sm">
									<table class="table table-striped">
											<thead>
												<tr>
													<th width="50%">직무 수준</th>
													<th>능력단위분류 코드(NCS코드)</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>
													<span data-bind="visible:visible"><span data-bind="text: competency.level"></span>수준</span>
													<select id="input-competency-level" class="form-control" data-bind="{value:competency.level, visible:editable}" placeholder="직무 수준">
														<option value="0" disabled selected>직무 수준 선택</option>
														<option value="1">1수준</option>
														<option value="2">2수준</option>
														<option value="3">3수준</option>
														<option value="4">4수준</option>
														<option value="5">5수준</option>
														<option value="6">6수준</option>
														<option value="7">7수준</option>
														<option value="8">8수준</option>
													</select>
													</td>
													<td>
													<span data-bind="{text: competency.properties.competencyUnitCode, visible:visible}"></span>
													<input type="text" class="form-control input-md" name="competency-unit-code" data-bind="{value: competency.properties.competencyUnitCode, visible:editable }" placeholder="능력단위분류번호" />
													</td>
												</tr>
											</tbody>
									</table>		
								</div>
								<div class="p-sm text-right">
									<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
									<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
									<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
									<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
								</div>
							</div>
						</form>
						<hr/>
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
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title"><span data-bind="text:competency.name"></span></h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">
						<form>
						<div class="row">
							<div class="col-sm-12">									
								<table class="table table-striped">
									<thead>
										<tr>
											<th width="50%">하위요소(능력단위요소)</th>
											<th width="50%">직무 수준</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<span data-bind="{text:essentialElement.name, visible:visible}"></span>
												<input type="text" class="form-control" id="input-essential-element-name" data-bind="{value:essentialElement.name, visible:editable}}" placeholder="하위요소(능력단위요소)">											
											</td>
											<td>
												<span data-bind="visible:visible"><span data-bind="text:essentialElement.level"></span>수준</span>
												<select id="input-essential-element-level" class="form-control" data-bind="{value:essentialElement.level, visible:editable}" placeholder="직무 수준">
													<option value="0" disabled selected>직무 수준 선택</option>
													<option value="1">1수준</option>
													<option value="2">2수준</option>
													<option value="3">3수준</option>
													<option value="4">4수준</option>
													<option value="5">5수준</option>
													<option value="6">6수준</option>
													<option value="7">7수준</option>
													<option value="8">8수준</option>
												</select>
											</td>
										</tr>	
									</tbody>				
								</table>
							</div>				
						</div>
						<div class="row" data-bind="invisible:deletable">
							<div class="col-sm-offset-6 col-sm-6">
								<input type="checkbox" id="input-essential-element-opt" class="k-checkbox" data-bind="checked: keepCreating" >
         						<label class="k-checkbox-label" for="input-essential-element-opt">이어서 하위요소(능력단위요소) 추가하기</label>
							</div>
						</div>
							<div class="p-sm text-right">
								<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
								<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
								<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
								<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat btn-outline" data-dismiss="modal">닫기</button>			
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
