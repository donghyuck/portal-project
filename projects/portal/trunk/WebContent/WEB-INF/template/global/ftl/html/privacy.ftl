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
				<div class="breadcrumbs">
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
					<div class="col-sm-12">					
					<p class="text-sm">
					${action.webSite.company.displayName} 개인정보 취급방침이 2015년 4월 16일에 업데이트되었습니다. 
					변경 사항은 주로 앞으로 출시될 새로운 기능을 다루거나, 
					사용자가 제공한 생일 또는 타사 사용자 데이터와 같은 데이터의 사용 현황에 대한 
					추가 정보(예: 제품 또는 상품권을 보낼 때)를 제공하기 위해 이루어 졌습니다. 
					모든 변경 사항은 소급하지 않습니다.
					</p>					
					</div>			
				</div>
				<hr/>
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">
						<p class="text-md text-center">
						${action.webSite.company.displayName}은 고객의 개인 정보를 중요하게 생각합니다. 이에 ${action.webSite.company.displayName}은 고객의 정보를 수집, 사용, 공개, 이전, 저장하는 것과 관련된 사항을 규정하는 개인정보 취급방침을 마련했습니다. 
						잠시 시간을 내어 ${action.webSite.company.displayName}의 개인정보 처리 방침을 익힌 후 궁금한 사항이 있으면 <span class="text-info">알려 주시기</span> 바랍니다.
						</p>					
					</div>
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