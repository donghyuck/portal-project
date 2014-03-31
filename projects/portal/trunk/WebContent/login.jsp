<%@ page pageEncoding="UTF-8"%>
<%@ page import="architecture.common.user.*"%>
<html decorator="homepage">
<head>
<title>로그인</title>
<%
	User user = SecurityHelper.getUser();
	Company company = user.getCompany();
%>
<script type="text/javascript">
	yepnope([{
		load: [ 
			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/bootstrap/3.1.0/non-responsive.css',		
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.10.2/jquery.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery.extension/jquery.ui.shake.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/bootstrap/3.1.0/bootstrap.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery.imagesloaded/imagesloaded.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.modernizr.custom.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.api.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.js'],
		complete: function() {
			
			common.api.getUser( {
				success : function ( token ) {
					if( !token.anonymous )
						alert( "이미 로그인되어 있습니다." );
				}				
			} );		
			
			var slideshow = $('#slideshow').extFullscreenSlideshow();
			
			/* LOGIN */
			$('#login-window').modal({show:true, backdrop:false});						
			var template = kendo.template($("#alert-template").html());	
			var validator = $("#login-window").kendoValidator({
				errorTemplate: '<span class="help-block">#=message#</span>',
			}).data("kendoValidator");
			
			$('form[name="fm1"]').submit(function(e) {		
				var btn = $('.custom-signin');
				btn.button('loading');	
				$("#status").html("");				
				if( validator.validate() ){        				
					$.ajax({
						type: "POST",
						url: "/login",
						dataType: 'json',
						data: $("form[name=fm1]").serialize(),
						success : function( response ) {   
							if( response.error ){ 
								$("#status").html(  template({ message: "입력한 사용자 이름 또는 비밀번호가 잘못되었습니다." })  );
								$("#password").val("").focus();								
								$(".custom-signin").shake({
									direction: "left",
									distance: 10,
									times: 5,
									speed: 100
								});								
							} else {
								//$("form[name='fm1']")[0].reset();               	                            
								$("form[name='fm']").attr("action", "/main.do").submit();
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
			
			/* SIGNUP */
			var signup_modal = $('#signup-modal');
			signup_modal.modal({show:false, backdrop:true});		
			var signupPlaceHolder =  new SignupForm({});
			signup_modal.data("signupPlaceHolder", signupPlaceHolder );			
			kendo.bind(signup_modal, signupPlaceHolder  );		
			$('form[name="fm2"]').submit(function(e) {			
				var btn = $('.custom-signup');				
				btn.button('loading');				
				
				var input_email_required = (signupPlaceHolder.media == 'twitter') ;
				
				var input_checkbox = $("input[name='input-agree']");
				var input_email = $("input[name='input-email']");
				var alert_danger = signup_modal.find(".custom-alert");			
				  
				var hasError = false;
				var error_message = null;
				
				if( input_email_required){
					if ( signupPlaceHolder.email == null ){
						hasError = true;
						error_message = input_email.attr('data-required-msg');						
					}else if ( !common.api.isValidEmail (signupPlaceHolder.email)  ) {
						hasError = true;
						error_message = input_email.attr('data-email-msg');		
					}else{
						$('form[name="fm2"] fieldset' ).removeClass("has-error");
						alert_danger.html( "" );
					}
				}
								
				if( signupPlaceHolder.agree == false )
				{
					error_message = input_checkbox.attr('validationMessage');
					hasError = true;
				}else{
					if( input_email_required ){
						if( hasError ){
							$('form[name="fm2"] fieldset' ).addClass("has-error");
						}else{
							$('form[name="fm2"] fieldset' ).removeClass("has-error");
						}					
					}
				}			
				if( hasError ){
					alert_danger.html( template({message: error_message }) );			
					btn.button('reset')
				}else{				
					common.api.signup({
						data: kendo.stringify( signup_modal.data("signupPlaceHolder") ),
						success : function(data){														
							if ( !data.anonymous ){	
								common.api.signin({
									onetime:  signup_modal.data("signupPlaceHolder").onetime,
									success : function(response){
										btn.button('reset')   	    
										$("form[name='fm']").attr("action", "/main.do").submit();
									}
								}); 								
							}
						},
						fail : function(response){							
							alert( "회원 가입이 정상적으로 처지되지 못했습니다." );							
							btn.button('reset')
							$('#signup-modal').modal('hide');
						}
					});
				}				
				return false ;
			} );
					
			$('#login-window').on('hidden.bs.modal', function () {
			});

			$('#signup-modal').on('hidden.bs.modal', function () {
				$('#login-window').modal('show');
			});

			 $("input[name='input-email']").keypress(function(event){
				var keycode = (event.keyCode ? event.keyCode : event.which);
				if(keycode == '13'){
					$('.custom-signup').focus();
				}				
			});
			
			$("input[name='password']").keypress(function(event){
				var keycode = (event.keyCode ? event.keyCode : event.which);
				if(keycode == '13'){
					$('.custom-signin').focus();
				}				
			});
						
			$("#login-window .custom-external-login-groups button").each(function( index ) {
				var external_login_button = $(this);
				external_login_button.click(function (e){																												
					var target_media = external_login_button.attr("data-target");
					var target_url = "http://<%= architecture.ee.web.util.ServletUtils.getLocalHostAddr()%>/community/connect-socialnetwork.do?media=" + target_media + "&domainName=" + document.domain ; 
					window.open( 
							target_url,
							'popUpWindow', 
							'height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes');
				});								
			});						
	
		}		
	}]);	
	
	function handleCallbackResult( media, code, exists ){		
		if(exists){
			if( code != null && code != ''  ){							
				common.api.signin({
					onetime:  code,
					success : function(response){
						//$("form[name='fm']")[0].reset();               	    
						$("form[name='fm']").attr("action", "/main.do").submit();
					}
				}); 
			}else{
				alert( media +  "인증에 실패하였습니다." );
			}
		}else{
			if( code != null && code != ''  ){			
				$('#login-window').modal('hide');
				$("form[name='fm2']")[0].reset();        
				$("#signup-modal .custom-alert").html("");			
				if( $('form[name="fm2"] fieldset' ).hasClass("has-error") ){
					$('form[name="fm2"] fieldset' ).removeClass("has-error");
				}				
				setTimeout(function(){
					var signupPlaceHolder = $('#signup-modal').data("signupPlaceHolder");
					signupPlaceHolder.reset();
					signupPlaceHolder.media = media ;
					signupPlaceHolder.onetime = code ;			
					
					if( media === 'twitter'){					
						$('form[name="fm2"] fieldset').removeClass("hide");
					} else {
						if( $('form[name="fm2"] fieldset').hasClass("hide") )
							$('form[name="fm2"] fieldset').addClass("hide");
					}
					
					$('#signup-modal').modal('show');
				},300);					
			}else{
				//$("form[name='fm']")[0].reset();               	                            
				$("form[name='fm']").attr("action", "signup.do").submit();			
			}
		}
	}

	function toggleWindow(){
		$('#login-window').modal('toggle');
	}
		
</script>
<style scoped="scoped">

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
</head>
<body class="color1">
	<!-- Main Page Content  -->

		<div class="main" id="slideshow"></div>
	
		<nav class="navbar navbar-fixed-bottom" role="navigation" class="color:#000000;">
			<div class="container-fluid">
				<ul class="nav navbar-nav navbar-left">
					 <li><a href="#">약관</a></li>
					 <li><a href="#">개인정보보호</a></li>
					 <li><a href="#" onClick="toggleWindow(); return false;">로그인</a></li>
					 <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/signup.do">회원가입</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					 <li><a href="#">Link</a></li>
				</ul>
			</div>
		</nav>
			
	<!-- Modal -->
	<div class="modal fade bs-modal-lg" id="login-window" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header" id="myModalLabel">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">로그인</h4>
				</div>
			<div class="modal-body">
				<div class="container custom-external-login-groups" style="width:100%;">
					<div class="row blank-top-5 ">
						<div class="col-sm-6">
							<button class="btn btn-block btn-primary btn-lg "  data-target="facebook"><i class="fa fa-facebook"></i> | 페이스북으로 로그인</button>
						</div>
						<div class="col-sm-6">
							<button class="btn btn-block btn-info btn-lg " data-target="twitter"><i class="fa fa-twitter"></i> | 트위터로 로그인</button>
						</div>
					</div>							
				</div>
				<div class="container" style="width:100%;">					
					<div class="row blank-top-15">
						<div class="col-lg-12">
							<form name="fm1" class="form-horizontal" role="form" method="POST" accept-charset="utf-8">
								<input type="hidden" id="output" name="output" value="json" />		    
								<div class="form-group">
									<label for="username" class="col-lg-3 control-label">아이디</label>
									<div class="col-lg-9">
										<input type="text" class="form-control"  id="username" name="username"  pattern="[^0-9][A-Za-z]{2,20}" placeholder="아이디" required validationMessage="아이디를 입력하여 주세요.">
									</div>
								</div>
								<div class="form-group">
									<label for="password" class="col-lg-3 control-label">비밀번호</label>
									<div class="col-lg-9">
										<input type="password" class="form-control" id="password" name="password"  placeholder="비밀번호" required validationMessage="비밀번호를 입력하여 주세요." >
									</div>
								</div>
								<div class="form-group">
									<div class="col-lg-offset-3 col-lg-9">
										<div class="checkbox">
											<label>
												<input type="checkbox">로그인 상태유지  
											</label>
										</div>
									</div>
								</div>
								<div class="col-lg-12">									
									<span class="label label-primary">접속 IP</span>&nbsp;<%= request.getRemoteAddr() %>  <span class="label label-warning"></span><br/>
									<% if ( !user.isAnonymous() ) { %>
									<span class="label label-warning"><%= user.getUsername() %> 로그인됨</span>&nbsp; <button type="button" class="btn btn-danger btn-sm">로그아웃</button><br/>
									<% } %>
									<div id="status" class="blank-top-5"></div>
									<div class="pull-right">
										<button type="submit" class="btn btn-info custom-signin" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >로그인</button>									
									</div>									
								</div>
							</form>						
						</div>
					</div>
				</div>
			</div>
			<!-- 
			<div class="modal-footer">
				<div class="btn-group ">
					<button type="button" class="btn btn-link" >아이디/비밀번호찾기</button>
					<a id="signup"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/signup.do"  class="btn btn-link">회원가입</a>
				</div>					
				</div> 
			-->
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
						회원가입을 위해서  <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/content.do?contentId=1" target="_blank" class="btn btn-info">서비스 이용약관</a> 과  
						<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/content.do?contentId=2"  target="_blank" class="btn btn-info"> 개인정보 취급방침</a>을 읽고 동의해 주세요.
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
								<button type="submit" class="btn btn-primary custom-signup" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-check"></i>&nbsp;확인</button>								
							</div>	
						</form>			
						</div></div>			
					</div>
					<!-- 
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary custom-signup"><i class="fa fa-check"></i>&nbsp;확인</button>
					</div>-->
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<form name="fm" role="form" method="POST" accept-charset="utf-8" ></form>
	
	<script type="text/x-kendo-template" id="alert-template">
	<div class="alert alert-danger">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		#=message#
	</div>
    </script>
    
	<STYLE type="text/css">	    

                span.k-tooltip {
                     margin-top: 3px;
                     margin-left: 0px;
                     -moz-border-radius: 15px;
					 border-radius: 15px;
					vertical-align:middle ;
                }
                
				html .k-textbox
				{
				    -moz-box-sizing: border-box;
				    -webkit-box-sizing: border-box;
				    box-sizing: border-box;
				    height: 2.12em;
				    line-height: 2.12em;
				    padding: 2px .3em;
				    text-indent: 0;
				    width: 230px;
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
						
	</STYLE>
	<!-- End Main Content and Sidebar -->
	<!-- Start Breadcrumbs -->	    
	<!-- End Breadcrumbs -->	    	
</body>
</html>