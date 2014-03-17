<%@ page  pageEncoding="UTF-8"  
         import="java.util.Locale, java.io.*,
                 architecture.common.exception.Codeable,
                 architecture.common.util.I18nTextUtils,
                 architecture.ee.util.OutputFormat,
                 architecture.security.user.*,
                 architecture.ee.web.util.WebApplicationHelper,
                 architecture.ee.web.util.ParamUtils" %><%GroupManager gm = WebApplicationHelper.getComponent(GroupManager.class);
                 try{
                	 
                 	Group g = gm.getMenu("developer");
out.println( g);
                 }catch(GroupNotFoundException e){
                	 gm.createGroup("developer");
                 }%>                 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>쿼리 결과</title>
</head>
<body>
<%= gm.getGroups()  %>
<br>
<%= gm.getTotalGroupCount() %>
</body>
</html>