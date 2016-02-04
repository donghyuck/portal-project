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
	
	function getUserPhotoUrl( user ){
		if(common.ui.defined(user.username)){			
			return '<@spring.url "/download/profile/"  />' + user.username + '?width=150&height=150';
		}
		return '<@spring.url "/images/common/no-avatar.png"  />';
	}
	
	function createMyAssessment(source){
		var renderTo = $('#my-assessment');	
		var observable =  common.ui.observable({
			visible : false;
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
					update: { url:'<@spring.url "/data/me/competency/assessment/test/update.json?output=json"/>', type:'post' },
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

		/** Breadcrumbs */
		.breadcrumbs-v3 {
			position:relative;
		}

		.breadcrumbs-v3 p	{
			color : #fff;
			font-size: 16px;
			font-weight: 200;
			margin-bottom: 0;
		}	
		
		.breadcrumbs-v3.img-v1 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}	
		
		
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
		
		.headline h3 {		
			font-size: 2em;
    		font-weight: 600;
    	 	padding-left: 10px;
    		padding-right: 5px;
        	border-bottom-width: 3px;
		}
	</style>
</#compress>
</head>
<body class="">
	<div class="page-loader"></div>
 	<div id="my-assessment" class="wrapper">
		<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
			<div class="personalized-controls container text-center p-xl">
				<h1 class="text-md" data-bind="text:assessment.assessmentPlan.name"></h1>	
				<p class="text-quote" data-bind="text:assessment.assessmentPlan.description"></p>			
				<div class="credit-item">
					<div class="credit-img user">
						<img data-bind="attr:{src: getCandidatePhotoUrl() }" class="img-responsive img-circle">
					</div>
					<div class="credit-name"> <span data-bind="visible: assessment.candidate.nameVisible, text: assessment.candidate.name "></span><code data-bind="text: assessment.candidate.username"></code> </div>
					<div class="credit-title"></div>
				</div>	
									
			</div><!--/end container-->
		</div> 	
	  	<div class="container">
	  		<div class="row animated fadeInDown" data-bind="visisble:visible" style="display:none;">
		  		<div class="col-sm-12">
		 			<div class="no-border bg-transparent"
			 				data-role="listview"
			 			    data-auto-bind="false"
							data-template="my-assessment-template"
							data-bind="source:questionDataSource, events:{dataBound:questionDataBound}" style="min-height:500px; height: 100%; overflow: auto">		
					</div>	
		 		</div>
	 		</div>
		</div>			
		<div class="m-t-lg">					
			<button type="button" class="btn btn-primary btn-flat btn-outline btn-block btn-xxl" data-bind="click:saveOrUpdate">진단 완료</button>
		</div>
 	</div>
	

		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="my-assessment-template">
		<form class="ac-custom ac-radio ac-fill" data-object-id="#=questionId#" >
			<div class="headline"><h3>#= seq + 1 #.</h3>  #: competencyName# > #: essentialElementName # </div>
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