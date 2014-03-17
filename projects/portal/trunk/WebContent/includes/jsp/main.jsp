<%@ page pageEncoding="UTF-8"%>
<html decorator="banded">
<head>
<title>메인 페이지</title>
<script type="text/javascript">
<!--
yepnope([{
    load: [        
             'css!<%=request.getContextPath()%>/styles/kendo.common.min.css',
             'css!<%=request.getContextPath()%>/styles/kendo.metro.min.css',
             'css!<%=request.getContextPath()%>/styles/kendo.dataviz.min.css',
             '<%=request.getContextPath()%>/js/jquery/1.8.2/jquery.min.js',
             '<%=request.getContextPath()%>/js/kendo/kendo.web.min.js',
             '<%=request.getContextPath()%>
	/js/kendo/kendo.dataviz.min.js' ],
		complete : function() {

			// grid 생성
			$("#grid")
					.kendoGrid(
							{
								dataSource : {
									type : "odata",
									transport : {
										read : "http://demos.kendoui.com/service/Northwind.svc/Orders"
									},
									schema : {
										model : {
											fields : {
												OrderID : {
													type : "number"
												},
												Freight : {
													type : "number"
												},
												ShipName : {
													type : "string"
												},
												OrderDate : {
													type : "date"
												},
												ShipCity : {
													type : "string"
												}
											}
										}
									},
									pageSize : 10,
									serverPaging : true,
									serverFiltering : true,
									serverSorting : true
								},
								height : 250,
								filterable : true,
								sortable : true,
								pageable : true,
								columns : [ {
									field : "OrderID",
									filterable : false
								}, "Freight", {
									field : "OrderDate",
									title : "Order Date",
									width : 100,
									format : "{0:MM/dd/yyyy}"
								}, {
									field : "ShipName",
									title : "Ship Name",
									width : 200
								}, {
									field : "ShipCity",
									title : "Ship City"
								} ]
							});

			// 차트 생성
			setTimeout(function() {
				// Initialize the chart with a delay to make sure
				// the initial animation is visible

				$("#chart").kendoChart({

					title : {
						text : "인터넷 사용자"
					},
					legend : {
						position : "bottom"
					},
					seriesDefaults : {
						type : "area",
						stack : true
					},
					series : [ {
						name : "한국",
						data : [ 67.96, 68.93, 75, 74, 78 ]
					}, {
						name : "전세계",
						data : [ 15.7, 16.7, 20, 23.5, 26.6 ]
					} ],
					valueAxis : {
						labels : {
							format : "{0}%"
						}
					},
					categoryAxis : {
						categories : [ 2005, 2006, 2007, 2008, 2009 ]
					},
					tooltip : {
						visible : true,
						format : "{0}%"
					}
				});

			}, 500);

		}
	} ]);
	-->
</script>
</head>
<body>
	<div class="row">
		<div class="twelve columns">
			<img src="http://placehold.it/1000x400&text=[img]" />
			<hr />
		</div>
	</div>
	<!-- Second Band (Image Left with Text) -->
	<div class="row">
		<div class="four columns">
			<img src="http://placehold.it/400x300&text=[img]" />
		</div>
		<div class="eight columns">
			<div class="panel radius">
				<h4>This is a grid session.</h4>
				<div id="grid"></div>
			</div>
		</div>
	</div>
	<!-- Third Band (Image Right with Text) -->
	<div class="row">
		<div class="eight columns">
			<div class="panel radius">
				<p>인터넷 사용현황</p>
				<div class="chart-wrapper">
					<div id="chart"></div>
				</div>
			</div>
		</div>
		<div class="four columns">
			<img src="http://placehold.it/400x300&text=[img]" />
		</div>
	</div>


</body>
</html>