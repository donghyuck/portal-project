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
				'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',		
				
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment.style.css"/>',		
			
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			
			'css!<@spring.url "/styles/codrops/codrops.svgcheckbox.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',	
			
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
						wallpaper : true				
					},
					wallpaper : {
						renderTo:$(".fullscreen-static-image")
					},	
					jobs:jobs
				});	
			
			handleHeader();
			
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
	
	function formattedDateString( date ){
		console.log( typeof date === "date" );
	}
	
	function createMyAssessment(source){
		var renderTo = $('#my-assessment');	
		if( !renderTo.data("model") ){		
			var observable =  common.ui.observable({
				warning : false,
				visible : false,
				completable : false,
				unAnsweredCount : 0,
				assessment: new common.ui.data.competency.Assessment(),
				formattedStartDate : function(){
					var $this = this;
					return kendo.toString( 'g' , new Date($this.assessment.assessmentPlan.startDate) );				
				},
				questionDataBound : function(e){
					var $this = this;
					$.getScript('<@spring.url "/js/codrops/codrops.svgcheckbx.min.js"/>', 
				          function() {
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
				competencyDataSource :new kendo.data.DataSource({
					data : [],
					schema: {
                    	model: common.ui.data.competency.JobLevel
                    }
                }),
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
					},
					sync: function(e) {
						common.redirect("<@spring.url "/display/assessment/my-assessment-report.html"/>", {id: renderTo.data("model").assessment.assessmentId}, "POST");
					}
				}),
				setQuestionAnswer: function( questionId, answer ){
					var $this = this;
					var assessmentQuestion = $this.questionDataSource.get(questionId);
					var totalCount = $this.get('unAnsweredCount');
					
					assessmentQuestion.set('score', answer );	
					$.each( $this.questionDataSource.view(), function(index, value){
						if( value.get('questionId') == questionId && value.get('score') > 0 ){
							totalCount = totalCount - 1;
						}
					});						
					console.log( 'un answered count : ' + totalCount ); 
					$this.set('unAnsweredCount', totalCount );				
					if( totalCount == 0 ){
						$this.set('completable', true);
					}
				},
				setSource: function(source){
					var $this = this;
					source.copy($this.assessment);	
					$this.competencyDataSource.data( $this.assessment.competencies );	
					$this.questionDataSource.fetch(function(e){						
						$this.set('unAnsweredCount', this.total());			
						if( this.total() == 0 ){
							$this.set('warning', true);
						}			
					});
				}		
			});
			renderTo.data("model", observable);	
			kendo.bind(renderTo, observable );	
			$(document).on("click","[data-action='answer']", function(e){						
				var btn = $(this) ;
				var seq = btn.data('seq');
				var objectId = btn.data('object-id');
				var objectObjectScore = btn.data('object-score');	
				var elem = $('form[data-object-id=' + objectId + ']');
								
				observable.setQuestionAnswer( objectId, objectObjectScore);				
				elem.attr('answered', true);			
									
				if( observable.unAnsweredCount  > 0 ){
					if( elem.next().length == 0 ){
						common.ui.scroll.top($('form[answered]').first(), -20);	
					}else{
						$.each( $('form[answered=false]'), function( index, value ){
							var that = $(value);
							if( that.data('seq') > seq ){
								common.ui.scroll.top(that, -20);
								return false;
							}
						});
					}
				}else{
					common.ui.scroll.top($('form[answered]').last(), 20);				
				}
			});
		}
		
		if( source ){
			renderTo.data("model").setSource(source);
		}
	}		
	
	function getRatingLevels(){
		var renderTo = $('#my-assessment');	
		return renderTo.data("model").assessment.assessmentPlan.ratingScheme.ratingLevels ;
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
		
		.navbar-brand>img {
			width:auto;
			height:55px;
		}
	</style>
</#compress>
</head>
<body class="bg-gray">
	<div class="page-loader"></div>
	
 	<div id="my-assessment" class="wrapper"> 	
	
	 	<nav class="one-page-header navbar navbar-default navbar-fixed-top one-page-nav-scrolling one-page-nav__fixed top-nav-collapse assessment-nav" data-role="navigation" data-offset-top="150">
			<div class="container">
				<div class="menu-container page-scroll">
					<a class="navbar-brand no-padding" href="#body">
						<img src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="Logo">
					</a>
				</div>
				<div class="tel-block hidden-3xs">
					<i class="icon-flat icon-svg icon-svg-sm business-color-phone"></i>
					070-7807-4040
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
						</div>
					</div>
				</div>
			  <!-- Promo Content END -->
  		</section>        	
		<section class="container g-mb-30">
		  	<div class="book-section g-bg-default rounded-2x no-margin-b animated fadeIn" data-bind="visible:visible" style="display:none;">
		  	
		  								<div class="alert alert-danger animated toda no-border rounded" data-bind="visible:warning" style="display:none;">
								<strong>죄송합니다 !!!  </strong> 선택하신 <span data-bind="text: assessment.jobLevelName"></span>는 아직 진단 문항이 준비되어 있지 않습니다. <br>
								<hr class="m-sm"/>
								<a href="<@spring.url "/display/competency/my-assessment.html" />" class="btn btn-info btn-flat btn-outline rounded">이전으로 돌아가기</a>										
							</div>
							
				<div class="row">
					<div class="col-sm-6">
						

								
						
							<table class="table no-margin-b">
						    	<thead>
						           	<tr>
						               	<th colspan="2">기본정보</th>
						   			</tr>
						      	</thead>							
				                <tbody>
					                <tr>
				                    	<td width="150"> 대상자 </td>
				                    	<td> <span data-bind="{ text: assessment.candidate.name}"></span> </td>
				                   	</tr>
					                <tr>
				                    	<td> 선택직무 </td>
				                    	<td> <span data-bind="text: assessment.job.name"></span> </td>
				                   	</tr>
					                <tr>
				                    	<td> 직무수준 </td>
				                    	<td> <span data-bind="text: assessment.jobLevelName"></span> ( <span data-bind="text: assessment.jobLevel"></span>수준 )</td>
				                   	</tr>
									<tr>
										<td>진단기간</td>
										<td><span data-bind="{ text: assessment.assessmentPlan.formattedStartDate }" ></span> 
											~ 
											<span data-bind="{ text: assessment.assessmentPlan.formattedEndDate }" ></span></td>
									</tr>				                   	
					                <tr>
				                    	<td>진단방법 </td>
				                    	<td> 
											<span data-bind="invisible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">자가진단</span>
				                        	<span data-bind="visible:assessment.assessmentPlan.feedbackEnabled" style="display:none;">다면진단 (360 degree feedback)</span>
										</td>
				                   	</tr>	
					                <tr>
				                    	<td> 진단문항 </td>
				                    	<td> <span data-bind="text: questionDataSource.total()"></span> </td>
				                   	</tr>					                   				                   					                   	
				             	</tbody>
				             </table>
					</div>
					<div class="col-sm-6">
						<table class="table">
					    	<thead>
					           	<tr>
					               	<th >진단역량</th>
					               	<th width="150">수준</th>
					   			</tr>
					      	</thead>
							<tbody data-role="listview"
								class="no-border bg-transparent"
								data-auto-bind="false"	
								data-template="my-assessment-competency-template"
								data-bind="source:competencyDataSource" style="overflow: auto; color:#fff;"> 
							</tbody>		                    
						</table>	
					</div>
				</div>
		  	</div>
		  </section>
		    		
        <div class="container content">    
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
		<div class="m-t-lg animated slideInUp" data-bind="visible: completable" style="display:none;">					
			<button type="button" class="btn btn-primary btn-flat btn-outline btn-block btn-xxl" 
				data-bind="click:saveOrUpdate">진단 완료</button>
		</div>
 	</div>
	

		<!-- START TEMPLATE -->	
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
				
		<script type="text/x-kendo-template" id="my-assessment-template">
		<form class="ac-custom ac-radio ac-fill" data-object-id="#=questionId#" data-seq="#=seq#" answered="false">
			<div class="headline"><h3>#= seq  #.</h3>  #: competencyName# > #: essentialElementName # </div>
			<h2>#: question #</h2>
			<ul>
			# var rating = getRatingLevels() ; #
			# for (var i = 0; i < rating.length ; i++) { #	
			# var ratingLevel = rating[i] ; #	
			<li>
				<input id="#=uid#-rating-#=ratingLevel.ratingLevelId#" name="#=uid#-rating" type="radio" data-action="answer" data-seq="#=seq#" data-object-id="#=questionId#" data-object-score="#=ratingLevel.score#" />
				<label for="#=uid#-rating-#=ratingLevel.ratingLevelId#">#: ratingLevel.title #</label>
			</li>
			# } #
			</ul>			
		</form>
		</script>
		<!-- END TEMPLATE -->	
					
</body>
</html>