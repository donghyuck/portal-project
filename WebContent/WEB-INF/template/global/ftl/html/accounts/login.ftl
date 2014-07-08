<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/codrops/codrops.morphing-button.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',

			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 			
			'${request.contextPath}/js/codrops/codrops.morphing-button.js',
				
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'
			],
			complete: function() {
				common.ui.setup({
					features:{
						backstretch : true
					}
				});	

			}
		}]);	
	
		-->
		</script>
		<style>	
		</style>
</#compress>		
	</head>
	<body class="color3">

		<nav class="navbar navbar-inverse navbar-fixed-bottom" role="navigation">
			<div class="container">
				<ul class="nav navbar-nav navbar-left">
					 <li><a href="#">약관</a></li>
					 <li><a href="#">개인정보보호</a></li>
					 <li><a href="#" onclick="toggleWindow(); return false;">로그인</a></li>					 
				</ul>
			</div>
		</nav>					
	</body>    
</html>