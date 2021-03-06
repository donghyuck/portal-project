<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 회원가입<#else>회원가입</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',	
			'css!<@spring.url "/styles/fonts/line-icons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/page_signin_signup_v4.css"/>',
			
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			
					
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jquery.plugins/jquery.ui.shake.min.js"/>',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',						
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 				
			'<@spring.url "/js/common/common.ui.core.js"/>',
			'<@spring.url "/js/common/common.ui.bootstrap.js"/>',
			'<@spring.url "/js/common/common.ui.data.min.js"/>',
			'<@spring.url "/js/common/common.ui.connect.min.js"/>'
			],	
			complete: function() {
                <#if action.url??>
				  console.log( '${action.url}'); 
				</#if>	
				// START SCRIPT	
				common.ui.setup({
					features:{
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){
								var renderTo = $("#signup");		
								if( !e.token.anonymous ){				
									createAlertBlock(e.token);
								}else{
									renderTo.fadeIn()
									prepareSignUp()	
								}
							} 
						}						
					}
				});	
				// END SCRIPT            
			}
		}]);	

		function createAlertBlock(currentUser){
			var template = kendo.template($("#alert-template").html());	
			$(".container:first").prepend(template(currentUser));			
		}

		function createWelcomeBlock(Form){
			var renderTo = $(".form-block");		
			renderTo.fadeOut({
				done : function(){
					var template = kendo.template($("#welcome-template").html());	
					$(".container:first").prepend(template(Form));				
				}
			});
						
		}
		
				
		function prepareSignUp () {	
			common.ui.data.user( {
				success : function ( user ) {				
					if( !user.anonymous ){
						var template = kendo.template($("#alert-template").html());	
						$(".container:first").prepend(template(user));				
					}else{
						createSignUpBlock(user);	
					}													
				}				
			} );
		}
		
		function disableSighUpBlock(){
			var renderTo = $("#signup");
			renderTo.find('button').attr('disabled', '');
			renderTo.find('fieldset').attr('disabled', '');		
		}

		function enableSighUpBlock(){
			var renderTo = $("#signup");
			renderTo.find('button[disabled]').attr('disabled', null);
			renderTo.find('fieldset[disabled]').attr('disabled', null);		
		}
				
		function createSignUpBlock(user){
			var renderTo = $("#signup");
			if( !common.ui.defined(renderTo.data("model")) ){
				var SignupForm = kendo.data.Model.define({
						id : "id",
						fields: {
							"media": { type: "string", defaultValue : "internal" },
							"id": { type: "string" },
							"username": { type: "string" },
					        "firstName": { type: "string" },
					        "lastName": { type: "string" },        
					        "name": { type: "string" },
					        "email": { type: "string" },
					        "locale": { type: "string" },
					        "location": { type: "string" },
					        "languages": { type: "string" },
					        "timezone": { type: "string" },
					        "gender" : { type: "string" },
					        "password1": { type: "string" },
					        "password2": { type: "string" },
					        "onetime": { type: "string" },
					        "nameVisible" : { type:"boolean", defaultVlaue: false },
					        "emailVisible" : { type:"boolean", defaultVlaue: false },
					        "agree":  { type:"boolean", defaultVlaue: false }
						}
					});
					
				var observable =  common.ui.observable({
					visible : true,
					connectWith : function(e){
						var btn = $(e.target);
						kendo.ui.progress(renderTo, true);	
						console.log( btn.data('target') );						
						window.open( 
							common.ui.connect.authorizeUrl(btn.data('target')),
							btn.data('target') + " Window", 
							"height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes");	
						return false;	
					},
					form: new SignupForm(),
					register: function(e){
						var btn = $(e.target);
					} 
				});
				
				var validator = renderTo.find("form").kendoValidator({
					rules : {
						matches: function (input) {
				            var matchesPropertyName = input.data("matches");
				            if (!matchesPropertyName) return true;
				            var propertyName = input.prop("kendoBindingTarget").toDestroy[0].bindings.value.path;
				            return (observable.get(matchesPropertyName) === observable.get(propertyName));
				        }
					},
					messages : {
						matches: function (input) {
		                    return input.data("matches-msg") || "Does not match";
		                }
					},
					errorTemplate: "<p class='text-danger'>#=message#</p>"
				}).data("kendoValidator");
				
				renderTo.find("form").submit(function(e) {		
					e.preventDefault();				
					if( validator.validate() ){
						
						if( $("#signup-status").is(":visible") ){
							$("#signup-status").fadeOut();
						}
						kendo.ui.progress(renderTo, true);	
						common.ui.ajax(
						"<@spring.url "/data/accounts/register.json?output=json"/>", 
						{
							data: common.ui.stringify( observable.form ),
							contentType : "application/json",
							success : function( response ) {   
								if( response.error ){ 
									$("#signup-status").html("죄송합니다. 나중에 나중에 아주 나중에 다시 해보세요.");									
									$("#signup-status").fadeIn();
								} else {     
								createWelcomeBlock(observable.form);								
								<#if action.url??>
								//location.href="<@spring.url "/accounts/login?ver=1&url=${action.url}"/>";
								<#else>
								//location.href="<@spring.url "/accounts/login?ver=1"/>";
								</#if>								
								}
							},
							complete: function(jqXHR, textStatus ){					
								kendo.ui.progress(renderTo, false);	
							},
							error:function(xhr){	
								if( xhr.status == 500 )
								{
									$("#signup-status").html(xhr.responseJSON.error.message);									
									$("#signup-status").fadeIn();	
								}else{
									common.ui.handleAjaxError(xhr);
								} 
							}	
						});	
					}
					//console.log( common.ui.stringify( observable.form ) ) ;
				});	
				kendo.bind(renderTo, observable);
				renderTo.data("model", observable );
			}
		}
		
		function handleCallbackResult( success ){
			var renderTo = $("#signup");
			common.ui.connect.connectedProfile({
				success : function(data){
					console.log( common.ui.stringify( data.user ));
					if( common.ui.defined( data.user ) ){
						if( !data.user.anonymous ){
							disableSighUpBlock();
							var template = kendo.template($("#alert2-template").html());	
							$(".container:first").prepend(template(data));		
						}else{
						
						}
					}
				},
				complete : function(){
					kendo.ui.progress(renderTo, false);	
				}
			});	
		}		
		function validateRequired ( input ) {
			var signupPlaceHolder = getSignupPlaceHolder();
			if( signupPlaceHolder.isExternal() ){				
				if(input.is("[name=signupInputEmail]") || 
					input.is("[name=signupInputPassword1]") || 
					input.is("[name=signupInputPassword2]") 
				){
					return false;
				} 
			}
			return true;			
		}

		
		function signupCallbackResult( media, code , exists  ){
			if(exists){
				if( code != null && code != ''  ){					
					common.api.user.signin({
						onetime: code,
						success : function( token ){
							homepage();
						},
						fail : function (response) {	
						}  
					});								
				}else{
					alert( media +  "인증에 실패하였습니다." );
				}			
			}else{
				$("#signup-form").data('kendoValidator').hideMessages();
				$('.has-error').each(function( index ) {				
					$(this).removeClass('has-error');
				});				
				$('#signup-window').modal('hide');
				setTimeout(function(){
					var signupPlaceHolder = getSignupPlaceHolder();
					signupPlaceHolder.reset();
					signupPlaceHolder.media = media ;
					signupPlaceHolder.onetime = code ;					
					if( media == 'twitter'){					
						$('form[name="fm2"] fieldset').removeClass("hide");
					}					
					$('#signup-modal').modal('show');
				},300);									
			}		
		}
		
		function toggleWindow(){
			$('#signup-window').modal('toggle');
		}
		
		function getSignupPlaceHolder(){
			var signupPlaceHolder =  $("#signup-form").data("signupPlaceHolder");				
			return signupPlaceHolder ;	
		}

		function goLogin(){
			
			window.location.replace("/accounts/login.do");
			
		}	
				
		function homepage(){
			window.location.replace("/main.do");
		}		
		
		
		-->
		</script>
		
		<style>
		
		.navbar-fixed-top .navbar-btn {
		    border: #fff solid 1px;
		    color: #fff;
		    background: rgba(255, 255, 255, 0.3);
		}
		
		.navbar-fixed-top .navbar-btn:hover {
			color: #000!important;
			background:#fff!important;
			border:#fff solid 1px !important;
		}
		
		.navbar-fixed-top .navbar-text {
			color:#fff;
		}		
		
		
		.wrapper {
			background:transparent;
		}
		.navbar-brand>img {
			max-width: 150px;
			height:auto;
		}	
		.copyright-text{
			color:#fff;
		}
		
		.wrapper > footer {
			position: fixed;
			bottom: 0;
			width : 100%;
		}
		footer a {
			color:#fff;
		}
		
		footer a:hover{
			color:#fff;
		}

		.sky-form .note-error.k-invalid-msg 
		{
			color:#EC1414!important;
		}

		.sky-form .checkbox input:checked++i:after {
		    opacity: 1;
		}
		
		.popover {
			display: block;
			margin: 80px auto;
			right: 0;
			border: 0px solid #a94442;
			background: rgba(55, 58, 71, 0.5);
			color : #fff;
			max-width: 350px;
		    border-radius: 6px!important;
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
			margin-bottom : 20px;
		}
		
		
	.reg-block .email-login {
		color: rgba(0,0,0,.5);
		padding-top: 60px;
		border-top: 1px solid #eee;
		position: relative;
	}

	.form-block {
		padding:15px;
	    min-width: 430px;
	    margin: 60px auto;	
	    float: right;
		border-radius: 6px!important;
		border: 1px solid rgba(0,0,0,.2);
		-webkit-box-shadow: 0 5px 10px rgba(0,0,0,.2);
	    box-shadow: 0 5px 10px rgba(0,0,0,.2);		    
	}


	.reg-block .social-login {
		border : 0 ;
	}

	@media (min-width: 992px)
	{
		.reg-block, .reg-block {
			min-width : 400px;
		}
	
	}
	
	.k-invalid-msg {
	    font-size: .9em;
	}

	/**/
	/* radios and checkboxes */
	/**/


	.sky-form .radio,
	.sky-form .checkbox {
		margin-bottom: 4px;
		padding-left: 27px;
		font-size: 1.0em;
		line-height: 27px;
		color: #999;
		cursor: pointer;
		font-weight:200;
	}
	.sky-form .radio:last-child,
	.sky-form .checkbox:last-child {
		margin-bottom: 0;
	}
	.sky-form .radio input,
	.sky-form .checkbox input {
		position: absolute;
		left: -9999px;
	}
	.sky-form .radio i,
	.sky-form .checkbox i {
		position: absolute;
		top: 5px;
		left: 0;
		display: block;
		outline: none;
		border-style: solid;
		background: #fff;
	    width: 17px;
	    height: 17px;
	    border-width: 1px;
	}
	.sky-form .radio i {
		border-radius: 50%;
	}
	.sky-form .radio input + i:after,
	.sky-form .checkbox input + i:after {
		position: absolute;
		opacity: 0;
		-ms-transition: opacity 0.1s;
		-moz-transition: opacity 0.1s;
		-webkit-transition: opacity 0.1s;
	}
	.sky-form .radio input + i:after {
		content: '';
		top: 4px;
		left: 4px;
		width: 5px;
		height: 5px;
		color:#999;
		border-radius: 50%;
	}
	.sky-form .checkbox input + i:after {
		content: '\f00c';
		top: 2px;
		left: 0px;
		width: 15px;
		height: 15px;
		color:#999;
		font: normal 10px FontAwesome;
		text-align: center;
	}
	.sky-form .radio input:checked + i:after,
	.sky-form .checkbox input:checked + i:after {
		opacity: 1;
	}
		
		
		button[data-target=facebook],button[data-target=twitter]{
			font-size:1em;
		}
		
		/**
		.reg-block {
			width: 480px;
			padding: 0px;
			margin: 60px auto;
			background: #fff;			
			float: right;
		    border-radius: 6px!important;
		 	border: 1px solid rgba(0,0,0,.2);
			-webkit-box-shadow: 0 5px 10px rgba(0,0,0,.2);
    		box-shadow: 0 5px 10px rgba(0,0,0,.2);		    
		}

		.reg-block-header {
			padding:20px 20px 10px 20px;
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
		
		
		.reg-block .sky-form {
			border:0;
		}
		
		.reg-block h2, .reg-block p, .reg-block p a {
			color: #777;
		}
						
		.reg-block p {
			font-size : 1.2em;
		}
		
		.reg-block-header h2 {
			font-size: 28px;
		}
		
		.reg-block .sky-form .checkbox {
			font-size : 1.0em;
			color:#999;
		}
		
		.reg-block .sky-form footer {
		    border-top: 0;
		    border-bottom-left-radius: 6px!important;
		    border-bottom-right-radius: 6px!important;		
		}		
		
		@media (max-width: 500px) { 
			.reg-block {
				width: 100%;
				margin: 60px auto;
			}
		}

		.heading h6 {
			padding: 0 12px;
			position: relative;
			display: inline-block;
			line-height: 34px !important; /*For Tagline Boxes*/
		}
		
		.heading h6:before,.heading h6:after {
			content: ' ';
			width: 70%;
			position: absolute;
			border-width: 1px;
			border-color: #bbb;
		}
		
		.heading h6:before {
			right: 100%;
		}
		
		.heading h6:after {
			left: 100%;
		}
		
		@media ( max-width : 768px) {
			.heading h6:before,.heading h6:after {
				width: 20%;
			}
		}				
		.heading-v4 h6:before,.heading-v4 h6:after {
			top: 17px;
			border-bottom-style: solid;
		}				
				
				
		.k-widget.k-tooltip-validation {
			background-color: transparent ;
			color: #a94442;
			border-width: 0;
		}
		
		.k-tooltip {
			-webkit-box-shadow : 0 0 0 0 ;
			box-shadow : 0 0 0 0;
		}

		.nav>li>a:hover {
			background-color:#007AFF;
			color : #ffffff;
		}
	
		.cbp-bicontrols {
			top: 80%;
		}
		.cbp-bicontrols span:before {
			font-size: 40px;
			opacity: 0.7;
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
					<div class="collapse navbar-collapse pull-right"> 
						<p class="navbar-text">이미 이용하고 계신가요 ?</p> 
						<#if action.url??>
						<a href="<@spring.url"/accounts/login?ver=1&url=${action.url}"/>" class="btn-u btn-brd btn-u-md navbar-btn">로그인</a> 		
						<#else>
						<a href="<@spring.url"/accounts/login?ver=1"/>" class="btn-u btn-brd btn-u-md navbar-btn">로그인</a> 				
						</#if>
						
					</div>
	
				</div>
			</nav>		
			<div class="container" style="min-height:500px;">			
				<div class="row">			
					<div class="col-sm-6 col-sm-offset-6 col-md-4 col-md-offset-8 form-block">
					
						<div id="signup" class="reg-block no-border" style="display:none;" data-bind="{visible:visible}">						
							<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
								
								<div class="row">
									<div class="col-sm-6">
										<button class="btn btn-block btn-flat btn-outline rounded btn-primary btn-lg" data-bind="{click:connectWith}" data-target="facebook"><i class="fa fa-facebook"></i> | 페이스북으로 회원가입</button>
									</div>
									<div class="col-sm-6">
										<button class="btn btn-block btn-flat btn-outline rounded btn-info btn-lg" data-bind="{click:connectWith}" data-target="twitter"><i class="fa fa-twitter"></i> | 트위터로 회원가입</button>
									</div>
								</div>		
							</#if>			
							
							<form role="form" id="signup-form" name="fm1" method="POST" accept-charset="utf-8" class="sky-form">
							<div class="heading heading-v4 margin-top-20">
                        		<h6>혹은 직접 입력하여 주세요.</h6>
                    		</div>
							
							<div id="signup-status" class="alert alert-danger rounded-2x no-border" style="display:none;"></div>
							
							<div class="input-group margin-bottom-10">
								<span class="input-group-addon rounded-left"><i class="icon-pencil color-green"></i></span>
								<input name="name" type="text" class="form-control rounded-right" placeholder="이름"  data-bind="value: form.name" required data-required-msg="이름을 입력하여 주십시오.">
							</div>
							<span class="k-invalid-msg" data-for="name"></span>
							<div class="input-group margin-bottom-10">
								<span class="input-group-addon rounded-left"><i class="icon-user color-green"></i></span>
								<input name="username" type="text" class="form-control rounded-right" placeholder="아이디" data-bind="value: form.username" data-available  required data-required-msg="아이디를 입력하여 주십시오.">
							</div>
							<span class="k-invalid-msg" data-for="username"></span>
							<div class="input-group margin-bottom-10">
								<span class="input-group-addon rounded-left"><i class="icon-envelope color-green"></i></span>
								<input name="email" type="email" class="form-control rounded-right" placeholder="메일" data-bind="value: form.email" required  data-required-msg="메일주소를 입력하여 주십시오." data-email-msg="메일주소 형식이 바르지 않습니다.">
							</div>
							<span class="k-invalid-msg" data-for="email"></span>	
							<div class="input-group margin-bottom-10">
								<span class="input-group-addon rounded-left"><i class="icon-lock color-green"></i></span>
								<input name="password1"type="password" class="form-control rounded-right" placeholder="비밀번호" data-bind="value: form.password1" required data-required-msg="비밀번호를 입력하여 주십시오." pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).{8,}" validationMessage="비밀번호는 대문자, 소문자, 숫자, 특수문자를 포합하는 8자이상이여야 합니다.">
							</div>
							<span class="k-invalid-msg" data-for="password1"></span>
							<div class="input-group margin-bottom-10">
								<span class="input-group-addon rounded-left"><i class="icon-lock color-green"></i></span>
								<input name="password2" type="password" class="form-control rounded-right" placeholder="비밀번호확인" data-matches="form.password1" data-bind="value: form.password2" required data-matches-msg="비밀번호를 정확하게 다시 입력하여 주세요." data-required-msg="비밀번호를 다시한번 입력하여 주십시오.">
							</div>
							<span class="k-invalid-msg" data-for="password2"></span>		
							<div class="margin-bottom-20">
											<label class="checkbox">
												<input type="checkbox" name="agree" data-bind="checked:form.agree" required validationMessage="회원가입을 위하여 동의가 필요합니다.">
												<i></i>
												<span class="k-invalid-msg" data-for="agree" role="alert" style="display: none;">회원가입을 위하여 동의가 필요합니다.</span>												
												서비스 약관과 개인정보취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
											</label>
							</div>		
							<button type="submit" class="btn-u btn-block rounded">가입</button>
							</form>
						</div>					
					
					</div>
				</div>
			</div>		
								
			<div class="container" style="min-height:570px;">
					<div  class="reg-block animated fadeIn" style="display:none;" data-bind={visible:visible}>	
						<div class="reg-block-header no-border">
							<h2>회원가입</h2>
							<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
								<div class="row">
									<div class="col-sm-6">
										<button class="btn btn-block btn-flat btn-outline rounded btn-primary btn-lg" data-bind="{click:connectWith}" data-target="facebook"><i class="fa fa-facebook"></i> | 페이스북으로 회원가입</button>
									</div>
									<div class="col-sm-6">
										<button class="btn btn-block btn-flat btn-outline rounded btn-info btn-lg" data-bind="{click:connectWith}" data-target="twitter"><i class="fa fa-twitter"></i> | 트위터로 회원가입</button>
									</div>
								</div>		
							</#if>	
						</div>
						
								<form role="form" id="signup-form" name="fm1" method="POST" accept-charset="utf-8" class="sky-form">
									<div class="heading heading-v4">
                        				<h6>혹은 직접 입력하여 주세요.</h6>
                    				</div>
									<fieldset <#if !action.user.anonymous >disabled</#if> style="padding-top:0;" >
										<div class="form-group">
											<label for="signupInputName">이름</label>
											<input type="text" class="form-control" id="signupInputName" name="signupInputName" placeholder="이름" data-bind="value: form.name" required data-required-msg="이름을 입력하여 주십시오." >
										</div>
										<div class="form-group">
											<label for="signupInputUsername">아이디</label>
											<input type="text" class="form-control" id="signupInputUsername" name="signupInputUsername" placeholder="아이디" data-bind="value: form.username" data-available  required data-required-msg="아이디를 입력하여 주십시오." >
											 <span data-for="RetireDate"></span>
										</div>									
										<div class="form-group">
											<label for="signupInputEmail">이메일 주소</label>
											<input type="email" class="form-control" id="signupInputEmail" name="signupInputEmail"  placeholder="이메일 주소" data-bind="value: form.email" required  data-required-msg="메일주소를 입력하여 주십시오." data-email-msg="메일주소 형식이 바르지 않습니다." >
										</div>
										<div class="form-group">
											<label for="signupInputPassword1">비밀번호</label>
											<input type="password" class="form-control" id="signupInputPassword1" name="signupInputPassword1"  placeholder="비밀번호" data-bind="value: form.password1" required data-required-msg="비밀번호를 입력하여 주십시오." pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&+=]).{8,}" validationMessage="비밀번호는 대문자, 소문자, 숫자, 특수문자를 포합하는 8자이상이여야 합니다.">
										</div>
										<div class="form-group">
											<label for="signupInputPassword2">비밀번호 확인</label>
											<input type="password" class="form-control" id="signupInputPassword2" name="signupInputPassword2"  placeholder="비밀번호 확인" data-matches="form.password1" data-bind="value: form.password2" required data-matches-msg="비밀번호를 정확하게 다시 입력하여 주세요." data-required-msg="비밀번호를 다시한번 입력하여 주십시오.">
										</div>									
										<section>
											<label class="checkbox">
												<input type="checkbox"  id="signupInputAgree" name="signupInputAgree" data-bind="checked:form.agree" required validationMessage="회원가입을 위하여 동의가 필요합니다.">
												<i></i>
												<div class="note note-error k-invalid-msg" data-for="signupInputAgree" role="alert" style="display: none;">회원가입을 위하여 동의가 필요합니다.</div>												
												서비스 약관과 개인정보취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
											</label>
										</section>
									</fieldset>	
									<footer class="text-right">
										<button type="reset" value="Reset" class="btn btn-info btn-flat btn-outline">취소</button>
										<button type="submit" class="btn btn-info btn-flat btn-outline signup" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>확인</button>
									</footer>	
								</form>
														
					</div>			
			</div><!-- /.container -->

			<footer>
				<nav class="navbar navbar-static-bottom">
				<div class="container">
					<div class="row">
						<div class="col-sm-6">
							<div class="copyright-text">
							<#if action.webSite ?? >${.now?string("yyyy")} &copy; ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
								<#if action.hasWebSiteMenu("RULES_MENU") >
									<#assign website_rules_menu = action.getWebSiteMenu("RULES_MENU") />
									<#list website_rules_menu.components as item >					
									<a href="${item.page}">${item.title}</a> <#if item != website_rules_menu.components?last >|</#if>		
									</#list>
							</#if>
							</div>
						</div>
						<div class="col-sm-6">
						<div class="copyright-text  text-right">
						<#if action.hasWebSiteMenu("FOOTER_MENU") >
							<#assign website_footer_menu = action.getWebSiteMenu("FOOTER_MENU") />
							<#if  website_footer_menu.components?has_content >
								<#list website_footer_menu.components as item >					
									<a href="${item.page}">${item.title}</a> <#if item != website_footer_menu.components?last >|</#if>	
								</#list>
							</#if>
						</#if>
						</div>
						</div>					
					</div><!--/row--> 
				</div>
				</nav>
			</footer>	
					
		</div>			
	<div class="modal fade" id="signup-window" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">회원가입</h4>
				</div>
				<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
				<div class="modal-body color4">
					<fieldset <#if !action.user.anonymous >disabled</#if>>
						<div class="col-sm-6">
							<button class="btn btn-block btn-primary btn-lg custom-social-groups"  data-target="facebook"><i class="fa fa-facebook"></i> | 페이스북으로 회원가입</button>
						</div>
						<div class="col-sm-6">
							<button class="btn btn-block btn-info btn-lg custom-social-groups" data-target="twitter"><i class="fa fa-twitter"></i> | 트위터로 회원가입</button>
						</div>
					</fieldset>		
				</div>
				</#if>
				<div class="modal-body">
						<div class="row">
							<div class="col-sm-12">
								<div id="status"></div>								
								<#if !action.user.anonymous >
								<p class="text-danger">
								<i class="fa fa-info"></i> 현재 로그인 상태입니다.  
								<div class="btn-group ">
									<button type="button" class="btn btn-info btn-sm homepage" ><i class="fa fa-home"></i> 홈페이지 이동</button>
									<button type="button" data-loading-text="로그아웃중 ..." class="btn btn-danger btn-sm logout">로그아웃</button>								
								</div>
								</p>
								</#if>								
							</div>
						</div>	
						<div class="row blank-top-15">
							<div class="col-sm-5"></div>
							<div class="col-sm-7">
								<form role="form" id="signup-form" name="fm1" method="POST" accept-charset="utf-8" >
									<fieldset <#if !action.user.anonymous >disabled</#if>>
										<div class="form-group">
											<label for="signupInputName">이름</label>
											<input type="text" class="form-control" id="signupInputName" name="signupInputName" placeholder="이름" data-bind="value: name" required data-required-msg="이름을 입력하여 주십시오." >
										</div>
										<div class="form-group">
											<label for="signupInputUsername">아이디</label>
											<input type="text" class="form-control" id="signupInputUsername" name="signupInputUsername" placeholder="아이디" data-bind="value: username" data-available  required data-required-msg="아이디를 입력하여 주십시오." >
											 <span data-for="RetireDate"></span>
										</div>									
										<div class="form-group">
											<label for="signupInputEmail">이메일 주소</label>
											<input type="email" class="form-control" id="signupInputEmail" name="signupInputEmail"  placeholder="이메일 주소" data-bind="value: email" required  data-required-msg="메일주소를 입력하여 주십시오." data-email-msg="메일주소 형식이 바르지 않습니다." >
										</div>
										<div class="form-group">
											<label for="signupInputPassword1">비밀번호</label>
											<input type="password" class="form-control" id="signupInputPassword1" name="signupInputPassword1"  placeholder="비밀번호" data-bind="value: password1" required data-required-msg="비밀번호를 입력하여 주십시오.">
										</div>
										<div class="form-group">
											<label for="signupInputPassword2">비밀번호 확인</label>
											<input type="password" class="form-control" id="signupInputPassword2" name="signupInputPassword2"  placeholder="비밀번호 확인" data-bind="value: password2" required data-required-msg="비밀번호를 다시한번 입력하여 주십시오.">
										</div>									
										<div class="checkbox">
											<label>
												<input type="checkbox"  id="signupInputAgree" name="signupInputAgree" required validationMessage="회원가입을 위하여 동의가 필요합니다."> 
												
												서비스 약관과 개인정보취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
											</label>
										</div>
									</fieldset>	
									<div class="pull-right">	
										<button type="reset" value="Reset" class="btn btn-info" data-dismiss="modal">취소</button>
										<button type="button" class="btn btn-info signup" data-action="signup">확인</button>
									</div>	
								</form>
							</div>
						</div>
				</div>
				<!--<div class="modal-footer">					
					<div class="btn-group ">
						<button type="button" class="btn btn-info" >아이디/비밀번호찾기</button>
						<a id="signup"  href="<@spring.url '/accounts/login.do'/>"  class="btn btn-info">로그인</a>
					</div>
					
				</div>-->
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->


	<div class="modal fade bs-modal-lg" id="signup-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title"  id="myModalLabel2">회원가입</h4>
					</div>
					<div class="modal-body">
						<p>
						회원가입을 위해서  <a href="<@spring.url '/content.do?contentId=1'/>" target="_blank" class="btn btn-info">서비스 이용약관</a> 과  
						<a href="<@spring.url '/content.do?contentId=2'/>"  target="_blank" class="btn btn-info"> 개인정보 취급방침</a>을 읽고 동의해 주세요.
						</p>					
						 <div class="panel panel-default panel-border-thick">
							<div class="panel-body">
							
						<form name="fm2" role="form" method="POST" accept-charset="utf-8" >	
							<div class="form-group ">
								<div class="checkbox">
									<label>
										<input type="checkbox"  name="input-agree"  data-bind="checked: agree"  validationMessage="회원가입을 위하여 동의가 필요합니다."> 
											서비스 이용약관과  개인정보 취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
									</label>
								</div>
							</div>	
							<fieldset class="hide">
								<div class="form-group ">
									<label class="control-label"  for="input-email"><span class="label label-primary">메일주소 입력</span></label>
									<input type="email" class="form-control"  id="input-email" name="input-email" placeholder="메일" data-bind="value: email"   data-required-msg="메일주소를 입력하여 주십시오." data-email-msg="메일주소 형식이 바르지 않습니다." >		
									<span class="help-block">서비스 이용을 위하여 메일 주소 입력이 필요합니다.</span>							
								</div>
							</fieldset>			
							<div class="custom-required-inputs">	</div>	
							<div class="custom-alert"></div>						
							<div class="pull-right">	
								<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-primary social-signup" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-check"></i>&nbsp;확인</button>								
							</div>	
						</form>			
						</div></div>			
					</div>
					<!-- 
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary social-signup"><i class="fa fa-check"></i>&nbsp;확인</button>
					</div>-->
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<script type="text/x-kendo-template" id="alert-template">
	<div class="popover pull-right animated bounceInDown">
		<!--<h3 class="popover-title">로그인 상태입니다.</h3>-->
			<div class="popover-content text-center">		
			<img class="img-rounded" src="/download/profile/#=username#?width=100&amp;height=150">	
			<p>#:name # 님은 로그인 상태입니다. 본인이 아니라면 로그아웃을 클릭하십시오.</p>
			<a href="/" class="btn btn-info rounded btn-flat btn-lg">메인으로 이동</a><a href="/logout" class="m-l-sm btn btn-danger rounded btn-flat btn-lg">로그아웃</a>
		</div>
	</div>
    </script>	
	<script type="text/x-kendo-template" id="welcome-template">
	<div class="popover pull-right animated zoomIn">
			<div class="popover-content text-center">		
			<h2>회원이되신것을 환영합니다.</h2>
			<p> 더 나은 서비스를 제공할 수 있도록 최선을 다하겠습니다. 즐거운 하루되세요.</p>
			<#if action.url??>
				<a href="<@spring.url "/accounts/login?ver=1&url=${action.url}"/>" class="m-l-sm btn btn-success rounded btn-flat btn-lg">로그인</a>
			<#else>
				<a href="<@spring.url "/accounts/login?ver=1"/>" class="m-l-sm btn btn-success rounded btn-flat btn-lg">로그인</a>
			</#if>						
		</div>
	</div>
    </script>    	
	<script type="text/x-kendo-template" id="alert2-template">
	<div class="popover pull-right animated bounceInDown">
			<div class="popover-content text-center">		
			<img class="img-rounded" src="#=imageUrl#">	
			<p> #:profile.name # 님은 이미 회원입니다.</p>
			<a href="/" class="btn btn-info btn-flat rounded btn-lg">메인으로 이동</a><a href="/accounts/login" class="m-l-sm btn btn-danger rounded btn-flat btn-lg">로그인</a>
		</div>
	</div>
    </script>			
	</body>    
</html>
