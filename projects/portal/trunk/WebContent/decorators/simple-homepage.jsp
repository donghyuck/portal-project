<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<title>
	<decorator:title default="..." />
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.0.0/bootstrap.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<%
String userAgent = request.getHeader("user-agent");
if( userAgent.contains("MSIE 8.0") || userAgent.contains("MSIE 7.0") ){
%>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/bootstrap/3.0.0/respond.min.js"></script>
<%
}
%>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>
	.navbar-default {
		background-color: transparent;
		border: none;
	}
	
	.container {
		max-width : 900px;
	}

	footer {
		padding-top : 10px;
		padding-bottom : 10px;
		text-align: center;
	}
	
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />"   background="<decorator:getProperty property="body.background" />" class="<decorator:getProperty property="body.class" />">
	<decorator:body />
</body>
</html>