<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<title> ${action.targetPage.title}</title>
		<#compress>				
		<script type="text/javascript">
		<!--		

		var jobs = [];	
		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
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
				<#if !action.user.anonymous ></#if>	
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
		<#assign current_menu = action.getNavigator() />					
		<header  class="cloud <#if current_menu.parent.css??>${current_menu.parent.css}</#if>">			
				<script>
				jobs.push(function () {
					$(".navbar-nav li[data-menu-item='${current_menu.parent.name}']").addClass("active");
				});
				</script>
				<div class="breadcrumbs">
			        <div class="container">
			            <h1 class="pull-left">${ current_menu.title }
			            	<small>
			            		<i class="fa fa-quote-left"></i>&nbsp;${ current_menu.description ? replace ("{displayName}" , action.webSite.company.displayName ) }&nbsp;<i class="fa fa-quote-right"></i>
			            	</small>
			            </h1>
			            <ul class="pull-right breadcrumb">
					        <li><a href="main.do"><i class="fa fa-home fa-lg"></i></a></li>
					        <li><a href="">${current_menu.parent.title}</a></li>
					    	<li class="active">${current_menu.title}</li>
			            </ul>
			        </div>
			    </div>	
		</header>	
		</#if>	
									
		<!-- START MAIN CONTENT -->	
		<div class="container content">
			<#if action.isSetNavigator()  >
			<#assign current_menu = action.getNavigator() />
			<div class="row">
				<div class="col-lg-3 visible-lg">	
					<div class="headline"><h4> ${current_menu.parent.title} </h4></div>  
                	<p class="margin-bottom-25"><small>${current_menu.parent.description!" " }</small></p>					
					<div class="list-group">
					<#list current_menu.parent.components as item >
						<#if item.name ==  current_menu.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>
					</div>
				</div>
				<div class="col-lg-9">		
					<div class="content-main-section" style="min-height:300px;">
					${ action.processedBodyText }
					</div>
				</div>
			</div>
			<#else>
			<div class="row">
				<div class="col-sm-12">
					<div class="content-main-section">
						<div class="page-header">
							<h2>${action.targetPage.title}</h2>
						</div>			
						${ action.processedBodyText }			
					</div>
				</div>
			</div>	
			</#if>
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