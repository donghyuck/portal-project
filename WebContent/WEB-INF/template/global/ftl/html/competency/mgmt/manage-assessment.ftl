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
						getAssessmentPlanGrid().dataSource.read();
					}
				});
				
				createAssessmentPlanGrid();
			}
		}]);		


		function getAssessmentPlanGrid(){
			var renderTo = $("#assessment-grid");
			return common.ui.grid(renderTo);
		}
		

		function createAssessmentPlanGrid(){
			var renderTo = $("#assessment-grid");
			if(! common.ui.exists(renderTo) ){			
				
				var companySelector = getCompanySelector();					
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/competency/assessment/plan/list.json?output=json"/>', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									objectType: 1,
									objectId: companySelector.value()
								};
							}
						},
						schema: {
							model: common.ui.data.competency.AssessmentPlan
						}
					},
					columns: [
						{ title: "역량진단", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량진단계획 추가 </button><button class="btn btn-flat btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 새로고침 </button></div>'),
					resizable: true,
					editable : false,					
					selectable : "row",
					scrollable: true,
					height: 400,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	 
	                    	createAssessmentPlanDetails(selectedCell);
	                    	//e.preventDefault();
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){	
					var newPlan = new common.ui.data.competency.AssessmentCreatePlan();
					newPlan.set("objectType", 1);
					newPlan.set("objectId",companySelector.value());
					createAssessmenPlanModal(newPlan);			
				});					
			}
		}		

		function createAssessmentPlanDetails(source){
			var renderTo = $("#assessment-details");
			if( !renderTo.data("model")){		
				
				$('#multiple-apply-allowed-switcher').switcher({ on_state_content:"", off_state_content: ""});
				$('#feedback-enabled-switcher').switcher({ on_state_content:"", off_state_content: ""});				
				var EMPTY_JOB_SELECTION = new common.ui.data.competency.JobSelection();
				var observable =  common.ui.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,		
					multipleApplyAllowed: false,		
					feedbackEnabled:false,
					assessment : new common.ui.data.competency.AssessmentPlan(),
					jobSelection: new common.ui.data.competency.JobSelection(),
					view : function(e){
						var $this = this;		
						if($this.assessment.assessmentId < 1){
							$("#rating-scheme-details").hide();	
						}
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
					},
					edit : function(e){
						var $this = this;
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);
						return false;
					},
					ratingSchemeDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/assessment/rating-scheme/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { objectType:1, objectId:getCompanySelector().value() }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.RatingScheme
						},
						error:common.ui.handleAjaxError
					}),	
					onRatingSchemeChange: function(e){			
						var $this = this;
					},
					addSubject:function(e){
						var $this = this;
						var companyDropdown = $("#job-details-company-list").data('kendoDropDownList');
						var newSubject = new common.ui.data.competency.AssessmentSubject();
						newSubject.set("objectType", 70);
						newSubject.set("objectId", $this.assessment.get("assessmentId"));
						newSubject.set("subjectObjectType", 1);
						newSubject.set("subjectObjectId", companyDropdown.value());
						newSubject.set("subjectObjectName", companyDropdown.text());
						common.ui.grid($('#assessment-details-tabs-2 .k-grid')).dataSource.add(newSubject) ;
						companyDropdown.refresh();
						return false;
					},
					cancelChanges:function(e){
						common.ui.grid( $($(e.target).data("target")) ).cancelChanges();
						return false; 
					},
					addJobSelection:function(e){
						var $this = this;										
						var newJobSelection = new common.ui.data.competency.JobSelection();
						$this.jobSelection.copy(newJobSelection);						
						EMPTY_JOB_SELECTION.copy($this.jobSelection);								
						newJobSelection.set("objectType", 70);
						newJobSelection.set("objectId", $this.assessment.get("assessmentId"));												
						if(newJobSelection.classifyType > 0 ){
							newJobSelection.set("classifyTypeName", $this.classifyTypeDataSource.get(newJobSelection.classifyType).name);
						}
						if(newJobSelection.classifiedMajorityId > 0 ){
							newJobSelection.set("classifiedMajorityName", $this.classifiedMajorityDataSource.get(newJobSelection.classifiedMajorityId).name);
						}
						if(newJobSelection.classifiedMiddleId > 0 ){
							newJobSelection.set("classifiedMiddleName", $this.classifiedMiddleDataSource.get(newJobSelection.classifiedMiddleId).name);
						}
						if(newJobSelection.classifiedMinorityId > 0 ){
							newJobSelection.set("classifiedMinorityName", $this.classifiedMinorityDataSource.get(newJobSelection.classifiedMinorityId).name);
						}																								
						common.ui.grid($('#assessment-details-tabs-1 .k-grid')).dataSource.add(newJobSelection) ;
						return false;
					},
					onStartChange:function(){
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");
						var startDate = start.value(),
                        endDate = end.value();
                        if (startDate) {
                            startDate = new Date(startDate);
                            startDate.setDate(startDate.getDate());
                            end.min(startDate);
                        } else if (endDate) {
                            start.max(new Date(endDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }
					},
					onEndChange:function(){
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");	
						var endDate = end.value(),
                        startDate = start.value();

                        if (endDate) {
                            endDate = new Date(endDate);
                            endDate.setDate(endDate.getDate());
                            start.max(endDate);
                        } else if (startDate) {
                            end.min(new Date(startDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }			
					},					
					saveOrUpdate : function(e){
						var $this = this;						
						var btn = $(e.target);	
						this.assessment.set("multipleApplyAllowed", $this.multipleApplyAllowed );						
						this.assessment.set("feedbackEnabled", $this.feedbackEnabled );
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/assessment/plan/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.assessment ),
								contentType : "application/json",
								success : function(response){																	
									$this.setSource(new common.ui.data.competency.AssessmentPlan(response));	
									getAssessmentPlanGrid().dataSource.read();
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
								}
							}
						);							
						return false;
					},					
					classifyTypeDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/codeset/group/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { objectType:1, objectId:getCompanySelector().value(), name:"JOB_CLASSIFY_SYSTEM" }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),
					classifiedMajorityDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/codeset/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),	
					classifiedMiddleDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/codeset/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),		
					classifiedMinorityDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/codeset/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),						
					jobSelectionDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.competency.JobSelection
                        }
					}),
					propertyDataSource :new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					subjectDataSource :new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.competency.AssessmentSubject
                        }
					}),
					companyDataSource:getCompanySelector().dataSource,
					setSource: function(source){
						var $this = this;
						source.copy($this.assessment);							
						$this.propertyDataSource.read();				
						$this.propertyDataSource.data($this.assessment.properties);	
						$this.jobSelectionDataSource.read();	
						$this.jobSelectionDataSource.data($this.assessment.jobSelections);
						$this.subjectDataSource.read();				
						$this.subjectDataSource.data($this.assessment.subjects);	
						EMPTY_JOB_SELECTION.copy($this.jobSelection);	
						
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
						$this.set("deletable", true);							
												
						if($this.assessment.multipleApplyAllowed){
							$('#multiple-apply-allowed-switcher').switcher('on');
						}else{
							$('#multiple-apply-allowed-switcher').switcher('off');
						}		
										
						if($this.assessment.feedbackEnabled){
							$('#feedback-enabled-switcher').switcher('on');
						}else{
							$('#feedback-enabled-switcher').switcher('off');
						}				
						
						renderTo.find("[name=state][value=" + $this.assessment.state + "]").click();		
						
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");		
						start.max(end.value());
                   	 	end.min(start.value());
                   	 	
						renderTo.find("ul.nav.nav-tabs a:first").tab('show');
					}
				});					
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );	
			}			
			if( source ){
				renderTo.data("model").setSource( source );	
				if (!renderTo.is(":visible")) 
					renderTo.show();		
			}
		}
				
		function createAssessmenPlanModal(source){
			var parentRenderTo = $("#assessment-details");
			var renderTo = $("#assessment-plan-modal");			
			if( !renderTo.data('bs.modal') ){
			
				var validator = renderTo.find("form").kendoValidator().data("kendoValidator")
			
				var observable =  common.ui.observable({
					createPlan:new common.ui.data.competency.AssessmentCreatePlan(),
					assessmentSchemeDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '<@spring.url "/secure/data/mgmt/competency/assessment/scheme/list.json?output=json"/>',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { objectType:1, objectId:getCompanySelector().value() }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.AssessmentScheme
						},
						error:common.ui.handleAjaxError
					}),
					onStartChange:function(){
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");
						 var startDate = start.value(),
                        endDate = end.value();
                        if (startDate) {
                            startDate = new Date(startDate);
                            startDate.setDate(startDate.getDate());
                            end.min(startDate);
                        } else if (endDate) {
                            start.max(new Date(endDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }
					},
					onEndChange:function(){
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");	
						var endDate = end.value(),
                        startDate = start.value();

                        if (endDate) {
                            endDate = new Date(endDate);
                            endDate.setDate(endDate.getDate());
                            start.max(endDate);
                        } else if (startDate) {
                            end.min(new Date(startDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }			
					},
					saveOrUpdate : function(e){
						var $this = this;
						var btn = $(e.target);	
						if(validator.validate()){						
							common.ui.progress(renderTo, true);
							common.ui.ajax(
								'<@spring.url "/secure/data/mgmt/competency/assessment/plan/create.json?output=json" />' , 
								{
									data : kendo.stringify($this.createPlan),
									contentType : "application/json",
									success : function(response){																											
										createAssessmentDetails(new common.ui.data.competency.Assessment(response));								
										getAssessmentGrid().dataSource.read();
									},
									complete : function(e){
										common.ui.progress(renderTo, false);
									}
								}
							);	
						}
						return false;						
					},	
					setSource: function(source){
						var $this = this;			
						var start = renderTo.find('input[data-role=datetimepicker][name=startDate]').data("kendoDateTimePicker");
						var end = renderTo.find('input[data-role=datetimepicker][name=endDate]').data("kendoDateTimePicker");		
						source.copy($this.createPlan);
						start.max(end.value());
                   	 	end.min(start.value());
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
		
		
		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}				
		</script> 		 
		<style>
		
		.no-shadow{
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
		}
		
		input.k-checkbox+label {
		    font-weight: 100;
		    color: #555;
		    line-height: .875em;
    	}
    	
		.fieldlist {
            margin: 0 0 -1em;
            padding: 0;
        }
        .fieldlist li {
            list-style: none;
            padding-bottom: 1em;
        }			
        
        .switcher-lg {
        	width:45px;
        }
        
	 	div[disabled=disabled] > .switcher {
	 		pointer-events : none;
		    cursor: not-allowed !important;
		    opacity: .5 !important;
		    filter: alpha(opacity = 50);
		}       
		
		span.k-widget.k-tooltip-validation {
			display: block;
    		margin-top: 5px;
            text-align: left;
                    border: 0;
                    padding: 0;
                    background: none;
                    box-shadow: none;
                    color: red;
                    font-size : 12px;
        }

        .k-tooltip-validation .k-warning {
        	display: none;
        }
                
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >
			<div id="content-wrapper">
			
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_5") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>	
						
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				<div class="row animated fadeInRight">
	                <div class="col-md-4">  
	                	<div class="panel panel-transparent">							
							<div class="panel-body no-padding">
								<input id="company-dropdown-list" />
								<hr/>
							</div>
						</div>
						<div id="assessment-grid" class="no-shadow"></div>	
	                </div><!-- /.col-md-4 -->   
                	<div class="col-md-8">
                		<div id="assessment-details" class="panel animated fadeInRight" data-bind="attr: { data-editable: editable }" style="display:none; border-width:3px;" >
							<div class="panel-body">
								<div class="form-group">	
									<h4  data-bind="{text: assessment.name, visible:visible}"></h4>
									<input type="text" class="form-control input-md" name="assessment-name" data-bind="{value: assessment.name, visible:editable }" placeholder="이름" />
								</div>
								<div class="form-group">				
									<span data-bind="{text: assessment.description, visible:visible}"></span>
									<textarea class="form-control" rows="4"  name="assessment-description"  data-bind="{value: assessment.description, visible:editable}" placeholder="설명"></textarea>
								</div>
								
								<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">상태</h6>
								<span class="badge badge-success rounded" data-bind="text:assessment.state, visible:visible"></span>
								<div class="btn-group btn-sm" data-toggle="buttons" data-bind="visible:editable">
								  <label class="btn btn-primary">
								    <input type="radio" name="state" value="NONE" autocomplete="off" data-bind="checked: assessment.state">NONE
								  </label>
								  <label class="btn btn-primary">
								    <input type="radio" name="state" value="INCOMPLETE" autocomplete="off" data-bind="checked: assessment.state">INCOMPLETE
								  </label>
								  <label class="btn btn-primary">
								    <input type="radio" name="state" value="PUBLISHED"  autocomplete="off" data-bind="checked: assessment.state">PUBLISHED
								  </label>
								  <label class="btn btn-primary">
								    <input type="radio" name="state" value="DELETED"  autocomplete="off" data-bind="checked: assessment.state">DELETED
								  </label>
								</div>

								<div class="form-group">
									<div class="row">
										<div class="col-sm-6">
											<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">진단 시작일</h6>
											<span data-bind="text: assessment.formattedStartDate, visible:visible"></span>
											<input name="startDate" data-role="datetimepicker" data-bind="value: assessment.startDate, visible:editable, events: { change: onStartChange }" >
										</div>
										<div class="col-sm-6">
											<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">진단 종료일</h6>
											<span data-bind="text: assessment.formattedEndDate, visible:visible"></span>
											<input name="endDate" data-role="datetimepicker" data-bind="value: assessment.endDate, visible:editable, events: { change: onEndChange }" >
										</div>
									</div>
								</div>								
								<table class="table">							
													<tbody>
														<tr>
															<td width="150" class="text-muted">진단척도</td>
															<td>
															<span data-bind="visible:visible, text:assessment.ratingScheme.name"></span>
															<input id="rating-scheme-dorpdown-list"
															data-option-label="선택"
															data-role="dropdownlist"
										                  	data-auto-bind="true"
										                  	data-value-primitive="true"
										                   	data-text-field="name"
										                   	data-value-field="ratingSchemeId"
										                   	data-bind="value:assessment.ratingScheme.ratingSchemeId, source: ratingSchemeDataSource, visible:editable,events:{change: onRatingSchemeChange}" />
															</td>
														</tr>
														<tr>
															<td class="text-muted">중복진단허용</td>
															<td class="no-padding-b">
																<div data-bind="enabled:editable">
																	<input id="multiple-apply-allowed-switcher" type="checkbox" 
																	data-class="switcher-primary switcher-lg" 
																	data-bind="checked:multipleApplyAllowed"/>
																</div>
																<p data-bind="visible:visible" class="text-xs text-muted">
																	<span data-bind="visible:multipleApplyAllowed">중복진단을 허용합니다.</span>
																	<span data-bind="invisible:multipleApplyAllowed">중복진단을 허용하지 않습니다.</span>
																</p>
															</td>
														</tr>
														<tr>
															<td class="text-muted">360도 피드벡</td>
															<td class="no-padding-b">
																<div data-bind="enabled:editable">
																	<input id="feedback-enabled-switcher" type="checkbox" 
																	data-class="switcher-primary switcher-lg" 
																	data-bind="checked:feedbackEnabled"/>
																</div>
																<p data-bind="visible:visible" class="text-xs text-muted">
																	<span data-bind="visible:feedbackEnabled">360도 피드백을 활성화 합니다.</span>
																	<span data-bind="invisible:feedbackEnabled">360도 피드백을 비활성화 합니다.</span>
																</p>
															</td>
														</tr>
																												
														<tr data-bind="visible:feedbackEnabled" style="display:none;">
															<td class="text-muted">역량진단방법</td>
															<td>															
																<table class="table table-condensed">
																	<thead>
																		<tr>
																			<th width="90">방향</th>
																			<th>가중치</th>
																			<th>최대인원</th>
																		</tr>
																	</thead>
																	<tbody>
																		<tr>
																			<td>자신</td>
																			<td>
																			<input data-role="numerictextbox"
															                   data-format="p0"
															                   data-min="0.01"
															                   data-max="1"
															                   data-step="0.1"
															                   data-bind="enabled:editable"
															                   style="width: 180px">
																			</td>
																			<td><input data-role="numerictextbox" type="number" value="30" min="0" max="100" step="1" style="width: 180px" /></td>
																		</tr>
																		<tr>
																			<td>동료</td>
																			<td>
																			<input data-role="numerictextbox"
															                   data-format="p0"
															                   data-min="0.01"
															                   data-max="1"
															                   data-step="0.1"
															                   data-bind="enabled:editable"
															                   style="width: 180px">	
																			</td>
																			<td><input data-role="numerictextbox" type="number" value="1" min="0" max="100" step="1" style="width: 180px"/></td>
																		</tr>
																		<tr>
																			<td>부하</td>
																			<td>
																			<input data-role="numerictextbox"
															                   data-format="p0"
															                   data-min="0.01"
															                   data-max="1"
															                   data-step="0.1"
															                   data-bind="enabled:editable"
															                   style="width: 180px">	
																			</td>
																			<td><input data-role="numerictextbox" type="number" value="1" min="0" max="100" step="1" style="width: 180px"/></td>
																		</tr>
																		<tr>
																			<td>상사</td>
																			<td>
																			<input data-role="numerictextbox"
															                   data-format="p0"
															                   data-min="0.01"
															                   data-max="1"
															                   data-step="0.1"
															                   data-bind="enabled:editable"
															                   style="width: 180px">
																			</td>
																			<td><input data-role="numerictextbox" type="number" value="1" min="0" max="100" step="1" style="width: 180px"/></td>
																		</tr>
																	</tbody>
																</table>															
															</td>
														</tr>	
														<tr>
															<td class="text-muted">역량진단방법</td>
															<td>
															
															<ul class="fieldlist">
													            <li>
													              	<input type="checkbox" id="assessment-methods-1" class="k-checkbox" checked="checked">
													          		<label class="k-checkbox-label" for="assessment-methods-1">인지능력테스트</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-2" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-2">직무지식테스트</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-3" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-3">PERSONALITY TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-4" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-4">BIOGRAPHICAL DATA</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-5" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-5">INTEGRITY TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-6" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-6">STRUCTURED INTERVIEWS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-7" class="k-checkbox" disabled="disabled">
													          		<label class="k-checkbox-label" for="assessment-methods-7">PHYSICAL FITNESS TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-8" class="k-checkbox" disabled="disabled">
													          		<label class="k-checkbox-label" for="assessment-methods-8">PHYSICAL ABILITY TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-9" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-9">SITUATIONAL JUDGMENT TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-10" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-10">WORK SAMPLE TESTS</label>
													            </li>
													            <li>
													              	<input type="checkbox" id="assessment-methods-11" class="k-checkbox">
													          		<label class="k-checkbox-label" for="assessment-methods-11">ASSESSMENT CENTERS</label>
													            </li>
													        </ul>
															</td>
														</tr>													
													</tbody>
								</table>            	
                    		</div><!-- /.panel-body -->    
                    		<div class="panel-body no-padding">
											<ul id="assessment-details-tabs" class="nav nav-tabs">
												<li class="m-l-sm">
													<a href="#assessment-details-tabs-1" data-toggle="tab">직무</a>
												</li>
												<li class="">
													<a href="#assessment-details-tabs-2" data-toggle="tab">대상자</a>
												</li>
												<li class="">
													<a href="#assessment-details-tabs-3" data-toggle="tab">속성</a>
												</li>												
											</ul>
											<div class="tab-content no-padding">
												
												<div class="tab-pane fade" id="assessment-details-tabs-1" style="min-height:300px;">
													<table class="table table-striped" data-bind="visible:visible">
														<thead>
															<tr>
																<th width="20%">분류체계</th>
																<th width="20%">대분류</th>
																<th width="20%">중분류</th>
																<th width="20%">소분류</th>
																<th width="20%">직무</th>
															</tr>
														</thead>
														<tbody  class="no-border"
																data-role="listview"
												                data-template="job-selection-view-template"
												                data-bind="source:jobSelectionDataSource"
												                style="height: 300px; overflow: auto">
												            
												        </tbody>
													</table>																											
													<div class="panel no-border-hr no-border-radius no-margin-b" data-bind="visible:editable">
														<div class="panel-body">
															<div class="row">
																<div class="col-sm-3">
																	<input id="job-details-classify-type-dorpdown-list"
																			data-option-label="분류체계"
																			data-role="dropdownlist"
														                  	data-auto-bind="true"
														                   	data-text-field="name"
														                   	data-value-field="codeSetId"
														                   	data-bind="{value: jobSelection.classifyType, source: classifyTypeDataSource , visible:editable}"
														                   	style="width:100%" />
																</div>
																<div class="col-sm-3">
																	<input id="job-details-classified-majority-dorpdown-list"
																	data-option-label="대분류"
																	data-role="dropdownlist"
												                  	data-auto-bind="false"
												                  	data-cascade-from="job-details-classify-type-dorpdown-list"
												                   	data-text-field="name"
												                   	data-value-field="codeSetId"
												                   	data-bind="{value: jobSelection.classifiedMajorityId, source: classifiedMajorityDataSource , visible:editable}" 
												                   	style="width:100%"/>
																</div>
																<div class="col-sm-3">
																	<input id="job-details-classified-middle-dorpdown-list" 
																	data-option-label="중분류"
																	data-role="dropdownlist"
																	data-auto-bind="false"
												                   	data-cascade-from="job-details-classified-majority-dorpdown-list"
												                   	data-text-field="name"
												                   	data-value-field="codeSetId"
												                   	data-bind="{value: jobSelection.classifiedMiddleId, source: classifiedMiddleDataSource, visible:editable }" 
												                   	style="width:100%"/>
																</div>
																<div class="col-sm-3">
																	<input 
																	data-role="dropdownlist"
																	data-option-label="소분류"
																	data-auto-bind="false"
												                   	data-cascade-from="job-details-classified-middle-dorpdown-list"
												                   	data-text-field="name"
												                   	data-value-field="codeSetId"
												                   	data-bind="{value: jobSelection.classifiedMinorityId, source: classifiedMinorityDataSource, visible:editable }" 
												                   	style="width:100%"/>	
																</div>																																																									
															</div>
														</div>
														<div class="panel-footer">
															<button class="btn btn-flat btn-labeled btn-outline btn-danger" data-bind="click:addJobSelection"><span class="btn-label icon fa fa-plus"></span> 진단 직무 추가 </button>
															<button class="btn btn-flat btn-outline btn-info pull-right" data-bind="click:cancelChanges" 
																data-target="#assessment-details-tabs-2 .k-grid"> 변경취소 </button>									
														</div>
													</div>												
													<div data-role="grid"
														class="no-border"
													    data-scrollable="true"
													    data-editable="true"
													    data-columns="[{ 'field': 'classifyTypeName', 'title':'분류체계'},{ 'field': 'classifiedMajorityName', 'title':'대분류' },{ 'field': 'classifiedMiddleName', 'title':'중분류' },{ 'field': 'classifiedMinorityName', 'title':'소분류' },{ 'field': 'jobName', 'title':'직무' },{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
													    data-bind="source:jobSelectionDataSource, visible:editable"
													    style="height: 300px"></div>
													    												
												</div> <!-- / .tab-pane -->
												
												
												<div class="tab-pane fade" id="assessment-details-tabs-2" style="min-height:300px;">	
													<table class="table table-striped" data-bind="visible:visible">
														<thead>
															<tr>
																<th width="270">대상</th>
															</tr>
														</thead>
														<tbody  class="no-border"
																data-role="listview"
												                data-template="subject-view-template"
												                data-bind="source:subjectDataSource"
												                style="height: 300px; overflow: auto">
												            
												        </tbody>
													</table>
													<div class="panel no-border-hr no-border-radius no-margin-b" data-bind="visible:editable">
														<div class="panel-body">
															<input id="job-details-company-list"
																data-option-label="회사"
																data-role="dropdownlist"
																data-auto-bind="true"
																data-text-field="displayName"
																data-value-field="companyId"
														    	data-bind="{source:companyDataSource, visible:editable}"
																style="width:100%" />
															
														</div>
														<div class="panel-footer">	
															<button class="btn btn-flat btn-labeled btn-outline btn-danger" data-bind="click:addSubject"><span class="btn-label icon fa fa-plus"></span> 진단대상 추가 </button>
															<button class="btn btn-flat btn-outline btn-info pull-right" data-bind="click:cancelChanges"
																data-target="#assessment-details-tabs-2 .k-grid" > 변경취소 </button>	
														</div>
													</div>	
													<div 
														data-role="grid"
														class="no-border"
													    data-scrollable="true"
													    data-editable="true"
													    data-columns="[{ 'field': 'subjectObjectName', 'title':'이름'},{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
													    data-bind="source:subjectDataSource, visible:editable"
													    style="height: 300px"></div>
												
												</div> <!-- / .tab-pane -->
												
												<div class="tab-pane fade active in" id="assessment-details-tabs-3" style="min-height:300px;">		
													<table class="table table-striped" data-bind="visible:visible">
														<thead>
															<tr>
																<th width="270">이름</th>
																<th>값</th>
															</tr>
														</thead>
														<tbody  class="no-border"
																data-role="listview"
												                data-template="property-view-template"
												                data-bind="source:propertyDataSource"
												                style="height: 300px; overflow: auto">
												            
												        </tbody>
													</table>																											
													<div data-role="grid"
														class="no-border"
													    data-scrollable="true"
													    data-editable="true"
													    data-toolbar="['create', 'cancel']"
													    data-columns="[{ 'field': 'name', 'width': 270 , 'title':'이름'},{ 'field': 'value', 'title':'값' },{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
													    data-bind="source:propertyDataSource, visible:editable"
													    style="height: 300px"></div>
												</div> <!-- / .tab-pane -->							
											</div> <!-- / .tab-content -->
											                    		
                    		</div>
                    		<div class="panel-footer">
	 								<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
									<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
									<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
									<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>	                   		
                    		</div>
                		</div><!-- /.panel -->  
                	 </div><!-- /.col-md-8 -->                   	 
                 </div><!-- /.row -->   
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->	
		
		<div id="assessment-plan-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-md">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title">역량진단계획</h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">
						<form>
						<div class="form-group">
							<input type="text" name="Name" class="form-control" data-bind="{value: createPlan.name }" placeholder="이름" required validationMessage="역량진단 이름을 입력하여 주세요." />	
							<span class="k-invalid-msg" data-for="Name"></span>
						</div>
						<div class="form-group">
							<textarea name="Desceiption"
								class="form-control m-t-sm" rows="4"  
								data-bind="{value: createPlan.description }" 
								placeholder="설명" 
								required validationMessage="어떤 역량진단인지를 간략하게 기술하여 주세요."></textarea>
							<span class="k-invalid-msg" data-for="Description"></span>	
						</div>	
						<div class="form-group">	
							<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">역량진단운영체계</h6>
							<input id="input-assessment-scheme-dorpdown-list"
									name="Scheme"
											data-option-label="선택"
											data-role="dropdownlist"
										    data-auto-bind="true"
										    data-value-primitive="true"
										    data-text-field="name"
										    data-value-field="assessmentSchemeId"
										    data-bind="value:createPlan.assessmentSchemeId, source: assessmentSchemeDataSource"
										    required data-required-msg="역량진단운영체계를 선택하여 주십시오."
										     />
							<span class="k-invalid-msg" data-for="Scheme"></span>			     
						</div>
						<div class="form-group">	
							<div class="row">
								<div class="col-sm-6">
									<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">시작일</h6>
									<input name="startDate" data-role="datetimepicker"
						                   data-bind="value: createPlan.startDate,
						                              events: { change: onStartChange }"
						                              required data-required-msg="진단 시작일을 선택하여 주십시오."
						                   style="width: 100%">
						            <span class="k-invalid-msg" data-for="startDate"></span>		       
								</div>
								<div class="col-sm-6">
									<h6 class="text-primary text-semibold text-xs" style="margin: 15px 0 5px 0;">종료일</h6>
									<input name="endDate" data-role="datetimepicker"
						                   data-bind="value: createPlan.endDate,
						                              events: { change: onEndChange }"
						                              required data-required-msg="진단 종료일을 선택하여 주십시오."
						                   style="width: 100%">
						            <span class="k-invalid-msg" data-for="endDate"></span>		       
								</div>
							</div>	
						</div>
						<form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary btn-flat btn-outline" data-bind="click:saveOrUpdate" >확인</button>		
						<button type="button" class="btn btn-default btn-flat btn-outline" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>	
		</div>					


		<script type="text/x-kendo-tmpl" id="subject-view-template">
		<tr>
			<td>#: subjectObjectName #</td>
		</tr>	
		</script>	
		<script type="text/x-kendo-tmpl" id="job-selection-view-template">
		<tr>
			<td>#: classifyTypeName #</td>
			<td>#if(classifiedMajorityName == null){# 전체 #}else{# #: classifiedMajorityName # #}#</td>
			<td>#if(classifiedMiddleName == null){# 전체 #}else{# #: classifiedMiddleName # #}#</td>
			<td>#if(classifiedMinorityName == null){# 전체 #}else{# #: classifiedMinorityName # #}#</td>
			<td>#if(jobName == null){# 전체 #}else{# 전체 #: jobName # #}#</td>
		</tr>	
		</script>				
		<script type="text/x-kendo-tmpl" id="rating-level-view-template">
		<tr>
			<td>#: score #</td>
			<td>#: title #</td>
		</tr>		
		</script>
		<script type="text/x-kendo-tmpl" id="property-view-template">
		<tr>
			<td>#: name #</td>
			<td>#: value #</td>
		</tr>	
		</script>											
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>
