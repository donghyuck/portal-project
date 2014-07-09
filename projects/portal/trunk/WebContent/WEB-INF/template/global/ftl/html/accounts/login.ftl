<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.pages/common.signup_signon.css" />
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
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
			complete: function() {
				common.ui.setup({
					features:{
						backstretch : true,
						morphing : true
					}
				});	

			}
		}]);	
	
		-->
		</script>
		<style>	
		
		.nav>li>a{
			color: #fff;
			font-weight: 700;
		}
		.nav>li>a:hover, .nav>li>a:focus {
			text-decoration: none;
			background-color: #3498db;
			color: #fff;
		}
		</style>
</#compress>		
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="container">
			<div class="reg-block">
		        <div class="reg-block-header">
		            <h2>Sign In</h2>
		            <ul class="social-icons text-center">
		                <li><a class="rounded-x social_facebook" data-original-title="Facebook" href="#"></a></li>
		                <li><a class="rounded-x social_twitter" data-original-title="Twitter" href="#"></a></li>
		                <li><a class="rounded-x social_googleplus" data-original-title="Google Plus" href="#"></a></li>
		                <li><a class="rounded-x social_linkedin" data-original-title="Linkedin" href="#"></a></li>
		            </ul>
		            <p>Don't Have Account? Click <a class="color-green" href="page_registration1.html">Sign Up</a> to registration.</p>            
		        </div>
		
		        <div class="input-group margin-bottom-20">
		            <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
		            <input type="text" class="form-control" placeholder="Email">
		        </div>
		        <div class="input-group margin-bottom-20">
		            <span class="input-group-addon"><i class="fa fa-lock"></i></span>
		            <input type="text" class="form-control" placeholder="Password">
		        </div>
		        <hr>
		        <label class="checkbox">
		            <input type="checkbox"> 
		            <p>Always stay signed in</p>
		        </label>
		                                
		        <div class="row">
		            <div class="col-md-10 col-md-offset-1">
		                <button type="submit" class="btn-u btn-block">Log In</button>
		            </div>
		        </div>
		    </div>
		</div><!-- ./container -->
		<nav class="navbar navbar-fixed-bottom" role="navigation">
			<div class="container">
				<ul class="nav navbar-nav navbar-right">
					 <li><a href="#">이용약관</a></li>
					 <li><a href="#">개인정보보호</a></li>
					 <li><a href="#" onclick="toggleWindow(); return false;">로그인</a></li>					 
				</ul>
			</div>
		</nav>			
	</body>    
</html>