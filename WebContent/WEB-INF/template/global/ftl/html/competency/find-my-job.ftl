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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-v6.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/default.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/profile.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/page_job.css"/>',
			'css!<@spring.url "/styles/jquery.sliding-panel/jquery.sliding-panel.css"/>',	
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment.style.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',				
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',			
			
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.sliding-panel/jquery.sliding-panel.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', ,
			'<@spring.url "/js/wow/wow.min.js"/>', , 
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {		
				
				common.ui.setup({
					features:{
						wow:true,
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){
								e.token.copy(currentUser);
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".promo-bg-img-v2")
					},	
					jobs:jobs
				});	
				handleHeader();				
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();	
				kendo.bind( $(".sliding-panel"), currentUser); 				
				// END SCRIPT 				
			}
		}]);	
		function getCurrentUser () {
			return common.ui.accounts().token ;
		}
		// Fixed Header
		function handleHeader() {
			jQuery(window).scroll(function() {
			  if (jQuery(window).scrollTop() > 100) {
				jQuery('.header-fixed .header-sticky').addClass('header-fixed-shrink');
			  } else {
				jQuery('.header-fixed .header-sticky').removeClass('header-fixed-shrink');
			  }
			});
		}
						
		-->
		</script>		
		<style scoped="scoped">	
				
		/** Breadcrumbs */
		.promo-bg-img-v2 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}		 
		.promo-bg-fixed p {
			color:#f5f5f5;
		}
		
		.arrow-up:after {
			border-bottom: 20px solid #f5f5f5;
		}
		</style>   	
		</#compress>
	</head>
	<body class="header-fixed sliding-panel-ini sliding-panel-flag-right bg-gray">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!--=== Header v6 ===-->
			<div class="header-v6 header-border-bottom header-dark-dropdown header-sticky">
			<!-- Navbar -->
			<div class="navbar mega-menu" role="navigation">
				<div class="container">
					<!-- Brand and toggle get grouped for better mobile display -->
					<div class="menu-container">
						<button type="button" class="navbar-toggle sliding-panel__btn">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<!-- Navbar Brand -->
						<div class="navbar-brand">
							<a href="/">
								<img class="default-logo" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="Logo">
								<img class="shrink-logo" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="Logo">
							</a>
						</div>
						<!-- ENd Navbar Brand --> 
						<!-- Header Inner Right -->		
		
						<!-- End Header Inner Right -->
					</div>
				</div>
			</div>
			<!-- End Navbar -->	
			</div>
			<!--=== End Header v6 ===--> 
			
			<!-- Promo Block -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />				
			<div class="job-img margin-bottom-30 fullheight  bg-dark" style="height:350px;">
				<div class="container valign__middle text-center">
					<div class="margin-bottom-100"></div>	
					
					<div class="job-banner">
						<h2>Discover the Companies You would love to Work for ...</h2>
					</div>
										
					<div class="wow fadeIn" data-wow-delay=".3s" data-wow-duration="1.5s" style="visibility: hidden;">
						<span class="promo-text-v2 color-light margin-bottom-10" >
							<#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }
						</span>
						<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					</div>	
				</div>
			</div>
			</#if>				
			<!-- ./END HEADER -->			
			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
		        <ul class="list-unstyled row portfolio-box team-v1 no-border" id="my-assessment-plan-listview">
		        </ul>
		    </div>

			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
	
			<!-- ./END FOOTER -->					
		</div>				

		<#include "/html/competency/common-sliding-panel.ftl" >		

	</body>    
</html>