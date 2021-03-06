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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-v6.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/default.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/profile.min.css"/>',
			'css!<@spring.url "/styles/jquery.sliding-panel/jquery.sliding-panel.css"/>',	
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment.style.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',				
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',			
			
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.sliding-panel/jquery.sliding-panel.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', ,
			'<@spring.url "/js/wow/wow.min.js"/>', , 
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {		
				
				common.ui.setup({
					features:{
						wow:true,
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){
								e.token.copy(currentUser);
								currentUser.set('visible',true);								
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".promo-bg-img-v2")
					},	
					jobs:jobs
				});	
				handleHeader();		
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();
				kendo.bind( $(".accounts-user-profile"), currentUser); 					
				createMyAssessmentPlanListView();
				// END SCRIPT 				
			}
		}]);			

		function getCurrentUser () {
			return common.ui.accounts().token ;
		}
		
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
				
				 $(document).on("click","[data-action='redirect']", function(e){		
				 	var that = $(this);
				 	common.redirect( that.data('target') , {id: that.data('object-id')}, "POST");	
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
									//getMyAssessmentPlanListView().dataSource.read();
									//console.log(common.ui.stringify(response));
									common.redirect("<@spring.url "/display/assessment/do-assessment.html"/>", {id:response.assessmentId}, "POST");
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
		
		
		// Fixed Header
		function handleHeader() {
			jQuery(window).scroll(function() {
			  if (jQuery(window).scrollTop() > 100) {
				jQuery('.header-fixed .header-sticky').addClass('header-fixed-shrink');
			  } else {
				jQuery('.header-fixed .header-sticky').removeClass('header-fixed-shrink');
			  }
			});
		}
		// Header
		function handleHeader2() {
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
		/**
		.team-v1 li:hover>.team-img:after {
			background: #fff;
		}*/
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
    	
    	.call-action-v2 p {
    		font-size : 1.8em;
    	}
    	
    	.call-action-v2 h2 {
    		font-size : 2.5em;
    	}
    	
		</style>   	
		</#compress>
	</head>
	<body class="header-fixed promo-padding-top sliding-panel-ini sliding-panel-flag-right">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->			
			<#include "/html/competency/common-header-v6.ftl" >			
			<!-- ./END HEADER --> 
			<!-- Promo Block -->
			<div class="promo-bg-img-v2 fullheight promo-bg-fixed arrow-up bg-dark" style="height:350px;">
				<div class="container valign__middle text-center">
					<div class="margin-bottom-100"></div>	
					<div class="wow fadeIn" data-wow-delay=".3s" data-wow-duration="1.5s" style="visibility: hidden;">
						<span class="promo-text-v2 color-light margin-bottom-10" >
							역량진단센터
						</span>
					</div>	
				</div>
			</div>
			<!-- ./End Promo Block -->
			<!-- START MAIN CONTENT -->
			<div class="call-action-v2 p-md bg-white arrow-up">
				<div class="container">
					<i class="icon-flat icon-svg basic-color-microphone2"></i>
					<h2 class="wow fadeInUp" data-wow-duration="1.5s" data-wow-delay=".5s">역량진단은 왜 중요할까요?</h2>
					<div class="wow fadeInUp" data-wow-duration="1.5s" data-wow-delay=".5s">
						<p>모든 직업은 특정 지식과 기술들이 요구됩니다. 그리고 이것은 직업의 종류와 복잡성에 따라 달라집니다.</p>
						<p>	
						역량진단은 단순하게 학습을 통하여 배우는 것이 나은지 경험을 통하여 배우는 것이 더 나은가를 아는 것 이상으로,
						선택한 직무가 요구하는 여러 지식과 기술들을 개발하기 위한 여러가지 방법을 제공합니다.   
						</p>
						<p>	
						또한 미래 또는 현재 직무를 수행하기 위하여 무엇을 어떻게 개발해야 하는 가를 알려주기 때문에 성공적인 자기개발계획에 중요한 핵심 요소입니다. 		
						</p>
					</div>
				</div>
			</div>						
			<#if action.user.anonymous >		
			<div class="call-action-v1 bg-color-dark margin-bottom-40">
		        <div class="container">
		            <div class="call-action-v1-box">
		                <div class="call-action-v1-in">
		                    <h3 class="color-light">
		                    서비스 문의는 <span class="color-green">jhlee@podosw.com</span> 메일 또는 <span class="color-green">070-7807-4040</span> 로 전화 주세요.
		                    </h3>
		                    <p class="color-light">
		 					제공되는 역량진단 서비스는 프로토타입 수준입니다. 
		 					역량진단 서비스는 회원 가입후 이용하실수 있습니다. 
							</p>
		                </div>
		                <div class="call-action-v1-in inner-btn page-scroll">
		                	
		                	<a href="<@spring.url "/accounts/signup?ver=1&url=${springMacroRequestContext.getRequestUri()}" />" class="btn-u btn-u-lg btn-brd btn-brd-width-2 btn-brd-hover btn-u-light btn-u-block">회원가입</a>
		                	<a href="<@spring.url "/accounts/login?ver=1&url=${springMacroRequestContext.getRequestUri()}" />" class="btn-u btn-u-lg btn-brd btn-brd-width-2 btn-brd-hover btn-u-light btn-u-block">로그인</a>
		                	
		                </div>
		            </div>
		        </div>
		    </div>
		    </#if>			
			<div class="container content-md">
		        <ul class="list-unstyled row portfolio-box team-v1 no-border" id="my-assessment-plan-listview"></ul>
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
					<div class="modal-body no-padding " style="min-height:300px;">							
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
					<div class="modal-body animated fadeIn" data-bind="invisible:secondStep" style="min-height:300px;">		
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
					<div class="modal-body animated fadeIn" data-bind="visible:secondStep" style="min-height:300px;">	
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
		<#include "/html/competency/common-sliding-panel.ftl" >									
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
					<button data-action="redirect" data-target="<@spring.url "/display/competency/my-assessment-report.html" />" data-object-id="#=assessmentId#" class="btn btn-flat btn-success btn-sm rounded">결과보기</button>
				#}else{#
					<button data-action="redirect" data-target="<@spring.url "/display/competency/do-assessment.html" />" data-object-id="#=assessmentId#" class="btn btn-flat btn-primary btn-sm rounded">진단완료하기</button>
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
		<li class="col-sm-6 col-md-6 col-lg-4 m-b-sm">
        	<!--<div class="team-img"> 	
       			<img class="img-responsive" src="/download/image/9451/ncs.png">
       		</div>-->
       		<i class="icon-flat icon-svg user-color-person-in-a-mirror"></i>
       		
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
