<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
	<#assign pageMenuName = "USER_MENU" />
	<#assign pageMenuItemName = "MENU_1_1" />
		<#if action.webSite ?? >
			<#assign webSiteMenu = action.getWebSiteMenu(pageMenuName) />
			<#assign navigator = WebSiteUtils.getMenuComponent(webSiteMenu, pageMenuItemName) />
			<title>${navigator.title}</title>
		</#if>	
		<script type="text/javascript">
		<!--

		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
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
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.webSite ?? >
				<#assign webSiteMenu = action.getWebSiteMenu(pageMenuName) />
				<#assign navigator = WebSiteUtils.getMenuComponent(webSiteMenu, pageMenuItemName) />
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
							<div class="pull-right breadcrumb-v1">
								<ul class="breadcrumb">
									<li><a href="main.do"><i class="fa fa-home fa-lg"></i></a></li>
									<li><a href="">${navigator.parent.title}</a></li>
									<li class="active">${navigator.title}</li>
								</ul>
							</div>	
						</div>
					</div>
				</div>	
			</header>					
			<!-- START MAIN CONTENT -->	

			<div class="container content">
				<div class="title-box-v2">
					<p>
					메르딩앙은 오픈 소스 소프트웨어 개발자 그룹으로 웹을 기반으로 하는 응용프로그램 개발을 돕는 여러가지 도구들을 만들고 있습니다.		
					또한 다수의 우수한 오픈소스 기술들을 사용하고 있습니다.								
					</p>
				</div>

        <!-- About Sldier -->
        <div class="shadow-wrapper margin-bottom-50">
            <div class="carousel slide carousel-v1 box-shadow shadow-effect-2" id="myCarousel">
                <ol class="carousel-indicators">
                    <li class="rounded-x active" data-target="#myCarousel" data-slide-to="0"></li>
                    <li class="rounded-x" data-target="#myCarousel" data-slide-to="1"></li>
                    <li class="rounded-x" data-target="#myCarousel" data-slide-to="2"></li>
                </ol>

                <div class="carousel-inner">
                    <div class="item active">
                        <img class="img-responsive" src="assets/img/team/team.jpg" alt="">
                    </div>
                    <div class="item">
                        <img class="img-responsive" src="assets/img/team/team3.jpg" alt="">
                    </div>
                    <div class="item">
                        <img class="img-responsive" src="assets/img/team/team2.jpg" alt="">
                    </div>
                </div>

                <div class="carousel-arrow">
                    <a data-slide="prev" href="#myCarousel" class="left carousel-control">
                        <i class="fa fa-angle-left"></i>
                    </a>
                    <a data-slide="next" href="#myCarousel" class="right carousel-control">
                        <i class="fa fa-angle-right"></i>
                    </a>
                </div>
            </div>            
        </div>
        <!-- End About Sldier -->

        <!-- About Description -->
        <div class="row">
            <div class="col-md-8">
                <div class="row">
                    <div class="col-sm-4">
                        <img alt="" src="assets/img/main/6.jpg" class="img-responsive margin-bottom-20">
                    </div>
                    <div class="col-sm-8">
                        <p>Unify is an incredibly beautiful responsive Bootstrap Template for corporate and creative professionals. It works on all major web browsers, tablets and phone.</p>
                        <ul class="list-unstyled margin-bottom-20">
                            <li><i class="fa fa-check color-green"></i> Donec id elit non mi porta gravida</li>
                            <li><i class="fa fa-check color-green"></i> Corporate and Creative</li>
                            <li><i class="fa fa-check color-green"></i> Responsive Bootstrap Template</li>
                            <li><i class="fa fa-check color-green"></i> Corporate and Creative</li>
                        </ul>                    
                    </div>
                </div>

                <blockquote class="hero-unify">
                    <p>Award winning digital agency. We bring a personal and effective approach to every project we work on, which is why. Unify is an incredibly beautiful responsive Bootstrap Template for corporate professionals.</p>
                    <small>CEO, Jack Bour</small>
                </blockquote>
            </div><!--/col-md-8-->        

            <div class="col-md-4">
                <h3 class="heading-xs no-top-space">Web Design <span class="pull-right">88%</span></h3>
                <div class="progress progress-u progress-xs">
                    <div style="width: 88%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="88" role="progressbar" class="progress-bar progress-bar-u">
                    </div>
                </div>

                <h3 class="heading-xs no-top-space">PHP/WordPress <span class="pull-right">76%</span></h3>
                <div class="progress progress-u progress-xs">
                    <div style="width: 76%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="76" role="progressbar" class="progress-bar progress-bar-u">
                    </div>
                </div>

                <h3 class="heading-xs no-top-space">HTML/CSS <span class="pull-right">97%</span></h3>
                <div class="progress progress-u progress-xs">
                    <div style="width: 97%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="97" role="progressbar" class="progress-bar progress-bar-u">
                    </div>
                </div>

                <h3 class="heading-xs no-top-space">Web Animation <span class="pull-right">68%</span></h3>
                <div class="progress progress-u progress-xs">
                    <div style="width: 68%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="68" role="progressbar" class="progress-bar progress-bar-u">
                    </div>
                </div>
            </div><!--/col-md-4-->
        </div> 
        <!-- About Description -->
    </div>
    			
	<article class="bg-slivergray">			
		<div class="container content">
        <div class="title-box-v2">
            <h2>
            오픈소스 서비스
            <small>메르디앙은 오픈소스들에 대한 프리미엄 지원 및 개발자 지원 서비스를 제공하고 있습니다. </small>
            </h2>
            <p>메르디앙은 오픈소스들에 대한 프리미엄 지원 및 개발자 지원 서비스를 제공하고 있습니다. </p>
        </div>

        <div class="row margin-bottom-40">
            <!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/sites/all/themes/gopo13/images/oss-logo-spring.png" alt="">       
                    <p>
					Spring is the most popular and complete application development framework for enterprise Java™. Spring projects provide comprehensive infrastructure support for developing Java applications. Millions of developers use Spring to build modern Web and enterprise applications The Spring Framework is released under version 2.0 of the Apache License. Learn more about open source Spring projects.	
					</p>
                </div>  
            </div>
            <!-- End Simple Block -->
             <!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/assets/images/oss/logo-oss-hadoop.png" alt="">       
                    <p>
					The popular Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models. It is designed to scale up from single servers to thousands of machines, each offering local computation and storage.
					</p>
                </div>  
            </div>
            <!-- End Simple Block -->
            <!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/sites/all/themes/gopo13/images/oss-logo-groovy.png" alt="">       
                    <p>
					Groovy is an agile and dynamic language for the Java Virtual Machine that builds upon the strengths of Java but has additional power features inspired by languages like Python, Ruby and Smalltalk Groovy makes modern programming features available to Java developers with almost-zero learning curve.	
					</p>
                </div>  
            </div>
            <!-- End Simple Block -->
		</div>
		<div class="row margin-bottom-40">
            <!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/sites/all/themes/gopo13/images/oss-logo-redis.png" alt="">       
                    <p>
                    Redis is an open-source, networked, in-memory, key-value data store with optional durability. It is written in ANSI C. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets. Redis is open source software released under the terms of the three clause BSD license. Redis is the most popular key-value store in the cloud.
                    </p>
                </div>  
            </div>
            <!-- End Simple Block -->   
            <!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/sites/all/themes/gopo13/images/oss-logo-openchorus.png" alt="">       
                    <p>
                   The OpenChorus project aims to develop a platform for collaborative data science with Greenplum customers, data science practitioners, open source developers, and a variety of like-minded partners, while facilitating an open dialogue about the future of predictive analytics.
                   </p>
                </div>  
            </div>
            <!-- End Simple Block -->        
			<!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/assets/images/oss/logo-oss-tomcat.png" alt="">       
                    <p>
                  Apache Tomcat is a popular open source application server that implements the Java Servlet, JavaServer Pages, Java Unified Expression Language and Java WebSocket technologies. Apache Tomcat powers numerous large-scale, mission-critical web applications, including those written in Spring, across a diverse range of industries and organizations, and is released under the Apache License version 2.
                  </p>
                </div>  
            </div>
            <!-- End Simple Block -->      
		</div>
		<div class="row margin-bottom-40">
			<!-- Begin Easy Block v2 -->                
            <div class="col-md-4 col-sm-6 md-margin-bottom-20">
                <div class="simple-block">
                    <img class="img-responsive p-sm" src="http://www.pivotal.io/assets/images/oss/oss-logo-apache.png" alt="">       
                    <p>
                  Apache HTTP Server is the most popular web server on the Internet, powering over 100 million websites, and one of the oldest open source projects in use today. Apache HTTP Server provides functionality around authentication, security and content delivery and is released under the Apache License version 2.
                  </p>
                </div>  
            </div>
            <!-- End Simple Block -->                                                    
        </div>
    </div>
</article>
<div class="container content">		
    	<!-- Meer Our Team -->
    	<div class="headline"><h2>프로젝트 멤버</h2></div>
        <div class="row team">
            <div class="col-sm-3">
                <div class="thumbnail-style">
                    <img class="img-responsive" src="/images/common/no-image2.jpg" alt="">
                    <h3><a>Antonio</a> <small>Software Architect</small></h3>
                    <p>열정만 있는 소프트웨어 아키텍트이자 게으른 자바 개발자.</p>
                    <ul class="list-unstyled list-inline team-socail">
                    	<li><a href="#"><i class="fa fa-facebook"></i></a></li>
                    	<li><a href="#"><i class="fa fa-twitter"></i></a></li>
                    	<li><a href="#"><i class="fa fa-google-plus"></i></a></li>
                    </ul>
                </div>
            </div>            
        </div><!--/team-->
    	<!-- End Meer Our Team -->
    </div>
			
			<!-- END MAIN CONTENT -->	
			</#if>	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- END FOOTER -->
		</div><!-- ./wrapper -->	
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>