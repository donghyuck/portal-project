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
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {			
				common.ui.setup({
					features:{
						wallpaper : false,
						lightbox : true,
						spmenu : false,
						morphing : false,
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
				var currentUser = new common.ui.data.User();			
				<#if !action.user.anonymous >	
				</#if>	
				// END SCRIPT	
			}
		}]);	
				
		-->
		</script>		
		<style scoped="scoped">		
		blockquote p {
			font-size: 15px;
		}							
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>	
		<!-- START HEADER -->		
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.isSetNavigator()  >
				<#assign navigator = action.getNavigator() />			
				<header  class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">					
				<script>
					jobs.push(function () {
						$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
					});
				</script>			
				<div class="breadcrumbs arrow-up">
					<div class="container">
						<div class="row">
							<h2 class="pull-left">${ navigator.title }
							<small class="page-summary">
									${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }								
							</small>	
							</h2>
						</div>
					</div>
				</div>	
			</header>	
			</#if>				
			<!-- END HEADER -->			
			<!-- START MAIN CONTENT -->	
			<div class="container content">		
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<h1 class="text-center text-xxl">서비스 전체 보기</h1>
						<p class="text-center"><i class="icon-flat microphone"></i></p>
						<p class="text-sm text-center p-md">
						<strong>${action.webSite.company.displayName} 개인정보 취급방침이 2015년 4월 16일에 업데이트되었습니다. </strong>
						변경 사항은 주로 앞으로 출시될 새로운 기능을 다루거나, 
						사용자가 제공한 생일 또는 타사 사용자 데이터와 같은 데이터의 사용 현황에 대한 
						추가 정보(예: 제품 또는 상품권을 보낼 때)를 제공하기 위해 이루어 졌습니다. 
						모든 변경 사항은 소급하지 않습니다.
						</p>					
					</div>			
				</div>
				<hr/>				
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