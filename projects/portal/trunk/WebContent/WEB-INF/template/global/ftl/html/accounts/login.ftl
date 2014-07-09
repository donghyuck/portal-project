<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
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
	<body class="color3">
				<div class="mockup-content">

				

					<div class="morph-button morph-button-modal morph-button-modal-1 morph-button-fixed no-margin">
						<button type="button">이용약관</button>
						<div class="morph-content">
							<div>
								<div class="padding-sm">
									<button type="button" class="btn-close">Close</button>
									<h2>Terms &amp; Conditions</h2>
									<p>Pea horseradish azuki bean lettuce avocado asparagus okra. Kohlrabi radish okra azuki bean corn fava bean mustard tigernut juccama green bean celtuce collard greens avocado quandong <strong>fennel gumbo</strong> black-eyed pea. Grape silver beet watercress potato tigernut corn groundnut. Chickweed okra pea winter purslane coriander yarrow sweet pepper radish garlic brussels sprout groundnut summer purslane earthnut pea <strong>tomato spring onion</strong> azuki bean gourd.</p>
									<p><input id="terms" type="checkbox"><label for="terms">I accept the terms &amp; conditions.</label></p>
								</div>
							</div>
						</div>
					</div>
					 


					<div class="morph-button morph-button-modal morph-button-modal-1 morph-button-fixed no-margin">
						<button type="button">개인정보보호</button>
						<div class="morph-content">
							<div>
								<div class="padding-sm">
									<button type="button" class="btn-close">Close</button>
									<h2>Terms &amp; Conditions</h2>
									<p>Pea horseradish azuki bean lettuce avocado asparagus okra. Kohlrabi radish okra azuki bean corn fava bean mustard tigernut juccama green bean celtuce collard greens avocado quandong <strong>fennel gumbo</strong> black-eyed pea. Grape silver beet watercress potato tigernut corn groundnut. Chickweed okra pea winter purslane coriander yarrow sweet pepper radish garlic brussels sprout groundnut summer purslane earthnut pea <strong>tomato spring onion</strong> azuki bean gourd.</p>
									<p><input id="terms" type="checkbox"><label for="terms">I accept the terms &amp; conditions.</label></p>
								</div>
							</div>
						</div>
					</div>
					


					<div class="morph-button morph-button-modal morph-button-modal-2 morph-button-fixed no-margin">
						<button type="button">Login</button>
						<div class="morph-content">
							<div>
								<div class="content-style-form content-style-form-1">
									<button type="button" class="btn-close">Close</button>
									<h2>Login</h2>
									<form>
										<p><label>Email</label><input type="text"></p>
										<p><label>로그인</label><input type="password"></p>
										<p><button>Login</button></p>
									</form>
								</div>
							</div>
						</div>
					</div>					 


					<div class="morph-button morph-button-modal morph-button-modal-2 morph-button-fixed no-margin">
						<button type="button">회원가입</button>
						<div class="morph-content">
							<div>
								<div class="content-style-form content-style-form-1">
									<button type="button" class="btn-close">Close</button>
									<h2>Login</h2>
									<form>
										<p><label>Email</label><input type="text"></p>
										<p><label>Password</label><input type="password"></p>
										<p><button>Login</button></p>
									</form>
								</div>
							</div>
						</div>
					</div>					 

		</div>			
		
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