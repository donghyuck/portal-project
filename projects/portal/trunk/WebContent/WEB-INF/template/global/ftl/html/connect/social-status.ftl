<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<title></title>
		<#compress>	
		<link rel="stylesheet" href="/styles/font-awesome/4.0.3/font-awesome.min.css">
		<link rel="stylesheet" href="/styles/common.themes/unify/plugins/brand-buttons/brand-buttons.min.css">
		<link rel="stylesheet" href="/styles/common.themes/unify/pages/profile.min.css">
		<link rel="stylesheet" href="/styles/jquery.jgrowl/jquery.jgrowl.min.css">
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'/js/jquery/1.10.2/jquery.min.js',
			'/js/jgrowl/jquery.jgrowl.min.js',
			'/js/kendo/kendo.web.min.js',
			'/js/kendo.extension/kendo.ko_KR.js',			
			'/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'/js/common.plugins/query.backstretch.min.js', 	
			'/js/bootstrap/3.1.0/bootstrap.min.js',
			'/js/common/common.models.js',
			'/js/common/common.api.js',
			'/js/common/common.ui.js',
			'/js/common/common.ui.core.js',
			'/js/common/common.ui.connect.js'
			],
			complete: function() {
				// START SCRIPT	
				common.ui.setup({
					features:{
						backstretch : false
					}
				});	  
				// START SCRIPT					
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					authenticate : function( e ){
						e.token.copy(currentUser);
					}				
				});
				
				$("button.btn-close").click(function(e){
					window.close();
				});
				
				<#if profile ?? >				
				if(window.opener){
					if(typeof window.opener.handleCallbackResult == "function"){	
						window.opener.handleCallbackResult( <#if error ?? >false<#else>true</#if> );
						window.close();
					}
				}
				/**
				common.api.social.profile({
					url : "/connect/${connect.providerId}/user/lookup.json",
					success : function( data ){
						
					}
				});
				**/
				</#if>
				// END SCRIPT            
			}
		}]);	
		-->
		</script>
		<style scoped="scoped">
		.wrapper {
			background:transparent;
		}
		
		.error-v1 {
			padding: 20px 30px;
			text-align: center;
			margin-bottom: 15px;
			background: rgba(255,255,255,0.3);
		}
		</style>
		</#compress>	
	</head>
	<body>
		<div class="page-loader"></div>
		<!-- START MAIN CONTENT -->	
		<div class="wrapper">
		<div class="breadcrumbs">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<h2><i class="fa fa-${connect.providerId}"></i> Status <#if connect.displayName ?? ><small>${connect.displayName}</small></#if></h2>				
					<button type="button" class="btn-close btn-close-grey btn-sm" style="top:0px;"><span class="sr-only">Close</span></button>
				</div>
			</div>
		</div>
		</div>
		<div class="profile container content">	
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
				
					<#if error ?? >
					<div class="error-v1 rounded">
						<p>${error?html}</p>
						<a class="btn btn-lg btn-${connect.providerId}" href="/connect/${connect.providerId}/authorize">
							<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
						</a>
					</div>
					</#if>
					
					<#if social_provider_error ?? >
					<div class="error-v1 rounded">
						<p>${social_provider_error?html}</p>
						<a class="btn btn-lg btn-${connect.providerId}" href="/connect/${connect.providerId}/authorize">
							<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
						</a>
					</div>
					</#if>	
									
					<#if profile ?? >
					<div class="profile-blog">
							<img class="rounded-x" src="<#if connect.imageUrl ??>${connect.imageUrl}<#else>/images/common/anonymous.png</#if>" alt="">
							<div class="name-location">
								<strong>${connect.displayName}</strong>
							</div>
							
							<#if connect.profileUrl ?? >
							<p><a href="${connect.profileUrl }" class="btn-link">홈</a></p>
							</#if>						
					
					</#if>
					
				</div>
			</div>
		</div>
		
		</div>
		<!-- END MAIN CONTENT -->	
		
	</body>
</html>