
<script type="text/x-kendo-template" id="photo-view-template">	
	<figure class="effect-marley" data-ride="lightbox" >
		<img src="${request.contextPath}/community/download-my-image.do?imageId=#:imageId#" alt="#:name# 이미지"/>
		<figcaption>
			<h2>#: name # <span></span></h2>
			<p>#: formattedModifiedDate #</p>
			<a href="\\#">View more</a>
		</figcaption>			
	</figure>
</script>

<script id="photo-editor-modal-template" type="text/x-kendo-template">
	<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
		<div class='modal-dialog'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title' data-bind="text: image.name">포토 수정</h5>
				</div>
				<div class='modal-body'>					
					<div class="page-header no-margin-t">
						<h4 class="text-primary"><i class="fa fa-lock"></i> <strong>공개</strong>&nbsp;<small>공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h4>
					</div>
					<div class="btn-group btn-group-sm" data-toggle="buttons">
						<label class="btn btn-success active">
						<input type="radio" name="photo-public-shared" value="1">모두에게 공개
						</label>
						<label class="btn btn-success">
						<input type="radio" name="photo-public-shared" value="0"> 비공개
						</label>
					</div>	
																	
					<div class="page-header">
						<h4 class="text-primary"><i class="fa fa-upload"></i> <strong>이미지 변경</strong> <small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h4>
					</div>
					<input name="update-photo-file" type="file" class="pull-right" />	
										
					<div class="page-header">
						<h4 class="text-primary"><i class="fa fa-bars"></i> <strong>속성</strong> <small>수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</small></h4>
					</div>
					<div class="photo-props-grid" style="min-height: 300px"></div>
																
				</div>
				<div class='modal-footer'>		
					<!--<button type="button" class="btn btn-primary custom-update" disabled="disabled">확인</button>	-->
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>확인</button>				
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>	

<script type="text/x-kendo-template" id="notice-options-template">	
<div class="popover bottom">
	<div class="arrow"></div>
	<h3 class="popover-title">소스 설정			
		<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	</h3>
	<div class="popover-content">
		<h5 ><small><i class="fa fa-info"></i>공지 & 이벤트 소스를 변경할수 있습니다.</small></h5>	
		<div class="btn-group btn-group-sm" data-toggle="buttons">
			<label class="btn btn-success <#if action.user.anonymous >active</#if>">
				<input type="radio" name="notice-selected-target" value="30" >사이트
			</label>
			<label class="btn btn-success <#if !action.user.anonymous >active</#if>">
				<input type="radio" name="notice-selected-target" value="1">My 회사
			</label>
		</div>
	</div>
</div>
</script>

<script type="text/x-kendo-template" id="notice-view-template">	
<div class="panel panel-default no-border no-margin-b" data-bind="visible: visible">
	<div class="panel-heading rounded-top" style="background-color: \\#fff; ">
		<h4 class="panel-title" data-bind="html:announce.subject"></h4>
	</div>
	<div class="panel-body padding-sm">
		<ul class="list-unstyled text-muted">
			<li><span class="label label-primary label-lightweight">게시 기간</span> <span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></li>
			<li><span class="label label-default label-lightweight">생성일</span> <span data-bind="text: announce.formattedCreationDate"></span></li>
			<li><span class="label label-default label-lightweight">수정일</span> <span data-bind="text: announce.formattedModifiedDate"></span></li>
		</ul>	
	<div class="media">
		<a class="pull-left" href="\\#">
			<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">																	
				<p><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span> <code data-bind="text: announce.user.username"></code></p>
				<p data-bind="visible:announce.user.emailVisible, text: announce.user.email"></p>
			</h5>		
		</div>		
	</div>	
	<hr class="devider no-margin-t">
		<div data-bind="html: announce.body " />		
	</div>
</div>
<div class="notice-grid" style="min-height: 300px"></div>
</script>