<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
<#compress>
<title>메인 페이지</title>
<script type="text/javascript">
<!--
yepnope([{
    load: [        
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.pages/common.signup_signon.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jquery.plugins/jquery.ui.shake.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',

			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 
				
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'			
			],             
		complete : function() {

		}
	} ]);
	-->
</script>
</#compress>
</head>
<body>
	<div class="row">
		<div class="twelve columns">
			<img src="http://ncc.phinf.naver.net/ncc01/2012/10/17/133/img01.jpg?type=w323" />
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
	<!-- Start Breadcrumbs -->	    
	<section class="row">
	    <div class="twelve columns">
	        <hr style="margin-top:10px;margin-bottom:10px;" />
			<ul class="breadcrumbs">
			  <li class="current"><a href="${request.contextPath}/main.do">홈</a></li>
			</ul>
		</div>
	</section>
	<!-- End Breadcrumbs -->	  

</body>
</html>