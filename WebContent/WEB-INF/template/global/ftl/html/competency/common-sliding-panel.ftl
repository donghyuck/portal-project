		<div class="sliding-panel bg-color-darker accounts-user-profile">
			<!--<div class="sliding-panel-header">
				<div class="profile-blog my-profile-img">
					<img class="rounded" src="/images/common/anonymous.png" width="42" height="42" data-bind="attr:{src:photoUrl}, invisible:anonymous" alt="" />
					<span data-bind="text:name">방문자</span>
				</div>	
			</div>-->
			<div class="sliding-panel-inner sliding-panel-scrollable fullscreen profile">
				<div class="profile-blog">
					<div class="profile-image-wrapper">
						<img src="/images/common/anonymous.png" data-bind="attr:{src:photoUrl}, invisible:anonymous" />
						<a href="#">변경</a>
					</div>
					<div class="name-location">
					<span data-bind="text:name"></span>
					<span data-bind="text:email"><i class="fa fa-map-marker"></i><a href="#">California,</a> <a href="#">US</a></span>
					</div>
					<div class="clearfix margin-bottom-20"></div>
					<p>Donec non dignissim eros. Mauris faucibus turpis volutpat sagittis rhoncus. Pellentesque et rhoncus sapien, sed ullamcorper justo.</p>								
					</div>
												
									
				<div class="p-xxs">
					<a href="<@spring.url "/accounts/login.html?url=${springMacroRequestContext.getRequestUri()}"/>" 
						class="btn btn-xs btn-success btn-flat rounded" data-bind="visible:anonymous" >로그인</a>
					<a href="<@spring.url "/accounts/logout.html?url=${springMacroRequestContext.getRequestUri()}"/>" 
						class="btn btn-xs btn-danger btn-flat rounded" data-bind="invisible:anonymous" >로그아웃</a>
				</div>
								
				
				<i class="icon-flat icon-svg icon-svg-md business-color-online-support"></i>
				<h4>문의</h4>
				<address>
					서울특별시 구로구 구로동 235-2 <br>
					에이스하이엔드타워 917<br><br>
					Phone: 070-7807-4040<br>
					Fax: 070-7614-3113<br><br>
					Email: <a href="mailto:#">jhlee@podosw.com</a><br>
				</address>
			</div>	
			<a href="javascript:void(0);" class="sliding-panel__close">Close</a>
		</div>