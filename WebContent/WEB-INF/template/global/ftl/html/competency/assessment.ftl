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
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',				
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			
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
			<script>
			jobs.push(function () {
				$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
			});
			</script>			
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
					<div class="col-md-6 md-margin-bottom-50">
						<img class="img-responsive" src="<@spring.url "/download/image/9451/ncs.png"/>" alt="">
					</div>
					<div class="col-md-6">
						<h2 class="title-v2">국가직무능력표준 기반 직무역량진단</h2>					
						<p>국가직무능력표준(이하 NCS)는 산업현장에서 직무를 수행하기 위하여 요구되는 지식∙기술∙태도 등을 국가가 산업부문별수준별로 체계화 한 것입니다.</p>
						
						<p>회사는 NCS를 활용하여 직원 개개인의 직무능력을 정확하게 진단할 수 있습니다. </p>
						<p>채용∙승진이나 적재적소에 인력배치 그리고 재교육 등을 쉽게할 수 있고 결과적으로 직무능력중심의 공정한 인사관리가 가능하게 됩니다.</p>
						<hr/>
						<p>개인은 직업에서 요구되는 역량을 본인이 어느 정도 보유하고 있는지 알 수 있습니다.<p>
						<p><p>
						<p><p>
						<p><p>
						<a href="<@spring.url "/display/competency/my-assessment.html" />" class="btn-u btn-brd btn-u-lg btn-brd-hover btn-u-dark">직업역량진단하기</a>
					</div>
				</div><!--/end row-->
			</div>
			<!--
			<div class="bg-color-light">
				<div class="container content-sm">
					<div class="row">
						<div class="col-md-6 md-margin-bottom-50">
							<img class="img-responsive" src="<@spring.url "/download/image/9451/ncs.png"/>" alt="">
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
						</div>
					</div>
				</div>
			</div>
			-->			
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