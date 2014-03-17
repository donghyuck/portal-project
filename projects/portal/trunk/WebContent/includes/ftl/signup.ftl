<#ftl encoding="UTF-8"/>
<html>
    <head>
        <title>회원가입</title>
        <script type="text/javascript">
        yepnope([{
        	  load: [ "${context.contextPath}/js/jquery/1.8.2/jquery.min.js",      
        	           "${context.contextPath}/js/kendo/kendo.web.min.js",
        	           "${context.contextPath}/js/common.js",
        	           "${context.contextPath}/styles/kendo.common.min.css",
        	           "${context.contextPath}/styles/kendo.metro.min.css"
        	         ],
        	  complete: function() {        	
        		  var validator = $("#forms").kendoValidator().data("kendoValidator");     
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
                                      status.text( response.error.message ).addClass("invalid") ;                                      
                                      $("#save").kendoAnimate("slideIn:up");                                                                            
                                      if ( response.error.code == '001.005110.001' )
                                          $("#username").val("");
                                      else 
                                          $("form[name='fm1']")[0].reset();                                        
                                      validator.validate();                                      
                                      token( "/token.do", true, function( response ){                                                      
                                          if( response.item ){                                            
                                             $( "input[name='org.apache.struts.taglib.html.TOKEN']").val( response.item.token );
                                          }                                                                                
                                      }, 'json' ); 
                                 } else {
                                      if ( response.item.success == "true" )
                                      {
                                           var status = $(".status");
                                            status.text(  "회원 가입을 축하합니다."  ).addClass("valid") ;
                                           $("form[name='fm1']")[0].reset();                                           
                                           $("form[name='fm1']").attr("action", "/main.do").submit();
                                      }
                                 }                                 
        				     },
        				     error: function( xhr, ajaxOptions, thrownError){         				        
        				         var status = $(".status");			         
							     status.text(  "잘못된 접근입니다."  ).addClass("invalid") ;    
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
            
<div id="signup" class="k-content">
<div id="forms">        
        <div id="window"></div>           
        <form name="fm1"  method="POST" >
        <input type="hidden" id="output" name="output" value="json" />
		<#if Session[ "org.apache.struts.action.TOKEN" ]?exists>		     
		     <input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="${Session[ "org.apache.struts.action.TOKEN" ]  }"/>
		</#if>        
        <h3>회원 가입 하기</h3>
        <ul class="forms">
            <li>
                <label for="name" class="required">이름</label>
                <input type="text" id="name" name="name" class="k-textbox"  placeholder="이름" required validationMessage="성과 이름을 입력하세요." />
            </li>                    
            <li>
                <label for="username" class="required">아이디</label>
                <input type="text" id="username" name="username" class="k-textbox"  placeholder="아이디" required validationMessage="아이디를 입력하여 주세요." />
            </li>
            <li>
                <label for="email" class="required">이메일 주소</label>
                <input type="email"  id="email" name="email" class="k-textbox" placeholder="이메일 주소"  required data-email-msg="이메일 주소 형식이 올바르지 않습니다."  validationMessage="이메일 주소를 입력하여 주세요." />            
            </li>
            <li>
                <label for="password" class="required">비밀번호</label>
                <input type="password" id="password" name="password" class="k-textbox"  placeholder="비밀번호"  required validationMessage="비밀번호를 입력하여 주세요."  />
            </li>
            <li  class="accept">
                <input type="checkbox" id="emailVisible" name="emailVisible"  />이름 공개여부
            </li>
            <li  class="accept">
                <input type="checkbox" id="nameVisible" name="nameVisible"  />이메일 주소 공개여부
            </li>
            <li class="status"></li>
            <li  class="accept">
                <button  type="button"  id="save" class="k-button">회원 가입하기</button>   
            </li>
        </ul>
        </form>      
        <style scoped>

			.k-textbox {
                width: 11.8em;
            }         

 			#forms {
                    width: 600px;
                    height: 323px;
                    margin: 30px auto;
                    padding: 10px 20px 20px 170px ;
                }
                #forms h3 {
                    font-weight: normal;
                    font-size: 1.4em;
                    border-bottom: 1px solid #ccc;
                }
                #forms ul {
                    list-style-type: none;
                    margin: 0;
                    padding: 0;
                }
                #forms li {
                    margin: 10px 0 0 0;
                }
                label {
                    display: inline-block;
                    width: 90px;
                    text-align: right;
                }
                .required {
                    font-weight: bold;
                }
                .accept, .status {
                    padding-left: 90px;
                }
                .valid {
                    color: green;
                }
                .invalid {
                    color: red;
                }
                span.k-tooltip {
                    color: red;
                    margin-left: 6px;
                }
                span.k-tooltip-validation {
                   border-color: white;
                   background-color: white;
                }                           
        </style>        
</div>
</div>
    </body>
</html>