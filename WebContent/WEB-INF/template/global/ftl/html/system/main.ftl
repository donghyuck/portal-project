<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',

			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',	
			
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
					
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',		
				
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			
			'${request.contextPath}/js/common.admin/pixel.admin.js',
			'${request.contextPath}/js/common/common.ui.core.js',							
			'${request.contextPath}/js/common/common.ui.data.js',
			'${request.contextPath}/js/common/common.ui.community.js',
			'${request.contextPath}/js/common/common.ui.admin.js'
			],
			complete: function() {
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				common.ui.admin.setup({
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(targetCompany);
					}
				});		
				// END SCRIPT
			}
		}]);
		-->
		</script> 		 
		<style>
		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<div class="page-header">
					<h1><i class="fa fa-bar-chart-o page-header-icon"></i> 사용자 관리</h1>
				</div><!-- / .page-header -->
				<div class="note note-info padding-xs-vr">
				사용자관리..
				</div> <!-- / .note -->
				
				
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>