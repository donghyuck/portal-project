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
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/jszip.min.js"/>',
			'<@spring.url "/js/kendo/pako_deflate.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.all.min.js"/>',
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
	    
	function getPdf( selector ) {
		 kendo.drawing.drawDOM( selector )
	        .then(function(group) {
	            // Render the result as a PDF file
	            return kendo.drawing.exportPDF(group, {
	                paperSize: "auto",
	                margin: { left: "1cm", top: "1cm", right: "1cm", bottom: "1cm" }
	            });
	        })
	        .done(function(data) {
	            // Save the PDF file
	            kendo.saveAs({
	                dataURI: data,
	                fileName: "역량진단결과.pdf",
	                proxyURL: "<@spring.url "/download/export"/>"
	            });
	        });
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
                summaryDataSource : new kendo.data.DataSource({
					transport: { 
						read: { url:'<@spring.url "/data/me/competency/assessment/test/summary.json?output=json"/>', type:'post' },
						parameterMap: function (options, operation){
							if (operation !== "read") {
								return kendo.stringify(options.models);
							} 
							return {
								assessmentId: observable.assessment.assessmentId
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
                }),
				setSource: function(source){
					var $this = this;
					source.copy($this.assessment);	
					$this.set('candidatePhotoUrl',  getUserPhotoUrl($this.assessment.candidate) );
					$this.jobLevelDataSource.data($this.assessment.job.jobLevels);		
					$this.summaryDataSource.fetch( function(){
						var data = this.data();
						createRadarChart(data)
						createBarChart(data);		
					});				
				}
			});		
			
			renderTo.data("model", observable);	
			kendo.bind(renderTo, observable );
			
			common.ui.grid($("#assessed-summary-grid"), {
				autoBind : false,
				dataSource : observable.summaryDataSource,
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
		}
		if( source ){
			renderTo.data("model").setSource(source);
		}
	}		
    
    function createRadarChart(data){
  		var renderTo = $('#assessed-summary-chart');	
		renderTo.kendoChart({
			title: {
				text: "Budget report"
			},
			dataSource: {
				data: data
			},
			seriesDefaults: {
				type: "radarLine",
				style: "smooth"
			},
			series: [{
				name: "본인",
				field: "finalScore"
			}],
			categoryAxis: {
				field: "essentialElementName"
			},
			valueAxis: {
				visible: true
			},
			tooltip: {
			 visible: true
			}
		});	
    }           
               
 	function createBarChart(data) {
 		var renderTo = $('#assessed-summary-bar-chart');	
		renderTo.kendoChart({
			dataSource: {
				data:data,
			},
                title: {
                    text: "Spain electricity production (GWh)"
                },
                seriesDefaults: {
                    type: "bar"
                },
                series: [{
                    field: "finalScore",
                    name: "본인"
                }],
                categoryAxis: {
                    field: "essentialElementName",
                    majorGridLines: {
                        visible: false
                    },
                    minorGridLines: {
                        visible: true
                    },
                    labels: {
                        rotation: "auto"
                    }
                },
                valueAxis: {
                    majorUnit: .5,
                    plotBands: [{
                        from: 0,
                        to: 3,
                        color: "#c00",
                        opacity: 0.3
                    }, {
                        from: 2.97,
                        to: 3,
                        color: "#c00",
                        opacity: 0.8
                    }],
                    max: 6,
                    line: {
                        visible: false
                    }
                },
                tooltip: {
                    visible: true
                }
            });
        }              
               
                    	
	function getMyAssessment(){
		var renderTo = $('#my-assessment');
		return renderTo.data("model").assessment;
	}
	
	function getMyAssessedSummaryGrid(){
		var renderTo = $("#assessed-summary-grid");
		return common.ui.grid(renderTo);
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
	                    <div class="headline">
	                    	<h2>역량진단결과</h2>                    
	                    </div>
	                   
	                </div>
	                <div class="col-sm-4">
						<a href="#" class="btn btn-flat btn-outline btn-labeled btn-primary k-grid-pdf"><span class="btn-label icon fa fa-file-pdf-o"></span>PDF</a>
	                </div>
	            </div><!-- /.row -->
	        </div>    		
        </div>
        
        <div class="container content-md pdf-page">   
        
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
									<td><span data-bind="{ text: assessment.assessmentPlan.formattedStartDate }" class="text-muted"></span> 
										~ 
										<span data-bind="{ text: assessment.assessmentPlan.formattedEndDate }" class="text-muted"></span></td>
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
									<td><span data-bind="{text: assessment.formattedModifiedDate }" class="text-muted"></span></td>
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
        			 
        			<div id="assessed-summary-chart"></div>  
					<div id="assessed-summary-grid"></div>  
					<div id="assessed-summary-bar-chart"></div> 
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