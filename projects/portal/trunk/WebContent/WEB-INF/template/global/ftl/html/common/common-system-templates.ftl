	<!- ================================ ->
	<!-- SECURE TOOLBAR 										 -->
	<!- ================================ ->
	<script id="top-navbar-template" type="text/x-kendo-template">
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
					<input type="hidden" id="companyId" name="targetCompanyId" value="${action.user.company.companyId}" />
					<input type="hidden" id="targetSiteId" name="targetSiteId" value="0" />
				</form>			
				<div class="navbar-form navbar-left">
					<div class="form-group">
						<div id="companyDropDownList"></div>
					</div>					
				</div>			
				<div class="collapse navbar-collapse navbar-ex1-collapse">					
					<ul class="nav navbar-nav">						
					<#assign webSiteMenu = action.getWebSiteMenu("SYSTEM_MENU") />
					<#list webSiteMenu.components as item >
						<#if  item.components?has_content >
						<li class="dropdown">
							<a href="\\#" class="dropdown-toggle" data-toggle="dropdown">${item.title}<b class="caret"></b></a>
							<ul class="dropdown-menu">
							<#list item.components as sub_item >	
							<#if WebSiteUtils.isUserAccessAllowed(request, sub_item ) >						
							<#if sub_item.components?has_content >
								<li class="dropdown-submenu">
									<a href="\\#" class="dropdown-toggle" data-toggle="dropdown">${sub_item.title}</a>
									<ul class="dropdown-menu">
										<#list sub_item.components as sub_sub_item >
										<li><a href="${sub_sub_item.page}" data-description="${sub_sub_item.description}" >${ sub_sub_item.title }</a></li>
										</#list>
									</ul>
								</li>
								<#else>								
								<li><a href="${sub_item.page}" data-description="${sub_item.description}" >${sub_item.title}</a></li>
							</#if>
							</#if>								
							</#list>
							</ul>
						</li>						
						<#else>
						<li><a href="\\#">${ item.title }</a></li>
						</#if>							
					</#list>	
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
		
	<script id="topnavbar-template" type="text/x-kendo-template">
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
					<input type="hidden" id="companyId" name="targetCompanyId" value="${action.user.company.companyId}" />
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
			<span class="label label-info">#= contentType #</span>
			<a href="${request.contextPath}/secure/download-attachment.do?attachmentId=#= attachmentId #" class="btn btn-sm btn-warning">다운로드</a>
		</script>
		
	<!- ================================ ->
	<!-- COMPANY SETTING MODAL TEMPLAGE 		 -->
	<!- ================================ ->			
	<script id="company-setting-modal-template" type="text/x-kendo-template">
	
		<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>
			<div class='modal-dialog modal-lg'>
				<div class='modal-content'>
					<div class='modal-header'>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
						<h5 class='modal-title'>#= title #</h5>
					</div>
					<div class='modal-body'>
						<div class="row">						
							<div class="col-sm-6">
								<div class="panel-header text-primary">
									<h5 >
									<small><i class="fa fa-info"></i> 변경후에 확인 버튼을 클릭하세요. </small>
									
									</h5>
								</div>		
							  <div class="form-group">
							    <label>이름</label>
							    <input type="text" class="form-control" placeholder="회사 이름" data-bind="value: company.displayName ">
							  </div>
							  <div class="form-group">
							    <label>도메인</label>
							     <input type="text" class="form-control" placeholder="도메인" data-bind="value: company.domainName">
							    <p class="help-block">예시) www.demo.com</p>
							  </div>
							  <div class="form-group">
							    <label>회사 소개</label>
							     <input type="text" class="form-control" data-bind="value:company.description">
							  </div>	
							</div>  
							<!-- attributes -->
							<div class="col-sm-6">
								<div class="panel-header text-primary">
									<h5>									 
									<small><i class="fa fa-info"></i> 프로퍼티는 변경 후 저장버튼을 클릭하면 반영됩니다.</small>
									</h5>
								</div>								
								<div data-role="grid"
									date-scrollable="false"
									data-editable="true"
									data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
									data-columns="[
										{ 'title': '이름',  'field': 'name', 'width': 200 },
										{ 'title': '값', 'field': 'value' },
										{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
									]"
									data-bind="source: properties, visible: isVisible"
									style="height: 300px"></div>
							</div>											
						</div>
					</div>
					<div class='modal-footer'>		
						<button type="button" class="btn btn-primary btn-sm custom-update" disabled data-bind="events:{ click: onSave }" >확인</button>		
						<button type="button" class="btn btn-default  btn-sm" data-dismiss='modal' aria-hidden='true'>취소</button>	
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
	</script>		
		
	<!- ================================ ->
	<!-- WEBSITE SETTING MODAL TEMPLAGE 		 -->
	<!- ================================ ->			
	<script id="website-setting-modal-template" type="text/x-kendo-template">
		<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>
			<div class='modal-dialog modal-lg'>
				<div class='modal-content'>
					<div class='modal-header'>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
						<h5 class='modal-title'>#= title #</h5>
					</div>
					<div class='modal-body'>
						<div class="row">						
							<div class="col-sm-6">
								<div class="panel-header text-primary">
									<h5 >
									<small><i class="fa fa-info"></i> 변경후에 확인 버튼을 클릭하세요. </small>									
									</h5>
								</div>		
							  <div class="form-group">
							    <label><small>이름</small></label>
							    <input type="text" class="form-control" placeholder="사이트 이름" data-bind="value: website.displayName ">
							  </div>		
							  <div class="form-group">
							    <label><small>설명</small></label>
							     <input type="text" class="form-control" placeholder="도메인" data-bind="value: website.description">
							  </div>
								<div class="form-group">
									<label><small>사용여부</small></label>
										<div class="checkbox">
											<label>
												<input type="checkbox"  name="enabled"  data-bind="checked: website.enabled" /> 사용
											</label>
										</div>						
								</div>
								<div class="form-group">
									<label><small>공개여부</small></label>
										<div class="checkbox">
											<label>
												<input type="checkbox"  name="enabled"  data-bind="checked: website.allowAnonymousAccess" /> 공개
											</label>
										</div>					
								</div>															  
							  <div class="form-group">
							    <label><small>도메인</small></label>
							     <input type="text" class="form-control" placeholder="URL" data-bind="value: website.url">
							    <p class="help-block">예시) www.demo.com, 111.111.111.111</p>
							  </div>							  							  						
							</div> 
							<!-- attributes -->
							<div class="col-sm-6">
								<div class="panel-header text-primary">
									<h5>									 
									<small><i class="fa fa-info"></i> 프로퍼티는 변경 후 저장버튼을 클릭하면 반영됩니다.</small>
									</h5>
								</div>								
								<div data-role="grid"
									date-scrollable="false"
									data-editable="true"
									data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
									data-columns="[
										{ 'title': '이름',  'field': 'name', 'width': 200 },
										{ 'title': '값', 'field': 'value' },
										{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
									]"
									data-bind="source: properties, visible: isVisible"
									style="height: 300px"></div>
							</div>											
						</div>
					</div>
					<div class='modal-footer'>		
						<button type="button" class="btn btn-primary btn-sm custom-update" disabled data-bind="events:{ click: onSave }" >확인</button>		
						<button type="button" class="btn btn-default  btn-sm" data-dismiss='modal' aria-hidden='true'>취소</button>	
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
	</script>						

	<!- ================================ ->
	<!-- WEBSITE MENU MODAL TEMPLAGE 				 -->
	<!- ================================ ->			
	<script id="website-menu-setting-modal-template" type="text/x-kendo-template">
		<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>
			<div class='modal-dialog modal-lg'>
				<div class='modal-content'>
					<div class='modal-header'>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
						<h5 class='modal-title'>#= title #</h5>
					</div>
					<div class='modal-body'>			
						<div class="page-header text-primary">
							<h5 >
								<small><i class="fa fa-info"></i> 
								<span data-bind="visible: website.menu.menuId" >잘못된 메뉴 데이터가 저장되는 경우 화면의 메뉴가 보이지 않을 수 있습니다.</span>
								<span data-bind="invisible: website.menu.menuId" >메뉴 데이터는 기본 템플릿을 기반으로 자동으로 생성되었습니다.</span>
								</small>									
							</h5>
						</div>							
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-lg-2 control-label" ><small>이름</small></label>
								<div class="col-lg-10">
									<input type="text" class="form-control" placeholder="이름" data-bind="value:website.menu.name"/>
								</div>
							</div>					
							<div class="form-group">
								<label class="col-lg-2 control-label"><small>타이틀</small></label>
								<div class="col-lg-10">
									<input type="text" class="form-control" placeholder="타이틀" data-bind="value:website.menu.title"/>
								</div>
							</div>				
							<div class="form-group">
								<label class="col-lg-2 control-label" ><small>사용여부</small></label>
								<div class="col-lg-10">
									<div class="checkbox">
										<label>
											<input type="checkbox"  name="enabled"  data-bind="checked: website.menu.enabled" /> 사용
										</label>
									</div>
								</div>							
							</div>													
						</form>															
					</div>
					<div class='modal-body editor-model-body'>
						<div id="xmleditor"></div>
					</div>
					<div class='modal-footer' style="margin-top: 0px;">
						<button type="button" class="btn btn-primary btn-sm custom-update" data-bind="events:{ click: onSave }" data-loading-text="Loading...">확인</button>		
						<button type="button" class="btn btn-default  btn-sm" data-dismiss='modal' aria-hidden='true'>취소</button>						
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->				
	</script>