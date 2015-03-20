<!--=== Footer ===-->
<footer class="footer-global">
	<div class="footer">
		<div class="container">
			
			<#if action.isSetPage() && !action.isSetNavigator() &&  action.webSite ??   >
				<#assign webSiteMenu = action.getWebSiteMenu(pageMenuName) />
				<#assign navigator = WebSiteUtils.getMenuComponent(webSiteMenu, pageMenuItemName) />					
			</#if>
			<#if action.webSite ?? >				
			<!-- breadcombs -->
			<div class="footer-breadory">
			<div class="row">
				<div class="col-sm-12">
					<div class="breadcrumbs">
						<a href="main.do" class="breadcrumbs-home" ><i class="fa fa-home fa-lg"></i></a>
						<ol class="breadcrumbs-list">
							<li><a href="">${navigator.parent.title}</a></li>
							<li class="active">${navigator.title}</li>
						</ol>
					</div>
					<div class="directorynav">
						<#assign directoryAncestor = navigator.parent />						
						<div class="col-sm-3 no-padding-l">
							<label><h3><#if directoryAncestor.icon?? ><i class="fa ${directoryAncestor.icon}"></i></#if> ${directoryAncestor.title}</h3></label>
							<ul>
							<#list directoryAncestor.components as item >
								<li><a href="${item.page}"><#if item.icon?? ><i class="fa ${item.icon}"></i></#if> ${item.title}</a></li>
							</#list>
							</ul>
						</div>			
					</div>										
				</div>
			</div>
			</div>
			<!--  /.breadcombs -->
			<hr/>
			</#if>
			<div class="row">
				<div class="col-md-3 md-margin-bottom-40">
					<label><h3><i class="fa fa-circle-thin"></i> 공지 & 이벤트</h3></label>
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
					<ul id="footer-announcement" class="list-unstyled latest-list m-l-sm">
					</ul>	
				</div>
				<div class="col-md-3 md-margin-bottom-40">
					<label><h3><i class="fa fa-circle-thin"></i> 링크</h3></label>
				</div>
				<div class="col-md-3 md-margin-bottom-40">
					<label><h3><i class="fa fa-circle-thin"></i> 제휴 사이트</h3></label>				
				</div>		

				<div class="col-md-3 md-margin-bottom-40">
					<p><small>${action.webSite.company.description}</small></p>		
					<div class="footer-logo">
						<img src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" height="42"   alt="로고 이미지">
					</div>
					<ul class="list-unstyled link-list m-l-sm">
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