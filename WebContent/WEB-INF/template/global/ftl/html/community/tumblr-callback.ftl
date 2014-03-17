<#ftl encoding="UTF-8"/>
<html decorator="secure-metro">
	<head>
		<title>쇼셜 인증</title>
		<script type="text/javascript"> 
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.9.1/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.js',
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.min.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.min.js'],
			complete: function() {

			}	
		}]);
		</script>		
	</head>
	<body class="color2">						
		<div class="container">
			<div class="row">
				<div class="col-sm-12">			
				${request.remoteHost}		
				${request.remoteAddr}		
				${request.remoteUser}			
					<div id="status"></div>
				</div>
			</div>
		</div>		
	</body>	
</html>