<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<title></title>
		<#compress>	
		<link rel="stylesheet" href="<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>">
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',
			'css!<@spring.url "/styles/common.plugins/brand-buttons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/profile.css"/>',
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 	
			'<@spring.url "/js/bootstrap/3.3.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>'		
			],
			complete: function() {
				// START SCRIPT	
				common.ui.setup({
					features:{
						backstretch : false
					}
				});	  
				// START SCRIPT		
				/**			
				var currentUser = new common.ui.data.User();			
				common.ui.data.user( {
					success : function ( user ) {				
						user.copy(currentUser);						
					}				
				} );	
				**/
				
				window.onunload = function(){
					if(window.opener){
						var win = window.opener ;
						if(!win.closed){
							window.opener.handleCallbackResult( false );
						}
					}
				};
				
				$("button.btn-close").click(function(e){
					if(typeof window.opener.handleCallbackResult == "function"){	
						window.opener.handleCallbackResult( false );
					}
					window.close();
				});
				
				<#if user.anonymous && profile ?? >				
				if(window.opener){
					if(typeof window.opener.handleCallbackResult == "function"){	
						window.opener.handleCallbackResult( <#if error ?? >false<#else>true</#if> );
						window.close();
					}
				}
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
					<h2><i class="fa fa-${connect.providerId}"></i> 연결 상태   <#if connect.displayName ?? ><small> ${connect.displayName} </small></#if></h2>				
					<button type="button" class="btn-close btn-close-grey btn-sm" style="top:0px;"><span class="sr-only">Close</span></button>
				</div>
			</div>
		</div>
		</div>
		<div class="profile container content">	
			<div class="row">
				<div class="col-md-8 col-md-offset-2">				
					<#if error??>
					<div class="error-v1 rounded">
						<p>${error?html}</p>
						<#if !profile?? >
						<a class="btn btn-lg btn-${connect.providerId}" href="/connect/${connect.providerId}/authorize">
							<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
						</a>
						</#if>
					</div>
					</#if>					
					<#if social_provider_error?exists >
					<div class="error-v1 rounded provider">
						<p>${social_provider_error?html}</p>
						<#if !profile?? >
						<a class="btn btn-lg btn-${connect.providerId}" href="/connect/${connect.providerId}/authorize">
							<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
						</a>
						</#if>
					</div>
					</#if>										
					<#if profile?? >
					<div class="profile-blog">
						<img class="rounded-x" src="<#if connect.imageUrl ??>${connect.imageUrl}<#else>/images/common/anonymous.png</#if>" alt="">
						<div class="name-location">
							<strong>${profile.name}</strong>
						</div>							
						<#if connect.profileUrl ?? >
						<p class="text-center"><a href="${connect.profileUrl }" class="btn btn-lg btn-${connect.providerId}"><i class="fa fa-${connect.providerId}"></i> 쇼셜 바로가기</a></p>
						</#if>
					<#else>	
						<#if !error?? && !social_provider_error?? && user?? && user.anonymous >
							<i class="icon-flat person"></i>
							<div class="profile-blog">
							<a class="btn btn-lg btn-${connect.providerId}" href="/connect/${connect.providerId}/authorize">
								<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
							</a>
							</div>
						</#if>
					</#if>				
				</div>
			</div>
		</div>
		
		</div>
		<!-- END MAIN CONTENT -->	
		
	</body>
</html>