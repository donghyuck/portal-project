	<!- ================================ ->
	<!-- SECURE TOOLBAR 										 -->
	<!- ================================ ->
	
	<!- ================================ ->
	<!-- SECURE ATTACH DETAIL								 -->
	<!- ================================ ->	
		<script id="attach-details-template" type="text/x-kendo-template">	
			<span class="label label-info">#= contentType #</span>
			<a href="<@spring.url "/secure/download-attachment.do?attachmentId=#= attachmentId #"/>" class="btn btn-sm btn-warning">다운로드</a>
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

<script type="text/x-kendo-tmpl" id="logo-list-view-template">
	<div class="media">
		<a class="pull-left" href="\\#">
		<img class="media-object" src="<@spring.url "/secure/download-logo-image.do?logoId=#=logoId#"/>" alt="...">
		</a>
		<div class="media-body">
			<p>파일 : #: filename# <span class="label label-info">#: imageContentType #</span></p>
			<p>크기 : #= formattedImageSize() #</p>
			<p>수정일 : #= formattedModifiedDate() #</p>
		</div>
	</div>
</script>		
	