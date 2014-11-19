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
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Expires" content="-1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/fonts/nanumgothic.css" /> 
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.3.0/bootstrap.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common.themes/unify/style.css" />
<link rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common.themes/unify/themes/default.css" id="style_color">
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>

	.header {
		width: 100%;
		top: 0px;
		padding-top: 0px !important;
		background: rgba(0,0,0,0.7);
		border-bottom: 1px solid rgba(228, 228, 228, 0.23);		
	}	
	
	.header .navbar-brand {
		height:20px;
	}
	.header .navbar-default {
		background: transparent;		
	}
	
	.header .navbar-default .navbar-nav > li > a {
		color: #444;
	}
	
	.k-loading-image {
		background-image: url('/images/common/loader/loading-transparent-bg.gif');
	}
					
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />" class="<decorator:getProperty property="body.class" default="" />">
	<!-- <div class="page-loader" ></div>-->
	<decorator:body />
</body>
</html>