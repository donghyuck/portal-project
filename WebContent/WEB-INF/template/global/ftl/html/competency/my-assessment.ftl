<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >		
		<title>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 	
			'<@spring.url "/js/common.plugins/switchery.min.js"/>',	
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 		
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
			],			
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},	
					jobs:jobs
				});	
						
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				createMyAssessmentPlanListView();
				// END SCRIPT 				
			}
		}]);			

		function createMyAssessmentPlanListView(){
			var renderTo = $('#my-assessment-plan-listview');	
			if( ! common.ui.exists(renderTo) ){
				var dataSource = common.ui.datasource( '<@spring.url "/data/me/competency/assessment/plan/list.json?output=json"/>',{
					schema:{
						model: common.ui.data.competency.AssessmentPlan
					}
				});
				common.ui.listview(renderTo,{
              	  	dataSource: dataSource,
                	template: kendo.template($("#my-assessment-plan-listview-template").html())
        	    });
        	    
        	    $(document).on("click","[data-action='apply']", function(e){						
					var btn = $(this) ;
					var objectId = btn.data('object-id');
					var item = dataSource.get(objectId);
					console.log( common.ui.stringify(item) );
					createApplyAssessmentModal(item);
					
				});
			}
		}
		
		function createApplyAssessmentModal(source){
			var renderTo = $("#apply-assessment-modal");	
			if( !renderTo.data('bs.modal') ){				
				var observable =  common.ui.observable({
					secondStep : false,
					job : new common.ui.data.competency.Job(),
					assessmentPlan : new common.ui.data.competency.AssessmentPlan(),
					jobDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'<@spring.url "/data/me/competency/assessment/job/list.json?output=json'"/>, type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									assessmentId: observable.assessmentPlan.assessmentId
								};
							}
						},			
						schema: {
							model: common.ui.data.competency.Job
						}
					}),
					goFirstStep:function(){
						renderTo.find("form")[0].reset();
						observable.set('secondStep', false);
					},
					create : function(e){
						var $this = this;						
						var btn = $(e.target);	
						var newAssessment = new common.ui.data.competency.Assessment();
						newAssessment.candidate.userId =  getCurrentUser().userId;
						newAssessment.job.jobId = $this.job.jobId;
						newAssessment.assessmentPlan.assessmentId = $this.assessmentPlan.assessmentId;
						
						console.log( common.ui.stringify(newAssessment) );
						
						/**
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "data/me/competency/assessment/create.json?output=json" />' , 
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
						*/				
						return false;
					
					},
					jobLevelDataSource :new kendo.data.DataSource({
						data : [],
						schema: {
                            model: common.ui.data.competency.JobLevel
                        }
					}),
					setSource: function(source){
						var $this = this;
						var doRead = true;						
						if( source.assessmentId == $this.assessmentPlan.assessmentId )
						{
							doRead = false;
						}
						source.copy($this.assessmentPlan);						
						if( doRead & $this.assessmentPlan.assessmentId > 0 )
							$this.jobDataSource.read();						
						$this.set("secondStep", false);
						renderTo.find("form")[0].reset();
					}
				});		
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );	
				
				$(document).on("click","input[type=radio][data-action='select']", function(e){						
					var radio = $(this) ;					
					var item = observable.jobDataSource.get(radio.val());
					item.copy(observable.job);
					observable.jobLevelDataSource.read();
					observable.jobLevelDataSource.data(observable.job.jobLevels);					
					observable.set('secondStep', true);					
				});	
			}
			if( source ){
				renderTo.data("model").setSource( source );		
			}
			renderTo.modal('show');
		}
		-->
		</script>		
		<style scoped="scoped">			
		/** Breadcrumbs */
		.breadcrumbs-v3 {
			position:relative;
		}

		.breadcrumbs-v3 p	{
			color : #fff;
			font-size: 24px;
			font-weight: 200;
			margin-bottom: 0;
		}	
		
		.breadcrumbs-v3.img-v1 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}		
		
		
		
		#apply-assessment-modal .modal-content{
		    border-radius: 6px !important;
		}
		
		.team-v1 li:hover>.team-img:after {
			background: #fff;
		}
		.team-v1 li>.team-img {
		    min-height: 30px;
		}
		.team-v1 li>.team-img ul{
			text-align:right;
		} 
		
		.modal-body .k-listview td{
			vertical-align: middle;
		}
		
		.modal-body .k-listview td .k-radio-label{
			font-weight: 100;
		    margin-bottom: 0;
		    font-size : 1.2em;
		    line-height: 1.3em;
		}
		
		ul.list-unstyled li .k-radio-label{
			font-weight: 100;
		    margin-bottom: 0;
		    line-height: 1.3em;
		    font-size : 1.2em;
		    padding-bottom: 1em;
		}		
		
		.sky-form .radio input+i:after {
		    top: 6px;
		    left: 6px;
		    background-color: #999;
		}		
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>					
					<a href="<@spring.url "/display/0/my-home.html"/>"><span class="btn-flat home t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>					
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<button class="btn-link hvr-pulse-shrink" data-action="create" data-object-type="40"><i class="icon-flat microphone"></i></button>
					<button class="btn-link hvr-pulse-shrink"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>				
			<!-- ./END HEADER -->			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
		        <ul class="list-unstyled row portfolio-box team-v1 no-border" id="my-assessment-plan-listview">
		        </ul>
		    </div>
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				


		<!-- START MODAL -->		
		
	<div id="apply-assessment-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-md modal-flat">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title"><span data-bind="text:assessmentPlan.name"/> </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					
					<div class="modal-body" data-bind="invisible:secondStep" style="min-height:300px;">
						<form action="#" class="sky-form no-border">
							<header><span class="text-xxs">직무를 선택하여 주세요.</span></header>
		                    <table class="table table-striped no-margin">
				            	<thead>
				                	<tr>
				                    	<th class="hidden-sm" width="42">&nbsp;</th>
				                    	<th width="30%">직무</th>
				                    	<th>직무정의</th>
				              		</tr>
				          		</thead>
				          		<tbody data-role="listview"
				                    		class="no-border"
											data-auto-bind="false"	
						                 	data-template="my-assessment-job-template"
						                 	data-bind="source: jobDataSource" style="height: 300px; overflow: auto"> 
								</tbody>		                    
				        	</table>
		                </form>
					</div>
					<div class="modal-body" data-bind="visible:secondStep" style="min-height:300px;">	
							<table class="table table-striped">
								<thead>
										<tr>
											<th width="30%" >직무분류체계</th>
											<th>
												<span data-bind="{ text:job.classification.classifyTypeName }" class="text-muted"></span>
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>대분류</td>
											<td>
											<span data-bind="{ text:job.classification.classifiedMajorityName }" class="text-muted"></span>
											</td>
										</tr>
										<tr>
											<td>중분류</td>
											<td>
											<span data-bind="{text: job.classification.classifiedMiddleName}" class="text-muted"></span>
											</td>
										</tr>
										<tr>
											<td>소분류</td>
											<td>
												<span data-bind="{text: job.classification.classifiedMinorityName}" class="text-muted"></span>
											</td>
										</tr>	
										<tr>
											<td>직무</td>
											<td>
												<span class="color-green" data-bind="{text: job.name}" ></span>
											</td>
										</tr>	
										<tr>
											<td>직무정의</td>
											<td>
												<span data-bind="{text: job.description}" class="text-muted"></span>
											</td>
										</tr>																																								
									</tbody>
							</table>	
							
															
						<form action="#" class="sky-form no-border">
							<header><span class="text-xxs">직급를 선택하여 주세요.</span></header>				
							<table class="table table-striped no-margin">
				            	<thead>
				                	<tr>
				                    	<th class="hidden-sm" width="42">&nbsp;</th>
				                    	<th width="50%">직급</th>
				                    	<th>직무경험</th>
				              		</tr>
				          		</thead>
				          		<tbody data-role="listview"
				                    		class="no-border"
											data-auto-bind="false"	
						                 	data-template="my-assessment-job-level-template"
						                 	data-bind="source: jobLevelDataSource" style="height: 300px; overflow: auto"> 
								</tbody>		                    
				        	</table>													
						</form>
					</div>
					<div class="modal-footer">	
						<button type="button" class="btn btn-primary btn-flat btn-outline rounded btn-left" data-bind="click:goFirstStep, visible:secondStep" >이전</button>					
						<button type="button" class="btn btn-default btn-flat btn-outline rounded" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>	
		</div>					

		
		<!-- END MODAL -->	
		
		
              
							
		<!-- START TEMPLATE -->									
		<script type="text/x-kendo-template" id="my-assessment-job-level-template">
		<tr>
		    <td class="hidden-sm no-padding"><i class="icon-flat icon-svg icon-svg-md business-color-work"></i></td>
		    <td>    
		    	<label class="radio"><input type="radio" name="radio" name="input-select-job-level" value="#=level#"><i class="rounded-x"></i>#: name #</label>
		    </td>
			<td>
				#:minWorkExperienceYear# ~ #:minWorkExperienceYear# 년		
			</td>
		</tr>	
		        
		</script>
		
		<script type="text/x-kendo-template" id="my-assessment-job-template">
		<tr>
		    <td class="hidden-sm no-padding"><i class="icon-flat icon-svg icon-svg-md business-color-work"></i></td>
		    <td>    
		    	<label class="radio"><input type="radio" data-action="select" name="radio" name="input-select-job" value="#=jobId#"><i class="rounded-x"></i>#: name #</label>
		    </td>
			<td>
				<div class="headline-left">
                    <h6 class="heading-md">#:classification.classifiedMajorityName# > #:classification.classifiedMiddleName# > <span class="color-green">#:classification.classifiedMinorityName#</span></h2>
                </div>
				#: description #			
			</td>
		</tr>			
		</script>
		
		<script type="text/x-kendo-template" id="my-assessment-plan-listview-template">
		<li class="col-sm-6 col-md-4">
        	<div class="team-img">
        		<ul class="text-right">
                	<li><button class="btn btn-flat btn-primary btn-outline  rounded" data-action="apply" data-object-id="#:assessmentId#">참여하기</a></li>             
                	<li><a href="\\#" class="btn btn-flat btn-success btn-outline  rounded" data-object-id="#:assessmentId#">결과보기</a></li>                        
                </ul>   	
       		</div>
            <h3>#:name#</h3>
            <h4>#: formattedStartDate() # ~ #: formattedEndDate() #</h4>
            <p>#:description#</p>            
            <table class="table">
            	<thead>
                	<tr>
                    	<th>대분류</th>
                        <th>중분류</th>
                        <th>소분류</th>
                        <th>직무</th>
                    </tr>
                </thead>
                <tbody>
 				# for (var i = 0; i < jobSelections.length ; i++) { #	
	            # var jb = jobSelections[i] ; #	
	                <tr>
                    	<td>#if(jb.classifiedMajorityId > 0){# #:jb.classifiedMajorityName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.jobId > 0){# #:jb.jobName# #}#</td>
                   	</tr>
                # } #                
             	</tbody>
             </table>
        </li>	
	    </script>
	    
		<#include "/html/common/common-homepage-templates.ftl" >		
		<#include "/html/common/common-personalized-templates.ftl" >
		<#include "/html/common/common-editor-templates.ftl" >	
		<!-- ./END TEMPLATE -->
	</body>    
</html>