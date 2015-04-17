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
			.breadcrumbs-v3 p	{
				color : #fff;
			}	
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1">
				<div class="container text-center">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl">${ navigator.title }</h1>
					</div><!--/end container-->
			</div>    			
			
					
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
						</div>
					</div>
				</div>	
			</header>	
			</#if>				
			<!-- START MAIN CONTENT -->	
			<div class="container content">
				<div class="row margin-bottom-40">
					<div class="col-md-6 md-margin-bottom-40">
						<p class="text-md">
						<span class="dropcap-bg">메</span>르딩앙은 오픈 소스 소프트웨어 개발자 그룹으로 엔터프라이즈 수준의 응용프로그램과 콤포넌트들을 만들고 있습니다.
						</p>
						<hr class="devider devider-db-dashed">
						<p class="text-md">
						특히 우리는 완전한 100% 프로그램을 만드는 것이 목표가 아닌 누군가의 아이디어를 구현하기 위한 서비스 또는 제품 개발을 돕는 응용프로그램과 콤포넌트들 만드는 것을 목표로 하고 있습니다.
						</p>
						<hr class="devider devider-db-dashed">
						<p class="text-md">
						또한 우리 스스로 역시 생산성 향상을 위하여 다수의 우수한 오픈소스 기술들을 사용하고 있으며 이러한 과정에서 얻어진 유용한 것들을 모두와 공유합니다.								
						</p>
					</div>
					<div class="col-md-6 md-margin-bottom-40">
					
<div class="shadow-wrapper">
            <div class="carousel slide carousel-v1 box-shadow shadow-effect-2" id="myCarousel">
                <ol class="carousel-indicators">
                    <li class="rounded-x active" data-target="#myCarousel" data-slide-to="0"></li>
                    <li class="rounded-x" data-target="#myCarousel" data-slide-to="1"></li>
                    <li class="rounded-x" data-target="#myCarousel" data-slide-to="2"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="item active">
                        <img class="img-responsive" src="/download/image/2111/competence-key_174329024.jpg" alt="" style="max-height: 400px;">
                    </div>
                    <div class="item">
                        <img class="img-responsive" src="/download/image/2131/opensource.jpg" alt="" style="max-height: 400px;">
                    </div>
                    <div class="item">
                        <img class="img-responsive" src="/download/image/2132/opensource.jpg" alt="" style="max-height: 400px;">
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
					
					</div>					
				</div>		
			</div>
		
		<article class="bg-slivergray">			
			<div class="container content no-padding-b">
			<div class="title-box-v2">
				<h1>
					오픈소스 서비스
					<small class="no-border"> 우리는 아래의 오픈소스 기술들을 사용하면서 얻어진 유용한 것들을 제공합니다. </small>
				</h1>
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

				<div class="container">
					<!-- Meer Our Team -->
					<div class="headline"><h2>멤버 소개</h2></div>
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
			
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- END FOOTER -->
		</div><!-- ./wrapper -->	
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>