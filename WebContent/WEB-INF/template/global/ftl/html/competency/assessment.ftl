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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/profile.css"/>',	
			
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment/competency-assessment.style.css"/>',		
			
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			
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
			questionDataBound : function(e){
				var $this = this;
				console.log(1);
				$.getScript('<@spring.url "/js/codrops/codrops.svgcheckbx.min.js"/>', 
			          function() {
			               console.log(2);
			               $this.set('visible', true);
			          }          
			    );
			},
			getCandidatePhotoUrl: function(){
				return '<@spring.url "/download/profile/"  />' + this.assessment.candidate.username + '?width=150&height=150'; 
			},
			saveOrUpdate : function(){
				var $this = this;
				$this.questionDataSource.sync();
			},
			questionDataSource : new kendo.data.DataSource({
				batch: true,
				transport: { 
					update: { url:'<@spring.url "/data/me/competency/assessment/test/update.json?output=json"/>', contentType:'application/json', type:'post' },
					read: { url:'<@spring.url "/data/me/competency/assessment/test/list.json?output=json"/>', type:'post' },
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
					model: common.ui.data.competency.AssessmentQuestion
				}
			})
		});
		renderTo.data("model", observable);	
		kendo.bind(renderTo, observable );	
		observable.questionDataSource.read();
		$(document).on("click","[data-action='answer']", function(e){						
			var btn = $(this) ;
			var objectId = btn.data('object-id');
			var objectObjectScore = btn.data('object-score');					
			var assessmentQuestion = observable.questionDataSource.get(objectId);
			assessmentQuestion.set('score', objectObjectScore);				
			common.ui.scroll.top($('form[data-object-id='+ objectId +']').next(), -20);
			
		});
		
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
		
		/** Svg CheckBox */
		.ac-custom h2 {
		    font-size: 1.5em;
		    line-height: 1.5em;
		}	 
		.ac-custom input[type="checkbox"]:checked + label, .ac-custom input[type="radio"]:checked + label {
		    color: #000;
		}	
		
		.ac-custom input[type="checkbox"], .ac-custom input[type="radio"], .ac-custom label::before {
			margin-top: -20px;
		    width: 35px;
		    height: 35px	;
		    top:50%;
		}
		
		.ac-custom label::before {
		    border: 2px solid #000;
		    font-size: 1.5em;
		}
		
		.ac-custom svg {
			top:50%;
			left:8px;
		}
		
		.ac-custom svg path {
	    	stroke: #ff3b30;
	    	stroke-width: 10px;
	    }	
		    
		.ac-custom label {
			font-size: 1.5em;
		    color: rgba(0,0,0,0.8);
		    font-weight: 200;
		    padding: 0 0 0 60px;
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
	
	 	<nav class="one-page-header navbar navbar-default navbar-fixed-top one-page-nav-scrolling one-page-nav__fixed top-nav-collapse" data-role="navigation" data-offset-top="150">
			<div class="container">
				<div class="menu-container page-scroll">
					<a class="navbar-brand no-padding" href="#body">
						<img  src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="${action.webSite.company.name} Logo" style="height:42px; width:auto;">
					</a>
				</div>	
				<div class="tel-block hidden-3xs">
					<i class="icon-flat icon-svg icon-svg-sm business-color-phone"></i>
					1-800-643-4500
				</div>
			</div>
			<!-- /.container -->
		</nav>	
		<section class="intro-section">
		<div class="fullscreen-static-image fullheight" style="position: relative; z-index: 0; height: 307px; background: none;">
				<!-- Promo Content BEGIN -->
				<div class="container valign__middle text-center" style="padding-top: 16.7072px;">
					<div class="row">
						<div class="col-md-8 col-md-offset-2 col-sm-12 col-xs-12 page-scroll">
							<h1 class="g-color-white g-mb-25" data-bind="text:assessment.assessmentPlan.name"></h1>
							<p class="g-color-white g-mb-40"><span data-bind="text:assessment.assessmentPlan.description"></span></p>
							<a href="#footer" class="btn-u btn-u-lg g-bg-default-color btn-u-upper rounded">Contact Us</a>
						</div>
					</div>
				</div>
			  <!-- Promo Content END -->
  		</section>        	
		<section class="container g-mb-30">
		  	<div class="book-section g-bg-default rounded no-margin-b">

							<table class="table">
				            	<thead>
				                	<tr>
				                    	<th>대상자</th>
				                        <th>
											<span data-bind="{ text: assessment.candidate.name, visible: assessment.candidate.nameVisible }"></span>
										</th>
				                    </tr>
				                </thead>
				                <tbody>
					                <tr>
				                    	<td> 선택직무 </td>
				                    	<td> <span data-bind="text: assessment.job.name"></span> </td>
				                   	</tr>
					                <tr>
				                    	<td> 직무수준 </td>
				                    	<td> <span data-bind="text: assessment.jobLevelName"></span> </td>
				                   	</tr>
					                <tr>
				                    	<td> 선택직무 </td>
				                    	<td> 
											<span data-bind="invisible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">자가진단</span>
				                        	<span data-bind="visible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">다면진단</span>
										</td>
				                   	</tr>	
					                <tr>
				                    	<td> 진단문항 </td>
				                    	<td> <span data-bind="text: questionDataSource.total()"></span> </td>
				                   	</tr>					                   				                   					                   	
				             	</tbody>
				             </table>	
				             					
		  	</div>
		  </section>
		    		
        <div class="container content-md">    
	  		<div class="row" data-bind="visible:visible" style="display:none;">
		  		<div class="col-sm-12">
		 			<div class="no-border bg-transparent animated slideInUp"
			 				data-role="listview"
			 			    data-auto-bind="false"
							data-template="my-assessment-template"
							data-bind="source:questionDataSource, events:{dataBound:questionDataBound}" 
							style="min-height:500px; height: 100%; overflow: auto">		
					</div>	
		 		</div>
	 		</div>
		</div><!--/end container-->			
		<div class="m-t-lg animated fadeIn" data-bind="visible:visible" style="display:none;">					
			<button type="button" class="btn btn-primary btn-flat btn-outline btn-block btn-xxl" 
				data-bind="click:saveOrUpdate">진단 완료</button>
		</div>
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