<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>
	<decorator:title default="..." />
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>
	
	body {
		overflow-y : hidden;
	}

	@media only screen and (min-width: 768px) {
		body{
			font-size: 10pt;
		}
	}
	
	@media only screen and (min-width: 1280px) {
		body{
			font-size: 11pt;
		}
	}
	
	@media only screen and (min-width: 1440px) {
		body{
			font-size: 14pt;
		}
	}

::-webkit-scrollbar {
	width: 8px;
	height: 8px;
}

::-webkit-scrollbar-track {
		background: rgba(0, 0, 0, 0.05)
	}
	
::-webkit-scrollbar-thumb {
		border-radius: 12px;
		background: rgba(0, 0, 0, 0.2)
	}
	
::-webkit-scrollbar-thumb:hover {
		background: rgba(0, 0, 0, 0.25)
	}
	
	.k-menu.k-header, .k-menu .k-item {
		border-color :#dadada;
	}
	
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />" class="<decorator:getProperty property="body.class" />">
	<decorator:body />
</body>
</html>