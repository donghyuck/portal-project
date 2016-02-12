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
							createMyAssessment( assessment );
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
	
	function getUserPhotoUrl( user ){
		if(common.ui.defined(user.username)){			
			return '<@spring.url "/download/profile/"  />' + user.username + '?width=150&height=150';
		}
		return '<@spring.url "/images/common/no-avatar.png"  />';
	}
	
	function createMyAssessment(source){
		var renderTo = $('#my-assessment');	
		var observable =  common.ui.observable({
			visible : false,
			assessment:source ,
			getCandidatePhotoUrl: function(){
				return '<@spring.url "/download/profile/"  />' + this.assessment.candidate.username + '?width=150&height=150'; 
			},
			summaryDataSource : new kendo.data.DataSource({
				batch: true,
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
						 { field: "finalScore", aggregate: "average" }			
					] 
				},
				aggregate: [
					{ field: "finalScore", aggregate: "average" },
                	{ field: "finalScore", aggregate: "min" },
                    { field: "finalScore", aggregate: "max" }]
				
				
			})
		});
		renderTo.data("model", observable);	
		kendo.bind(renderTo, observable );	
		observable.summaryDataSource.read();
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
	                    	<h2 data-bind="text:assessment.assessmentPlan.name"></h2>                    
	                    </div>
	                    <p class="text-muted" data-bind="text:assessment.assessmentPlan.description"></p>
	                </div>
	                <div class="col-sm-4">
						<div class="ibox no-margin">
	                		<div class="ibox-title">
	                        	<h5 class="text-gray">진단대상자</h5>   
	                        	<i class="icon-flat icon-svg icon-svg-sm basic-color-center-location" style="
								    position: absolute;
								    top: 10px;
								    right: 20px;
								"></i>                     
	                    	</div>
			            	<div class="ibox-content">
								<div class="page-credits">				
									<div class="credit-item">
										<div class="credit-img user">
											<img data-bind="attr:{src: getCandidatePhotoUrl() }" class="img-responsive img-circle" src="<@spring.url "/images/common/anonymous.png"/>">
										</div>
										<div class="credit-name">
											<span data-bind="{ text: assessment.candidate.name, visible: assessment.candidate.nameVisible }"></span>
											&nbsp;
											<span class="text-muted" data-bind="{ text: assessment.candidate.username }"></span>
										</div>
										<div class="credit-title"><span data-bind="text:assessment.candidate.company.displayName"></span> </div>
									</div>
								</div>                  
								<ul class="list-unstyled project-details">                        
			                        <li><strong>직무:</strong> <span data-bind="text: assessment.job.name"></span></li>
			                        <li><strong>직무수준:</strong> <span data-bind="text: assessment.jobLevelName"></span></li>
			                        <li><strong>진단방법:</strong> 
			                        	<span data-bind="invisible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">자가진단</span>
			                        	<span data-bind="visible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">다면진단</span>
			                        </li>
		                    	</ul> 	
	                   		</div>
	                   	</div>
	                </div>
	            </div><!-- /.row -->
	        </div>    		
        </div>
        <div class="container content-md">   

			<div data-role="grid"
                 data-editable="false"
                 data-scrollable="false"
                 data-columns="[
                              	 { 'field': 'competencyName', title:'역량' },	
                                 { 'field': 'essentialElementName', title:'하위요소' },
                                 { 'field': 'totalCount' , title:'문항수'},
                                 { 'field': 'totalScore', title:'점수' },
                                 { 'field': 'finalScore', title:'&nbsp;', groupFooterTemplate: '역량평균 :  #= average #', aggregates:'[min, max, count]', footerTemplate: '<div>Min: #= min #</div><div>Max: #= max #</div>'  }                                 
                              ]"
                 data-bind="source: summaryDataSource"
                 ></div>
	  		
		</div><!--/end container-->			
 	</div>
	

		<!-- START TEMPLATE -->	
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