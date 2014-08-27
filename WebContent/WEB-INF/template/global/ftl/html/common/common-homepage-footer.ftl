<!--=== Footer ===-->
<footer>
	<div class="footer">
		<div class="container">
			<div class="footer-wrapper">
				<div class="row">
					<!-- Footer Col. -->
					<div class="col-md-3 col-sm-3 footer-col">
						<div class="footer-content">
							<div class="footer-content-logo">
								<img src="${request.contextPath}/download/logo/company/${action.webSite.company.name}" height="42"   alt="로고 이미지">
							</div>
							<div class="footer-content-text">
								<p>${action.webSite.company.description}</p>							
							</div>
						</div>
					</div>
					<!-- //Footer Col.// -->
					<!-- Footer Col. -->
					<div class="col-md-3 col-sm-3 footer-col">
						<div class="footer-title">
							이벤트 & 공지
						</div>
						<script type="text/javascript">
						<!--
							jobs.push( function(){
								var announcement = new common.api.Announcement({pageSize: 3}); 			 				
								var template = kendo.template($("#footer-notice-template").html());				
								announcement.dataSource().bind('change', function(){
									if(this.view().length>0)
										$("#footer-recent-announces").html(kendo.render(template, this.view()))
								}).read();							
							} );
						-->
						</script>

						<ul id="footer-recent-announces" class="footer-content list-unstyled">
						</ul>	
					</div>
					<!-- //Footer Col.// -->
					<!-- Footer Col. -->
					<div class="col-md-3 col-sm-3 footer-col">
						<div class="footer-title">
							Links
						</div>
						<div class="footer-content">

						</div>
					</div>
					<!-- //Footer Col.// -->
					<!-- Footer Col. -->
					<div class="col-md-3 col-sm-3 footer-col">
						<div class="footer-title">
							Photostream
						</div>
						<div class="footer-content">
                                                                   
						</div>						
					</div><!-- //Footer Col.// -->
				</div>
			</div>
		</div>
		<!--=== Copyright ===-->
		<div class="copyright">
			<div class="container">
				<div class="row">
					<div class="col-md-12 col-sm-12">
						<div class="copyright-text">
							<#if action.webSite ?? >${.now?string("yyyy")} &copy; ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
							<a href="${request.contextPath}/content.do?contentId=2">개인정보 취급방침</a> | <a href="${request.contextPath}/content.do?contentId=1">이용약관</a>
						</div>
					</div>
				</div><!--/row--> 
			</div><!--/container--> 
		</div><!--/copyright--> 
	</div>
</footer>