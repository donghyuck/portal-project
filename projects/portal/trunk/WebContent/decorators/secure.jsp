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
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.1.0/bootstrap.css" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>
	
		.header-1,
		.header-1:hover,
		.header-2,
		.header-2:hover {
			text-align: none;
			cursor: pointer;
			text-decoration: none !important;
			display: block;
			z-index: 100000000;
			border-top: 1px solid #eee;
			margin: 0 -9px 0 -9px;
		}

		.header-1,
		.header-1:hover {
			color: #333 !important;
			font-size: 18px;
			font-weight: 300;
			padding: 30px 18px 15px 18px;
			background: #fafafa;
			background: rgba(0,0,0,.02);
			margin-bottom: -15px;
		}

		.header-2,
		.header-2:hover {
			text-transform: uppercase;
			font-size: 11px;
			font-weight: 600;
			color: #888 !important;
			padding: 10px 18px 0 18px;
			margin-bottom: 15px;
			margin-top: 0;
		}

		.header-1 + .header-2 {
			margin-top: 10px;
			margin-bottom: 0;
		}

		.header-1 + .col-sm-12 {
			margin-top: 15px;
			padding-top: 15px;
			border-top: 1px solid #eee;
			margin-left: -9px;
			margin-right: -9px;
			padding-left: 18px;
			padding-right: 18px;
			width: auto !important;
			float: none;
		}			
	
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />"  data-color="<decorator:getProperty property="body.data-color" />" class="<decorator:getProperty property="body.class" default="" />">
	<div class="page-loader" ></div>
	<decorator:body />
</body>
</html>