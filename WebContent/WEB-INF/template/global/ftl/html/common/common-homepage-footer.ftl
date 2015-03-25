<!--=== Footer ===-->
<footer class="footer-v1">
	<div class="footer">
		<div class="container">
			<div class="row">
				<!-- About -->
				<div class="col-md-3 md-margin-bottom-40">
					<div class="footer-logo">
						<img src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" height="42"   alt="로고 이미지">
					</div>
					<p>${action.webSite.company.description}</p>					
				</div>
				<!-- End About -->
				<div class="col-md-3 md-margin-bottom-40">
					<div class="headline"><h2>최근 글</h2></div>
					<script type="text/javascript">
					<!--
							jobs.push( function(){
								var announcement = common.ui.datasource(
									'<@spring.url "/data/announce/list.json"/>',
									{
										schema: {
											data : "announces",
											model : common.ui.data.Announce,
											total : "totalCount"
										},
										pageSize: 5											
									}
								);
								var template = kendo.template($("#footer-notice-template").html());		
								announcement.bind('change', function(){
									if(this.view().length>0){
										$("#footer-announcement").html(kendo.render(template, this.view()))
									}
								}).read(); 					
							});
					-->
					</script>
					<ul id="footer-announcement" class="list-unstyled latest-list">
					</ul>	
				</div>
				<div class="col-md-3 md-margin-bottom-40">
					<div class="headline"><h2>링크</h2></div>
				</div>
				<div class="col-md-3 md-margin-bottom-40">
					<div class="headline"><h2>링크</h2></div>		
					<ul>
						<li><a href="#">메르디앙 소개</a></li>
						<li><a href="#">사이트 맵</a></li>
						<li><a href="#">이벤트 & 공지</a></li>
					</ul>		
				</div>
			</div><!-- /.row -->
		</div><!-- /.container -->
	</div><!-- /.footer -->	
	<!-- copyright-->	
	<div class="copyright">
		<div class="container">
			<div class="row">
				<div class="col-md-12 col-sm-12">
					<div class="copyright-text">
						<#if action.webSite ?? >${.now?string("yyyy")} &copy; ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
						<a href="<@spring.url '/content.do?contentId=2'/>">개인정보 취급방침</a> | <a href="<@spring.url '/content.do?contentId=1'/>">이용약관</a>
					</div>
				</div>
			</div><!--/row--> 
		</div><!--/container--> 
	</div><!--/copyright--> 
</footer>