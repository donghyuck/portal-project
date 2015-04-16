<#ftl encoding="UTF-8"/>
<#assign page = action.getPage() >
<html decorator="unify">
<head>
<#compress>
<title>${page.title}</title>
<script type="text/javascript">
<!--
yepnope([{
    load: [        
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],        
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
			  <li class="current"><a href="<@spring.url "/display/main.html"/>">홈</a></li>
			</ul>
		</div>
	</section>
	<!-- End Breadcrumbs -->	  

</body>
</html>