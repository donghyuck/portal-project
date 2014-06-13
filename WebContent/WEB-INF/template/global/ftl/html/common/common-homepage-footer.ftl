<!--=== Footer ===-->
<div class="footer">
	<div class="container layout">
	<div class="row">
		<div class="col-md-4 md-margin-bottom-40">
			<!-- About -->
			<div class="headline"><h4> 회사소개 </h4></div>  
			<p class="margin-bottom-25 md-margin-bottom-40">${action.webSite.company.description}</p>    
		</div><!--/col-md-4-->  
		<div class="col-md-4 md-margin-bottom-40">
		</div><!--/col-md-4-->
		<div class="col-md-4">
			<div class="headline"><h4> 연락처 </h4></div> 
			<address class="md-margin-bottom-40">
			서울특별시 구로구 디티털로 30길 31<br />
			코오롱빌란트2차 701호 ~ 704호<br />
			Tel: 02 555 1965<br />
			Fax: 02 2081 1090 <br />
			<!--Email: <a href="mailto:info@anybiz.com" class="">info@anybiz.com</a>-->
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
                    <#if action.webSite ?? >${.now?string("yyyy")} &copy; ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
                    <a href="${request.contextPath}/content.do?contentId=2">개인정보 취급방침</a> | <a href="${request.contextPath}/content.do?contentId=1">이용약관</a>
                </p>
            </div>
            <div class="col-md-6">  
                <a href="${request.contextPath}/main.do">
                    <img src="${request.contextPath}/download/logo/company/${action.webSite.company.name}" class="pull-right img-responsive" alt="" />
                </a>
            </div>
        </div><!--/row-->
    </div><!--/container--> 
</div><!--/copyright--> 
<!--=== End Copyright ===-->