<%@ page  pageEncoding="UTF-8"  
    import="architecture.ee.web.community.social.provider.connect.ConnectionFactoryLocator,
    			architecture.ee.web.community.social.provider.connect.SocialConnect.Media,
    			architecture.ee.util.ApplicationHelper,
    			org.springframework.social.connect.web.ConnectSupport,
    			architecture.ee.web.community.social.provider.*,	
    			org.springframework.web.context.request.*,
    			org.springframework.util.*,
                 java.util.List" %>                 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Test Socail</title>
	<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>	
	<script type="text/javascript">
	<!--
		yepnope([{
			load: [
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.10.2/jquery.min.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',			
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.core.js',
			'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.api.core.js'
			],
			complete: function() {
				alert( common.guid() );
			}
		}]);	
	-->
	</script>
</head>
<body>


</body>
</html>