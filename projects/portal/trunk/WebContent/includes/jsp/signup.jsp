<%@ page pageEncoding="UTF-8"%>
<%@ page import="architecture.ee.web.util.WebApplicationHelper"%>
<html decorator="banded">
    <head>
        <title>회원가입</title>
        <script type="text/javascript">
        yepnope([{
        	  load: [ '<%= request.getContextPath()  %>/js/jquery/1.8.2/jquery.min.js',      
        	          '<%= request.getContextPath()  %>/js/kendo/kendo.web.min.js',
        	          '<%= request.getContextPath()  %>/js/common.js',
        	          '<%= request.getContextPath()  %>/styles/kendo.common.min.css',
        	          '<%= request.getContextPath()  %>/styles/kendo.metro.min.css'
        	         ],
               	  complete: function() {        	
            		  var validator = $("#signup-form").kendoValidator().data("kendoValidator");     
            		  $("#save").click(function() {
            			  if( validator.validate() )
            		      {        				
            				 $.ajax({
            				     type: "POST",
            				     url: "signup.do",
            				     dataType: 'json',
            				     data: $("form[name=fm1]").serialize(),
            				     success : function( response ) {        				             				       				     
                                     if( response.error ){    
                                          var status = $(".status");
                                          status.text( response.error.message ).addClass("error") ;                                      
                                          $("#save").kendoAnimate("slideIn:up");                                                                            
                                          if ( response.error.code == '001.005110.001' )
                                              $("#username").val("");
                                          else 
                                              $("form[name='fm1']")[0].reset();           
                                          
                                          validator.validate();                                      
                                          token( "/common/token.do", true, function( response ){                                                      
                                              if( response.item ){                                            
                                                 $( "input[name='org.apache.struts.taglib.html.TOKEN']").val( response.item.token );
                                              }                                                                                
                                          }, 'json' ); 
                                     } else {
                                          if ( response.item.success == "true" )
                                          {
                                               var status = $(".status");
                                                status.text(  "회원 가입을 축하합니다."  ).addClass("success") ;
                                               $("form[name='fm1']")[0].reset();                                           
                                               $("form[name='fm1']").attr("action", "/main.do").submit();
                                          }
                                     }                                 
            				     },
            				     error: function( xhr, ajaxOptions, thrownError){         				        
            				         var status = $(".status");			         
    							     status.text(  "잘못된 접근입니다."  ).addClass("error") ;    
            				         $("#save").kendoAnimate("slideIn:up");        
            				         token( "/token.do", true, function( response ){         		
            				                  $("form[name='fm1']")[0].reset();		                                       
                                              if( response.item ){                                                                                              
                                                 $( "input[name='org.apache.struts.taglib.html.TOKEN']").val( response.item.token );
                                              }                                                                                
                                          }, 'json' );
            				     }        				     
            				 });
            			  }else{        			      
            				  $("#save").kendoAnimate("slideIn:up");        
            			  }
                      });
            	  } 
            	}]);      
        </script>
    </head>
    <body>
            
	<!-- Main Page Content & Breadcrumbs -->   
	<div class="row">
		<div class="eight columns">
			<h3>회원가입</h3>
			<p>설명</p>
			<section  id="signup-form" class="panel radius validator-form">
		    <form name="fm1"  method="POST"  accept-charset="utf-8">
		    	<input type="hidden" id="output" name="output" value="json" />
		    	<input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="<%=  session.getAttribute("org.apache.struts.action.TOKEN")  %>" />			
				<div class="row">
				    <div class="three mobile-one columns">
				      <label for="name" class="right inline required small-text">이름:</label>
				    </div>
				    <div class="nine mobile-one columns">
				      <input type="text" id="name" name="name"  placeholder="이름" required validationMessage="성과 이름을 입력하세요." />
				    </div>
				  </div>
				  <div class="row">
				    <div class="three mobile-one columns">
				      <label for="username" class="right inline required small-text">아이디:</label>
				    </div>
				    <div class="nine mobile-one columns">
				      <input type="text" id="username" name="username"  placeholder="아이디" required validationMessage="아이디를 입력하여 주세요." />
				    </div>
				  </div>
				  <div class="row">
				    <div class="three mobile-one columns">
				      <label for=email class="right inline required small-text">메일:</label> 
				    </div>
				    <div class="nine mobile-one columns">
				      <input type="email"  id="email" name="email" placeholder="이메일 주소"  required data-email-msg="이메일 주소 형식이 올바르지 않습니다."  validationMessage="이메일 주소를 입력하여 주세요." />            
				    </div>
				  </div>  
				  <div class="row">
				    <div class="three mobile-one columns">
				      <label for=passowrd class="right inline required small-text">비밀번호:</label> 
				    </div>
				    <div class="nine mobile-one columns">
				      <input type="password" id="password" name="password" class="k-textbox"  placeholder="비밀번호"  required validationMessage="비밀번호를 입력하여 주세요."  />
				    </div>	
				  </div>  
				  <div class="row">
				    <div class="three columns">
				    </div>
				    <div class="nine mobile-one columns">
				      <div class="tag small-text">이름 공개여부</div><input type="checkbox" id="nameVisible" name="nameVisible" class="regular-checkbox" /><label for="nameVisible"></label>
				    </div>
				  </div>  	
				  <div class="row">
				    <div class="three columns">
				    </div>
				    <div class="nine mobile-one columns">
				      <div class="tag small-text">이메일 주소 공개여부</div><input type="checkbox" id="emailVisible" name="emailVisible" class="regular-checkbox" /><label for="emailVisible"></label>
				    </div>
				  </div> 				  
				<div class="row">
					<div class="three mobile-one columns">
				    </div>
					    <div class="nine mobile-one columns">
					        <br/>
					        <br/>
							<p>
						    <small class="status round"></small>
						    </p>
					    </div> 					    				    			    
				</div>					
				<div class="row">
				    <div class="three mobile-one columns">
				    </div>
				    <div class="nine mobile-three columns">
				      <button  type="button"  id="save" class="k-button small-text">회원 가입하기</button>
				  </div>  					    				    			    
				</div>				
				</form>
			</section>			
		</div>
		<div class="four columns">
		</div>
		<!-- End Sidebar -->
	</div>
	<style>
	</style>

	
	<!-- End Main Content and Sidebar -->
	    
    </body>
</html>
