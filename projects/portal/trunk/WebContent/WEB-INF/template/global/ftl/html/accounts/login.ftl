<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>', 
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',				
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jquery.plugins/jquery.ui.shake.min.js"/>',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',						
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
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
						var renderTo = $("#signin .social-icons");
						var html = kendo.render( kendo.template('<li #if(!allowSignin){# class="hidden"  # } #><a class="rounded-x social_#= provider #" data-action="connect" data-provider-id="#: provider #"  href="\\#"></a></li>') , response.media );
						renderTo.html( html );							
						$("a[data-action='connect']").click(function(e){
							var $this = $(this);				
							//$("form[name='signin-fm'] fieldset").attr("disabled", true);									
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
					}else{
						$("#signin-block").show();
					}													
				}				
			} );		
			/*		
			$("#signin-block>button.btn-close").click(function(e){
				$this = $(this);					
				if($this.hasClass("up")){					
					$("#signin-block>section.sky-form").slideDown("slow", function(){
						$this.toggleClass("up");	
					});
				}else{
					$("#signin-block>section.sky-form").slideUp("slow", function(){
						$this.toggleClass("up");	
					});					
				}
			
			}); 
				*/		
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
									location.href="<@spring.url "/"/>";
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
		
		/* Registration and Login Page v2
			------------------------------------*/
		.wrapper {
			background:transparent;
		}
					
		.reg-block {
			width: 320px;
			padding: 20px;
			margin: 60px auto;
			background: #fff;			
			border-top: solid 0px #34aadc;
			float: right;
		}

		.reg-block > .sky-form {
			border:0;
		}
		
		.reg-block h2,
		.reg-block p,
		.reg-block p a {
			color: #777;
		}
				
		.reg-block > .sky-form fieldset {
			padding: 10px 0px 5px;
		}
		
		.reg-block p {
			font-size : 1.2em;
		}
		
		.reg-block-header h2 {
			font-size: 28px;
		}
		
		
		/*Forms*/
		.reg-block .input-group-addon {
			color: #bbb;
			background: none;
			min-width: 40px;
		}
		
		.reg-block .form-control:focus {
		   box-shadow: none;
		   border-color: #999;
		}
		
		.reg-block .checkbox { 
			color: #555;
			margin-bottom: 20px;
			font-weight: normal;
		}

		/*Reg Header*/
		.reg-block-header {
			padding-bottom: 5px;
			margin-bottom: 10px;
			border-bottom: solid 1px #eee;
		}
		
		.reg-block-header h2 {
			text-align: center;
			margin-bottom: 15px;
		}
		
		.reg-block-header p {
			text-align: center;
		}
		.reg-block-header p.text-right {
			text-align: right;
		} 
		/*For Mobile Devices*/
		@media (max-width: 500px) { 
			.reg-block {
				width: 300px;
				margin: 60px auto;
			}
		}
		.navbar-brand>img {
			max-width: 150px;
			height:auto;
		}		
		.copyright-text{
			color:#fff;
		}
				
		/**
		.reg-block {
			width: 380px;
			padding: 0px;
			margin: 60px auto;
			background:rgba(255, 255, 255, .8);
			border-top: solid 2px #34aadc;
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
			background-color: rgba(52, 170, 220, .6)!important
		}

		.reg-block .btn-close.up {
			  background-image: url(/images/common/white-angle-down.png);
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
			border: 0px solid #a94442;
			background: rgba(55, 58, 71, 0.5);
			color : #fff;
			max-width: 350px;
		}
		
		.popover > .popover-content {
			padding : 15px;
		}
		
		.popover-content > img {
		  border-radius: 80px!important;
		  display: inline-block;
		  height: 80px;
		  margin: -2px 0 0 0;
		  width: 80px;
		}
		
		.popover  p {
			color : #fff;
			font-size:1.1em;
			margin-top : 15px;
			margin-bottom : 10px;
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
			background: rgba(255, 255, 255, 1);
		}
		
		.sky-form footer { 
			background: rgba(255, 255, 255, 1);
		}
		*/		
		</style>
</#compress>		
	</head>
	<body class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
			<nav class="navbar navbar-fixed-top">
				<div class="container-fluid">
					<div class="navbar-header">
						<a class="navbar-brand" href="/">
							<img alt="Brand" src="/download/logo/company/${action.webSite.company.name}">
						</a>
					</div>					
				</div>
			</nav>		
			<div class="container" style="min-height:450px;">
					<div id="signin" class="reg-block" style="display:none;">	
						<div class="reg-block-header">
							<h2></h2>
							<ul class="social-icons text-center">
								<li><a class="rounded-x social_facebook" data-original-title="Facebook" href="#"></a></li>
								<li><a class="rounded-x social_twitter" data-original-title="Twitter" href="#"></a></li>
								<li><a class="rounded-x social_googleplus" data-original-title="Google Plus" href="#"></a></li>
								<li><a class="rounded-x social_linkedin" data-original-title="Linkedin" href="#"></a></li>
							</ul>
							<p class="m-t-md">${action.webSite.displayName} 회원이 아니신가요? <br >지금 <span class="text-primary">가입</span>하세요.</p>        
							<p class="text-right" ><a class="btn btn-info btn-flat btn-outline" href="<@spring.url "/accounts/signup.do"/>">가입하기</a></p>    
						</div>
						<div class="sky-form">
							<fieldset>
								<section id="signin-status" class="no-margin"></section>						
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
									<label class="checkbox"><input type="checkbox" name="remember"><i></i>로그인 상태 유지</label>
								</section>
							</fieldset>		
						</div>		
		<!--		
		<div class="input-group margin-bottom-20">
			<span class="input-group-addon"><i class="fa fa-envelope"></i></span>
			<input type="text" name="username" placeholder="아이디 또는 이메일" pattern="[^-][A-Za-z0-9]{2,20}" required validationMessage="아이디 또는 이메일 주소를 입력하여 주세요.">
		</div>
		<div class="input-group margin-bottom-20">
			<span class="input-group-addon"><i class="fa fa-lock"></i></span>
			<input type="password" name="password" placeholder="비밀번호" required  validationMessage="비밀번호를 입력하여 주세요." >
		</div>
		
		<hr>		-->
						<div class="row">
							<div class="col-md-10 col-md-offset-1">
								<button type="submit" class="btn btn-info btn-block btn-flat btn-outline btn-lg" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >로그인</button>
							</div>
						</div>			
					</div>
    

			<div id="signin-block" class="reg-block pull-right animated zoomIn" style="display:none;">
				
				<section class="sky-form"> 
					<header class="text-center">
						<!--<img src="/download/logo/company/${action.webSite.company.name}" height="80%" class="img-circle" alt="로그인">-->
						<ul class="social-icons text-center">
							<li><a class="rounded-x social_facebook" data-original-title="Facebook" href="#"></a></li>
							<li><a class="rounded-x social_twitter" data-original-title="Twitter" href="#"></a></li>
							<li><a class="rounded-x social_googleplus" data-original-title="Google Plus" href="#"></a></li>
							<li><a class="rounded-x social_linkedin" data-original-title="Linkedin" href="#"></a></li>
						</ul>
						<p>쇼셜 로그인을 통한 인증을 지원합니다.</p>			
						 <p>계정을 가지고 있지 않다면, 다음을 클릭하세요. <a class="color-green" href="<@spring.url "/accounts/signup.do"/>">회원가입</a></p>		
						<#assign webSite = action.webSite
							isAllowedSignup = WebSiteUtils.isAllowedSignup( webSite ) >
						<#if isAllowedSignup >
						 <p>계정을 가지고 있지 않다면, 다음을 클릭하세요. <a class="color-green" href="<@spring.url "/accounts/signup.do"/>">회원가입</a></p>
						 </#if>						
					</header>
					<form name="signin-fm" role="form" method="POST" accept-charset="utf-8">
						<input type="hidden" name="output" value="json" />
						<fieldset>
							<section id="signin-status" class="no-margin"></section>						
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
									<div class="col-sm-6">
										<div class="m-b-md">
										<label class="checkbox"><input type="checkbox" name="remember"><i></i>로그인 상태 유지</label>
										</div>
									</div>
									<div class="col-sm-6">
										<button type="submit" class="btn btn-info btn-block btn-flat btn-outline btn-lg btn-signin" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >로그인</button>
									</div>
								</div>
							</section>
						</fieldset>				
						<footer class="text-right">
							<div class="text-muted"><i class="fa fa-info-circle"></i> 접속 IP: ${ action.getRemoteAddr() }</div>
						</footer>
					</form><!-- /form -->
				</section>
			</div><!-- /.reg-block -->
		</div><!-- /.container -->
		<footer>
			<nav class="navbar navbar-static-bottom">
			<div class="container">
				<div class="row">
					<div class="col-md-12 col-sm-12">
						<div class="copyright-text">
						<#if action.webSite ?? >${.now?string("yyyy")} &copy; ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
							<#if action.hasWebSiteMenu("RULES_MENU") >
								<#assign website_rules_menu = action.getWebSiteMenu("RULES_MENU") />
								<#list website_rules_menu.components as item >					
							<a href="${item.page}">${item.title}</a> <#if item != website_rules_menu.components?last >|</#if>		
								</#list>
						<#else>
							<a href="<@spring.url '/content.do?contentId=2'/>">개인정보 취급방침</a> | <a href="<@spring.url '/content.do?contentId=1'/>">이용약관</a>
						</#if>
						</div>
					</div>
				</div><!--/row--> 
			</div>
			</nav>
		</footer>	
	</div> <!-- ./wrapper -->	
		
	<script type="text/x-kendo-template" id="alert-template">
	<div class="popover pull-right animated bounceInDown">
		<!--<h3 class="popover-title">로그인 상태입니다.</h3>-->
			<div class="popover-content text-center">		
			<img class="img-rounded" src="/download/profile/#=username#?width=100&amp;height=150">	
			<p>#:name # 님은 로그인 상태입니다. 본인이 아니라면 로그아웃을 클릭하십시오.</p>
			<a href="/" class="btn btn-info btn-flat btn-lg">메인으로 이동</a><a href="/logout" class="m-l-sm btn btn-danger btn-flat btn-lg">로그아웃</a>
		</div>
	</div>
    </script>
	</body>    	
</html>