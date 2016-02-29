<%@ page  pageEncoding="UTF-8"  isErrorPage="true"
         import="java.util.Locale, java.io.*,
                 architecture.common.exception.Codeable,
                 architecture.common.util.I18nTextUtils,
                 architecture.ee.util.OutputFormat,
                 architecture.common.user.authentication.UnAuthorizedException,
                 architecture.ee.web.util.WebApplicationHelper,
                 architecture.ee.web.util.ServletUtils,
                 architecture.ee.web.util.ParamUtils" %><%
                 
	OutputFormat format = ServletUtils.getOutputFormat(request, response);
	Throwable ex = exception;	
	if( ex == null ){
		// 스트럿츠1 오류 처리
		// ex = (Throwable)request.getAttribute( org.apache.struts.Globals.EXCEPTION_KEY );
		ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
	}
	
	if( ex == null ){
		ex = (Throwable) request.getAttribute( org.springframework.security.web.WebAttributes.AUTHENTICATION_EXCEPTION );
	}
	
	int objectType = 1;
	int objectAttribute = 1 ;
	int errorCode = 0;
	Locale localeToUse = WebApplicationHelper.getLocale();
	
	String exceptionClassName = "";
	String exceptionMessage   = "";
		
	if( ex != null ){		

		if( ex instanceof org.springframework.web.util.NestedServletException && ex.getCause() != null ){
			ex = ((org.springframework.web.util.NestedServletException)ex).getCause();			
		}
		
		if( ex  instanceof Codeable ){
			errorCode = ((Codeable)	ex).getErrorCode();				
		}
		
		exceptionClassName =  ex.getClass().getName();
		exceptionMessage = ex.getMessage() ;
		
		if( ex instanceof UnAuthorizedException ){ /*  || ( ex.getCause() != null && ex.getCause() instanceof UnAuthorizedException ) ){ */
			//exceptionClassName = ex.getCause().getClass().getName();
			exceptionMessage = "요청하신 작업에 대한 권한이 없습니다.";
			response.setStatus(403);
		} 
	}
		
    if(format == OutputFormat.XML ){
    	response.setContentType("text/xml;charset=UTF-8");
%>
<?xml version="1.0" encoding="UTF-8"?>
<response>
    <error>
        <locale><%= localeToUse %></locale>
        <code><%= I18nTextUtils.generateResourceBundleKey(objectType, errorCode, objectAttribute ) %></code>
        <exception><%= exceptionClassName  %></exception>
        <message><%= exceptionMessage == null ? "" : exceptionMessage %></message>        
    </error>
</response>    	
<%    	
    } else if (format == OutputFormat.JSON ) {
    	//response.sendError(500);
    	response.setContentType("application/json;charset=UTF-8");
%>{"error":{ "locale" : "<%= localeToUse %>", "code": "<%= I18nTextUtils.generateResourceBundleKey(objectType, errorCode, objectAttribute ) %>", "exception" : "<%= exceptionClassName  %>", "message" : "<%= exceptionMessage == null ? "" : exceptionMessage %>" }}<%	
    } else if (format == OutputFormat.HTML ) { 
    	
%><html>
    <head> 
        <title>오류가 발생했습니다.</title>
    </head>
    <body>
      <%= errorCode %><p/>
      <%= exceptionMessage == null ? "오류가발생됨" : exceptionMessage %><p/>
      <%    
      if(ex != null){    	  
    	  StringWriter sout = new StringWriter();
          PrintWriter pout = new PrintWriter(sout);
          ex.printStackTrace(pout);
          response.flushBuffer();
          //response.setCharacterEncoding("UTF-8");
          %>
          <pre>
          <%= sout.toString() %>
          </pre>
          <%    	  
      }
      %>
    </body>
</html>        
<%
    } 
%>    