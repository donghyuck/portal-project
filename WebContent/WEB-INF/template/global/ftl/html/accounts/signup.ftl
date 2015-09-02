<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 회원가입<#else>회원가입</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>', 
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',			
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',			
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
				
				common.ui.setup({
					features:{
						wallpaper : true,
						loading:true
					}
				});	
				
								
				// START SCRIPT	
				prepareSignUp();
				// END SCRIPT            
			}
		}]);	

		function prepareSignUp () {	
			common.ui.data.user( {
				success : function ( user ) {				
					if( !user.anonymous ){
						var template = kendo.template($("#alert-template").html());	
						$(".container:first").prepend(template(user));				
					}else{
						createSignUpBlock(user)	
					}													
				}				
			} );
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
						window.open( common.ui.connect.authorizeUrl(btn.data('target')),
								btn.data('target') + " Window", 
								"height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes");	
						return false;	
					},
					signup : new SignupForm()
				});
				kendo.bind(renderTo, observable);
				renderTo.data("model", observable );				
			}
			//renderTo.show();
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
		
		function handleCallbackResult( success ){
			var renderTo = $("#signup");
			kendo.ui.progress(renderTo, false);	
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
		
		/*For Mobile Devices*/
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
			<div class="container" style="min-height:570px;">
					<div id="signup" class="reg-block animated fadeIn" style="display:none;" data-bind={visible:visible}>	
						<div class="reg-block-header no-border">
							<h2>회원가입</h2>
				<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
					<p>쇼셜계정을 사용하여 손쉽게 회원 가입 하실수 있습니다.</p>
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
										<section>
											<label class="checkbox">
												<input type="checkbox"  id="signupInputAgree" name="signupInputAgree" required validationMessage="회원가입을 위하여 동의가 필요합니다.">
												<i></i>
												서비스 약관과 개인정보취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
											</label>
										</section>
									</fieldset>	
									<footer class="text-right">
										<button type="reset" value="Reset" class="btn btn-info btn-flat btn-outline">취소</button>
										<button type="button" class="btn btn-info btn-flat btn-outline signup">확인</button>
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

				
		<!--<nav class="navbar navbar-fixed-bottom" role="navigation" class="color:#000000;">
			<div class="container-fluid">
				<ul class="nav navbar-nav navbar-left">
					 <li><a href="#">약관</a></li>
					 <li><a href="#">개인정보보호</a></li>
					 <li><a href="<@spring.url '/accounts/login.do'/>">로그인</a></li>
					 <li><a href="#" onClick="toggleWindow(); return false;">회원가입</a></li>
				</ul>
			</div>
		</nav>-->
	<!-- Modal -->
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
												<input type="checkbox"  id="signupInputAgree" name="signupInputAgree" required validationMessage="회원가입을 위하여 동의가 필요합니다."> 서비스 약관과 개인정보취급방침 및 개인정보 수집항목•이용목적•보유기간에 동의합니다.
											</label>
										</div>
									</fieldset>	
									<div class="pull-right">	
										<button type="reset" value="Reset" class="btn btn-info" data-dismiss="modal">취소</button>
										<button type="button" class="btn btn-info signup">확인</button>
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
			<a href="/" class="btn btn-info btn-flat btn-lg">메인으로 이동</a><a href="/logout" class="m-l-sm btn btn-danger btn-flat btn-lg">로그아웃</a>
		</div>
	</div>
    </script>			
	</body>    
</html>
