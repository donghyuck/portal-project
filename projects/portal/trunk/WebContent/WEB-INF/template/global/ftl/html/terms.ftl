<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >
		<title>${page.title}</title>
		<script type="text/javascript">
		<!--		
		var jobs = [];			
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
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
			complete: function() {			
				common.ui.setup({
					features:{
						wallpaper : false,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){	
								}
							} 
						}						
					},
					jobs:jobs
				});	
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				<#if !action.user.anonymous >	
				</#if>	
				// END SCRIPT	
			}
		}]);	
		-->
		</script>		
		<style scoped="scoped">
		.breadcrumbs h2 {
			font-size: 32px;
			font-weight: 200;
		}
		.localnav:before, .localnav:after {
			content: ' ';
			display: table;
		}		
		.localnav {
			position: relative;
			margin-top: 0;
			padding-top: 1em;		
			border-bottom: 1px solid #d6d6d6;
			margin: 0 auto;		
		}
		
		.localnav-title {
			padding: 0;
			display: block;
			font-size: 32px;
			line-height: 1;
			float: left;
			font-weight: 200;
		}

		.localnav-links {
			float: right;
			margin: 8px 0 7px 0;
		}		
		.localnav-links>li {
			float: left;
			list-style: none;
			margin-left: 30px;
		}	
		.localnav-link {
			font-size: 13px;
			color: #333;
			display: inline-block;
			white-space: nowrap;
		}			
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>	
		<!-- START HEADER -->		
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	

			<#if action.isSetNavigator()  >
				<#assign navigator = action.getNavigator() />
				<header class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">					
				<script>
					jobs.push(function () {
						$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
					});
				</script>			
				<div class="breadcrumbs">
					<div class="container">
						<div class="row">
							<h2>${ navigator.title }
							<small class="page-summary">
							${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }								
							</small>	
							</h2>
						</div>
					</div>
				</div>	
			</header>	
			</#if>				
			<!-- END HEADER -->			
			<!-- START MAIN CONTENT -->	
			<div class="container content">			
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<h1 class="text-center text-xxl">${action.webSite.company.displayName} 서비스 이용약관</h1>
						<p class="text-center"><i class="icon-flat microphone"></i></p>
						<p class="text-sm text-center p-md">
						${action.webSite.company.displayName} 에서 제공하는 	서비스를 이용함으로써 귀하는 본 약관에 동의하게 되므로 본 약관을 주의 깊게 읽어보시기 바랍니다.
						</p>					
					</div>			
				</div>
				<hr/>				
			</div>							 			
			<!-- END MAIN CONTENT -->	
 			<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- END FOOTER -->	
		</div>		
		<!-- START TEMPLATE -->			
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>