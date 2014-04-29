<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title>기업소개</title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',			
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'],
			complete: function() {
			
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
				      
				// START SCRIPT	
				// ACCOUNTS LOAD	
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if CompanyUtils.isallowedSignIn(action.company) ||  !action.user.anonymous  || action.view! == "personalized" >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);
					}				
				});				
				
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

		.k-grid table tr.k-state-selected{
			background: #428bca;
			color: #ffffff; 
		}
		
		#announce-view .popover {
			position : relative;
			max-width : 500px;
		}
						
		</style>   	
	</head>
	<body>
		<!-- START HEADER -->
		<#include "/html/common/common-homepage-menu.ftl" >	
		<#assign current_menu = action.getWebSiteMenu("USER_MENU", "MENU_1_3") />
		<header class="cloud">
			<div class="container">
				<div class="col-lg-12">	
					<h1>${ current_menu.title }</h1>
					<h4><i class="fa fa-quote-left"></i>&nbsp; ${action.webSite.company.displayName} 고객들을 소개합니다.&nbsp;<i class="fa fa-quote-right"></i></h4>
				</div>
			</div>
		</header>	
		<!-- END HEADER -->	
		<!-- START MAIN CONTENT -->	
		<div class="container layout">	
			<div class="row">
				<div class="col-lg-3 visible-lg">
					<!-- start side menu -->		
					<div class="list-group">
					<#list current_menu.parent.components as item >
						<#if item.name ==  current_menu.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>										
					</div>	
					<!-- end side menu -->						
				</div>
				<div class="col-lg-9">

					<div class="row">
						<div class="col-lg-6">
																							
						</div>							
						<div class="col-lg-6">			
											
						</div>								
					</div>	
					
				</div>				
			</div>
		</div>									 
		<div class="container layout">						
				<div class="row">
				</div>		
			</div>				
		<!-- END MAIN CONTENT -->	

 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->	
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>