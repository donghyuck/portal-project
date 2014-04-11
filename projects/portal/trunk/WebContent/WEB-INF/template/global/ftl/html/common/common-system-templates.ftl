	<!- ================================ ->
	<!-- SECURE TOOLBAR 										 -->
	<!- ================================ ->
	<script id="topnavbar-template" type="text/x-kendo-template">
		${action.getClass().getName()}
		<div class="navbar navbar-inverse navbar-fixed-top " role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="\\#">관리자 콘솔</a>
				</div>
				<form role="navigation" name="navbar-form" method="POST" accept-charset="utf-8">
					<input type="hidden" id="output" name="output" value="html" />
					<input type="hidden" id="companyId" name="targetCompanyId" value="0" />
					<input type="hidden" id="targetSiteId" name="targetSiteId" value="0" />
				</form>			
				<div class="navbar-form navbar-left">
					<div class="form-group">
						<div id="companyDropDownList"></div>
					</div>					
				</div>			
				<div class="collapse navbar-collapse navbar-ex1-collapse">					
					<ul class="nav navbar-nav">
					# for (var i = 0; i < data.length; i++) { #
						# var item =data[i] ; #
						#if ( item.components.length > 0) { #	
						<li class="dropdown">
							<a href="\\#" class="dropdown-toggle" data-toggle="dropdown">#= item.title # <b class="caret"></b></a>
							<ul class="dropdown-menu">
							# for ( var j = 0 ; j <item.components.length ; j ++ ) { #
								# var sub_item =item.components[j] ; #
								<li><a href="\\#" #if (sub_item.page != 'null' && sub_item.page != '')  { # action="#=sub_item.page#" description="#=sub_item.description#" # } # >#= sub_item.title #</a></li>
							# } #
							</ul>							
						</li>
						# } else { #	
						<li><a href="\\#">#= item.title #</a></li>
						# } #
					# } #
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="${request.contextPath}/main.do"><i class="fa fa-home"></i> 사용자 홈</a></li>
						<li class="dropdown">
							<a href="\\#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> ${action.user.name} <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="\\#">Action</a></li>
								<li><a href="\\#">Another action</a></li>
								<li><a href="\\#">Something else here</a></li>
								<li><a href="${request.contextPath}/logout"><i class="fa fa-sign-out"></i> 로그아웃</a></li>
							</ul>
						</li>
						<li>
							<p class="navbar-text"></p>
						</li>
					</ul>					
				</div>
			</div>
		</div>	
	</script>	
	<!- ================================ ->
	<!-- SECURE ATTACH DETAIL								 -->
	<!- ================================ ->	
		<script id="attach-details-template" type="text/x-kendo-template">	
			<a href="${request.contextPath}/secure/download-attachment.do?attachmentId=#= attachmentId #" class="btn btn-sm btn-warning">다운로드</a>
		</script>
	