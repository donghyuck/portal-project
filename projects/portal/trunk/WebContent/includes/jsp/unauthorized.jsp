<%@ page pageEncoding="UTF-8"%>
<%@ page import="architecture.common.user.*"%>
<html decorator="homepage">
<head>
<title>접근 권한이 없습니다.</title>
<%
	User user = SecurityHelper.getUser();
	Company company = user.getCompany();
%>
	<script type="text/javascript">
	<!--
	yepnope([{
		load: [ 
			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/font-awesome/4.0.3/font-awesome.min.css',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.10.2/jquery.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery.extension/jquery.ui.shake.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/bootstrap/3.0.3/bootstrap.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery.imagesloaded/imagesloaded.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.modernizr.custom.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.api.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.js'],
		complete: function() {
			var slideshow = $('#slideshow').extFullscreenSlideshow();
		}		
	}]);			
	-->
	</script>	
	<style scoped="scoped">
	
	.cbp-bicontrols {
		top: 80%;
	}
				
	</style>	
	<body class="color8">
		<div class="main" id="slideshow"></div>
	</body>
</html>