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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/one.style.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/profile.css"/>',				
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment/assessment.style.css"/>',					
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',				
			'css!<@spring.url "/styles/codrops/codrops.svgcheckbox.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',					
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',					
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', , 
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){
							console.log( kendo.stringify(e.token) );
								e.token.copy(currentUser);
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".fullscreen-static-image")
					},	
					jobs:jobs
				});	
				handleHeader();		
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				createMyAssessmentPlanListView();
				// END SCRIPT 				
			}
		}]);			

		
		function getMyAssessmentPlanListView(){
			var renderTo = $('#my-assessment-plan-listview');	
			return common.ui.listview(renderTo);
		}

		function createMyAssessmentPlanListView(){
			var renderTo = $('#my-assessment-plan-listview');	
			if( ! common.ui.exists(renderTo) ){
				var dataSource = common.ui.datasource( '<@spring.url "/data/me/competency/assessment/plan/stats/list.json?output=json"/>',{
					schema:{
						model: common.ui.data.competency.AssessmentStats
					}
				});
				common.ui.listview(renderTo,{
              	  	dataSource: dataSource,
                	template: kendo.template($("#my-assessment-plan-listview-template").html()),
                	dataBound: function(){		
                		renderTo.removeClass("k-widget k-listview");                	
                	}
        	    });
        	    
        	    $(document).on("click","[data-action='apply']", function(e){						
					var btn = $(this) ;
					var objectId = btn.data('object-id');
					var item = dataSource.get(objectId);
					createApplyAssessmentModal(item);					
				});
				
        	    $(document).on("click","[data-action='result']", function(e){						
					var btn = $(this) ;
					var objectId = btn.data('object-id');
					var item = dataSource.get(objectId);
					createResultAssessmentModal(item);					
				});				
			}
		}
		
		function createResultAssessmentModal(source){
			var renderTo = $("#result-assessment-modal");	
			if( !renderTo.data('bs.modal') ){				
				var observable =  common.ui.observable({
					assessmentPlan : new common.ui.data.competency.AssessmentPlan(),
					userAssessedCount : 0,
					assessmentDataSource: new kendo.data.DataSource({
						data : [],
						filter: { field: "state", operator: "eq", value: "ASSESSED" },
						schema: {
                            model: common.ui.data.competency.Assessment
                        }
					}),				
					setSource: function(source){
						var $this = this;			
						new common.ui.data.competency.AssessmentPlan(source.assessmentPlan).copy($this.assessmentPlan);			
						$this.set('userAssessedCount', source.userAssessedCount);		
						$this.assessmentDataSource.read();
						$this.assessmentDataSource.data( source.userAssessments );						
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
		
		function createApplyAssessmentModal(source){
			var renderTo = $("#apply-assessment-modal");	
			if( !renderTo.data('bs.modal') ){				
				var observable =  common.ui.observable({
					secondStep : false,
					job : new common.ui.data.competency.Job(),
					jobLevel : 0,
					userIncompleteCount : 0,
					assessmentPlan : new common.ui.data.competency.AssessmentPlan(),
					hasIncomplete :false,
					jobDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'<@spring.url "/data/me/competency/assessment/job/list.json?output=json"/>', type:'post' },
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
						var newAssessment = new common.ui.data.competency.Assessment();						
						newAssessment.candidate.userId =  getCurrentUser().userId;
						newAssessment.job = $this.job ;
						newAssessment.assessmentPlan.assessmentId = $this.assessmentPlan.assessmentId;
						newAssessment.jobLevel = $this.jobLevel ;
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/data/me/competency/assessment/create.json?output=json" />' , 
							{
								data : kendo.stringify( newAssessment ),
								contentType : "application/json",
								success : function(response){																	
									getMyAssessmentPlanListView().dataSource.read();
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
									renderTo.modal('hide');
								}
							}
						);		
						return false;					
					},
					assessmentDataSource: new kendo.data.DataSource({
						data : [],
						filter: { field: "state", operator: "neq", value: "ASSESSED" },
						schema: {
                            model: common.ui.data.competency.Assessment
                        }
					}),
					jobLevelDataSource :new kendo.data.DataSource({
						data : [],
						schema: {
                            model: common.ui.data.competency.JobLevel
                        }
					}),
					setSource: function(source){
						var $this = this;
						var doRead = true;						
						if( source.assessmentPlanId == $this.assessmentPlan.assessmentId )
						{
							doRead = false;
						}
						new common.ui.data.competency.AssessmentPlan(source.assessmentPlan).copy($this.assessmentPlan);	
						$this.set('userIncompleteCount', source.userIncompleteCount);
						if(source.userIncompleteCount > 0){	
							$this.set('hasIncomplete', true);
						}else{
							$this.set('hasIncomplete', false);						
						}
						$this.userAssessments = source.userAssessments;									
						if( doRead & $this.assessmentPlan.assessmentId > 0 )
						{
							$this.jobDataSource.read();
							$this.assessmentDataSource.read();
							$this.assessmentDataSource.data( source.userAssessments );
						}	
						$this.set("secondStep", false);
						renderTo.find("form")[0].reset();
					}
				});		
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );		
				
				
				render.on("click", "[data-action='redirect']", function(e){
					alert(1);
				});
							
				$(document).on("click","input[type=radio][data-action='select']", function(e){						
					var radio = $(this) ;			
					var objectType  = radio.data("object-type");
					var objectId = radio.val();		
					if( objectType == 60 ){
						var item = observable.jobDataSource.get(objectId);
						item.copy(observable.job);
						observable.jobLevelDataSource.read();
						observable.jobLevelDataSource.data(observable.job.jobLevels);					
						observable.set('secondStep', true);	
					}else if (objectType == 61){
						observable.set('jobLevel', objectId );
						observable.create();
					}	
				});	
			}
			if( source ){
				renderTo.data("model").setSource( source );		
			}
			renderTo.modal('show');
		}
		// Header
		function handleHeader() {
			// jQuery to collapse the navbar on scroll
			var OffsetTop = $('.navbar').attr('data-offset-top');
			if ($('.navbar').offset().top > OffsetTop) {
				$('.navbar-fixed-top').addClass('top-nav-collapse');
			}
			$(window).scroll(function() {
				if ($('.navbar').offset().top > OffsetTop) {
					$('.navbar-fixed-top').addClass('top-nav-collapse');
				} else {
					$('.navbar-fixed-top').removeClass('top-nav-collapse');
				}
			});
	
			var $offset = 0;
			if ($('.one-page-nav-scrolling').hasClass('one-page-nav__fixed')) {
				$offset = $(".one-page-nav-scrolling").height()+8;
			}
			// jQuery for page scrolling feature - requires jQuery Easing plugin
			$('.page-scroll a').bind('click', function(event) {
				var $position = $($(this).attr('href')).offset().top;
				$('html, body').stop().animate({
					scrollTop: $position - $offset
				}, 600);
				event.preventDefault();
			});
	
			var $scrollspy = $('body').scrollspy({target: '.one-page-nav-scrolling', offset: $offset+2});
	
			// Collapse Navbar When It's Clickicked
			$(window).scroll(function() {
				$('.navbar-collapse.in').collapse('hide');
			});
		}
			
		-->
		</script>		
		<style scoped="scoped">
		
		.modal-content{
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
		
		.sky-form header i.icon-svg {
		    position: absolute;
    		left: 12px;
    	}
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
		<nav class="one-page-header navbar navbar-default navbar-fixed-top one-page-nav-scrolling one-page-nav__fixed top-nav-collapse assessment-nav" data-role="navigation" data-offset-top="150">
			<div class="container">
				<div class="row collapse navbar-collapse navbar-ex1-collapse">
					<div class="col-md-6 no-side-padding">
						<div class="pull-left">
							<div class="menu-container">
								<ul class="nav navbar-nav">
									<li class="home">
										<a href="#body">Home</a>
									</li>
									<li class="active">
										<a href="#">역량진단</a>
									</li>
									<li class="">
										<a href="#services">진단결과</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="tel-block hidden-3xs">
						<i class="icon-flat icon-svg icon-svg-sm business-color-phone"></i>
						070-7807-4040
					</div>
				</div>
			</div>
			<!-- /.container -->
		</nav>	
		<section class="intro-section">
			<div class="fullscreen-static-image fullheight" style="position: relative; z-index: 0; height: 307px; background: none;">
				<!-- Promo Content BEGIN -->
				<div class="container valign__middle text-center" style="padding-top: 60px;">
					<div class="row">
						<div class="col-md-8 col-md-offset-2 col-sm-12 col-xs-12 page-scroll">
							<h1 class="g-color-white g-mb-25" data-bind="text:assessment.assessmentPlan.name"></h1>
							<p class="g-color-white g-mb-40"><span data-bind="text:assessment.assessmentPlan.description"></span></p>
							<!--<a href="#footer" class="btn-u btn-u-lg g-bg-default-color btn-u-upper rounded">Contact Us</a>-->
						</div>
					</div>
				</div>
			</div>	
		  	<!-- Promo Content END -->
  		</section>     					
			<!-- ./END HEADER -->			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
		        <ul class="list-unstyled row portfolio-box team-v1 no-border" id="my-assessment-plan-listview">
		        </ul>
		    </div>
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->



			<!-- ./END FOOTER -->					
		</div>				


		<!-- START MODAL -->	
		<div id="result-assessment-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg modal-flat">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title"><span data-bind="text:assessmentPlan.name"/> </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>										
					<div class="modal-body no-padding" style="min-height:300px;">							
								<p class="text-muted p-sm bg-gray no-margin-b">
									진단이력이 <span class="text-danger" data-bind="text:userAssessedCount"></span>건 있습니다. 결과보기 버튼을 클릭하여 진단결과를 확인할 수 있습니다.
								</p>
								<table class="table no-margin" style="border-top: 1px solid #ddd;">
					            	<thead>
					                	<tr>
					                    	<th width="42">&nbsp;</th>
					                    	<th class="hidden-sm" width="40%">분류</th>
					                    	<th>직무</th>
					                    	<th>직급</th>
					                    	<th>진단일자</th>
					                    	<th width="90">&nbsp;</th>
					              		</tr>
					          		</thead>
					          		<tbody data-role="listview"
					                    		class="no-border"
												data-auto-bind="false"	
							                 	data-template="my-assessment-template"
							                 	data-bind="source:assessmentDataSource" style="height: 300px; overflow: auto"> 
									</tbody>		                    
					        	</table>
					</div>
					<div class="modal-footer">				
						<button type="button" class="btn btn-default btn-flat btn-outline rounded" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>	
		</div>	
					
		<div id="apply-assessment-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg modal-flat">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title"><span data-bind="text:assessmentPlan.name"/> </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>										
					<div class="modal-body no-padding bg-gray" data-bind="visible:hasIncomplete" style="border-bottom: 1px dashed #e5e5e5;">							
								<p class="text-muted p-sm">
									미완료된진단이 <span class="text-danger" data-bind="text: userIncompleteCount"></span>건 있습니다. 진단을 완료하거나 새로운 진단을 시작할 수 있습니다.
								</p>
								<table class="table no-margin">
					            	<thead>
					                	<tr>
					                    	<th width="42">&nbsp;</th>
					                    	<th class="hidden-sm" width="40%">분류</th>
					                    	<th>직무</th>
					                    	<th>직급</th>
					                    	<th>일자</th>
					                    	<th width="90">&nbsp;</th>
					              		</tr>
					          		</thead>
					          		<tbody data-role="listview"
					                    		class="no-border"
												data-auto-bind="false"	
							                 	data-template="my-assessment-template"
							                 	data-bind="source:assessmentDataSource" style="height: 300px; overflow: auto"> 
									</tbody>		                    
					        	</table>
					</div>
					<div class="modal-body" data-bind="invisible:secondStep" style="min-height:300px;">		
						<form action="#" class="sky-form no-border">
							<header>
								<i class="icon-flat icon-svg icon-svg-sm basic-color-checked-checkbox"></i>
								<span class="text-xxs">직무를 선택하여 주세요.</span></header>
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
							<table class="table table-striped hidden">
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
							<header>
								<i class="icon-flat icon-svg icon-svg-sm basic-color-checked-checkbox"></i>
								<span class="text-xxs">직급를 선택하여 주세요.</span></header>				
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
		<script type="text/x-kendo-template" id="my-assessment-template">
		<tr>
		    <td class="no-padding-vr"><i class="icon-flat icon-svg icon-svg-sm business-color-true-false"></i></td>
		    <td class="hidden-sm"> 
		    #: job.classification.classifiedMajorityName# > #: job.classification.classifiedMiddleName# > <span class="color-green">#: job.classification.classifiedMinorityName#</span>		    
		    </td>
			<td>
			#: job.name #
			</td>
			<td>
			#: jobLevelName #
			</td>
			<td>
			#: kendo.toString( new Date( modifiedDate ), "d") #
			</td>
			<td>
				#if (state == 'ASSESSED') {#
					<a href="/display/0/my-assessment-report.html?id=#=assessmentId#" class="btn btn-flat btn-success btn-sm rounded">결과보기</a>	
				#}else{#
					<a href="/display/0/assessment.html?id=#=assessmentId#" class="btn btn-flat btn-primary btn-sm rounded">진단완료하기</a>				
				#}#
			</td>
		</tr>			
		</script>					
					
		<script type="text/x-kendo-template" id="my-assessment-job-level-template">
		<tr>
		    <td class="hidden-sm no-padding-vr"><i class="icon-flat icon-svg icon-svg-md business-color-for-experienced"></i></td>
		    <td>    
		    	<label class="radio"><input type="radio" data-action="select" name="input-select-job-level" data-object-type= "61" value="#=level#"><i class="rounded-x"></i>#: name #</label>
		    </td>
			<td>
				#:minWorkExperienceYear# ~ #:maxWorkExperienceYear# 년		
			</td>
		</tr>	
		        
		</script>
		
		<script type="text/x-kendo-template" id="my-assessment-job-template">
		<tr>
		    <td class="hidden-sm no-padding-vr"><i class="icon-flat icon-svg icon-svg-md user-color-worker"></i></td>
		    <td>    
		    	<label class="radio"><input type="radio" data-action="select" name="radio" name="input-select-job" data-object-type= "60" value="#=jobId#"><i class="rounded-x"></i>#: name #</label>
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
		<li class="col-sm-6 col-md-6 col-lg-4">
        	<div class="team-img"> 	
       		</div>
            <h3>#: assessmentPlan.name#</h3>
            <h4>#= kendo.toString( new Date(assessmentPlan.startDate), "g") # ~ #: kendo.toString( new Date( assessmentPlan.endDate), "g") #</h4>
            <p>#: assessmentPlan.description#</p>            
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
 				# for (var i = 0; i < assessmentPlan.jobSelections.length ; i++) { #	
	            # var jb = assessmentPlan.jobSelections[i] ; #	
	                <tr>
                    	<td>#if(jb.classifiedMajorityId > 0){# #:jb.classifiedMajorityName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.jobId > 0){# #:jb.jobName# #}#</td>
                   	</tr>
                # } #                
             	</tbody>
             </table>
           		<div class="text-right">
        		#if(assessmentPlan.multipleApplyAllowed || userAssessedCount == 0 || userIncompleteCount > 0 ){#
                	<button class="btn btn-flat btn-primary btn-outline  rounded" data-action="apply" data-object-id="#:assessmentPlan.assessmentId#">참여하기</button>
                #}#	     
                #if(userAssessedCount>0){ #        
                	<button href="\\#" class="btn btn-flat btn-success btn-outline rounded" data-action="result" data-object-id="#:assessmentPlan.assessmentId#">결과보기</button>                     
                #}#
                </div> 
        </li>	
	    </script>
		<!-- ./END TEMPLATE -->
	</body>    
</html>