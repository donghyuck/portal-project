<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >
		<title>${page.title}</title>
		<script type="text/javascript">
		<!--		
		var jobs = [];			
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 				
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {			
				var currentUser = new common.ui.data.User();		
				common.ui.setup({
					features:{
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
															 
								}
							} 
						}						
					},
					jobs:jobs
				});	
				// ACCOUNTS LOAD
				common.ui.backstretch({renderTo:$(".interactive-slider-v2 > .container") });
				<#if !action.user.anonymous >	
				</#if>	
				// END SCRIPT	
			}
		}]);	
				
		-->
		</script>		
		<style scoped="scoped">		
					
		</style>   	
	</head>
	<body class="bg-dark">
		<div class="page-loader"></div>	
		<!-- START HEADER -->		
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.isSetNavigator()  >
				<#assign navigator = action.getNavigator() />
			<div class="interactive-slider-v2 arrow-up">
				<div class="container">
					<h1 class="text-xxl">${ navigator.title }</h1>
					<p class="text-sm text-center p-md">${ navigator.description ? replace ("{displayName}" , action.webSite.displayName ) }</p>
				</div>
			</div>
			</#if>				
			<!-- END HEADER -->			
			<!-- START MAIN CONTENT -->	
			<div class="container content bg-white ">		
				<div class="row">					
						<#list action.menuNames as item>
						<div class="col-md-4 col-sm-6" style="min-height: 200px;">			
						<#assign menu = action.getWebSiteMenu(item) />
						<div class="headline"><h4> ${menu.title} </h4></div>  
						<ul>
							<#list menu.components as menu_item>
							<li>${menu_item.title}
								<#if  menu_item.components?has_content >
								<ul>
								<#list menu_item.components as menu_item_item>
									<li>${menu_item_item.title}</li>
								</#list>	
								</ul>	
								</#if>
							</li>	
							</#list>
						</ul>
						</div>	
						</#list>						
				</div>
			</div>							 			
			<!-- END MAIN CONTENT -->	
 			<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- END FOOTER -->	
		</div>		
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>