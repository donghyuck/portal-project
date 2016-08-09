<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',	
			'css!<@spring.url "/styles/fonts/line-icons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/page_signin_signup_v4.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			
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
				common.ui.setup({
					features:{
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){									
								if( !e.token.anonymous ){				
									createAlertBlock(e.token);
								}else{
									var renderTo = $("#signin");	
									renderTo.fadeIn()
									prepareSocialSignOn();
									createSignInBlock();	
								}
							} 
						}						
					}
				});				
			}
		}]);			
		
		function createAlertBlock(currentUser){
			var template = kendo.template($("#alert-template").html());	
			$(".container:first").prepend(template(currentUser));			
		}
		
		function createSignInBlock(){
			var renderTo = $("#signin");			
			var validator = renderTo.find("form").kendoValidator({
				errorTemplate: "<p class='text-danger'>#=message#</p>"
			}).data("kendoValidator");			
		
			renderTo.find("form").submit(function(e) {		
				event.preventDefault();		
				//var btn = renderTo.find("button[data-action='signin']");
				if( validator.validate() ){					
					if( $("#signin-status").is(":visible") ){
						$("#signin-status").fadeOut();
					}
					common.ui.progress(renderTo, true);		
					common.ui.ajax(
						"<@spring.url "/login_auth"/>", 
						{
							data: renderTo.find("form").serialize(),
							success : function( response ) {   
								if( response.error ){ 
									$("#signin-status").html("입력한 사용자 이름/메일주소 또는 비밀번호가 잘못되었습니다.");									
									$("#signin-status").fadeIn();									
									$("input[type='password']").val("").focus();											
								} else {        	   
									$("#signin-status").html("");    
									<#if action.url??>
									location.href="<@spring.url "${action.url}"/>";
									<#else>
									location.href="<@spring.url "/display/0/my-home.html"/>";
									</#if>	
								} 	
							},
							complete: function(jqXHR, textStatus ){
								common.ui.progress(renderTo, false);		
							}	
						}
					);	
				}else{        			      
					//btn.button('reset');
				}			
				return false ;
			});		
		}
		
		
		function prepareSocialSignOn(){	
			var renderTo = $("#signin");				
			common.ui.ajax("<@spring.url "/connect/list.json"/>", {
				success: function(response){ 
					var renderTo2 = renderTo.find('.social-login ul');
					var html = kendo.render( kendo.template('<li #if(!allowSignin){# class="hidden"# } #><a href="\\#" class="icon-svg-btn bg-transparent hvr-pulse-shrink" data-action="connect" data-provider-id="#= provider #"><i class="icon-flat icon-svg social-color-#= provider.toLowerCase() #"></i></a></li>') , response.media );
					renderTo2.html( html );							
					$("a[data-action='connect']").click(function(e){
						var $this = $(this);	
						//kendo.ui.progress(renderTo, true);							
						var popup = window.open( 
							"<@spring.url "/connect/"/>" + $this.data("provider-id") + "/authorize",
							$this.data("provider-id") + " Window", 
							"height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes");	
						return false;								
					});
				}				
			});		
		}

		function handleCallbackResult( success ){
			var renderTo = $("#signin");	
			if( success ){
				common.ui.connect.signin({
					success : function(data){
						if(data.userId > 0){
							location.href='<@spring.url "/display/0/my-home.html"/>';
						}else{
							$("form[name='signin-fm'] fieldset").attr("disabled", false);	
						} 
					},
					complete:function(e){
						kendo.ui.progress(renderTo, false);					
					}
				});
			}else{
				console.log("====== WOOPS !! ====== ");
				$("form[name='signin-fm'] fieldset").attr("disabled", false);	
			}		
		}
	
		-->
		</script>
		<style>
		
.login-block .or {
	padding:0;
}
			
.login-block .email-login {
	color: rgba(0,0,0,.5);
	padding-top: 60px;
	border-top: 1px solid #eee;
	position: relative;
}

.form-block {
	padding:15px;
    min-width: 380px;
    margin: 60px auto;	
    float: right;
	border-radius: 6px!important;
	border: 1px solid rgba(0,0,0,.2);
	-webkit-box-shadow: 0 5px 10px rgba(0,0,0,.2);
    box-shadow: 0 5px 10px rgba(0,0,0,.2);		    
}


.login-block .social-login {
	border : 0 ;
}

@media (min-width: 992px)
{
	.login-block, .reg-block {
		min-width : 350px;
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


		
		/* Registration and Login Page v2
			------------------------------------*/
			
			
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
			<div class="row">			
				<div class="col-sm-6 col-sm-offset-6 col-md-4 col-md-offset-8 form-block" id="signin" style="display:none;">
					<h2 class="margin-bottom-30 text-center">${action.webSite.displayName}에 로그인</h2>
					<form name="signin-fm" role="form" method="POST" accept-charset="utf-8" class="sky-form">
						<input type="hidden" name="output" value="json" />			
						<div class="login-block">
							<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
							<div class="social-login text-center no-border no-padding">							
								<ul class="list-inline margin-bottom-30">
									<li>
										<a href="#" class="icon-svg-btn bg-transparent" data-original-title="Twitter">									
											<i class="icon-flat icon-svg icon-svg-md social-color-twitter"></i>
										</a>
									</li>
									<li>
										<a href="#" class="icon-svg-btn bg-transparent" data-original-title="Facebook">									
											<i class="icon-flat icon-svg icon-svg-md social-color-facebook"></i>
										</a>
									</li>
								</ul>							
							</div>
							</#if>
							<div class="email-login">
								<#if WebSiteUtils.isAllowedSocialConnect( action.webSite ) >
								<div class="or rounded-x text-center">또는</div>
								</#if>
								<div id="signin-status" class="alert alert-danger rounded-2x no-border" style="display:none;"></div>	
								<div class="input-group margin-bottom-10">
									<span class="input-group-addon rounded-left"><i class="icon-user color-blue"></i></span>
									<input name="username" type="text" class="form-control rounded-right" placeholder="아이디 또는 이메일" pattern="[^-][A-Za-z0-9]{2,20}" required validationMessage="아이디 또는 이메일 주소를 입력하여 주세요.">
								</div>
								<span class="k-invalid-msg" data-for="username"></span>
								<div class="input-group margin-bottom-10">
									<span class="input-group-addon rounded-left"><i class="icon-lock color-blue"></i></span>
									<input name="password" type="password" class="form-control rounded-right" placeholder="비밀번호" required  validationMessage="비밀번호를 입력하여 주세요.">
								</div>
								<span class="k-invalid-msg" data-for="password"></span>

								<label class="checkbox">
									<input type="checkbox" name="rememberMe">
									<i></i>
									로그인 상태 유지
								</label>
											
								<div class="row margin-bottom-30">
									<div class="col-md-12">
										<button data-action="signin" type="submit" class="btn-u btn-u-blue btn-block rounded" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>로그인</button>
										<div class="text-center margin-top-20">
											<a class="btn-link" href="#">아이디 또는 비밀번호를 잊으셨나요 ?</a>
										</div>
									</div>
								</div>	
								
							</div>	
							<p class="text-center">
								${action.webSite.displayName}에 처음이세요?  지금 
								<#if action.url??>
									<a class="btn-link" href="<@spring.url "/accounts/signup?url=${action.url}"/>">가입</a>
								<#else>
									<a class="btn-link" href="<@spring.url "/accounts/signup"/>">가입</a>
								</#if>	
								하세요.
							</p>			
						</div>
					</form>
				</div>
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
	</div> <!-- ./wrapper -->	
		
	<script type="text/x-kendo-template" id="alert-template">
	<div class="popover pull-right animated bounceInDown">
		<!--<h3 class="popover-title">로그인 상태입니다.</h3>-->
			<div class="popover-content text-center">		
			<img class="img-rounded" src="/download/profile/#=username#?width=100&amp;height=150">	
			<p>#:name # 님은 로그인 상태입니다. 본인이 아니라면 로그아웃을 클릭하십시오.</p>

			<#if action.url??>
				<a href="<@spring.url "${action.url}"/>" class="btn btn-info btn-flat btn-lg">이전화면으로 이동</a>
				<a href="/accounts/logout.html?url=<@spring.url "${action.url}"/>" class="m-l-sm btn btn-danger btn-flat btn-lg">로그아웃</a>		
								
			<#else>
				<a href="/" class="btn btn-info btn-flat btn-lg">메인으로 이동</a>
				<a href="/logout" class="m-l-sm btn btn-danger btn-flat btn-lg">로그아웃</a>										
			</#if>
		</div>
	</div>
    </script>
	</body>    	
</html>