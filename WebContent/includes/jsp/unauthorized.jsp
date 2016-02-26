<%@ page pageEncoding="UTF-8"%>
<%@ page import="architecture.common.user.*"%>
<html decorator="unify">
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
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo.extension/kendo.ko_KR.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/bootstrap/3.3.4/bootstrap.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common.plugins/query.backstretch.min.js', 			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.core.js',						
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.data.js'			
			],
		complete: function() {
			
			common.ui.backstretch({
				renderTo:$("#slideshow")				
			});
			//var slideshow = $('#slideshow').extFullscreenSlideshow();
		}		
	}]);			
	-->
	</script>	
	<style scoped="scoped">
	
	#slideshow {
		position: fixed;
	    left: 0;
	    top: 0;
	    width: 100%;
	    height: 100%;
	}
	
	.panel {
		position: fixed;
		background-color: rgba( 0,0,0, .5);
		border: 0px ;
		border-radius: 8px;
		-webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
		box-shadow: 0 1px 1px rgba(0,0,0,.05);
		width: 300px;
		left: 50%;
		top: 50%;
		margin: -150px 0 0 -150px;
		color: #FFF;
		z-index:1;
	}
	p{
		color : #fff;
		font-size : 1.2 em;
	}
				
	</style>	
	<body class="color8">
		<div class="panel panel-default">
			<div class="panel-body">
			<p class="text-center">요청하신 페이지에 대한 권한이 없습니다.</p>
			<p class="text-center"><a href="/main.do" class="btn btn-info">확인</a></p>
			</div>
		</div>
		<div class="main" id="slideshow"></div>
	</body>
</html>