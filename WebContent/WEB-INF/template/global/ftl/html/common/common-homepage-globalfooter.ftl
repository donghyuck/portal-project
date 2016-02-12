<!--=== Footer ===-->
<footer class="footer-global">
	<div class="footer">
		<div class="container">
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />						
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
							<ul style="margin-left:5px;">
							<#list directoryAncestor.components as item >
								<li><a href="${item.page}">${item.title}</a></li>
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
				<div class="col-md-3 md-margin-bottom-40 b-l">
					<p><small><i class="fa fa-quote-left"></i> ${action.webSite.company.description} <i class="fa fa-quote-right"></i></small></p>		
					<div class="footer-logo">
						<img src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" height="42"   alt="로고 이미지">
					</div>
			<#if action.hasWebSiteMenu("FOOTER_MENU") >
				<#assign website_footer_menu = action.getWebSiteMenu("FOOTER_MENU") />
				<#if  website_footer_menu.components?has_content >
					<ul class="list-unstyled footer-link-list m-l-sm">
					<#list website_footer_menu.components as item >					
						<li><a href="${item.page}">${item.title}</a></li>
					</#list>
					</ul>	
				</#if>
			</#if>
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
					<#if action.webSite ?? >Copyright &copy; ${.now?string("yyyy")} ${action.webSite.company.displayName }. 모든 권리 보유.<#else></#if>
						<#if action.hasWebSiteMenu("RULES_MENU") >
							<#assign website_rules_menu = action.getWebSiteMenu("RULES_MENU") />
							<#list website_rules_menu.components as item >					
						<a href="${item.page}">${item.title}</a> <#if item != website_rules_menu.components?last >|</#if>		
							</#list>
					<#else>
						<a href="<@spring.url '/content.do?contentId=2'/>">개인정보 취급방침</a> | <a href="<@spring.url '/content.do?contentId=1'/>">이용약관</a>
					</#if>
					</div>
				</div>
			</div><!--/row--> 
		</div><!--/container--> 
	</div><!--/copyright--> 
</footer>