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
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.3.4/bootstrap.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap.themes/unify/1.9.1/style.css" />

<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.style.css" />

<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>
	.header {
		width: 100%;
		top: 0px;
		padding-top: 0px !important;
		background: #fff;
		border-bottom: 2px solid rgba(150, 150, 150, 0.23);	
	/*	background: url(/images/common/pattern.png) repeat; */
	}	
	
	.header .navbar-brand {
		height:20px;
	}
	
	.header .navbar-default {
		background: transparent;
	}
	
	.header .dropdown-menu {
		border-bottom: solid 2px rgba(228, 228, 228, 0.5);
	}
	
	.breadcrumbs {
		background: url(/images/common/pattern.png) repeat;
		border-bottom: solid 1px rgba(228, 228, 228, 0.23);
	}
	
	.footer .copyright .copyright-text {
		line-height: 40px;
	}	
	
	.footer .headline {
		border-bottom: 2px solid #fff;
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