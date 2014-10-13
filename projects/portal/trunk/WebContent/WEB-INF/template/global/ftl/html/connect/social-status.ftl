<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<title></title>
		<#compress>	
		<link rel="stylesheet" href="/styles/font-awesome/4.0.3/font-awesome.min.css">
		<link rel="stylesheet" href="/styles/common.themes/unify/plugins/brand-buttons/brand-buttons.min.css">
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
						backstretch : true
					}
				});	  
				// START SCRIPT					
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					authenticate : function( e ){
						e.token.copy(currentUser);
					}				
				});
				<#if profile ?? >
				common.api.social.profile({
					url : "/connect/${connect.providerId}/user/lookup.json",
					success : function( data ){
						alert(kendo.stringify(data));
					}
				});
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
					<h2><i class="fa fa-${connect.providerId}"></i> Status <#if profile ?? ><small>${profile.username}</small></#if>	</h2>				
				</div>
			</div>
		</div>
		</div>
		<div class="container content">	
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
				<#if error ?? >
					<div class="error-v1 rounded">
						<p>${error?html}</p>
						<a class="btn btn-lg btn-${connect.providerId}" href="/connect/facebook/authorize">
							<i class="fa fa-${connect.providerId}"></i> Connect with ${connect.providerId?cap_first} <i class="fa fa-angle-right"></i>
						</a>
					</div>
					</#if>
				</div>
			</div>
		</div>
		
		</div>
		<!-- END MAIN CONTENT -->	
		
	</body>
</html>