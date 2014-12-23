<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
<#compress>
		<title><#if action.webSite ?? >${action.webSite.displayName } 로그인<#else>로그인</#if></title>
		<script type="text/javascript"><!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>' 
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
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>'
			],			
			complete: function() {
			
				common.ui.setup({
					features:{
						wallpaper : true,
						loading:true
					}
				});			
				
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
				prepareSignOn();
				
			}
		}]);	

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
					
			var validator = $("#signin-block").kendoValidator({
				errorTemplate: "<b class='tooltip tooltip-alert'>#=message#</b>"
			}).data("kendoValidator");
			
			$('form[name="signin-fm"]').submit(function(e) {		
				var btn = $('.btn-signin');
				btn.button('loading');
				if( validator.validate() ){
					common.ui.ajax(
						"<@spring.url "/login"/>", 
						{
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
		
		-->
		</script>
		<style>	
		
		.reg-block {
			width: 380px;
			padding: 20px;
			margin: 60px auto;
			rgba(255, 255, 255, .8)
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
		</style>
</#compress>		
	</head>
	<body>
		<div class="page-loader"></div>
		<div class="wrapper">
		<div class="container" style="min-height:450px;">
			<div id="signin-block" class="reg-block pull-right animated swing">
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
					 <p>계정을 가지고 있지 않다면, 다음을 클릭하세요. <a class="color-green" href="<@spring.url "/accounts/signup.do"/>">회원가입</a></p>
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
		                <span class="label label-primary">접속 IP</span>&nbsp;<small>${ action.getRemoteAddr() }</small><span class="label label-warning"></span>
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
				</ul>
			</div>
		</nav>	
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