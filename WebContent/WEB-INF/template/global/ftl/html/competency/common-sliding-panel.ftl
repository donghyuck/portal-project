		<div class="sliding-panel bg-color-darker">
			<div class="sliding-panel-inner sliding-panel-scrollable fullscreen">
				<#if action.webSite ?? >
				<#assign onePageMenu = action.getWebSiteMenu("ONEPAGE_COMPETENCY_MENU") />	
				<ul class="sliding-navigation">
					<#list onePageMenu.components as item >
					<#if WebSiteUtils.isUserAccessAllowed(item) >
					<li><a href="${item.page}">${item.title}</a></li>	
					</#if>	
					</#list>	
				</ul>
				</#if>		
				
				
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