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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/one.style.css"/>',	
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment/competency-assessment.style.css"/>',			
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',	
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',		
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
			        
			$(window).on("resize", function() {
		      kendo.resize($(".chart-wrapper"));
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
	                margin: { left: "1cm", top: "1cm", right: "1cm", bottom: "1cm" },
	                multiPage : true
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
				assessment: new common.ui.data.competency.Assessment(),
				finalTotalScore : 0 ,
				finalMaxScore : 0,
				finalMinScore : 0,
				finalAvgScore : 0,
				saveAsPdf:function(){
					getPdf( renderTo.find('.pdf-page') );
					return false;
				},
				candidatePhotoUrl: null,
				jobLevelDataSource :new kendo.data.DataSource({
					data : [],
					schema: {
                    	model: common.ui.data.competency.JobLevel
                    }
                }), 
                competencyDataSource :new kendo.data.DataSource({
					data : [],
					schema: {
                    	model: common.ui.data.competency.JobLevel
                    }
                }),          
				elementDataSource :new kendo.data.DataSource({
					data : []
                }),                        
                summaryDataSource : new kendo.data.DataSource({
					transport: { 
						read: { url:'<@spring.url "/data/me/competency/assessment/test/scores.json?output=json"/>', type:'post' },
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
	                        	finalScore: { type: "number" },
	                        	othersAverageScore: { type: "number" }
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
					$this.competencyDataSource.data( $this.assessment.competencies );		
					$this.competencyDataSource.filter( { field: "level", operator: "gte", value: $this.assessment.jobLevel });
					
					
					$this.summaryDataSource.fetch( function(){
						var data = this.data();
						$this.elementDataSource.data(data);
						var aggregates = $this.summaryDataSource.aggregates();
						console.log( kendo.stringify (aggregates) );
						$this.set('finalTotalScore', aggregates.finalScore.sum);
						$this.set('finalMaxScore', aggregates.finalScore.max);
						$this.set('finalMinScore', aggregates.finalScore.min);
						$this.set('finalAvgScore', aggregates.finalScore.average);
						createRadarChart($('#assessed-summary-chart'), '영역별 점수 비교',  data)
						createBarChart(data);		
						$("#assessed-competency-details").kendoListView({
						     dataSource: $this.competencyDataSource,
						     template: kendo.template($("#my-assessed-conpetency-detail-template").html()),
						     dataBound: function(){						     	
						     	$("#assessed-competency-details").removeClass("k-widget k-listview");						     	
						     	$.each(this.dataItems(), function( index, item ) {
						     		var _renderTo = $('[data-uid=' + item.uid + ']');
						     		var _dataSource = new kendo.data.DataSource({ 
						     			data : $this.elementDataSource.data(), 
						     			sort: { field: "finalScore", dir: "asc" },
						     			filter: { field: "competencyId", operator: "eq", value: item.get("competencyId") }
						     		});
						     		common.ui.grid(_renderTo.find('.grid'), {
						     			dataSource : _dataSource,
						     			editable:false,
	   									scrollable : false,
	   									
	   									columns : [
	   										{ 'field': 'essentialElementName', title:'영역' },
	   										{ 'field': 'finalScore', title:'본인점수'},
	   										{ 'field': 'othersAverageScore', title:'전체평균'}
	   									]
						     		});
						     		createRadarChart(_renderTo.find('.chart'), null , _dataSource.view() );			     	
						     	});
						     }
						 });
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
	            	{ 'field': 'finalScore', title:'점수/문항수', aggregates: ["sum", "max", "min"], groupFooterTemplate: '역량점수 :  <span>#= sum #</span>', footerTemplate: "총점: #=sum #"  }                                 
	            ]
			} );
		}
		if( source ){
			renderTo.data("model").setSource(source);
		}
	}		
    
    function createRadarChart(renderTo, title, data){
		renderTo.kendoChart({
			title: {
				text: title
			},
			legend: {
                position: "bottom"
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
			},
			{
				name: "전체",
				field: "othersAverageScore"
			}],
			categoryAxis: {
				field: "essentialElementName"
			},
			valueAxis: {
				visible: true,
				min: 0,
				max: 5
			},
			tooltip: {
			 visible: true
			}
		});	
    }           
               
 	function createBarChart(data) {
 		var renderTo = $('#assessed-summary-bar-chart');	
		renderTo.kendoChart({
			encoding : "UTF-8",
			dataSource: {
				data:data,
			},
			
                title: {
                    text: "척도에 따른 영역별 점수 분포"
                },
                seriesDefaults: {
                    type: "bar"
                },
                series: [{
                    field: "finalScore",
                    name: "본인"
                },
                {
					name: "전체",
					field: "othersAverageScore"
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
                        rotation: "auto",
                        font: '400 .9em "나눔 고딕", "Nanum Gothic"'
                    }
                },
                valueAxis: {
                    majorUnit: .5,
                    plotBands: [{
                        from: 0,
                        to: 3,
                        color: "#c00",
                        opacity: 0.2
                    }, {
                        from: 2.995,
                        to: 3,
                        color: "#c00",
                        opacity: 0.9
                    },
                    {
                        from: 3,
                        to: 3.75,
                        color: "#1A96E5",
                        opacity: 0.2
                    },
                    {
                        from: 3.75,
                        to: 4,
                        color: "#1A96E5",
                        opacity: 0.4
                    },
                    {
                        from: 3.995,
                        to: 4,
                        color: "#1A96E5",
                        opacity: 0.9
                    },
                    {
                        from: 4,
                        to: 5,
                        color: "#1A96E5",
                        opacity: 0.6
                    }
                    
                    ],
                    min: 0,
                    max: 5,
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
	
		.k-widget {
	        font-family: "나눔 고딕", "Nanum Gothic";
	        font-weight:400;
	        font-size: 1em;
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
			
			/**
			background:#fff;
			 */
			 background:rgba(242,242,242,0.6);
			 border-bottom: 3px solid #efefef;
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
		
		.assessed_final_score {
			display:block;
			font: 400 12px Arial, Helvetica, sans-serif;
			font-size: 110px;
		    line-height: 1em;
		    letter-spacing: -2px;
		    text-indent: -8px;
		    color: #fff;		
		}  

		.service-block-v3 .service-in small {
		    text-transform: uppercase;
		    /*font-family: Arial, Helvetica, sans-serif;*/
		    font-size: .8em;
		    color:#333;
		}		
			
		.bg-selected {
			background-color: #3498db!important;
			color:#fff;
		}	
		
		.service-block-v3 .service-in h4 {
			font-family: Arial, Helvetica, sans-serif;
		}
		
		.service-block-header {		
			padding: 20px;
		}
		
		.service-block-body{
			padding: 20px;
			background-color: #fff!important;
			color:#333!important;
		}

		.highest {
		    color: #639514!important;
		    font-size: 36px!important;	
		}
		.average {			
		    color: #4da3d5!important;
		    font-size: 36px!important;	
		}		
		.lowest {			
		    color: #cd151e!important;
		    font-size: 36px!important;	
		}
		
		.score-image {
		    display: inline-block!important;
		    border-radius: 50%!important;
		    background-size: 48px 48px;
		    background-position: center center;
		    vertical-align: middle;
		    line-height: 32px;
		    box-shadow: inset 0 0 1px #999, inset 0 0 10px rgba(0,0,0,.2);
		    margin-left: 0px;
		}							
	</style>
</#compress>
</head>
<body class="">
	<div class="page-loader"></div>
 	<div id="my-assessment" class="wrapper"> 	
	 	<nav class="one-page-header navbar navbar-default navbar-fixed-top one-page-nav-scrolling one-page-nav__fixed top-nav-collapse" data-role="navigation" data-offset-top="150">
			<div class="container">
				<div class="menu-container page-scroll">
					<a class="navbar-brand no-padding" href="#body">
						<img  src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="${action.webSite.company.name} Logo" style="height:42px; width:auto;">
					</a>
				</div>	
				<div class="tel-block hidden-3xs">
					<i class="icon-electronics-042"></i> 1-800-643-4500
				</div>
			</div>
			<!-- /.container -->
		</nav>	
		<div class="header-v6 header-classic-dark header-sticky p-xs">
			<div class="container">
				<div class="row">
	                <div class="col-sm-8">
	                </div>
	                <div class="col-sm-4 text-right">
						<a href="#" class="icon-svg-btn " data-bind="click:saveAsPdf">
							<i class="btn-label icon-flat icon-svg icon-svg-sm file-color-pdf"></i>
						</a>	
	                </div>
	            </div><!-- /.row -->
	        </div>    		
        </div>
        
        <div class="container content-md pdf-page">           
 			<div class="ibox bordered rounded">
				<div class="ibox-title">
					<h2 data-bind="text:assessment.assessmentPlan.name"></h2>                        
				</div>
				<div class="ibox-content bg-transparent">
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
										<td class="bg-selected">
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
						<table class="table">
					    	<thead>
					           	<tr>
					               	<th>필요역량</th>
					               	<th>수준</th>
					   			</tr>
					      	</thead>
							<tbody data-role="listview"
								class="no-border"
								data-auto-bind="false"	
								data-template="my-assessment-competency-template"
								data-bind="source:competencyDataSource" style="overflow: auto"> 
							</tbody>		                    
						</table>									                	
					</div>		                	
		        </div>   
	        </div>
	                	 		
	        <h2 class="title-v2">진단결과</h2>        	 		
        	<div class="row">
        		<div class="col-sm-12">        		
						<div class="row margin-bottom-10">
							<div class="col-sm-6 sm-margin-bottom-20">
								<div class="service-block-v3 service-block-u no-padding rounded">
								<div class="service-block-header">
									<i class="icon-flat icon-svg icon-svg-md business-color-for-beginner"></i>
									<span class="service-heading" style="font-size:.8em;" >직무역량진단결과</span>
									<span class="assessed_final_score" data-bind="text:finalTotalScore"></span>
									<div class="clearfix margin-bottom-10"></div>
								</div>	
								<div class="service-block-body rounded-bottom">	
									<div class="row">
										<div class="col-xs-4 service-in">
											<small>가장낮은영역점수</small>
											<h4 class="counter lowest" data-bind="text:finalMinScore"></h4>
										</div>
										<div class="col-xs-4 text-center service-in">
											<small>평균영역점수</small>
											<h4 class="counter average" data-bind="text:finalAvgScore" data-format="##.##"></h4>
										</div>
										<div class="col-xs-4 text-right service-in">
											<small>가장높은영역점수</small>
											<h4 class="counter highest" data-bind="text:finalMaxScore"></h4>
										</div>
									</div>
								</div>	
								</div>
							</div>

							<div class="col-sm-6">
							<!--
								<div class="service-block-v3 service-block-blue no-padding">
								<div class="service-block-header">
									<i class="icon-screen-desktop"></i>
									<span class="service-heading">Overall Page Views</span>
									<span class="counter">324,056</span>
								</div>
									<div class="clearfix margin-bottom-10"></div>
								<div class="service-block-body">
									<div class="row margin-bottom-20">
										<div class="col-xs-6 service-in">
											<small>Last Week</small>
											<h4 class="counter">26,904</h4>
										</div>
										<div class="col-xs-6 text-right service-in">
											<small>Last Month</small>
											<h4 class="counter">124,766</h4>
										</div>
									</div>
									<div class="statistics">
										<h3 class="heading-xs">Statistics in Progress Bar <span class="pull-right">89%</span></h3>
										<div class="progress progress-u progress-xxs">
											<div style="width: 89%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="89" role="progressbar" class="progress-bar progress-bar-light">
											</div>
										</div>
										<small>15% higher <strong>than last month</strong></small>
									</div>
								</div>	
								</div>
							-->
							</div>
						</div>
						

			<div class="clearfix margin-bottom-20"></div>
			<div class="separator-2"></div>  
			<h3>1. 전체 진단 영역별 점수 분석</h3> 
								
					<div class="p-xs rounded bordered bg-white m-b-sm margin-bottom-10">	
						<div id="assessed-summary-chart"></div>  				
					</div>

					        			
					<div id="assessed-summary-grid" class="margin-bottom-10"></div>  

			<div class="clearfix margin-bottom-20"></div>
			<div class="separator-2"></div>  
			<h3>2. 진단 척도에 따른 영역별 점수 분석</h3> 
								
					<div class="p-xs rounded bordered bg-white m-b-sm margin-bottom-10">		
						<div id="assessed-summary-bar-chart"></div> 		
					</div>
					
					<div data-role="grid"
						data-auto-bind="false"
                 		data-editable="false"
                 		data-sortable="true"
                 		data-scrollable="false"
                 		data-columns="[
                 			{ 'field': 'competencyName', title:'역량' },
                        	{ 'field': 'essentialElementName', title:'진단영역'},
                        	{ 'field': 'finalScore', title:'본인점수', 'sortable':true , width:100},
                        	{ 'field': 'othersAverageScore', title:'전체평균', 'sortable':false , width:100},
                        	{ 'field': 'finalScore', title:'결과', 'sortable':false, 'template':$('\#my-assessed-score-column-template').html() },
                      	]"
                		 data-bind="source:elementDataSource"
                		 style="min-height:200px"></div>
                 
				</div>	 
			</div>   
			<div class="clearfix margin-bottom-20"></div>
			<div class="separator-2"></div>  
			<h3>3. 역량별 상세 분석</h3>        	 		
        	<div id="assessed-competency-details" class="no-border bg-transparent"></div>	
		</div><!--/end container-->			
 	</div>
	

		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="my-assessed-conpetency-detail-template">		
		<div class="ibox">			
			<h5><i class="fa fa-circle-o"></i> #: name  #</h5>
			<p>#: description #</p>
			<div class="ibox-content rounded-bottom" style="padding:5px; border:1px solid \#dbdbdb;">
				<div class="row">
					<div class="col-sm-12">
						<div class="chart chart-wrapper" style="height:320px;"></div>
					</div>
					<div class="col-sm-6">
						<div class="grid"></div>
					</div>
				</div>
			</div>
		</div>						
		</script>	
		
		
		<script type="text/x-kendo-template" id="my-assessed-score-column-template">			
			#if ( data.finalScore <= 3 ) {#
			<i class="score-image icon-flat icon-svg icon-svg-md basic-color-siren"></i>	
			<span class="text-danger">지속적 노력이 필요</span> 		
			#}else if ( data.finalScore > 3 && data.finalScore < 3.75 ) {#
			<i class="score-image icon-flat icon-svg icon-svg-md sports-color-walking"></i>
			단기간 향상이 가능
			#}else if ( data.finalScore >= 3.75 && data.finalScore < 4 ){#
			<i class="score-image icon-flat icon-svg icon-svg-md sports-color-running"></i>
			목표 영역
			#}else if ( data.finalScore >= 4){#
			<i class="score-image icon-flat icon-svg icon-svg-md sports-color-exercise"></i>
			강점 영역
			#}#
		</script>		

		<script type="text/x-kendo-template" id="my-assessment-competency-template">
		<tr>
		    <td>    
		    	#: name #
		    </td>
			<td>
				#: level # 수준	
			</td>
		</tr>			        
		</script>
				
		<script type="text/x-kendo-template" id="my-assessment-job-level-template">
		<tr #if ( getMyAssessment().jobLevelName == name ) {# class="bg-selected" #}# >
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