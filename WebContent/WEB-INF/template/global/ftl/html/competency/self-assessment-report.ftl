<#ftl encoding="UTF-8"/>
<#assign page = action.getPage() >
<html decorator="unify">
<head>
<#compress>
<title>${page.title}</title>
<script type="text/javascript">
<!--
var jobs = [];	
yepnope([{
    load: [        
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.svgcheckbox.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',		
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
		complete : function() {
			common.ui.setup({
				features:{
					wallpaper : false,
					loading:true
				},		
				jobs:jobs
			});		
			
			<#if RequestParameters['id']?? >
			var	assessmentId = ${ TextUtils.parseLong( RequestParameters['id'] ) } ;
			
			var renderTo = $("#my-assessment .assessment-header .ibox");		
			common.ui.progress(renderTo, true);
			common.ui.ajax( '<@spring.url "/data/accounts/get.json?output=json"/>' , {
				success : function(response){
					var currentUser = new common.ui.data.User($.extend( response.user, { roles : response.roles }));					
					common.ui.ajax( '<@spring.url "/data/me/competency/assessment/get.json?output=json"/>' , {
						data : { assessmentId : assessmentId},
						success : function(response){
							var assessment = new common.ui.data.competency.Assessment(response);
							createMyAssessedSummary(assessment);
						},
						complete : function(e){
							common.ui.progress(renderTo, false);						
						}
					});
					
				}
			});			
			<#else>
			alert("잘못된 접근입니다.");
			</#if>				
								
		}
	} ]);
	
	function getUserPhotoUrl(user){
		return '<@spring.url "/download/profile/"  />' + user.username + '?width=150&height=150'; 
	}
	
	function createMyAssessedSummary(source){
		var renderTo = $('#my-assessment');	
		if( !renderTo.data("model") ){
			var observable =  common.ui.observable({
				visible : false,
				assessment: new common.ui.data.competency.Assessment() ,
				candidatePhotoUrl: null,
				jobLevelDataSource :new kendo.data.DataSource({
					data : [],
					schema: {
                    	model: common.ui.data.competency.JobLevel
                    }
                }),
				setSource: function(source){
					var $this = this;
					source.copy($this.assessment);	
					$this.set('candidatePhotoUrl',  getUserPhotoUrl($this.assessment.candidate) );
					console.log( kendo.stringify( $this.assessment )) ;
					$this.jobLevelDataSource.data($this.assessment.job.jobLevels);		
					getMyAssessedSummaryGrid().dataSource.read();
				}
			});		
			renderTo.data("model", observable);	
			kendo.bind(renderTo, observable );
			createMyAssessedSummaryGrid();
		}
		if( source ){
			renderTo.data("model").setSource(source);
		}
	}		
	
	function getMyAssessment(){
		var renderTo = $('#my-assessment');
		return renderTo.data("model").assessment;
	}
	
	function getMyAssessedSummaryGrid(){
		var renderTo = $("#assessed-summary-grid");
		return common.ui.grid(renderTo);
	}
	
	function createMyAssessedSummaryGrid(){
		var renderTo = $("#assessed-summary-grid");
		if( !common.ui.exists (renderTo) ){
			var grid = common.ui.grid(renderTo, {
				autoBind : false,
				dataSource : {
					transport: { 
						read: { url:'<@spring.url "/data/me/competency/assessment/test/summary.json?output=json"/>', type:'post' },
						parameterMap: function (options, operation){
							if (operation !== "read") {
								return kendo.stringify(options.models);
							} 
							return {
								assessmentId: getMyAssessment().assessmentId
							};
						}
					},			
					schema: {
						model: {
	                    	fields: {
	                        	competencyId: { type: "number" },
	                        	competencyName: { type: "string" },
	                        	essentialElementId: { type: "number" },
	                        	essentialElementName: { type: "string" },
	                        	totalCount: { type: "number" },
	                        	totalScore: { type: "number" },
	                        	finalScore: { type: "number" }
	                        }	
	                    }
					},
					group: {
						field: "competencyName", aggregates: [
							 { field: "totalCount", aggregate: "sum" },
							 { field: "finalScore", aggregate: "sum" }				
						] 
					},
					aggregate:[
						{ field: "totalCount", aggregate: "sum" },
						{ field: "finalScore", aggregate: "sum" },
	                	{ field: "finalScore", aggregate: "min" },
	                    { field: "finalScore", aggregate: "max" },
	                    { field: "finalScore", aggregate: "average" }
	                ]
	   			},
	   			editable:false,
	   			scrollable : false,
	   			columns : [
					{ 'field': 'competencyName', title:'역량' },	
	              	{ 'field': 'essentialElementName', title:'하위요소' },
	              	{ 'field': 'totalCount' , title:'문항수', aggregates: ["sum"], groupFooterTemplate: '<span>#= sum #</span>', footerTemplate: "<span>#=sum #</span>"},
	          		{ 'field': 'totalScore', title:'점수' },
	            	{ 'field': 'finalScore', title:'&nbsp;', aggregates: ["sum", "max", "min"], groupFooterTemplate: '역량점수 :  <span>#= sum #</span>', footerTemplate: "총점: #=sum #"  }                                 
	            ]
			} );
			
			$("#assessed-summary-chart").kendoChart({
                title: {
                    text: "Budget report"
                },
                dataSource:grid.dataSource,
                seriesDefaults: {
                    type: "radarLine"
                },
                series: [{
                    name: "Budget",
                    field: "budget"
                }, {
                    name: "Spending",
                    field: "spending"
                }],
                categoryAxis: {
                    field: "unit"
                },
                valueAxis: {
                    labels: {
                        template: "$#= value / 1000 #k"
                    }
                }
            });
            			
		}
		
	}                         
                              	
	function getRatingLevels(){
		var renderTo = $('#my-assessment');	
		return renderTo.data("model").assessment.assessmentPlan.ratingScheme.ratingLevels ;
	}
	
	--></script>
	<style>

		#my-assessment {
			background-color: rgba(245, 245, 245, 0.952941);
		}
	
		
		.btn-xxl {
			padding 20px 26px;		
			font-size : 24px;	
		}
		
		.headline  {
			border-bottom: 3px solid #e5e5e5;
		}
		
		.ibox .page-credits .credit-item {
			padding: 0 0 10px 0;
		}
		.headline h3 {		
			font-size: 2em;
    		font-weight: 600;
    	 	padding-left: 10px;
    		padding-right: 5px;
        	border-bottom-width: 3px;
		}
		
		.assessment-header
		{
			background:#fff;
			/**
			 background:rgba(242,242,242,0.6);
			 border-bottom: 3px solid #efefef;*/
			 box-shadow: 0 1px 2px 0 rgba(0,0,0,0.22);
		}		
		.ibox-title {
			font-size:1.2em;
		}		
		/**
		.ibox-title
		{
			background: #272727!important;
			color:#fff;
			border-color:#007aff;
		}
		
		.ibox-content {
			background: #272727!important;
			color:#f5f5f5;
		}
		*/
		
		h1, h2, h3, h4, h5, h6 {
			color:#333;
		}
		
		.text-gray {
			color:#333!important;
		}
		
		.project-details li {
			color:#333!important;
		}
		
	</style>
</#compress>
</head>
<body class="">
	<div class="page-loader"></div>
 	<div id="my-assessment" class="wrapper"> 	
		<div class="assessment-header">
			<div class="container">
				<div class="row">
	                <div class="col-sm-8">
	                    <div class="headline no-border">
	                    	<h2>직무역량진단결과</h2>                    
	                    </div>
	                   
	                </div>
	                <div class="col-sm-4">
						
	                </div>
	            </div><!-- /.row -->
	        </div>    		
        </div>
        <div class="container content-md">   
        
 			<div class="ibox bordered">
	                		<div class="ibox-title">
	                        	  <h2 data-bind="text:assessment.assessmentPlan.name"></h2>                        
	                    	</div>

<div class="ibox-content">
						<table class="table no-margin-b">
					    	<thead>
					        	<tr>
					            	<th colspan="2"><i class="icon-flat icon-svg icon-svg-md user-color-worker"></i></th>
					           	</tr>
					   		</thead>
					     	<tbody>
								<tr>
									<td width="100">진단목적</td>
									<td><span data-bind="{ text:assessment.assessmentPlan.description" }" class="text-muted"></span></td>
								</tr>	
								<tr>
									<td>진단기간</td>
									<td><span data-bind="{text:assessment.assessmentPlan.startDate"}" class="text-muted"></span> 
										~ 
										<span data-bind="{text:assessment.assessmentPlan.endDate"}" class="text-muted"></span></td>
								</tr>	
								<tr>
									<td>진단방법</td>
									<td>
										<span data-bind="invisible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">자가진단</span>
			                        	<span data-bind="visible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">다면진단</span>
									</td>
								</tr>	
								<tr>
									<td>진단일</td>
									<td><span data-bind="{text: assessment.modifiedDate }" class="text-muted"></span></td>
								</tr>
								<tr>
									<td>대상자</td>
									<td class="no-padding-b">

										<div class="page-credits">				
											<div class="credit-item">
												<div class="credit-img user">
													<img data-bind="attr:{src: candidatePhotoUrl }" class="img-responsive img-circle" src="<@spring.url "/images/common/anonymous.png"/>">
												</div>
												<div class="credit-name">
													<span data-bind="{ text: assessment.candidate.name, visible: assessment.candidate.nameVisible }"></span>													
												</div>
												<div class="credit-title"><span data-bind="text:assessment.candidate.company.displayName"></span> </div>
											</div>
										</div>  

									</td>
								</tr>																									
							</tbody>		                    
			        	</table>
</div>			        	
	                    	
	                   	</div>       
        
        	<h2 class="title-v2">진단직무</h2>
        	<div class="p-xs rounded bordered bg-white m-b-sm">        		
	    	<div class="row">
		   		<div class="col-sm-6">
						<table class="table">
					    	<thead>
					        	<tr>
					            	<th colspan="2"><i class="icon-flat icon-svg icon-svg-md user-color-worker"></i></th>
					           	</tr>
					   		</thead>
					     	<tbody>
								<tr>
									<td width="100">대분류</td>
									<td><span data-bind="{ text: assessment.job.classification.classifiedMajorityName }" class="text-muted"></span></td>
								</tr>	
								<tr>
									<td>중분류</td>
									<td><span data-bind="{text: assessment.job.classification.classifiedMiddleName}" class="text-muted"></span></td>
								</tr>
								<tr>
									<td>소분류</td>
									<td><span data-bind="{text: assessment.job.classification.classifiedMinorityName}" class="text-muted"></span></td>
								</tr>	
								<tr>
									<td>직무</td>
									<td class="bg-primary">
										<span  data-bind="{text: assessment.job.name}" ></span>
									</td>
								</tr>	
								<tr>
									<td>직무정의</td>
									<td>
										<span data-bind="{text: assessment.job.description}" class="text-muted"></span>
									</td>
								</tr>																										
							</tbody>		                    
			        	</table>		                	
		   		</div>
		  		<div class="col-sm-6">
					<table class="table">
				    	<thead>
				           	<tr>
				               	<th>직위</th>
				               	<th>직무경력</th>
				   			</tr>
				      	</thead>
						<tbody data-role="listview"
							class="no-border"
							data-auto-bind="false"	
							data-template="my-assessment-job-level-template"
							data-bind="source:jobLevelDataSource" style="overflow: auto"> 
						</tbody>		                    
					</table>			                	
				</div>		                	
	        </div>   
	        </div>
	                	 		
        	<div class="row">
        		<div class="col-sm-12">
        			<h2 class="title-v2">진단결과</h2>
        			<div id="assessed-summary-chart" />  
					<div id="assessed-summary-grid" />  
				</div>	 
			</div>     	
		</div><!--/end container-->			
 	</div>
	

		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="my-assessment-job-level-template">
		<tr #if ( getMyAssessment().jobLevelName == name ) {# class="bg-primary" #}# >
		    <td>    
		    	#: name #
		    </td>
			<td>
				#:minWorkExperienceYear# ~ #:maxWorkExperienceYear# 년		
			</td>
		</tr>			        
		</script>
				
		<script type="text/x-kendo-template" id="my-assessment-template">
		<form class="ac-custom ac-radio ac-fill" data-object-id="#=questionId#" >
			<div class="headline"><h3>#= seq  #.</h3>  #: competencyName# > #: essentialElementName # </div>
			<h2>#: question #</h2>
			<ul>
			# var rating = getRatingLevels() ; #
			# for (var i = 0; i < rating.length ; i++) { #	
			# var ratingLevel = rating[i] ; #	
			<li>
				<input id="#=uid#-rating-#=ratingLevel.ratingLevelId#" name="#=uid#-rating" type="radio" data-action="answer" data-object-id="#=questionId#" data-object-score="#=ratingLevel.score#" />
				<label for="#=uid#-rating-#=ratingLevel.ratingLevelId#">#: ratingLevel.title #</label>
			</li>
			# } #
			</ul>			
		</form>
		</script>
		<!-- END TEMPLATE -->	
					
</body>
</html>