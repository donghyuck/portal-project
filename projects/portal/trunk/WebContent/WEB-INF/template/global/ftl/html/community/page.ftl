<#ftl encoding="UTF-8"/>
<#assign page = action.getPage() />
<html decorator="unify">
<head>
		<title>${page.title}</title>
		<#compress>
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
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {
				// START SCRIPT	

				common.ui.setup({
					features:{
						wallpaper : false,
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
		<#if action.isSetNavigator()  >
		<#assign navigator = action.getNavigator() />					
		<header  class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">			
				<script>
				jobs.push(function () {
					$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
				});
				</script>
				<div class="breadcrumbs arrow-up">
					<div class="container">
						<div class="row">
							<h2 class="pull-left">${ navigator.title }
							<small class="page-summary">
									${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }								
							</small>	
							</h2>
							<!--
							<div class="pull-right breadcrumb-v1">
								<ul class="breadcrumb">
									<li><a href="main.do"><i class="fa fa-home fa-lg"></i></a></li>
									<li><a href="">${navigator.parent.title}</a></li>
									<li class="active">${navigator.title}</li>
								</ul>
							</div>	
							-->
						</div>
					</div>
				</div>	
		</header>	
		<!-- START MAIN CONTENT -->	
		<div class="container content">
			<div class="row">
				<div class="col-lg-3 visible-lg">	
					<div class="headline"><h4> ${navigator.parent.title} </h4></div>  
                	<p class="margin-bottom-25"><small>${navigator.parent.description!" " }</small></p>					
					<div class="list-group">
					<#list navigator.parent.components as item >
						<#if item.name ==  navigator.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>
					</div>
				</div>
				<div class="col-lg-9">		
					<div class="content-main-section text-md" style="min-height:300px;">
					${ action.bodyText }
					</div>
				</div>
			</div>
		</div><!-- /.container -->		
		</#if>
		<!-- END MAIN CONTENT -->	
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-globalfooter.ftl" >		
		<!-- END FOOTER -->	
	</div><!-- /.wrapper -->	
	<!-- START TEMPLATE -->
	<#include "/html/common/common-homepage-templates.ftl" >		
	<!-- END TEMPLATE -->	
	</body>
</html>