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
								<p/>
								<div class="title">
									<h5>연락처</h5>
								</div>
								<address class="md-margin-bottom-40">
								서울특별시 구로구 디티털로 30길 31<br />
								코오롱빌란트2차 701호 ~ 704호<br />
								Tel: 02 555 1965<br />
								Fax: 02 2081 1090 <br />
								<!--Email: <a href="mailto:info@anybiz.com" class="">info@anybiz.com</a>-->
								</address>								
							</div>
						</div>
					</div>
					<!-- //Footer Col.// -->
					<!-- Footer Col. -->
					<div class="col-md-3 col-sm-3 footer-col">
						<div class="title">
							<h5>최근 소식</h5>
						</div>
                                    <div class="footer-content footer-recent-tweets-container">
                                        <ul class="tweetList footer-recent-tweets">
                                            <li class="tweet_content item">
                                                <p>Grab a copy of the popular Boomerang theme for $10 until its next release! </p>
                                                <p class="timestamp">2 days ago</p>
                                            </li>
                                            <li class="tweet_content item">
                                                <p>Newest Blog Awesome post: Stacking Text and Icons <a href="http://t.co/1qRP8K1wjG">Check it</a></p>
                                                <p class="timestamp">4 days ago</p>
                                            </li>
                                        </ul>
                                    </div>
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