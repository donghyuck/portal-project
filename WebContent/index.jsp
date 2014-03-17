<%
    if (request != null)
    {
        response.sendRedirect(request.getContextPath() + "/main.do");
        return;
    }
%>
<html>
	<head>
		<title>Go to System</title>
	</head>
	<body>
		<strong><a href="<%= request.getContextPath() %>/main.do">Click here!</a></strong> to go to System.
    </body>
</html>