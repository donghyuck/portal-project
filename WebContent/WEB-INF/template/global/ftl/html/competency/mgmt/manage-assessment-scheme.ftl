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

			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
					
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
						getAssessmentSchemeGrid().dataSource.read();
					}
				});					
				createAssessmentSchemeGrid();
			}
		}]);		
		
		function getAssessmentSchemeGrid(){
			var renderTo = $("#assessment-scheme-grid");
			return common.ui.grid(renderTo);
		}
		
		function createAssessmentSchemeGrid(){
			var renderTo = $("#assessment-scheme-grid");
			if(! common.ui.exists(renderTo) ){				
				var companySelector = getCompanySelector();						
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/assessment-scheme/list.json?output=json', type:'post' },
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
							model: common.ui.data.competency.AssessmentScheme
						}
					},
					columns: [
						{ title: "역량진단체계", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량진단체계 추가 </button><button class="btn btn-flat btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 새로고침 </button></div>'),
					resizable: true,
					editable : false,					
					selectable : "row",
					scrollable: true,
					height: 400,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	 
	                    	createAssessmentSchemeDetails(selectedCell);
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){	
					createAssessmentSchemeDetails(new common.ui.data.competency.AssessmentScheme());			
				});		
							
			}					
		}
		
		function createAssessmentSchemeDetails(source){
			var renderTo = $("#assessment-scheme-details");
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
					assessmentScheme: new common.ui.data.competency.AssessmentScheme(),
					jobSelection: new common.ui.data.competency.JobSelection(),
					create : function(e){
						console.log("create..");
						var $this = this;
						$this.setSource(new common.ui.data.competency.AssessmentScheme());
						return false;
					},					
					view : function(e){
						var $this = this;		
						if($this.assessmentScheme.assessmentSchemeId < 1){
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
								url: '/secure/data/mgmt/competency/assessment/rating-scheme/list.json?output=json',
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
					addJobSelection:function(e){
						
						
						console.log(common.ui.stringify($this.jobSelection));
						
						common.ui.grid($('#assessment-scheme-details-tabs-1 .k-grid')).addRow($this.jobSelection) ;
						return false;
					},
					saveOrUpdate : function(e){
						var $this = this;						
						var btn = $(e.target);	
						this.assessmentScheme.get("multipleApplyAllowed", $this.multipleApplyAllowed );						
						this.assessmentScheme.get("feedbackEnabled", $this.feedbackEnabled );
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/assessment-scheme/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.assessmentScheme ),
								contentType : "application/json",
								success : function(response){																	
									$this.setSource(new common.ui.data.competency.AssessmentScheme(response));	
									getAssessmentSchemeGrid().dataSource.read();
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
								url: '/secure/data/mgmt/competency/codeset/group/list.json?output=json',
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
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
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
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
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
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
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
					setSource: function(source){
						var $this = this;
						source.copy($this.assessmentScheme);	
						$this.propertyDataSource.read();				
						$this.propertyDataSource.data($this.assessmentScheme.properties);	
						$this.jobSelectionDataSource.read();	
						$this.jobSelectionDataSource.data($this.assessmentScheme.jobSelections);	
						EMPTY_JOB_SELECTION.copy($this.jobSelection);
						if($this.assessmentScheme.get("assessmentSchemeId") == 0)
						{
							$this.assessmentScheme.set("objectType", 1);
							$this.assessmentScheme.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);						
						}						
						if($this.assessmentScheme.multipleApplyAllowed){
							$('#multiple-apply-allowed-switcher').switcher('on');
						}else{
							$('#multiple-apply-allowed-switcher').switcher('off');
						}		
										
						if($this.assessmentScheme.feedbackEnabled){
							$('#feedback-enabled-switcher').switcher('on');
						}else{
							$('#feedback-enabled-switcher').switcher('off');
						}						
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
        
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >
			<div id="content-wrapper">
			
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_4_2") />
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
							<div id="assessment-scheme-grid" class="no-shadow"></div>	
						</div>
	                </div><!-- /.col-md-4 -->   
                	<div class="col-md-8">
                		<div id="assessment-scheme-details" class="panel animated fadeInRight" data-bind="attr: { data-editable: editable }" style="display:none; border-width:3px;">
							<div class="panel-body">
								<div class="form-horizontal">			
									<div class="row">
										<div class="col-sm-12">
											<div class="form-group no-margin-hr">	
												<span  data-bind="{text: assessmentScheme.name, visible:visible}"></span>
												<input type="text" class="form-control input-md" name="rating-scheme-name" data-bind="{value: assessmentScheme.name, visible:editable }" placeholder="이름" />
											</div>
											<div class="form-group no-margin-hr">				
												<span data-bind="{text: assessmentScheme.description, visible:visible}"></span>
												<textarea class="form-control" rows="4"  name="rating-scheme-description"  data-bind="{value: assessmentScheme.description, visible:editable}" placeholder="설명"></textarea>
											</div>
											<div class="no-margin-hr">											
												<table class="table">							
													<tbody>
														<tr>
															<td width="150" class="text-muted">진단척도</td>
															<td>
															<span data-bind="visible:visible, text:assessmentScheme.ratingScheme.name"></span>
															<input id="rating-scheme-dorpdown-list"
															data-option-label="선택"
															data-role="dropdownlist"
										                  	data-auto-bind="true"
										                  	data-value-primitive="true"
										                   	data-text-field="name"
										                   	data-value-field="ratingSchemeId"
										                   	data-bind="value:assessmentScheme.ratingScheme.ratingSchemeId, source: ratingSchemeDataSource, visible:editable,events:{change: onRatingSchemeChange}" />
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
															<td>역량진단방법</td>
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
											</div>
										</div>
									</div>			
									<div class="row">
										<div class="col-sm-12">
											
										</div><!-- / .col-sm-12 -->
									</div><!-- / .row -->	
                    			</div>
                    		</div>    
                    		<div class="panel-body no-padding">
											<ul id="assessment-scheme-details-tabs" class="nav nav-tabs">
												<li class="m-l-sm">
													<a href="#assessment-scheme-details-tabs-1" data-toggle="tab">직무</a>
												</li>
												<li class="">
													<a href="#assessment-scheme-details-tabs- 2" data-toggle="tab">역량</a>
												</li>
												<li class="">
													<a href="#assessment-scheme-details-tabs-3" data-toggle="tab">속성</a>
												</li>												
											</ul>
											<div class="tab-content no-padding">
												
												<div class="tab-pane fade" id="assessment-scheme-details-tabs-1" style="min-height:300px;">
													<table class="table table-striped" data-bind="visible:visible">
														<thead>
															<tr>
																<th width="270">분류체계</th>
																<th>대분류</th>
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
														                   	data-bind="{value: job.classification.classifyType, source: classifyTypeDataSource , visible:editable}"
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
															<button class="btn btn-flat btn-outline btn-info pull-right"> 변경취소 </button>									
														</div>
													</div>												
													<div data-role="grid"
														class="no-border"
													    data-scrollable="true"
													    data-editable="true"
													    data-columns="[{ 'field': 'classifyType', 'title':'분류체계'},{ 'field': 'classifiedMajorityId', 'title':'대분류' },{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
													    data-bind="source:jobSelectionDataSource, visible:editable"
													    style="height: 300px"></div>
													    												
												</div> <!-- / .tab-pane -->
												
												
												<div class="tab-pane fade" id="assessment-scheme-details-tabs-2" style="min-height:300px;">	
												</div> <!-- / .tab-pane -->
												
												<div class="tab-pane fade active in" id="assessment-scheme-details-tabs-3" style="min-height:300px;">		
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
                	</div><!-- /.pane center --> 
           		</div><!-- /.layout --> 	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<script type="text/x-kendo-tmpl" id="job-selection-view-template">
		<tr>
			<td>#: classifyType #</td>
			<td>#: classifiedMajorityId #</td>
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
