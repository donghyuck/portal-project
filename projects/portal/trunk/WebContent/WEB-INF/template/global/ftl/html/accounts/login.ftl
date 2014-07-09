<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.pages/common.signup_signon.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jquery.plugins/jquery.ui.shake.min.js',
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
						backstretch : true
					}
				});					
				prepareSignOn();
			}
		}]);	
	
		function prepareSignOn () {

			common.api.getUser( {
				success : function ( token ) {
					if( !token.anonymous ){
						$("form fieldset").prop("disabled", true);
						var template = kendo.template($("#alert-template").html());	
						$(".container:first").prepend(template(token));				
					}			
				}				
			} );		
					
			var validator = $("#signin-block").kendoValidator({
				errorTemplate: "<b class='tooltip tooltip-alert'>#=message#</b>"
			}).data("kendoValidator");
			
			$('form[name="signin-fm"]').submit(function(e) {		
				var btn = $('.btn-signin');
				btn.button('loading');
				if( validator.validate() ){        				
					$.ajax({
						type: "POST",
						url: "/login",
						dataType: 'json',
						data: $('form[name="signin-fm"]').serialize(),
						success : function( response ) {   
							if( response.error ){ 
								common.ui.alert({
									renderTo: "#signin-status",
									data:{message: "입력한 사용자 이름/메일주소 또는 비밀번호가 잘못되었습니다."}
								});
								$("input[type='password']").val("").focus();											
							} else {        	   
								$("#signin-status").html("");                         
								location.href="/main.do";
							} 	
						},
						error:handleKendoAjaxError,
						complete: function(jqXHR, textStatus ){					
							btn.button('reset');
						}
					});
				}else{        			      
					btn.button('reset');
				}			
				return false ;
			});	
						
		}
		
		
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
		
		.popover {
			display: block;
			margin: 80px auto;
			right: 0;
			border: 2px solid #a94442;
		}
		
		.popover-title{
			
		}
		</style>
</#compress>		
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="container" style="min-height:450px;">
			<div id="signin-block" class="reg-block reg-block-transparent  pull-right">
		        <div class="reg-block-header">		        
		            <h2><img src="/download/logo/company/${action.webSite.company.name}" height="42" class="img-circle" alt="로그인"></h2>
		            <ul class="social-icons text-center">
		                <li><a class="rounded-x social_facebook" data-original-title="Facebook" href="#"></a></li>
		                <li><a class="rounded-x social_twitter" data-original-title="Twitter" href="#"></a></li>
		                <li><a class="rounded-x social_googleplus" data-original-title="Google Plus" href="#"></a></li>
		                <li><a class="rounded-x social_linkedin" data-original-title="Linkedin" href="#"></a></li>
		            </ul>
		            <#assign webSite = action.webSite
		            	isAllowedSignup = WebSiteUtils.isAllowedSignup( webSite ) >
		            <#if isAllowedSignup >
					 <p>계정을 가지고 있지 않다면, 다음을 클릭하세요. <a class="color-green" href="{request.contextPath}/accounts/signup.do">회원가입</a></p>
					 </#if>					
		        </div>				
				<form name="signin-fm" class="form-horizontal" role="form" method="POST" accept-charset="utf-8">
				<fieldset>
				<input type="hidden" name="output" value="json" />		    
		        <div class="input-group margin-bottom-20">
		            <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
		            <input type="text" name="username" class="form-control" placeholder="아이디 또는 이메일" pattern="[^-][A-Za-z0-9]{2,20}" required validationMessage="아이디 또는 이메일 주소를 입력하여 주세요.">
		        </div>
		        <div class="input-group margin-bottom-20">
		            <span class="input-group-addon"><i class="fa fa-lock"></i></span>
		            <input type="password" name="password" class="form-control" placeholder="비밀번호" required validationMessage="비밀번호를 입력하여 주세요." >
		        </div>
		        <hr class="no-margin">
		        <label class="checkbox">
		            <input type="checkbox"> 
		            <p>로그인 상태 유지</p>
		        </label>		         
		        <div class="row margin-bottom-20">
		            <div class="col-md-10 col-md-offset-1">
		                <span class="label label-primary">접속 IP</span>&nbsp;<small>${ request.getRemoteAddr() }</small><span class="label label-warning"></span>
		            </div>
		        </div>
		        <div class="row">
		            <div id="signin-status"  class="col-sm-12"></div>
		        </div>
		        <div class="row">
		            <div class="col-md-10 col-md-offset-1">
		                <button type="submit" class="btn btn-primary btn-block btn-signin" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >로그인</button>
		            </div>
		        </div>
		        </fieldset><!-- /fieldset -->
		        </form><!-- /form -->
		    </div><!-- /.reg-block -->
		</div><!-- /.container -->
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
	<script type="text/x-kendo-template" id="alert-template">
	<div class="popover pull-right animated bounceInDown">
		<h3 class="popover-title">로그인 상태입니다.</h3>
			<div class="popover-content">			
			<p>#:name # 님은 로그인 상태입니다.</p>
			<a href="/main.do" class="btn btn-default">메인으로 이동</a>
		</div>
	</div>
    </script>	
</html>