<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>', 
			'css!<@spring.url "/styles/jquery.jgrowl/jquery.jgrowl.min.css"/>',
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jquery.plugins/jquery.ui.shake.min.js"/>',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',						
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 				
			'<@spring.url "/js/common/common.ui.core.js"/>',
			'<@spring.url "/js/common/common.ui.bootstrap.js"/>',
			'<@spring.url "/js/common/common.ui.data.min.js"/>',
			'<@spring.url "/js/common/common.ui.connect.min.js"/>'
			],			
			complete: function() {
			
				common.ui.setup({
					features:{
						wallpaper : true,
						loading:true
					}
				});			
				
				prepareSocialSignOn();
				prepareSignOn();
				
			}
		}]);			
		
		function prepareSocialSignOn(){				
				common.ui.ajax("<@spring.url "/connect/list.json"/>", {
					success: function(response){ 
						var renderTo = $("#signin-block .social-icons");
						var html = kendo.render( kendo.template('<li #if(!allowSignin){# class="hidden"  # } #><a class="rounded-x social_#= provider #" data-action="connect" data-provider-id="#: provider #"  href="\\#"></a></li>') , response.media );
						renderTo.html( html );							
						$("a[data-action='connect']").click(function(e){
							var $this = $(this);				
							$("form[name='signin-fm'] fieldset").attr("disabled", true);									
							window.open( 
								"<@spring.url "/connect/"/>" + $this.data("provider-id") + "/authorize",
								$this.data("provider-id") + " Window", 
								"height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes");	
							return false;								
						});
					}				
				});		
		}

		function prepareSignOn () {		
		
			common.ui.data.user( {
				success : function ( user ) {				
					if( !user.anonymous ){
						$("form fieldset").prop("disabled", true);
						var template = kendo.template($("#alert-template").html());	
						$(".container:first").prepend(template(user));				
					}								
				}				
			} );		
					
			$("#signin-block>button.btn-close").click(function(e){
				$this = $(this);	
				alert("1');
				if($this.hasClass("up")){
					$("#signin-block>section.sky-form").faceIn("slow", function(){
						$this.toggleClass("up");	
					});
				}else{
					$("#signin-block>section.sky-form").faceOut("slow", function(){
						$this.toggleClass("up");	
					});					
				}
			}); 
					
			var validator = $("#signin-block form").kendoValidator({
				errorTemplate: "<div class='note note-error'><i class='fa fa-exclamation-triangle'></i> #=message#</div>"
			}).data("kendoValidator");
			
			$('form[name="signin-fm"]').submit(function(e) {		
				event.preventDefault();
				var btn = $('.btn-signin');
				if( validator.validate() ){
					btn.button('loading');
					common.ui.ajax(
						"<@spring.url "/login_auth"/>", 
						{
							data: $('form[name="signin-fm"]').serialize(),
							success : function( response ) {   
								if( response.error ){ 
									common.ui.alert({
										appendTo: $("#signin-status"),
										message: "입력한 사용자 이름/메일주소 또는 비밀번호가 잘못되었습니다."
									});
									$("input[type='password']").val("").focus();											
								} else {        	   
									$("#signin-status").html("");                         
									location.href="<@spring.url "/main.do"/>";
								} 	
							},
							complete: function(jqXHR, textStatus ){					
								btn.button('reset');
							}	
						}
					);	
				}else{        			      
					btn.button('reset');
				}			
				return false ;
			});			
		}
				

		function handleCallbackResult( success ){
			if( success ){
				common.ui.connect.signin({
					success : function(data){
						if(data.userId > 0){
							location.href="/main.do";
						}else{
							$("form[name='signin-fm'] fieldset").attr("disabled", false);	
						} 
					}
				});
			}else{
				$("form[name='signin-fm'] fieldset").attr("disabled", false);	
			}		
		}
	
		-->
		</script>
		<style>	
		
		.reg-block {
			width: 380px;
			padding: 20px;
			margin: 60px auto;
			background:rgba(255, 255, 255, .8);
		}
		@media ( max-width : 600px) {
			.reg-block {
				width: 100%!important;			
			}
		}
		
		.reg-block .btn-close {
			background-image: url(/images/common/white-angle-up.png);
			background-repeat: no-repeat;
			background-position: center;
			background-color: rgba(0, 0, 0, .6)!important;		
		}

		.reg-block .btn-close.up {
			  background-image: url(/images/common/white-down-up.png);
		}
				
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
		
		.wrapper {
			background:transparent;
		}
		
		.sky-form .note.note-error {
			color: #ff3b30;
		}
		.sky-form .radio, .sky-form .checkbox {
			font-size: 14px;
		}
		
		.sky-form header  {
			background: rgba(255, 255, 255, .5);
		}
		
		.sky-form fieldset {
			background: rgba(255, 255, 255, .8);
		}
		
		.sky-form footer { 
			background: rgba(255, 255, 255, .8);
		}
		
		</style>
</#compress>		
	</head>
	<body class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
		<div class="container" style="min-height:450px;">
			<div id="signin-block" class="reg-block pull-right animated swing no-padding">
				<button class="btn-close"></button>
				<section class="sky-form"> 
					<header class="text-center">
						<img src="/download/logo/company/${action.webSite.company.name}" height="80%" class="img-circle" alt="로그인">
						<ul class="social-icons text-center">
							<li><a class="rounded-x social_facebook" data-original-title="Facebook" href="#"></a></li>
							<li><a class="rounded-x social_twitter" data-original-title="Twitter" href="#"></a></li>
							<li><a class="rounded-x social_googleplus" data-original-title="Google Plus" href="#"></a></li>
							<li><a class="rounded-x social_linkedin" data-original-title="Linkedin" href="#"></a></li>
						</ul>
						<div class="note">쇼셜 로그인을 통한 인증을 지원합니다.</div>					
						<#assign webSite = action.webSite
							isAllowedSignup = WebSiteUtils.isAllowedSignup( webSite ) >
						<#if isAllowedSignup >
						 <p>계정을 가지고 있지 않다면, 다음을 클릭하세요. <a class="color-green" href="<@spring.url "/accounts/signup.do"/>">회원가입</a></p>
						 </#if>						
					</header>
					<form name="signin-fm" role="form" method="POST" accept-charset="utf-8">
						<input type="hidden" name="output" value="json" />
						<fieldset>
							<section>
								<label class="input">
									<i class="icon-append fa fa-envelope"></i>
									<input type="text" name="username" placeholder="아이디 또는 이메일" pattern="[^-][A-Za-z0-9]{2,20}" required validationMessage="아이디 또는 이메일 주소를 입력하여 주세요.">
								</label>
							</section>
							<section>
								<label class="input">
									<i class="icon-append fa fa-lock"></i>
									<input type="password" name="password" placeholder="비밀번호" required  validationMessage="비밀번호를 입력하여 주세요." >
								</label>
							</section>
							<section>
								<div class="row">
									<div class="col col-4"></div>
									<div class="col col-8">
										<label class="checkbox"><input type="checkbox" name="remember"><i></i>로그인 상태 유지</label>
									</div>
								</div>
							</section>
							<section>
								<div class="row">
									<div id="signin-status"  class="col-sm-12"></div>
								</div>
		
								<div class="note"><i class="fa fa-info-circle"></i> 접속 IP: ${ action.getRemoteAddr() }</div>
							</section>
						</fieldset>				
						<footer>
							<button type="submit" class="btn btn-primary btn-block btn-signin" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >로그인</button>
						</footer>
					</form><!-- /form -->
				</section>
			</div><!-- /.reg-block -->
		</div><!-- /.container -->
		<!--
		<nav class="navbar navbar-fixed-bottom" role="navigation">
			<div class="container">
				<ul class="nav navbar-nav navbar-right">
					 <li><a href="#">이용약관</a></li>
					 <li><a href="#">개인정보보호</a></li>	 
				</ul>
			</div>
		</nav>
		-->	
	</div> <!-- ./wrapper -->	
		
	<script type="text/x-kendo-template" id="alert-template">
	<div class="popover pull-right animated bounceInDown">
		<h3 class="popover-title">로그인 상태입니다.</h3>
			<div class="popover-content">			
			<p>#:name # 님은 로그인 상태입니다.</p>
			<a href="/main.do" class="btn btn-default">메인으로 이동</a>
		</div>
	</div>
    </script>
	</body>    	
</html>