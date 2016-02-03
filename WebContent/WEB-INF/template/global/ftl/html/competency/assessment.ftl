<#ftl encoding="UTF-8"/>
<#assign page = action.getPage() >
<html decorator="unify">
<head>
<#compress>
<title>${page.title}</title>
<script type="text/javascript">
<!--
var jobs = [];	
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
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],   			     
		complete : function() {
			common.ui.setup({
				jobs:jobs
			});		
			
			<#if RequestParameters['id']?? >
			var	assessmentId = ${ TextUtils.parseLong( RequestParameters['id'] ) } ;			
			common.ui.ajax( '<@spring.url "/data/accounts/get.json?output=json"/>' , {
				success : function(response){
					var currentUser = new common.ui.data.User($.extend( response.user, { roles : response.roles }));					
					common.ui.ajax( '<@spring.url "/data/me/competency/assessment/get.json?output=json"/>' , {
						data : { assessmentId : },
						success : function(response){
							var assessment = new common.ui.data.competency.Assessment(response);		
							
							console.log(common.ui.stringify(assessment));
						}
					});
					
				}
			});			
			<#else>
			alert("잘못된 접근입니다.");
			</#if>			
		}
	} ]);
		
	-->
</script>
</#compress>
</head>
<body>
	<div class="page-loader"></div>
 	<div class="wrapper"></div>
</body>
</html>