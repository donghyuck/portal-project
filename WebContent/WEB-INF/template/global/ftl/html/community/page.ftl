<#ftl encoding="UTF-8"/>
<#import "/spring.ftl" as spring />
<#assign contextPath = rc.contextPath >
<#assign page = action.builder.getPage() >
<html decorator="unify">
<head>
		<title>${page.title}</title>
		<#compress>
		<script type="text/javascript">
		<!--		
		
		var jobs = [];	
		
		yepnope([{
			load: [
			'css!${contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${contextPath}/styles/bootstrap.themes/unify/colors/blue.css',		
			'${contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${contextPath}/js/kendo/kendo.web.min.js',
			'${contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'${contextPath}/js/bootstrap/3.2.0/bootstrap.min.js',
			'${contextPath}/js/common/common.ui.core.js',							
			'${contextPath}/js/common/common.ui.data.js',
			'${contextPath}/js/common/common.ui.community.js'],
			complete: function() {
				// START SCRIPT	

				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
									$("#announce-selector label.btn").last().removeClass("disabled");									 
								}
							} 
						}						
					},
					wallpaper : {
						slideshow : false
					},
					jobs:jobs
				});		
				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
								
			
				// END SCRIPT
			}
		}]);	
		-->
		</script>
		</#compress>	
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="wrapper">
		<!-- START HEADER -->
		<#include "/html/common/common-homepage-menu.ftl" >	
		<!-- END HEADER -->
		<header  class="cloud">			
			
		</header>	
									
		<!-- START MAIN CONTENT -->	
		<div class="container content">
${page}
		</div><!-- /.container -->		
		<!-- END MAIN CONTENT -->	
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->	
	</div><!-- /.wrapper -->	
	<!-- START TEMPLATE -->
	<#include "/html/common/common-homepage-templates.ftl" >		
	<!-- END TEMPLATE -->	
	</body>
</html>