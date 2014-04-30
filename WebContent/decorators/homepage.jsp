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
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/normalize/3.0.0/normalize.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.1.0/bootstrap.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>
	#account-navbar  ul.dropdown-menu {
		min-width : 320px;
	}
	
	body { 
		padding-top: 51px; 
	}
	
	.k-grid table tr.k-state-selected{
		background: #428bca;
		color: #ffffff; 
	}		

	/** Header css */
	header {
		background: #0070b8;
		background-size: cover;
		padding: 12px 0;
		 /*margin-top : -20px;   navbar-fixed-top*/
		margin-bottom: 10px;
	}

	header.cloud {
		color: white;
		background: #3ba5db url(/images/common/header/cloud-hero.png) bottom right no-repeat;
	}
.
	header h1 {
		color: white;
		font-weight: 300;
		margin-bottom: 0;
	}

	header h4 {
		color: white;
		font-weight: 300;
	}
	
	.navbar-inverse {
		background-color: #333;
		border-color: #222;
	}

	.k-editor-toolbar .k-tool {
		border : 0px;
		color: #34AADC;
	}

	.k-editor-toolbar .k-tool:hover {
		background-color: #428bca;
	}

	.k-editor-toolbar .k-state-hover {
		background-image: none, linear-gradient( to bottom, #428bca 0, #428bca 100%) ;
	}	
	
	.k-editor-toolbar .k-state-selected {
		background-color: #428bca;
	}
	
	@media (max-width: @screen-xs-max) {
		max-width: 650px;
	}
		
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />" class="<decorator:getProperty property="body.class" default="color4" />">
	<decorator:body />
</body>
</html>