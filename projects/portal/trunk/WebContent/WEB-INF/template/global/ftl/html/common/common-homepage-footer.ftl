<!--=== Footer ===-->
<div class="footer">
	<div class="container layout">
        <div class="row">
            <div class="col-md-4 md-margin-bottom-40">
                <!-- About -->
                <div class="headline"><h2> 회사소개 </h2></div>  
                <p class="margin-bottom-25 md-margin-bottom-40">Unify is an incredibly beautiful responsive Bootstrap Template for corporate and creative professionals.</p>    
            </div><!--/col-md-4-->  
            
            <div class="col-md-4 md-margin-bottom-40">
            </div><!--/col-md-4-->

            <div class="col-md-4">
                <div class="headline"><h2> 연락처 </h2></div> 
                <address class="md-margin-bottom-40">
                    25, Lorem Lis Street, Orange <br />
                    California, US <br />
                    Phone: 800 123 3456 <br />
                    Fax: 800 123 3456 <br />
                    Email: <a href="mailto:info@anybiz.com" class="">info@anybiz.com</a>
                </address>
            </div><!--/col-md-4-->
        </div><!--/row-->   
    </div><!--/container--> 
</div><!--/footer-->    
<!--=== End Footer ===-->

<!--=== Copyright ===-->
<div class="copyright">
    <div class="container layout">
        <div class="row">
            <div class="col-md-6">                      
                <p class="copyright-space">
                    <#if action.user.company ?? >2013 &copy; ${action.user.company.displayName }. 모든 권리 보유.<#else></#if>
                    <a href="${request.contextPath}/content.do?contentId=2">개인정보 취급방침</a> | <a href="${request.contextPath}/content.do?contentId=1">이용약관</a>
                </p>
            </div>
            <div class="col-md-6">  
                <a href="index.html">
                    <img id="logo-footer" src="http://htmlstream.com/preview/unify/assets/img/logo1-default.png" class="pull-right" alt="" />
                </a>
            </div>
        </div><!--/row-->
    </div><!--/container--> 
</div><!--/copyright--> 
<!--=== End Copyright ===-->