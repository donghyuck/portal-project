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
						getAssessmentGrid().dataSource.read();
					}
				});
				
				createAssessmentGrid();
			}
		}]);		


		function getAssessmentGrid(){
			var renderTo = $("#assessment-grid");
			return common.ui.grid(renderTo);
		}
		

		function createAssessmentGrid(){
			var renderTo = $("#assessment-grid");
			if(! common.ui.exists(renderTo) ){			
				
				var companySelector = getCompanySelector();					
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/assessment/list.json?output=json', type:'post' },
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
							model: common.ui.data.competency.Assessment
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
	                    	createAssessmentDetails(selectedCell);
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){	
					var newPlan = new common.ui.data.competency.AssessmentPlan();
					newPlan.set("objectType", 1);
					newPlan.set("objectId",companySelector.value());
					createAssessmenPlanModal(newPlan);			
				});					
			}
		}		

		function createAssessmentDetails(source){
		
		}
				
		function createAssessmenPlanModal(source){
			var parentRenderTo = $("#assessment-details");
			var renderTo = $("#assessment-plan-modal");			
			if( !renderTo.data('bs.modal') ){
				var observable =  common.ui.observable({
					plan:new common.ui.data.competency.AssessmentPlan(),
					assessmentSchemeDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/assessment/scheme/list.json?output=json',
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
					setSource: function(source){
						var $this = this;				
						source.copy($this.plan);
					}				
				});
				
				
				function startChange() {
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
                    }

                    function endChange() {
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
                    }
                    var today = kendo.date.today();
                    var start = $("#input-assessment-plan-start").kendoDateTimePicker({
                        value: today,
                        change: startChange,
                        parseFormats: ["MM/dd/yyyy"]
                    }).data("kendoDateTimePicker");

                    var end = $("#input-assessment-plan-end").kendoDateTimePicker({
                        value: today,
                        change: endChange,
                        parseFormats: ["MM/dd/yyyy"]
                    }).data("kendoDateTimePicker");

                    start.max(end.value());
                    end.min(start.value());
                    
				
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
                		<div id="assessment-details" class="panel panel-default" style="display:none;">
                		
                		</div>
                	 </div><!-- /.col-md-8 -->                   	 
                 </div><!-- /.row -->   
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->	
		
		<div id="assessment-plan-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title">역량진단계획</h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">

						<form>
							<div class="row">
								<div class="col-sm-12">		
									<input type="text" class="form-control" name="input-assessment-plan-name" 
										data-bind="{value: plan.name }" placeholder="이름" />							
									<textarea class="form-control m-t-sm" rows="4"  
										name="input-assessment-plan-description"  
										data-bind="{value: plan.description }" 
										placeholder="설명"></textarea>
										
									<h6 class="text-light-gray text-semibold text-xs" style="margin: 15px 0 5px 0;">역량진단운영체계</h6>											
									<input id="input-assessment-scheme-dorpdown-list"
											data-option-label="선택"
											data-role="dropdownlist"
										    data-auto-bind="true"
										    data-value-primitive="true"
										    data-text-field="name"
										    data-value-field="assessmentSchemeId"
										    data-bind="value:plan.assessmentSchemeId, source: assessmentSchemeDataSource" />
									
									<h6 class="text-light-gray text-semibold text-xs" style="margin: 15px 0 5px 0;">역량진단기간</h6>
									<input id="input-assessment-plan-start" style="width: 100%;" />
									<input id="input-assessment-plan-end" style="width: 100%;" />
										                   		
								</div>		
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
