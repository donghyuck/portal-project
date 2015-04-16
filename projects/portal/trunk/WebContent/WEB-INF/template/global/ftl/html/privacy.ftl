<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >
		<title>${page.title}</title>
		<script type="text/javascript">
		<!--
		
		var jobs = [];	
		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {			
				common.ui.setup({
					features:{
						wallpaper : false,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
															 
								}
							} 
						}						
					},
					jobs:jobs
				});	

				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				<#if !action.user.anonymous >	
				</#if>	
				// END SCRIPT	
			}
		}]);	
				
		-->
		</script>		
		<style scoped="scoped">
					
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>	
		<!-- START HEADER -->		
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.isSetNavigator()  >
				<#assign navigator = action.getNavigator() />			
				<header  class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">					
				<script>
					jobs.push(function () {
						$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
					});
				</script>			
				<div class="breadcrumbs">
					<div class="container">
						<div class="row">
							<h2 class="pull-left">${ navigator.title }
							<small class="page-summary">
									${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }								
							</small>	
							</h2>
						</div>
					</div>
				</div>	
			</header>	
			</#if>				
			<!-- END HEADER -->			
			<!-- START MAIN CONTENT -->	
			<div class="container content">			
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<p class="text-sm text-center">
						<strong>${action.webSite.company.displayName} 개인정보 취급방침이 2015년 4월 16일에 업데이트되었습니다. </strong>
						변경 사항은 주로 앞으로 출시될 새로운 기능을 다루거나, 
						사용자가 제공한 생일 또는 타사 사용자 데이터와 같은 데이터의 사용 현황에 대한 
						추가 정보(예: 제품 또는 상품권을 보낼 때)를 제공하기 위해 이루어 졌습니다. 
						모든 변경 사항은 소급하지 않습니다.
						</p>					
					</div>			
				</div>
				<hr/>
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">
						<p class="text-md text-center">
						${action.webSite.company.displayName}은 고객의 개인 정보를 중요하게 생각합니다. 
						이에 ${action.webSite.company.displayName}은 고객의 정보를 수집, 사용, 공개, 이전, 저장하는 것과 관련된 사항을 규정하는 개인정보 취급방침을 마련했습니다. 
						잠시 시간을 내어 ${action.webSite.company.displayName}의 개인정보 처리 방침을 익힌 후 궁금한 사항이 있으면 <span class="text-primary">알려 주시기</span> 바랍니다.
						</p>					
					</div>
				</div>	
				<hr/>
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<h3>개인정보 수집 및 사용</h3>
						<p class="text-sm m-t-md">
						개인 정보는 한 사람을 식별하거나 한 사람에게 연락하는 데 사용할 수 있는 데이터입니다.
						</p>
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}과 연락할 때 언제든 개인 정보를 제공하라는 요청을 받을 수 있습니다. 
						${action.webSite.company.displayName}는 본 개인정보 취급방침에 따라 사용할 수 있습니다. 
						또한 ${action.webSite.company.displayName}의 제품, 서비스, 콘텐츠 및 광고를 제공하고 개선하기 위해 다른 정보와 함께 사용할 수도 있습니다. 
						고객은 ${action.webSite.company.displayName}에서 요청하는 개인 정보를 제공할 의무는 없지만 제공하지 않기로 결정하면, 
						많은 경우 ${action.webSite.company.displayName}에서 
						${action.webSite.company.displayName}의 제품 또는 서비스를 제공하지 못하거나 고객의 문의에 답변할 수 없게 됩니다.						
						</p>			
						<p class="text-sm m-t-md">
						다음은 ${action.webSite.company.displayName}에서 수집할 수 있는 개인 정보의 유형 및 사용 방법에 대한 몇 가지 예입니다.
						</p>			
						<h3>${action.webSite.company.displayName}에서 수집하는 개인정보</h3>
						<ul class="text-sm">
							<li>
							고객이 ID를 만들거나, 제품을 구입하거나, 소프트웨어 업데이트를 다운로드하거나, 
							${action.webSite.company.displayName}에 연락하거나, 
							온라인 설문 조사에 참여하는 경우 ${action.webSite.company.displayName}에서는 
							고객의 이름, 우편 주소, 전화 번호, 이메일 주소, 연락처 환경설정, 신용 카드 정보 등 다양한 정보를 수집할 수 있습니다.
							</li>
							<li>
							고객이 ${action.webSite.company.displayName} 제품을 사용하여 가족 및 친구와 콘텐츠를 공유하거나, 
							상품권 및 제품을 보내거나, 다른 사람을 ${action.webSite.company.displayName} 서비스나 포럼에 초대하는 경우 
							${action.webSite.company.displayName}에서는 이름, 우편 주소, 이메일 주소, 전화 번호 등 고객이 제공한 상대방의 정보를 수집할 수 있습니다. 
							${action.webSite.company.displayName}은 이러한 정보를 사용하여 고객의 요청을 처리하고 관련 제품이나 서비스를 제공하거나 사기를 방지할 것입니다.
							</li>
						</ul>						
					</div>
				</div>													
			</div>							 									 			
			<!-- END MAIN CONTENT -->	
 			<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- END FOOTER -->	
		</div>		
		<!-- START TEMPLATE -->				
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>