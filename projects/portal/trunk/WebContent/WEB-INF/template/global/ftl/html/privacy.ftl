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
						<p class="text-center"><i class="icon-flat microphone"></i></p>
						<p class="text-sm text-center p-md">
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
						<p class="text-md text-center p-md">
						${action.webSite.company.displayName}은 고객의 개인 정보를 중요하게 생각합니다. 
						이에 ${action.webSite.company.displayName}은 고객의 정보를 수집, 사용, 공개, 이전, 저장하는 것과 관련된 사항을 규정하는 개인정보 취급방침을 마련했습니다. 
						잠시 시간을 내어 ${action.webSite.company.displayName}의 개인정보 처리 방침을 익힌 후 궁금한 사항이 있으면 <span class="text-primary">알려 주시기</span> 바랍니다.
						</p>					
					</div>
				</div>	
				<hr/>
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<h2></i> 개인정보 수집 및 사용</h2>
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
						<h3 class="m-t-md"><i class="fa fa-circle-thin"></i> ${action.webSite.company.displayName}에서 수집하는 개인정보</h3>
						<ul class="text-sm m-t-md">
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
						<h3 class="m-t-md"><i class="fa fa-circle-thin"></i> 개인 정보를 사용하는 방법</h3>		
						<ul class="text-sm m-t-md">
							<li>
							 ${action.webSite.company.displayName} 에서는 수집한 개인 정보를 통해  ${action.webSite.company.displayName} 의 최신 제품 발표, 소프트웨어 업데이트 및 예정된 이벤트를 알립니다. 
							  ${action.webSite.company.displayName} 의 메일링 목록에 정보를 남기지 않으려면 언제든지 환경설정을 업데이트하여 거부할 수 있습니다.
							</li>
							<li>
							또한 ${action.webSite.company.displayName}에서는 ${action.webSite.company.displayName}의 제품, 서비스, 콘텐츠 및 광고를 제작, 개발, 운영, 제공 및 개선하기 위해, 
							그리고 손실 방지 및 사기 방지 용도로 개인 정보를 사용합니다.
							</li>
							<li>
							 ${action.webSite.company.displayName}은 생년월일과 같은 고객의 개인 정보를 신원 확인, 사용자의 신원 확인 지원, 적절한 서비스 파악의 목적으로 사용할 수 있습니다. 
							 예를 들어,  ${action.webSite.company.displayName} ID 계정 소유자의 나이를 파악하기 위해 생년월일을 사용할 수도 있습니다.
							</li>
							<li>
							경우에 따라 개인 정보를 사용하여 구입한 항목에 대한 전달사항 및 이용 약관과 정책에 대한 변경사항과 같은 중요한 주의사항을 전달할 수도 있습니다. 
							이 정보는 ${action.webSite.company.displayName}과 상호 작용하는 데 중요하므로 이러한 통신의 수신은 거부할 수 없습니다.
							</li>
							<li>
							또한 ${action.webSite.company.displayName}에서는 ${action.webSite.company.displayName}의 제품, 서비스 및 고객 통신을 개선하기 위해 감사, 
							데이터 분석, 조사 등의 내부적인 용도에 개인 정보를 사용할 수 있습니다.
							</li>
						</ul>			
						<h2 class="m-t-lg">개인 정보 외의 정보 수집 및 사용</h2>	
						<p class="text-sm m-t-md">
						또한 ${action.webSite.company.displayName}은 자체적으로 특정 개인과의 직접적인 연관성이 없는 형태의 데이터를 수집합니다. 
						이러한 개인 정보 외의 정보는 어떤 목적으로든 수집, 사용, 전송 및 공개할 수 있습니다. 
						다음은 ${action.webSite.company.displayName}에서 수집하는 개인 정보 외의 정보와 그 사용 방법에 대한 몇 가지 예입니다.
						</p>		
						<ul class="text-sm m-t-md">
							<li>
							 ${action.webSite.company.displayName}에서는 고객 행동을 더 잘 이해하고 제품, 
							 서비스 및 광고를 개선하기 위해 Apple 제품이 사용되는 직업, 언어, 우편 번호, 지역 코드, 고유 기기 식별자, 언급자의 URL, 위치 및 시간대와 같은 정보를 수집할 수 있습니다.
							</li>
							<li>
							 ${action.webSite.company.displayName}에서는  ${action.webSite.company.displayName} 웹사이트 ${action.webSite.displayName}, 그 밖의 ${action.webSite.company.displayName} 제품 및 서비스에서의 고객 활동에 대한 정보를 수집할 수 있습니다. 
							 이 정보는 집계되어 고객에게 더욱 유용한 정보를 제공하고 ${action.webSite.displayName} 웹 사이트, 제품 및 서비스에서 어떤 부분에 대한 관심이 가장 많은지를 이해하는 데 사용됩니다. 
							 집계된 데이터는 본 개인정보 취급방침의 목적상 개인 정보 외의 정보로 간주됩니다.
							</li>
							<li>
							 ${action.webSite.company.displayName}은 검색어를 비롯해 고객이 당사의 서비스를 사용하는 방법에 대한 자세한 정보를 수집하여 저장할 수 있습니다. 
							 이 정보는 ${action.webSite.company.displayName} 서비스가 제공하는 결과의 관련성을 향상시키는 데 사용될 수도 있습니다. 
							 인터넷을 통해 서비스의 품질을 보장하려는 목적 등 제한된 경우를 제외하고 이러한 정보는 고객의 IP 주소와 연결되지 않습니다.
							</li>		
							<li>
							고객의 명시적의 동의하에  ${action.webSite.company.displayName}은 고객이 응용 프로그램을 사용하는 방법에 대한 데이터를 수집하여 앱 향상을 지원할 수 있습니다.
							</li>																												
						</ul>	
						<p class="text-sm m-t-md">
						개인 정보 외의 정보를 개인 정보와 통합할 경우 통합된 정보는 통합된 상태로 유지되는 동안 개인 정보로 간주됩니다.
						</p>
						
						<h2 class="m-t-lg">쿠키 및 기타 기술</h2>	
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}의 웹 사이트 ${action.webSite.displayName}, 온라인 서비스, 대화형 응용 프로그램, 이메일 메시지 및 광고에서는 "쿠키" 및 기타 기술(예: 픽셀 태그 및 웹 비콘)을 사용할 수 있습니다. 
						이러한 기술은 사용자 행동을 이해하고, 사용자가 웹 사이트의 어떤 부분을 방문했는지 파악하며, 광고 및 웹 검색을 용이하게 하고 그 효과를 측정하는 데 도움이 됩니다. 
						쿠키 및 기타 기술을 통해 수집된 정보는 개인 정보 외의 정보로 간주됩니다. 
						그러나 IP(인터넷 프로토콜) 주소 또는 이와 유사한 식별자가 해당 지역의 법에 따라 개인 정보로 간주되는 범위에서는 ${action.webSite.company.displayName}에서도 이러한 식별자를 개인 정보로 간주합니다. 
						마찬가지로 개인 정보 외의 정보가 개인 정보와 통합된 범위에서 ${action.webSite.company.displayName}에서는 통합된 정보를 본 개인정보 취급방침의 목적상 개인 정보로 간주합니다.
						</p>
						<p class="text-sm m-t-md">
						또한 ${action.webSite.company.displayName}과 ${action.webSite.company.displayName}의 파트너는 고객이 ${action.webSite.company.displayName} 웹 사이트, 온라인 서비스 및 응용 프로그램을 사용할 때 쿠키 및 기타 기술을 사용하여 개인 정보를 기억할 수 있습니다. 
						이는 고객에게 보다 편리하고 개인적인 환경을 제공하기 위한 것입니다. 
						예를 들어 고객의 이름을 알면 고객이 다음에 ${action.webSite.company.displayName} 웹사이트를 방문할 때 환영 인사말을 표시할 수 있고, 
						고객의 국가 및 언어와 학교(교육자인 경우)를 알면 맞춤화되고 보다 유용한 쇼핑 환경을 제공할 수 있으며, 
						고객의 컴퓨터나 기기를 사용하여 특정 제품을 쇼핑하거나 특정 서비스를 이용한 사람을 알면 고객 관심사와 보다 관련 있는 광고 및 이메일 통신을 제공할 수 있습니다. 
						또한 고객의 연락처 정보, 하드웨어 식별자 및 컴퓨터 또는 기기 정보를 알고 있으면 고객의 운영 체제를 개인화하고, 고객의 서비스를 설정하고, 고객에게 더 나은 서비스를 제공할 수 있습니다.
						</p>
						<p class="text-sm m-t-md">
						쿠키를 사용하지 않으려면 웹 브라우저를 사용하는 경우 해당 공급자와 쿠키를 허용하지 않는 방법을 확인하십시오. 
						${action.webSite.company.displayName} 웹 사이트의 특정 기능은 쿠키를 사용하지 않는 경우 사용할 수 없다는 점에 주의하십시오.
						</p>
						<p class="text-sm m-t-md">
						대부분의 인터넷 서비스에서 ${action.webSite.company.displayName}은 일부 정보를 자동으로 수집하여 로그 파일에 저장합니다. 
						이 정보에는 IP(인터넷 프로토콜) 주소, 브라우저 유형 및 언어, ISP(인터넷 서비스 제공업체), 참조 및 종료 웹 사이트 및 응용 프로그램, 운영 체제, 날짜/시간 스탬프, 클릭 스트림 데이터 등이 포함됩니다.
						</p>
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}에서는 이 정보를 사용하여 추세를 이해하고 분석하며, 
						사이트를 관리하고, 사이트에서의 사용자 행동을 파악하여 당사의 제품 및 서비스를 향상시키고 전체 사용자 계층에 대한 인구 통계 정보를 수집합니다. 
						이 정보는 ${action.webSite.company.displayName}의 마케팅 및 광고 서비스에 사용될 수도 있습니다.
						</p>
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}에서는 이메일 메시지 중 일부에 ${action.webSite.company.displayName} 웹 사이트의 콘텐츠로 연결되는"클릭 쓰루(click-through) URL"을 사용합니다. 
						고객이 이러한 URL 중 하나를 클릭하면 별도의 웹 서버를 거쳐 ${action.webSite.company.displayName} 웹 페이지의 대상 페이지로 도달하게 됩니다. 
						${action.webSite.company.displayName}에서는 이러한 클릭 쓰루 데이터를 사용하여 특정 사안에 대한 관심도를 알아보고, 고객 통신의 효과를 측정합니다. 
						이러한 방식으로 추적되는 것을 원치 않으면 이메일 메시지 내의 텍스트 또는 그래픽 링크를 클릭하지 않아야 합니다.
						</p>
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}에서는 픽셀 태그를 통해 이메일 메시지를 고객이 읽을 수 있는 형식으로 전송하고 고객이 이메일을 열었는지 확인합니다. 
						${action.webSite.company.displayName}에서는 이 정보를 사용하여 고객에게 보내는 메시지를 줄이거나 제거할 수 있습니다.
						</p>
						
						<h2 class="m-t-lg">제3자에 대한 공개</h2>	
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}에서는 제품 및 서비스를 제공하기 위해 ${action.webSite.company.displayName}과 협력하거나 
						${action.webSite.company.displayName}의 고객 마케팅을 돕는 전략적 파트너에게 특정 개인 정보를 수시로 제공할 수 있습니다. 
						${action.webSite.company.displayName}은 오직 ${action.webSite.company.displayName}의 제품, 서비스 및 광고를 제공하거나 향상시키기 위해서만 개인 정보를 공유합니다. 
						이를 제3자의 마케팅을 위해 제3자와 공유하지 않습니다.
						</p>
						<h3 class="m-t-md"><i class="fa fa-circle-thin"></i> 서비스 제공업체</h3>		
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}은 정보 처리, 신용 연장, 고객 주문 이행, 제품 배송, 고객 데이터 관리 및 강화, 고객 서비스 제공, 
						${action.webSite.company.displayName} 제품 및 서비스에 대한 고객의 관심도 측정 및 고객 연구 또는 만족도 조사 수행 등의 서비스를 제공하는 회사와 개인 정보를 공유합니다. 
						이러한 회사는 고객의 정보를 보호할 의무가 있으며 ${action.webSite.company.displayName}이 활동하는 모든 영역에 있을 수 있습니다.
						</p>
						<h3 class="m-t-md"><i class="fa fa-circle-thin"></i> 기타</h3>		
						<p class="text-sm m-t-md">
						법령, 법적 절차, 소송 및/또는 고객의 거주 국가 내외의 공공 또는 정부 당국의 요청으로 ${action.webSite.company.displayName}이 고객의 개인 정보를 공개해야 하는 경우가 있을 수 있습니다. 
						${action.webSite.company.displayName}에서는 국가안보, 법 집행 또는 기타 중요한 공공의 문제로 인해 공개가 필요하거나 적절하다고 판단하는 경우 고객에 대한 정보를 공개할 수 있습니다.
						</p>			
						<p class="text-sm m-t-md">
						또한 ${action.webSite.company.displayName}의 계약 조건을 이행하거나 ${action.webSite.company.displayName}의 영업 또는 사용자를 보호하기 위해 공개가 합리적으로 필요하다고 판단되는 경우 
						고객에 대한 정보를 공개할 수 있습니다. 뿐만 아니라 구조 조정, 합병, 또는 매각의 경우 ${action.webSite.company.displayName}은 ${action.webSite.company.displayName}에서 수집한 모든 개인 정보를 관련 제3자에게 이전할 수 있습니다.
						</p>					
						
						
						<h2 class="m-t-lg">개인 정보의 보호</h2>	
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}은 개인 정보의 보안을 매우 중요하게 생각합니다. 
						${action.webSite.displayName} 과 같은 ${action.webSite.company.displayName}의 온라인 서비스는 TLS(Transport Layer Security)와 같은 암호화를 사용하여 전송 중 개인 정보를 보호합니다.
						${action.webSite.company.displayName}에서는 고객의 개인 데이터를 저장할 때 물리적 보안 조치를 사용하는 시설 내에 설치된 접근이 제한된 컴퓨터 시스템을 사용합니다.
						데이터는 제3자 스토리지를 활용할 때를 포함하여 암호화된 형식으로 저장됩니다.
						</p>			
						<p class="text-sm m-t-md">
						고객이 일부 ${action.webSite.company.displayName} 제품, 서비스 또는 응용 프로그램을 사용하거나 
						게시판, 채팅룸 또는 SNS(소셜 네트워킹 서비스)에 글을 게시하는 경우 고객이 공유하는 개인 정보와 콘텐츠는 다른 사용자에게 보여지며 읽고, 수집하고 이용할 수 있게 됩니다. 
						이러한 경우에 고객이 공유 또는 제출하기로 선택하는 개인 정보에 대한 책임은 고객에게 있습니다. 
						예를 들어 고객이 게시판에 게시하는 글에 이름과 이메일 주소를 포함하는 경우 해당 정보는 공개됩니다. 
						따라서 이러한 기능을 사용할 때 주의하시기 바랍니다.
						</p>
						
						<h2 class="m-t-lg">개인 정보의 진실성 및 보관</h2>	
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName} 은 고객이 개인 정보를 정확하고 완전하며 최신 상태로 유지하기 쉽도록 해드립니다. 
						${action.webSite.company.displayName} 은 고객의 개인 정보를 법에서 더 오래 보관하도록 요구하거나 허용하지 않는 한, 
						본 개인정보 취급방침에 명시된 목적들을 달성하기에 필요한 기간 동안 보관할 것입니다.
						</p>
						
						<h2 class="m-t-lg">개인 정보 접근</h2>	
						<p class="text-sm m-t-md">
						고객은 http://222.122.63.146/accounts/login?ver=1 에서 고객의 계정으로 로그인하여 고객의 연락처 정보 및 환경설정을 정확하고 완전하며 최신 상태로 유지할 수 있습니다. 
						${action.webSite.company.displayName}에서 보유하고 있는 기타 개인 정보의 경우, 
						${action.webSite.company.displayName}에서는 고객이 부정확한 데이터에 대해 데이터의 수정을 요구하거나, 
						법에 따라 보관할 필요가 없는 경우 또는 다른 적법한 사업상의 목적을 위해 삭제를 요구하는 용도 등 모든 용도를 위해 고객에게 접근성을 제공할 것입니다. 
						${action.webSite.company.displayName}에서는 사소하거나 귀찮게 하거나, 다른 이들의 개인 정보를 위태롭게 하거나, 극도로 비실용적이거나, 
						기타 법에서 접근을 요구하지 않는 요청에 대해서는 처리를 거부할 수 있습니다. 
						</p>
					</div>
				</div>
				<hr/>
				<div class="row">					
					<div class="col-sm-10 col-sm-offset-1">		
						<h1 class="text-xxl">개인정보 취급방침 부록</h1>
						<h2 class="m-t-lg">개인 정보 수집 및 이용 세부 사항</h2>	
						<p class="text-sm m-t-md">
						${action.webSite.company.displayName}은 귀하의 개인 정보를 다음과 같이 수집하고 이용합니다.
						</p>
						<p class="text-sm m-t-md">
						일반적인 개인 정보
						</p>
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>수집 및 이용의 목적</th>
									<th>수집 항목</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
	ㅁ

									</td>
									<td>
	ㅁ

									</td>
								</tr>
							</tbody>
						</table>						
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