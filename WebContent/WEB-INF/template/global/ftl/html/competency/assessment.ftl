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
			'css!<@spring.url "/styles/codrops/codrops.cs-select.css"/>',	
			'css!<@spring.url "/styles/codrops/codrops.cs-skin-boxes.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 
			'<@spring.url "/js/codrops/codrops.fullscreenForm.js"/>', 
			'<@spring.url "/js/codrops/codrops.selectFx.js"/>', 
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
			
			
				var formWrap = document.getElementById( 'fs-form-wrap' );
				[].slice.call( document.querySelectorAll( 'select.cs-select' ) ).forEach( function(el) {	
					new SelectFx( el, {
						stickyPlaceholder: false,
						onChange: function(val){
							document.querySelector('span.cs-placeholder').style.backgroundColor = val;
						}
					});
				} );

				new FForm( formWrap, {
					onReview : function() {
						classie.add( document.body, 'overview' ); // for demo purposes only
					}
				} );
					
		}
	} ]);
	
	function createMyAssessment(source){
		var renderTo = $('#my-assessment');	
		var observable =  common.ui.observable({
			assessment:source ,
			questionDataBound : function(e){
				console.log(1);
				$.getScript('<@spring.url "/js/codrops/codrops.svgcheckbx.min.js"/>', 
			          function() {
			               console.log(2);
			          }          
			    );
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
			</div><!--/end container-->
		</div> 	
	  	<div class="container">
	  		<div class="row">
		  		<div class="col-sm-12">
		 			<div class="no-border bg-transparent"
			 				data-role="listview"
			 			    data-auto-bind="false"
							data-template="my-assessment-template"
							data-bind="source:questionDataSource, events:{dataBound:questionDataBound}" style="height: 100%; overflow: auto">		
					</div>	
					<button type="button" class="btn btn-primary btn-flat btn-outline" data-bind="click:saveOrUpdate">완료</button>
		 		</div>
	 		</div>
		</div>			
 	</div>


			<div class="fs-form-wrap" id="fs-form-wrap">
				<div class="fs-title">
					<h1>Project Worksheet</h1>
					<div class="codrops-top">
						<a class="codrops-icon codrops-icon-prev" href="http://tympanus.net/Development/NotificationStyles/"><span>Previous Demo</span></a>
						<a class="codrops-icon codrops-icon-drop" href="http://tympanus.net/codrops/?p=19520"><span>Back to the Codrops Article</span></a>
						<a class="codrops-icon codrops-icon-info" href="#"><span>This is a demo for a fullscreen form</span></a>
					</div>
				</div>
				<form id="myform" class="fs-form fs-form-full" autocomplete="off">
					<ol class="fs-fields">
						<li>
							<label class="fs-field-label fs-anim-upper" for="q1">What's your name?</label>
							<input class="fs-anim-lower" id="q1" name="q1" type="text" placeholder="Dean Moriarty" required/>
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q2" data-info="We won't send you spam, we promise...">What's your email address?</label>
							<input class="fs-anim-lower" id="q2" name="q2" type="email" placeholder="dean@road.us" required/>
						</li>
						<li data-input-trigger>
							<label class="fs-field-label fs-anim-upper" for="q3" data-info="This will help us know what kind of service you need">What's your priority for your new website?</label>
							<div class="fs-radio-group clearfix fs-anim-lower">
								<span><input id="q3b" name="q3" type="radio" value="conversion"/><label for="q3b" class="radio-conversion">Sell things</label></span>
								<span><input id="q3c" name="q3" type="radio" value="social"/><label for="q3c" class="radio-social">Become famous</label></span>
								<span><input id="q3a" name="q3" type="radio" value="mobile"/><label for="q3a" class="radio-mobile">Mobile market</label></span>
							</div>
						</li>
						<li data-input-trigger>
							<label class="fs-field-label fs-anim-upper" data-info="We'll make sure to use it all over">Choose a color for your website.</label>
							<select class="cs-select cs-skin-boxes fs-anim-lower">
								<option value="" disabled selected>Pick a color</option>
								<option value="#588c75" data-class="color-588c75">#588c75</option>
								<option value="#b0c47f" data-class="color-b0c47f">#b0c47f</option>
								<option value="#f3e395" data-class="color-f3e395">#f3e395</option>
								<option value="#f3ae73" data-class="color-f3ae73">#f3ae73</option>
								<option value="#da645a" data-class="color-da645a">#da645a</option>
								<option value="#79a38f" data-class="color-79a38f">#79a38f</option>
								<option value="#c1d099" data-class="color-c1d099">#c1d099</option>
								<option value="#f5eaaa" data-class="color-f5eaaa">#f5eaaa</option>
								<option value="#f5be8f" data-class="color-f5be8f">#f5be8f</option>
								<option value="#e1837b" data-class="color-e1837b">#e1837b</option>
								<option value="#9bbaab" data-class="color-9bbaab">#9bbaab</option>
								<option value="#d1dcb2" data-class="color-d1dcb2">#d1dcb2</option>
								<option value="#f9eec0" data-class="color-f9eec0">#f9eec0</option>
								<option value="#f7cda9" data-class="color-f7cda9">#f7cda9</option>
								<option value="#e8a19b" data-class="color-e8a19b">#e8a19b</option>
								<option value="#bdd1c8" data-class="color-bdd1c8">#bdd1c8</option>
								<option value="#e1e7cd" data-class="color-e1e7cd">#e1e7cd</option>
								<option value="#faf4d4" data-class="color-faf4d4">#faf4d4</option>
								<option value="#fbdfc9" data-class="color-fbdfc9">#fbdfc9</option>
								<option value="#f1c1bd" data-class="color-f1c1bd">#f1c1bd</option>
							</select>
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q4">Describe how you imagine your new website</label>
							<textarea class="fs-anim-lower" id="q4" name="q4" placeholder="Describe here"></textarea>
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q5">What's your budget?</label>
							<input class="fs-mark fs-anim-lower" id="q5" name="q5" type="number" placeholder="1000" step="100" min="100"/>
						</li>
					</ol><!-- /fs-fields -->
					<button class="fs-submit" type="submit">Send answers</button>
				</form><!-- /fs-form -->
			</div><!-- /fs-form-wrap -->
			

		<!-- START TEMPLATE -->	
		<script type="text/x-kendo-template" id="my-assessment-template">
		<form class="ac-custom ac-radio ac-fill">
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