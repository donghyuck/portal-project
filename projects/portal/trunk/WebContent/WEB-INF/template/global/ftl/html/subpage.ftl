<#ftl encoding="UTF-8"/>
<html decorator="homepage">
	<head>
		<title> ${action.targetPage.title}</title>
		<#compress>				
		<script type="text/javascript">
		<!--		

		var jobs = [];	
		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'${request.contextPath}/js/bootstrap/3.2.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.ui.core.js',							
			'${request.contextPath}/js/common/common.ui.data.js',
			'${request.contextPath}/js/common/common.ui.community.js'],
			complete: function() {
				// START SCRIPT	

				common.ui.setup({
					features:{
						wallpaper : false,
					},
					jobs:jobs
				});	
				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				common.ui.accounts($("#account-navbar"), {
					template : kendo.template($("#account-navbar-template").html()),
					allowToSignIn : <#if action.user.anonymous >false<#else>true</#if>,
					authenticate : function( e ){
						e.token.copy(currentUser);
						if( !currentUser.anonymous ){							
						}
					}
				});	
				
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