<#ftl encoding="UTF-8"/>
<html decorator="secure-metro">
	<head>
		<title>트위터 인증</title>
		<#compress>
		<script type="text/javascript"> 
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jquery.cookie/jquery.cookie.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.js',
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.min.js'],
			complete: function() {				
				//$("form[name='fm']").attr("action", "${action.socialNetwork.authorizationUrl}").submit();
				window.location.replace("${action.socialNetwork.authorizationUrl}&display=popup");
			}	
		}]);
		</script>		
		</#compress>
	</head>
	<body class="color2">						
		<form name="fm" method="POST" >
			<input type="hidden" name="display" value="popup"/>
		</form>	
	</body>	
</html>