<%
    if (request != null)
    {
        response.sendRedirect(request.getContextPath() + "/display/main.html");
        return;
    }
%>
<html>
	<head>
		<title>Go to System</title>
	</head>
	<body>
		<strong><a href="<%= request.getContextPath() %>/display/main.html">Click here!</a></strong> to go to System.
    </body>
</html>