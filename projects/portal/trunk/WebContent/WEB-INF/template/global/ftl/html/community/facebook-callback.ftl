<#ftl encoding="UTF-8"/>
<html decorator="secure-metro">
	<head>
		<title>페이스북 인증</title>
		<#compress>
		<script type="text/javascript"> 
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.js',
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.min.js'],
			complete: function() {				
				<#if action.userProfile?exists >
					<#assign onetime = action.onetime >
					<#assign before_domain = action.domainName >
					<#assign after_domain = ServletUtils.getDomainName( request.getRequestURL().toString() , false) >
					// 1. 인증 성공
					<#if before_domain !=  after_domain >
						${response.sendRedirect("http://" + before_domain + "/community/facebook-callback.do?onetime=" + onetime  )}						
					<#else>						
						var onetime = '${onetime}' ;
						<#if action.user.anonymous >
							// is anonymous							
							<#if action.findUser()?exists >
							// is connected 						
							if(typeof window.opener.handleCallbackResult == "function"){		
								window.opener.handleCallbackResult("facebook", onetime , true);
								window.close();						
							}else if( typeof window.opener.signupCallbackResult == "function"){			
								window.opener.signupCallbackResult("facebook", onetime, true);
							}else if( typeof window.opener.signinCallbackResult == "function"){	
								// window.opener.signinCallbackResult("facebook", onetime, true);			
								common.api.user.signin({
									onetime: onetime,
									success : function( token ){
										window.opener.location.reload(true);
										window.close();	
									},
									fail : function (response) {
										
									}  
								});					
							}else{
							
							}		
							<#else>
							// is not connected 
							var template = kendo.template($('#account-not-found-alert-template').html());
							$("#status").html(template({
								media: "facebook",
								user : {
									id : "${action.userProfile.id}",
									name: "${action.userProfile.name}"
								}
							}));					
							$('.alert button').first().click( function() {													
								if(typeof window.opener.handleCallbackResult == "function"){		
									window.opener.handleCallbackResult("facebook", onetime , false);	
								}else if( typeof window.opener.signupCallbackResult == "function"){			
									// goto signup
									window.opener.signupCallbackResult("facebook", onetime, false);
								} else {
									window.opener.location.href = "${request.contextPath}/accounts/signup.do";
								}		
								window.close();							
							});							
							</#if>
						<#else>
							// is login user ;										
							if(typeof window.opener.handleSocialCallbackResult == "function"){		
								window.opener.handleSocialCallbackResult("facebook", onetime , true);
								window.close();						
							}						
						</#if>
					</#if>
				<#else>	
					// 2. 인증 실패..
				</#if>
			}	
		}]);		
		
		 
		
		</script>	
		</#compress>	
	</head>
	<body class="color7">						
		<div class="container">
			<div class="row">
				<div class="col-sm-12">						
					<div id="status"></div>
				</div>
			</div>
		</div>		
		<script type="text/x-kendo-template" id="account-not-found-alert-template">
			<div class="alert alert-info alert-dismissable">
				<img class="media-object img-circle" src="http://graph.facebook.com/#=user.id#/picture" alt="프로파일 이미지">
				<p>연결되지 않는 #=media# 계정입니다. 회원가입을 하시겠습니까?</p>
				<p> <button type="button" class="btn btn-primary"><i class="fa fa-check"></i> &nbsp; 예</button> <button type="button" class="btn btn-info" onclick="javascript: window.close();">아니오</button></p>	
			</div>
		</script>
	</body>
</html>