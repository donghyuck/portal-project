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
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 	
			'<@spring.url "/js/common.plugins/switchery.min.js"/>',	
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 		
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
			],			
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},	
					jobs:jobs
				});	
						
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				// END SCRIPT 				
			}
		}]);			

		
		-->
		</script>		
		<style scoped="scoped">	
				
		/** Breadcrumbs */
		.breadcrumbs-v3 {
			position:relative;
		}

		.breadcrumbs-v3 p	{
			color : #fff;
			font-size: 24px;
			font-weight: 200;
			margin-bottom: 0;
		}	
		
		.breadcrumbs-v3.img-v1 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}		 
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>					
					<a href="<@spring.url "/display/0/my-home.html"/>"><span class="btn-flat home t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>					
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<button class="btn-link hvr-pulse-shrink" data-action="create" data-object-type="40"><i class="icon-flat microphone"></i></button>
					<button class="btn-link hvr-pulse-shrink"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>				
			<!-- ./END HEADER -->			
			<!-- START MAIN CONTENT -->
			<div class="container content">
				<div class="row">
					<div class="col-sm-6">
						
					</div>	
					<div class="col-sm-6">
					<h2 class="title-v2">국가직무능력표준 기반 직업역량진단</h2>
					
					<p>Self taught versus academic qualifications</p>
					
					<p>This was the question posed on Donald Trump’s The Apprentice. For those not familiar with this show, two groups of people competed over a series of weeks by performing various business related tasks.</p>
					
					<p>The winner would eventually become Donald Trump’s apprentice. One group was made up of people with academic qualifications. The other group was made up of people who didn’t have qualifications, but were self taught and running their own businesses.</p>
					
					<p>This is a good place to start understanding what competency assessment is all about. The only way to know whether street smarts or book smarts is better, is to look at individual people in their own right. Assessing people using their knowledge and skills in an on the job situation is the key to competency assessment.</p>
					
					<p>Every job requires a specific set of knowledge and skills. And this varies depending on the type and complexity of the job. More than just knowing whether street smarts or book smarts is better, competency assessment is all about providing a way of building the skills and knowledge people need to perform their current job. It is also the key element of the succession planning process because it provides a way of developing people for their future roles.</p>

					<a href="<@spring.url "/display/competency/my-assessment.html" />" class="btn-u btn-brd btn-u-lg btn-brd-hover btn-u-dark">직업역량진단 체험하기</a>

					</div>
				</div>
			</div>
			
			<div class="bg-color-light">
				<div class="container content-sm">
					<div class="row">
						<div class="col-md-6 md-margin-bottom-50">
							<img class="img-responsive" src="assets/img/mockup/imac2.png" alt="">
						</div>
						<div class="col-md-6">
							<br><br><br>
							<div class="headline-left margin-bottom-30">
								<h2 class="headline-brd">WE ARE UNIFY AGENCY</h2>
								<p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form.</p>
							</div>
							<ul class="list-unstyled lists-v2 margin-bottom-30">
								<li><i class="fa fa-check"></i> Suspendisse eget augue non dolor ultrices</li>
								<li><i class="fa fa-check"></i> Donec eget aliquet tortor, quis lacinia dolor</li>
								<li><i class="fa fa-check"></i> Curabitur ut augue at mi eleifend lobortis</li>
								<li><i class="fa fa-check"></i> Eleifend eget aliquet tortor, quis lacinia dolor</li>
							</ul>
							<a href="#" class="btn-u btn-brd btn-brd-hover btn-u-dark">Learn More</a>
						</div><!--/end row-->
					</div>
				</div>
			</div>			
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				

						
		<!-- START TEMPLATE -->	
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- ./END TEMPLATE -->
	</body>    
</html>