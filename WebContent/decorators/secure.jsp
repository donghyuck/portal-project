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
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/fonts/nanumgothic.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.3.4/bootstrap.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.style.css" />
<!-- <link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />-->
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
/**
		.k-grid .k-selectable tr.k-state-selected{
			background-color: #5ac8fa;
			border-color: #34aadc;		
		}	
			
		.k-detail-row .k-grid .k-selectable tr.k-state-selected{
			background-color: #34aadc;
			border-color: #34aadc;;			
		}
	*/		
			
		.k-grid tr[aria-selected="false"] > td > a.k-button {
			display : none; 
		}
						
		.k-grid tr[aria-selected="true"] > td > a.k-button {
			display : inline; 
		}

		.k-grid .k-selectable td > .btn-selectable, .k-grid .k-selectable tr[aria-selected="false"] > td .btn-selectable, .k-grid .k-selectable td > a.btn-selectable, .k-grid .k-selectable tr[aria-selected="false"] > td a.btn-selectable{
			cursor: not-allowed;
			pointer-events: none;
			opacity: 0;
			filter: alpha(opacity=65);
			-webkit-box-shadow: none;
			box-shadow: none;
		}			
		
		.k-grid  .k-selectable tr[aria-selected="true"] > td > .btn-selectable , .k-grid .k-selectable tr[aria-selected="true"] > td  a.btn-selectable {
			cursor: pointer;
			pointer-events: auto;
			opacity: 1;
			filter: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}
		
		.modal .modal-dialog {
			z-index:1060;
		}
		
		k-radio-label:before, k-radio-label:after , k-checkbox-label:before, k-checkbox-label:after {
			-webkit-box-sizing: content-box;
    		-moz-box-sizing: content-box;
    		box-sizing: content-box;
		}						
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />"  data-color="<decorator:getProperty property="body.data-color" />" class="<decorator:getProperty property="body.class" default="" />">

	<div class="page-loader" ></div>
	<decorator:body />
</body>
</html>