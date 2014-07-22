<!-- ============================== -->
<!-- my cloud template                                   -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="attachment-list-view-template">
<div class="file-wrapper">
	#if (contentType.match("^image") ) {#
	<img src="${request.contextPath}/community/view-my-attachment.do?width=150&height=150&attachmentId=#:attachmentId#" alt="#:name# 이미지" />		
	# } else { #		
	<img src="${request.contextPath}/images/common/icons/file/blank.png"></a>
	# } #	
	<div class="file-description">
		<h3>#:name#</h3>
		<p>#:size# 바이트</p>
	</div>
</div>

</script>	
<script type="text/x-kendo-tmpl" id="photo-list-view-template">
<div class="img-wrapper">			
	#if (contentType.match("^image") ) {#
	<img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#:imageId#" alt="#:name# 이미지" />
	# } else { #			
	<img src="http://placehold.it/146x146&amp;text=[file]"></a>
	# } #	
	<div class="img-description">
		<h3>#:name#</h3>
		<p>#:size# 바이트</p>
	</div>
</div>
</script>	
<!-- ============================== -->
<!-- my file template                        -->
<!-- ============================== -->
<script type="text/x-kendo-template" id="file-panel-template">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fa fa-cloud"></i> <span data-bind="text: name"></span></h3>
			<div class="k-window-actions panel-header-controls">
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a>
			</div>		
		</div>
		<div class="panel-body hide grey">
			<button type="button" class="close" aria-hidden="true">&times;</button>			
			<div class="btn-group dropup">
				<a class="btn btn-info" href="${request.contextPath}/community/download-my-attachment.do?attachmentId=#= attachmentId #" ><i class="fa fa-download"></i>&nbsp; 다운로드</a>
				<button  type="button" class="btn btn-info"><i class="fa fa-share"></i>&nbsp; 공유</button>	
				<button  type="button" class="btn btn-info"><i class="fa fa-comment-o"></i>&nbsp; 댓글 추가</button>						
			</div>			
			<div class="btn-group dropup" data-bind="visible: editable">
				<button  type="button" class="btn btn-danger custom-delete"  data-for-attachmentId="#=attachmentId #" ><i class="fa fa-trash-o"></i> 삭제</button>		
				<button  type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown"><i class="fa fa-upload"></i> 파일 변경하기</button>				
				<ul class="dropdown-menu" style="min-width:300px; padding:10px;">
					<li role="presentation" class="dropdown-header">마우스로 새로운 파일을 끌어 놓으세요.</li>
					<li>
						<input name="update-attach-file" id="update-attach-file" type="file"class="pull-right" />
					</li>
				</ul>			
			</div>			
		</div>					
		<div class="panel-body">			
			#if (contentType.match("^image") ) {#			
			<img src="${request.contextPath}/community/view-my-attachment.do?attachmentId=#= attachmentId #" alt="#:name# 이미지" class="img-responsive"/>			
			# } else { #		
				#if (contentType == "application/pdf" ) {#
				<div id="pdf-view"></div>
				# } else { #	
				<div class="k-grid k-widget" style="width:100%;">
					<div style="padding-right: 17px;" class="k-grid-header">
						<div class="k-grid-header-wrap">
							<table cellSpacing="0">
								<thead>
									<tr>
										<th class="k-header">속성</th>
										<th class="k-header">값</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<div style="height: 199px;" class="k-grid-content">
						<table style="height: auto;" class="system-details" cellSpacing="0">
							<tbody>
								<tr>
									<td>파일</td>
									<td>#= name #</td>
								</tr>
								<tr class="k-alt">
									<td>종류</td>
									<td>#= contentType #</td>
								</tr>
								<tr>
									<td>크기(bytes)</td>
									<td>#= size #</td>
								</tr>				
								<tr>
									<td>다운수/클릭수</td>
									<td>#= downloadCount #</td>
								</tr>											
							</tbody>
						</table>	
					</div>
				</div>
				# } #
			# } #  
		</div>	
	</div>			
</script>
<!-- ============================== -->
<!-- my photo template                                   -->
<!-- ============================== -->
<script type="text/x-kendo-template" id="photo-view-template">	
	<figure class="effect-marley" data-ride="lightbox" >
		<img src="${request.contextPath}/community/download-my-image.do?imageId=#:imageId#" alt="#:name# 이미지"/>
		<figcaption>
			<h2>#: name # <span></span></h2>
			<p>#= formattedModifiedDate() #</p>
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
						<input type="radio"  class="js-switch"  name="photo-public-shared" value="1">모두에게 공개
						</label>
						<label class="btn btn-success">
						<input type="radio"  class="js-switch"  name="photo-public-shared" value="0"> 비공개
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