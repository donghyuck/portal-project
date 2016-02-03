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
			'css!<@spring.url "/styles/codrops/codrops.svgcheckbox.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],   			     
		complete : function() {
			common.ui.setup({
				jobs:jobs
			});		
			
			<#if RequestParameters['id']?? >
			var	assessmentId = ${ TextUtils.parseLong( RequestParameters['id'] ) } ;			
			common.ui.ajax( '<@spring.url "/data/accounts/get.json?output=json"/>' , {
				success : function(response){
					var currentUser = new common.ui.data.User($.extend( response.user, { roles : response.roles }));					
					common.ui.ajax( '<@spring.url "/data/me/competency/assessment/get.json?output=json"/>' , {
						data : { assessmentId : assessmentId},
						success : function(response){
							var assessment = new common.ui.data.competency.Assessment(response);		
							createMyAssessment( assessment );
						}
					});
					
				}
			});			
			<#else>
			alert("잘못된 접근입니다.");
			</#if>					
		}
	} ]);
	
	function createMyAssessment(source){
		var renderTo = $('#my-assessment');	
		var observable =  common.ui.observable({
			assessment: source ,
			questionDataBound : function(e){
			console.log(1);
				$.getScript('<@spring.url "/js/codrops/codrops.svgcheckbx.min.js"/>', 
			          function() {
			               console.log(2);
			          }          
			    );
			},
			questionDataSource : new kendo.data.DataSource({
				transport: { 
					read: { url:'<@spring.url "/data/me/competency/assessment/test/list.json?output=json"/>', type:'post' },
					parameterMap: function (options, operation){
						if (operation !== "read") {
							return kendo.stringify(options);
						} 
						return {
							assessmentId: observable.assessment.assessmentId
						};
					}
				},			
				schema: {
					model: common.ui.data.competency.AssessmentQuestion
				}
			})
		});
		renderTo.data("model", observable);	
		kendo.bind(renderTo, observable );	
	}		
	
	function getRatingLevels(){
		var renderTo = $('#my-assessment');	
		return renderTo.data("model").assessment.assessmentPlan.ratingScheme.ratingLevels ;
	}
	
	--></script>
<style>
	h2{
	    display: block;
	    line-height: 1.5em;
	    font-size: 1.5em;
	    -webkit-margin-before: 0.83em;
	    -webkit-margin-after: 0.83em;
	    -webkit-margin-start: 0px;
	    -webkit-margin-end: 0px;
	    font-weight: bold;
	}
</style>
</#compress>
</head>
<body class="bg-dark">
	<div class="page-loader"></div>
 	<div class="wrapper"></div>
  	<div class="container">
 		<div id="my-assessment"> 	
 			<section class="no-border"
				data-template="my-assessment-template"
				data-bind="source:questionDataSource, events:{'dataBound': questionDataBound }" style="height: 100%; overflow: auto">		
			</section>	
 		</div>
  			
	</div>	

		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="my-assessment-template">
		<form class="ac-custom ac-radio ac-fill">
			<h2>#: question #</h2>
			<ul>
			# var rating = getRatingLevels() ; #
			# for (var i = 0; i < rating.length ; i++) { #	
			# var ratingLevel = rating[i] ; #	
			<li>
				<input id="#=uid#-rating-#=ratingLevel.ratingLevelId#" name="#=uid#-rating" type="radio">
				<label for="#=uid#-rating-#=ratingLevel.ratingLevelId#">#: ratingLevel.title #</label>
			</li>
			# } #
			</ul>			
		</form>
		</script>
		<!-- END TEMPLATE -->	
					
</body>
</html>