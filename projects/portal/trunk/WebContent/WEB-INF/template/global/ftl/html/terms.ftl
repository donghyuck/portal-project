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
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
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
		.breadcrumbs h2 {
			font-size: 32px;
			font-weight: 200;
		}
		.localnav:before, .localnav:after {
			content: ' ';
			display: table;
		}		
		.localnav {
			position: relative;
			margin-top: 0;
			padding-top: 1em;		
			border-bottom: 1px solid #d6d6d6;
			margin: 0 auto;		
		}
		
		.localnav-title {
			padding: 0;
			display: block;
			font-size: 32px;
			line-height: 1;
			float: left;
			font-weight: 200;
		}

		.localnav-links {
			float: right;
			margin: 8px 0 7px 0;
		}		
		.localnav-links>li {
			float: left;
			list-style: none;
			margin-left: 30px;
		}	
		.localnav-link {
			font-size: 13px;
			color: #333;
			display: inline-block;
			white-space: nowrap;
		}			
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
				<header class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">					
				<script>
					jobs.push(function () {
						$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
					});
				</script>			
				<div class="breadcrumbs">
					<div class="container">
						<div class="row">
							<h2>${ navigator.title }
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
					<div class="col-sm-12">
					
					Apple 개인정보 취급방침이 2014년 9월 17일에 업데이트되었습니다. 변경 사항은 주로 iOS 8과 함께 출시될 새로운 기능을 다루거나, 사용자가 제공한 생일 또는 타사 사용자 데이터와 같은 데이터의 사용 현황에 대한 추가 정보(예: 제품 또는 상품권을 보낼 때)를 제공하기 위해 이루어 졌습니다. 모든 변경 사항은 소급하지 않습니다.
					
					해당 국가의 13세 이상 사용자를 위한 Spotlight 제안, 분석,가족 공유, Apple ID에 대한 내용을 다루기 위해 언어를 추가하였습니다. 마지막으로 위치 기반 서비스에서 사용하는 GPS, Bluetooth, IP 주소, 크라우드 소싱 Wi-Fi 핫스팟 및 기지국 위치 등과 같은 기술에 대한 설명을 추가했습니다.
					
					<hr/>
					Apple은 고객의 개인 정보를 중요하게 생각합니다. 이에 Apple은 고객의 정보를 수집, 사용, 공개, 이전, 저장하는 것과 관련된 사항을 규정하는 개인정보 취급방침을 마련했습니다. 잠시 시간을 내어 Apple의 개인정보 처리 방침을 익힌 후 궁금한 사항이 있으면 알려 주시기 바랍니다.
					
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