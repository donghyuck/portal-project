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
				getClassifiedMajoritySelector();		
				// END SCRIPT 				
			}
		}]);	
		function getCurrentUser () {
			return common.ui.accounts().token ;
		}
		
		function getClassifiedMajoritySelector(){
			var renderTo = $("#classified-majority");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classify-type-dorpdown-list",
					optionLabel: "대분류",
					/*autoBind:false,*/
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					 
					 valueTemplate: '---<span class="selected-value"></span><span>#:data.name#</span>',
					 
					dataSource: {
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/data/me/competency/job/category/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  1 }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});				
				//getClassifiedMiddleSelector();
				//getClassifiedMinoritySelector();
			}
			return renderTo.data('kendoDropDownList');
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
		
		/* kendo listbox styling */
		ul.k-list > li.k-item:hover 
		{
			border: solid 1px #fc756f!important;
			background: #fc756f!important;
			color: #fff;	
		}               
		
		.k-dropdown .k-state-focused {
			color: #fc756f!important;
			background: #fff;			
		
		}
		 
		
		</style>   	
		</#compress>
	</head>
	<body class="header-fixed sliding-panel-ini sliding-panel-flag-right">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!--=== Header v6 ===-->
			<div class="header-v6 header-dark-dropdown header-sticky">
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
			<div class="promo-bg-img-v2 job-img fullheight promo-bg-fixed bg-dark" style="height:350px;">
				<div class="container valign__middle text-center">
					<div class="margin-bottom-100"></div>	
					<div class="wow fadeIn" data-wow-delay=".3s" data-wow-duration="1.5s" style="visibility: hidden;">
						<span class="promo-text-v2 color-light margin-bottom-10" >
							<#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }
						</span>
						<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					</div>	
				</div>
				<div class="job-img-inputs">
					<div class="container">
						<div class="row">
							<div class="col-sm-4 md-margin-bottom-10">
								<input id="classified-majority" placeholder="원하는 직무의 대분류를 선택하세요." style="font-size: 1.6em; color: #bcbcbc; width:100%"/>
							</div>
							<div class="col-sm-4 md-margin-bottom-10">
								<div class="input-group">
									<span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
									<input type="text" placeholder="where would you like to work" style>
								</div>
							</div>
							<div class="col-sm-4">
								<button type="button" class="btn-u btn-block btn-u-dark"> Search Job</button>
							</div>
						</div>
					</div>
				</div>								
			</div>
			</#if>				
			<!-- ./END HEADER -->			
			<div class="full-w-block">
				<div class="container">
					<div class="row">
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-bell-o icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>Accounting</h3>
									<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium</p>
								</div>
							</div>
						</div>
	
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-laptop icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>10,000+ jobs</h3>
									<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium</p>
								</div>
							</div>
						</div>
	
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-bullhorn icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>Web Design</h3>
									<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
		        <div class="headline"><h2>Job Categories</h2></div>
		        <div class="row job-content margin-bottom-40">
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Accounting &amp; Finance</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Accounting</a> <small class="hex">(342 jobs)</small></li>
						<li><a href="#">Admin &amp; Clerical</a> <small class="hex">(143 jobs)</small></li>
						<li><a href="#">Banking &amp; Finance</a> <small class="hex">(66 jobs)</small></li>
						<li><a href="#">Contract &amp; Freelance</a> <small class="hex">(12 jobs)</small></li>
						<li><a href="#">Business Development</a> <small class="hex">(212 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Medicla &amp; Health</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Nurse</a> <small class="hex">(546 jobs)</small></li>
						<li><a href="#">Health Care</a> <small class="hex">(82 jobs)</small></li>
						<li><a href="#">General Labor</a> <small class="hex">(11 jobs)</small></li>
						<li><a href="#">Pharmaceutical</a> <small class="hex">(109 jobs)</small></li>
						<li><a href="#">Human Resources</a> <small class="hex">(401 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Web Development</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Ecommerce</a> <small class="hex">(958 jobs)</small></li>
						<li><a href="#">Web Design</a> <small class="hex">(576 jobs)</small></li>
						<li><a href="#">Web Programming</a> <small class="hex">(543 jobs)</small></li>
						<li><a href="#">Other - Web Development</a> <small class="hex">(67 jobs)</small></li>
						<li><a href="#">Website Project Management</a> <small class="hex">(45 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3">
					<h3 class="heading-md"><strong>Sales &amp; Marketing</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Advertising</a> <small class="hex">(123 jobs)</small></li>
						<li><a href="#">Email Marketing</a> <small class="hex">(544 jobs)</small></li>
						<li><a href="#">Telemarketing &amp; Telesales</a> <small class="hex">(564 jobs)</small></li>
						<li><a href="#">Market Research &amp; Surveys</a> <small class="hex">(345 jobs)</small></li>
						<li><a href="#">SEM - Search Engine Marketing</a> <small class="hex">(32 jobs)</small></li>
					</ul>
				</div>
			</div>
		    </div>

			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
	
			<!-- ./END FOOTER -->					
		</div>				

		<#include "/html/competency/common-sliding-panel.ftl" >		

	</body>    
</html>