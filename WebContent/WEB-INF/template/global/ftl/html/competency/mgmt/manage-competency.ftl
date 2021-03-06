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
					
						var data = { objectType:1, objectId:e.data.companyId, name:"JOB_CLASSIFY_SYSTEM" };
						getClassifyTypeSelector().dataSource.read(data);	
														
						//getCompetencyGrid().dataSource.read();
						//getClassifiedMajoritySelector().dataSource.read({codeSetId:1});
						getCompetencyGroupSelector().dataSource.read({codeSetId:321});
						getCompetencyTypeSelector();		
						//getCompetencyGroupSelector();						
					}
				});	
				createCompetencyGrid();									
				// END SCRIPT
			}
		}]);		

		/**
		 * Competency dorpdown list creater 
		 */
		function getCompetencyGroupSelector(){
			var renderTo = $("#competency-group-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					optionLabel: "역량군 선택",
					autoBind:false,
					dataTextField: 'name',	
					dataValueField: 'code',
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
			}
			return renderTo.data('kendoDropDownList');
		}
		
		function getClassifyTypeSelector(){
			var renderTo = $("#classify-system-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					optionLabel: "직무분류체계",
					autoBind:false,
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/group/list.json?output=json',
								type: 'POST'
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});				
				getClassifiedMajoritySelector();
			}
			return renderTo.data('kendoDropDownList');
		}
		
		function getClassifiedMajoritySelector(){
			var renderTo = $("#classified-majority-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classify-system-dorpdown-list",
					optionLabel: "대분류",
					/*autoBind:false,*/
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
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
					}				
				});				
				getClassifiedMiddleSelector();
				getClassifiedMinoritySelector();
				getJobSelector();
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
		
		function getJobSelector(){
			var renderTo = $("#job-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-minority-dorpdown-list",
					optionLabel: "직무",
					dataTextField: 'name',	
					dataValueField: 'jobId',
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/job/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { 							
									companyId: getCompanySelector().value(),
									classifiedMajorityId:getClassifiedMajoritySelector().value(),
									classifiedMiddleId:getClassifiedMiddleSelector().value(),
									classifiedMinorityId:getClassifiedMinoritySelector().value(), 	
								}; 
							}
						},
						schema: { 
							data: "items",							
							model : common.ui.data.competency.Job
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}		
		
		function getCompetencyTypeSelector(){
			var renderTo = $("#competency-type-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					optionLabel: "역량유형",
					dataTextField: 'text',	
					dataValueField: 'value',
					dataSource: [
						{ text: "NONE", value: "0" },
                        { text: "직업기초능력", value: "5" }
					]			
				});
			}
			return renderTo.data('kendoDropDownList');
		}		
		
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
								return {
									companyId: companySelector.value(), 
									classifyType:getClassifyTypeSelector().value(),
									classifiedMajorityId:getClassifiedMajoritySelector().value(),
									classifiedMiddleId:getClassifiedMiddleSelector().value(),
									classifiedMinorityId:getClassifiedMinoritySelector().value(), 	
									competencyType : getCompetencyTypeSelector().value(),		
									competencyGroupCode : getCompetencyGroupSelector().value(),
									jobId: getJobSelector().value(), 							
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
							model: common.ui.data.competency.Competency
						}
					},
					columns: [
						{ title: "역량/능력단위", field: "name", filterable:false}, { title: "수준", field: "level", width: 80, filterable: { multi: true } }
					],
					toolbar: kendo.template('<div class="p-xxs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량/(능력단위) 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-success pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 검색</button></div>'),
					pageable: { refresh:true, pageSizes:false,  buttonCount: 2, messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : false,
					filterable: true,
					selectable : "row",
					scrollable: true,
					height: 500,
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
					hasJob: false,			
					competency : new common.ui.data.competency.Competency(),
					competencyGroupDataSource: new kendo.data.DataSource({
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" : 321 }; 
							}
						},
						schema: { 
							model:{
								id:'code',
								fields : {
									'code' : {type:"string", defaultValue:null },
									'name' : {type:"string", defaultValue:null }								
								}
							}
						},
						error:common.ui.handleAjaxError
					}),
					view : function(e){
						var $this = this;		
						if($this.competency.competencyId < 1){
							renderTo.hide();	
						}
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
						if($this.competency.get("competencyId") > 0){
							$this.set("deletable", true);
						}else{
							$this.set("deletable", false);
						}		
						$('#competency-details-competency-group-dorpdown-list').data('kendoDropDownList').enable(false);
						return false;
					},
					edit : function(e){
						var $this = this;					
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);							
						if($this.competency.get("competencyId") > 0){
							$this.set("deletable", true);
						}else{
							$this.set("deletable", false);
						}
						$('#competency-details-competency-group-dorpdown-list').data('kendoDropDownList').enable();
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
						
						var newJob = new common.ui.data.competency.Competency();
						$this.competency.copy( newJob );
						newJob.set("job", null);
						
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/update.json?output=json" />' , 
							{
								data : kendo.stringify( newJob),
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
						source.copy($this.competency);	
						console.debug(common.ui.stringify( $this.competency ));
						if( $this.competency.job.jobId > 0 )
							$this.set("hasJob", true);
						else
							$this.set("hasJob", false);
							
						if($this.competency.get("competencyId") == 0)
						{
							$this.competency.set("objectType", 1);
							$this.competency.set("objectId", getCompanySelector().value() );
							$this.edit();
							
						}else{
							$this.view();
							common.ui.grid( renderTo.find(".essential-element") ).dataSource.read({competencyId:$this.competency.competencyId});								
							renderTo.find("ul.nav.nav-tabs a:first").tab('show');																		
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
		
		function getSelectedEssentialElement(){
			var selectedCells = getEssentialElementGrid().select();	
			if( selectedCells.length == 1){
	           	var selectedCell = getEssentialElementGrid().dataItem( selectedCells );	 
	           	console.log(kendo.stringify(selectedCell) ); 
	           	return selectedCell;
	        }  			
	        return new common.ui.data.competency.EssentialElement();
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
					toolbar: kendo.template('<div class="p-xxs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 하위요소(능력단위 요소) 추가 </button>'),
					columns: [
						{ title: "하위요소(능력단위요소)", field: "name" },
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
		
		function getPerformanceCriteriaGrid(){
			var renderTo = $("#performance-criteria-grid");
			return common.ui.grid(renderTo);
		}

		function getActivityGrid(){
			var renderTo = $("#ability-grid");
			return common.ui.grid(renderTo);
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
					hasJob: false,	
					hasNext : false,
					hasPrevious : false,
					next:function(){
						var that = this;						
						var nextEl = getEssentialElementGrid().select().next();
						getEssentialElementGrid().select(nextEl);
						return false;				
					},
					previous:function(){
						var that = this;						
						var prevEl = getEssentialElementGrid().select().prev();
						getEssentialElementGrid().select(prevEl);
						return false;					
					},					
					abilityDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/competency/ability/list.json?output=json" />', type:'post' },
							update: { url:'<@spring.url "/secure/data/mgmt/competency/ability/batch/update.json?output=json" />', type:'post', contentType : "application/json" },
							create: { url:'<@spring.url "/secure/data/mgmt/competency/ability/batch/update.json?output=json" />', type:'post', contentType : "application/json" },
							destroy: { url:'<@spring.url "/secure/data/mgmt/competency/ability/batch/remove.json?output=json" />', type:'post', contentType : "application/json" },
							parameterMap: function(options, operation) {								
			                    if (operation !== "read" && options.models) {			                    
			                    	$.each(options.models, function(index, model){
			                    		model.objectType = 54;
			                    		model.objectId = renderTo.data("model").essentialElement.essentialElementId;
			                    	});			                    
			                   		return kendo.stringify(options.models) ;
			                    }else{
			                    	return {objectType:54, objectId: renderTo.data("model").essentialElement.essentialElementId};
			                    }
			                }
						},
						sort:{ field: "abilityType", dir: "asc" },
						batch: true,
						schema: {
							model: common.ui.data.competency.Ability
						}
					}),
					performanceCriteriaDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/competency/performance-criteria/list.json?output=json" />', type:'post' },
							update: { url:'<@spring.url "/secure/data/mgmt/competency/performance-criteria/batch/update.json?output=json" />', type:'post', contentType : "application/json" },
							create: { url:'<@spring.url "/secure/data/mgmt/competency/performance-criteria/batch/update.json?output=json" />', type:'post', contentType : "application/json" },
							destroy: { url:'<@spring.url "/secure/data/mgmt/competency/performance-criteria/batch/remove.json?output=json" />', type:'post', contentType : "application/json" },
							parameterMap: function(options, operation) {								
			                    if (operation !== "read" && options.models) {			                    
			                    	$.each(options.models, function(index, model){
			                    		model.objectType = 54;
			                    		model.objectId = renderTo.data("model").essentialElement.essentialElementId;
			                    	});			                    
			                   		return kendo.stringify(options.models) ;
			                    }else{
			                    	return {objectType:54, objectId: renderTo.data("model").essentialElement.essentialElementId};
			                    }
			                }
						},
						batch: true,
						schema: {
							model: common.ui.data.competency.PerformanceCriteria
						}
					}),
					edit : function(e){
						var $this = this;					
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);
						$("#input-essential-element-name").focus();
						
						$this.set('hasPrevious', false );
						$this.set('hasNext', false );
							
						return false;
					},
					view : function(e){
						var $this = this;		
						if($this.essentialElement.essentialElementId < 1){
							renderTo.modal('hide');						
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);						
							var prevEl = getEssentialElementGrid().select().prev();
							var nextEl = getEssentialElementGrid().select().next();
							$this.set('hasPrevious', (prevEl.length == 1) );
							$this.set('hasNext', (nextEl.length == 1) );
						}						
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
						source.copy($this.essentialElement);					
						if($this.essentialElement.get("essentialElementId") == 0)
						{										
							$this.essentialElement.set("competencyId", $this.competency.competencyId);
							//$this.set("visible", false);
							//$this.set("editable", true);
							//$this.set("updatable", true);
							$this.set("deletable", false);	
							$this.edit();				
							//$("#input-essential-element-name").focus();
						}else{
							//$this.set("visible", true);
							//$this.set("editable", false);
							//$this.set("updatable", false);
							$this.set("deletable", true);
							$this.view();
							renderTo.find("ul.nav.nav-tabs a:last").tab('show');	
							observable.abilityDataSource.read();	
							observable.performanceCriteriaDataSource.read();
						}							
						if( $this.competency.job.jobId > 0 )
							$this.set("hasJob", true);
						else
							$this.set("hasJob", false);
					}
				});				
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );
			}				
			if( source ){
				renderTo.data("model").setSource( source );		
			}	
			renderTo.modal('show');		
		}		
		
		function getAbilityTypeTitle(item){
			//console.log( kendo.stringify( item ) );
			//console.log( $.type( item ) ) ;
			if( item == 'KNOWLEDGE' )
				return '지식';
			else if (item == 'SKILL') 
				return '기술';			
			else if (item == 'ATTITUDE')
				return '태도';
			else 
				return '기타';
		}
		
		function abilityTypeDropDownEditor(container, options) {
            $('<input required data-text-field="text" data-value-field="value" data-bind="value:' + options.field + '"/>')
            .appendTo(container)
            .kendoDropDownList({
            	optionLabel: "선택" ,
                dataSource: [
		            { text: "지식", value: "KNOWLEDGE" },
		            { text: "기술", value: "SKILL" },
		            { text: "태도", value: "ATTITUDE" }
		        ]});
        }
                			
		</script> 		 
		<style>
							
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
		
		.k-grid .k-edit-cell {
		    padding: .3em .3em;
		}
		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >
			<div id="content-wrapper">
			
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_3") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				<div class="row animated fadeInRight">
	                <div class="col-md-5"> 
						<div class="panel panel-transparent">
							<div class="panel-body no-padding">
								<input id="company-dropdown-list" />
								<hr/>
								<div class="row">
									<div class="col-xs-6">
										<h5 class="text-info text-semibold text-xs ">역량군</h5>
									 	<div class="m-b-xs">
											<input id="competency-group-dorpdown-list" style="width:100%"/>
										</div>	
									</div>
									<div class="col-xs-6">
										<h5 class="text-info text-semibold text-xs ">역량유형</h5>
									 	<div class="m-b-xs">
											<input id="competency-type-dorpdown-list" style="width:100%" />
										</div>	
									</div>
								</div>
								<div class="row">									
								 	<div class="col-xs-6">
									 	
									 	<h5 class="text-primary text-semibold text-xs">직무분류</h5>
									 	<div class="m-b-xs">
											<input id="classify-system-dorpdown-list" style="width:100%"/>
										</div>
										<div class="m-b-xs">
											<input id="classified-majority-dorpdown-list" style="width:100%" />
										</div>
										<div class="m-b-xs">
											<input id="classified-middle-dorpdown-list" style="width:100%"/>
										</div>
										<div class="m-b-xs">
											<input id="classified-minority-dorpdown-list" style="width:100%"/>
										</div>							 	
								 	</div>			
								 	<div class="col-xs-6">
									 	<h5 class="text-primary text-semibold text-xs">직무</h5>
									 	<div class="m-b-xs">
											<input id="job-dorpdown-list" style="width:100%"/>
										</div>
									</div>						
								</div>						
							</div>
							<div id="competency-grid" class="no-shadow"></div>
						</div>	                
	                </div><!-- /.col-md-4 -->   
                	<div class="col-md-7">
					<div id="competency-details" class="panel panel-default" style="display:none;">
						<form>
							<div class="panel-heading">
								<strong><span class="panel-title" data-bind="{text: competency.name, visible:visible}"></span></strong>
								<input type="text" class="form-control" name="competency-name" data-bind="{value: competency.name, visible:editable }" placeholder="역량/능력단위" />
							</div>
							<div class="panel-body no-padding-b">	
								<p class="p-sm" data-bind="{text: competency.description, visible:visible}"></p>								
								<textarea class="form-control" rows="4"  name="competency-description"  data-bind="{value: competency.description, visible:editable}" placeholder="역량/능력단위 정의"></textarea>
								<div class="p-sm no-padding-hr">
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
													<span data-bind="{text: competency.competencyUnitCode, visible:visible}"></span>
													<input type="text" class="form-control input-md" name="competency-unit-code" data-bind="{value: competency.competencyUnitCode, visible:editable }" placeholder="능력단위분류번호" />
													</td>
												</tr>
											</tbody>
									</table>		
								</div>
																
								<h6 class="text-light-gray text-semibold text-xs" style="margin: 15px 0 5px 0;">역량군</h6>
								<input id="competency-details-competency-group-dorpdown-list"
										data-option-label="없음"
										data-role="dropdownlist"
										data-value-primitive="true"
										data-text-field="name"
										data-value-field="code"
										data-bind="value:competency.competencyGroupCode, source: competencyGroupDataSource"	>										
								<div class="p-sm no-padding-hr" data-bind="visible:hasJob">
									<h6 class="text-light-gray text-semibold text-xs" style="margin: 10px 0 5px 0;">직무분류</h6>
									<table class="table table-striped">
											<thead>
												<tr>
													<th width="25%">대분류</th>
													<th width="25%">중분류</th>
													<th width="25%">소분류</th>
													<th width="25%">직무</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-bind="text: competency.job.classification.classifiedMajorityName" ></span></td>
													<td><span data-bind="text: competency.job.classification.classifiedMiddleName" ></span></td>
													<td><span data-bind="text: competency.job.classification.classifiedMinorityName" ></span></td>
													<td class="text-primary"><span data-bind="text: competency.job.name"></span></td>
												</tr>
											</tbody>
										</table>	
								</div> 	
								<div class="p-sm text-right">
									<div class="btn-group">
										<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
										<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
										<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
										<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
									</div>
								</div>
							</div>
						</form>
						<hr/>
						<div class="panel-body no-padding-t" data-bind="{visible:deletable}">						
							<ul class="nav nav-tabs nav-tabs-sm">
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
								준비중입니다.
								</div>
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-3">
								준비중입니다.
								</div>	
								<div role="tabpanel" class="tab-pane fade" id="competency-details-tabs-4">
								준비중입니다.
								</div>																
							</div>						
						</div>					
					</div>	                	
                	</div><!-- /.col-md-8 --> 
                </div>	
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

						<button title="Previous (Left arrow key)" type="button" class="previous" style="top:75px;" data-bind="{visible: hasPrevious, click:previous}"></button>					
						<button title="Next (Right arrow key)" type="button" class="next"  style="top:75px;" data-bind="{visible: hasNext, click:next}"></button>	
							
						<form>
						<div class="row">
							<div class="col-sm-12">		
							
								<h4 class="text-primary" data-bind="{text: essentialElement.name, visible:visible}"></h4>
								<input type="text" class="form-control" name="input-essential-element-name" data-bind="{value: essentialElement.name, visible:editable }" placeholder="하위요소(능력단위요소)" />							
							
								<p class="p-sm" data-bind="{text: essentialElement.description, visible:visible}"></p>								
								<textarea class="form-control m-t-sm" rows="4"  name="input-essential-element-description"  data-bind="{value: essentialElement.description, visible:editable}" placeholder="하위요소(능력단위요소) 정의"></textarea>
								
														
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
												<span data-bind="visible:visible"><span data-bind="text:essentialElement.level"></span> 수준</span>
												<select id="input-essential-element-level" class="form-control" data-bind="{value:essentialElement.level, visible:editable}" placeholder="직무 수준">
													<option value="0" disabled selected>직무 수준 선택</option>
													<option value="1">1 수준</option>
													<option value="2">2 수준</option>
													<option value="3">3 수준</option>
													<option value="4">4 수준</option>
													<option value="5">5 수준</option>
													<option value="6">6 수준</option>
													<option value="7">7 수준</option>
													<option value="8">8 수준</option>
												</select>
											</td>
										</tr>	
									</tbody>				
								</table>
							</div>				
						</div>
						
						<div class="p-sm no-padding-hr" data-bind="visible:hasJob">
							<table class="table table-striped">
								<thead>
												<tr>
													<th width="25%">대분류</th>
													<th width="25%">중분류</th>
													<th width="25%">소분류</th>
													<th width="25%">직무</th>
												</tr>
								</thead>
								<tbody>
												<tr>
													<td><span data-bind="text: competency.job.classification.classifiedMajorityName" ></span></td>
													<td><span data-bind="text: competency.job.classification.classifiedMiddleName" ></span></td>
													<td><span data-bind="text: competency.job.classification.classifiedMinorityName" ></span></td>
													<td class="text-primary"><span data-bind="text: competency.job.name"></span></td>
												</tr>
								</tbody>
							</table>	
						</div> 
						<div class="row">
							<div class="col-sm-6">
								<div data-bind="invisible:deletable">
									<input type="checkbox" id="input-essential-element-opt" class="k-checkbox" data-bind="checked: keepCreating" >
		         					<label class="k-checkbox-label" for="input-essential-element-opt">이어서 하위요소(능력단위요소) 추가하기</label>
								</div>							
							</div>
							<div class="col-sm-6">
								<div class="p-sm text-right">
									<div class="btn-group">
										<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
										<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
										<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
										<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
									</div>
								</div>							
							</div>
						</div>
						</form>
					</div>
					<div class="modal-body no-padding">
						<ul class="nav nav-tabs nav-tabs-sm">
							<li class="m-l-sm"><a href="#essential-element-details-tabs-0" data-toggle="tab" data-action="performance-criteria">행동지표(수행준거)</a></li>
							<li><a href="#essential-element-details-tabs-1" data-toggle="tab" data-action="ability">KAS</a></li>
						</ul>							
						<div class="tab-content no-padding">
							<div role="tabpanel" class="tab-pane fade" id="essential-element-details-tabs-0">
								<div id="performance-criteria-grid" class="no-border no-shadow no-rounded" 
										data-role="grid"
										data-autoBind="false"
										data-scrollable="true"
						                data-editable="true"					              
						                data-toolbar="
						                	<div class='p-xxs'>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-danger k-grid-add'><span class='btn-label icon fa fa-plus'></span> 행동지표 추가 </button>
						                		<div class='pull-right'>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-success k-grid-save-changes'><span class='btn-label icon fa fa-floppy-o'></span> 변경사항 저장</button>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-default k-grid-cancel-changes'><span class='btn-label icon fa fa-undo'></span> 변경사항 취소</button>
						                		</div>
						                	</div>	
						                "
						                data-columns="[{ 'field': 'sortOrder', 'title': '순번', 'width': 100  },
											{ 'field': 'description', 'title': '행동지표(수행준거)'},
											{ 'command': 'destroy', title: '&nbsp;', width: 100 }]"		
										data-bind="source:performanceCriteriaDataSource"
										style="height:300px;">
								</div>
							</div>							
							<div role="tabpanel" class="tab-pane fade" id="essential-element-details-tabs-1">
								<div id="ability-grid" class="no-border no-shadow no-rounded" 
										data-role="grid"
										data-auto-bind="false"
										data-autoBind="false"
										data-scrollable="true"
						                data-editable="true"		
						                data-toolbar="
						                	<div class='p-xxs'>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-danger k-grid-add'><span class='btn-label icon fa fa-plus'></span>능력 추가 </button>
						                		<div class='pull-right'>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-success k-grid-save-changes'><span class='btn-label icon fa fa-floppy-o'></span> 변경사항 저장</button>
						                		<button class='btn btn-flat btn-labeled btn-outline btn-default k-grid-cancel-changes'><span class='btn-label icon fa fa-undo'></span> 변경사항 취소</button>
						                		</div>
						                	</div>	
						                "
						                data-columns="[
						                	{ 'field': 'abilityType', 'title': '구분', width: '100px', 'editor':abilityTypeDropDownEditor, template:'#= getAbilityTypeTitle(abilityType)  #'},
											{ 'field': 'name', 'title': 'KSA'},
											{ 'command': 'destroy', title: '&nbsp;', width: 100 }]"		
										data-bind="source:abilityDataSource"
										style="min-height:300px;">
							</div>															
						</div>	
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat btn-outline" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>
		</div>											
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>
