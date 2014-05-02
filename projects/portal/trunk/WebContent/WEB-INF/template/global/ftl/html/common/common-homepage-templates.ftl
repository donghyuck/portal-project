<script type="text/x-kendo-template" id="file-panel-template">
	<div class="panel panel-default">
		<div class="panel-heading">
			<i class="fa fa-cloud"></i>&nbsp;<span data-bind="text: name"></span>
			<div class="k-window-actions panel-header-actions">
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
<!-- my photo view panel template                    -->
<!-- ============================== -->
<script type="text/x-kendo-template" id="photo-panel-template">
	<div class="panel panel-default">
		<div class="panel-heading">
			<i class="fa fa-cloud"></i>&nbsp;마이 포토
			<div class="k-window-actions panel-header-actions">
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a>
			</div>		
		</div>	
		<div class="panel-body hide">
			<button type="button" class="close" aria-hidden="true">&times;</button>					
			<div class="btn-group dropup" data-bind="visible: editable">
				<button  type="button" class="btn btn-danger custom-delete"  data-bind="enabled: editable"><i class="fa fa-trash-o"></i> 삭제</button>				
			</div>		
			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-share"></i>&nbsp;<strong>이미지 공유</strong>&nbsp;<small>모두에게 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h5>
			</div>			
			<div class="btn-group" data-toggle="buttons">
				<label class="btn btn-primary btn-sm">
				<input type="radio" name="photo-public-shared" value="1">모두에게 공개
				</label>
				<label class="btn btn-primary btn-sm active">
				<input type="radio" name="photo-public-shared" value="0"> 비공개
				</label>
			</div>
			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-info"></i>&nbsp;<strong>이미지 속성</strong>&nbsp;<small>수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</small></h5>
			</div>
			<div id="photo-prop-grid"></div>			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-upload"></i>&nbsp;<strong>이미지 변경</strong>&nbsp;<small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
			</div>
			<input name="update-photo-file" type="file" id="update-photo-file" data-bind="enabled: editable" class="pull-right" />			
		</div>	
		<div class="panel-body block-space-0">			
			<figure>			
				<img data-bind="attr:{src: photoUrl, alt : name }" width="100%" class="border-buttom-rounded"/>			
				<figcaption class="border-buttom-rounded">
					<small class="text-muted" data-bind="text: modifiedDate"></small>				
				</figcaption>		
			</figure>		
			<div id="photo_overlay" class="overlay overlay-hugeinc color9">		
				<button type="button" class="overlay-close">Close</button>
				<figure class="img-full-width">
					<img data-bind="attr:{src: photoUrl}" class="img-fit-screen-width" />
				</figure>		
				<div style="position:fixed; top:10px; left: 10px; padding:5px;">
					<div class="btn-group">
					  <a  href="\\#" class="btn btn-link custom-previous" data-bind="visible: previous"><i class="fa fa-angle-left fa-4x"></i></a>
					  <a href="\\#" class="btn btn-link custom-next" data-bind="visible: next"><i class="fa fa-angle-right fa-4x"></i></a>
					</div>				
					<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-info active">
						 		<input type="radio" name="lightning-box-photo-scale"  value="0"><i class="fa fa-expand"></i></i>
							</label>
							<label class="btn btn-info">
						 		<input type="radio" name="lightning-box-photo-scale"  value="1"><i class="fa fa-arrows-h"></i></i>
							</label>
							<label class="btn btn-info">
								<input type="radio" name="lightning-box-photo-scale"  value="2"> <i class="fa fa-arrows-v"></i>
							</label>
					</div>	
				<div>									
			</div>							
		</div>				
	</div>		
</script>

<script type="text/x-kendo-template" id="photo-panel-template-old">
	<div class="panel panel-default">
		<div class="panel-heading">
			<i class="fa fa-cloud"></i>&nbsp;사진
			<div class="k-window-actions panel-header-actions">
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>
				<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a>
			</div>		
		</div>	
		<div class="panel-body hide">
			<button type="button" class="close" aria-hidden="true">&times;</button>					
			<div class="btn-group dropup" data-bind="visible: editable">
				<button  type="button" class="btn btn-danger custom-delete"  data-bind="enabled: editable"><i class="fa fa-trash-o"></i> 삭제</button>				
			</div>		
			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-share"></i>&nbsp;<strong>이미지 공유</strong>&nbsp;<small>모두에게 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h5>
			</div>			
			<div class="btn-group" data-toggle="buttons">
				<label class="btn btn-primary btn-sm">
				<input type="radio" name="photo-public-shared" value="1">모두에게 공개
				</label>
				<label class="btn btn-primary btn-sm active">
				<input type="radio" name="photo-public-shared" value="0"> 비공개
				</label>
			</div>
			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-info"></i>&nbsp;<strong>이미지 속성</strong></h5>
			</div>
			<div id="photo-prop-grid"></div>			
			<div class="page-header text-primary">
				<h5 ><i class="fa fa-upload"></i>&nbsp;<strong>이미지 변경</strong>&nbsp;<small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
			</div>
			<input name="update-photo-file" type="file" id="update-photo-file" data-bind="enabled: editable" class="pull-right" />			
		</div>	
		<div class="panel-body block-space-0">			
			<figure>			
				<img data-bind="attr:{src: photoUrl, alt : name }" width="100%" class="border-buttom-rounded"/>			
				<figcaption class="border-buttom-rounded">
					<ul class="list-inline">
						<small class="text-muted" data-bind="text: modifiedDate"></small>
					</ul>					
				</figcaption>		
			</figure>		
			<div id="photo_overlay" class="overlay overlay-hugeinc color9">
				<nav class="navbar navbar-default navbar-static-top" role="navigation">
					<div class="container">
						<ul class="nav navbar-nav navbar-right">
							<li class="previous" data-bind="visible: previous"><a href="\\#" class="btn-link"><i class="fa fa-angle-left fa-3x"></i></a></li>
							<li class="next" data-bind="visible: next"><a href="\\#" class="btn-link"><i class="fa fa-angle-right fa-3x"></i></a></li>								
						</ul>
					</div>
				</nav>								
				<button type="button" class="overlay-close">Close</button>
				<div class="container">
					<div class="row" >
						<div class="col-md-8"></div>
						<div class="col-md-4"
						<!-- start photo details -->	
							<div class="panel-group" id="photo-details-accordion">
								<div class="panel panel-dark">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a data-toggle="collapse" data-parent="\\#photo-details-accordion" href="\\#photo-details-info">
											<i class="fa fa-info"></i>&nbsp;사진정보
											</a>
										</h4>
									</div>
									<div id="photo-details-info" class="panel-collapse collapse in">
										<div class="panel-body">
											<p>파일: <span  data-bind="text: name"/></p>
											<p>크기: <span  data-bind="text: formattedSize" /> 바이트</p>			
											<p>생성일: <span  data-bind="text: formattedCreationDate" /></p>			
											<p>수정일: <span  data-bind="text: formattedModifiedDate"/></p>			
										</div>
									</div>
								</div>	
								<div class="panel panel-dark">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a data-toggle="collapse" data-parent="\\#photo-details-accordion" href="\\#photo-details-tags">
											<i class="fa fa-tags"></i>&nbsp;태그
											</a>
										</h4>
									</div>
									<div id="photo-details-tags" class="panel-collapse collapse">
										<div class="panel-body">
								
										</div>
									</div>
								</div>	
								<div class="panel panel-dark">
									<div class="panel-heading">
										<h4 class="panel-title">
											<a data-toggle="collapse" data-parent="\\#photo-details-accordion" href="\\#photo-details-comments">
											<i class="fa fa-comment-o"></i>&nbsp;댓글
											</a>
										</h4>
									</div>
									<div id="photo-details-comments" class="panel-collapse collapse">
										<div class="panel-body">
													<ul class="media-list">
														<li class="media">
															<div class="pull-left" >
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</div>
															<div class="media-body">
																<h4 class="media-heading">Media heading</h4>
															</div>
														</li>
														<li class="media">
															<a class="pull-left" href="\\#">
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</a>
															<div class="media-body">
																<h4 class="media-heading">Media heading</h4>
															</div>
														</li>
														<li class="media">
															<a class="pull-left" href="\\#">
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</a>
															<div class="media-body">
																<h4 class="media-heading">Media heading</h4>
															</div>
														</li>	
														<li class="media">
															<a class="pull-left" href="\\#">
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</a>
															<div class="media-body">
																<h4 class="media-heading">Media heading</h4>
															</div>
														</li>								
														<li class="media">
															<a class="pull-left" href="\\#">
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</a>
															<div class="media-body">
																<h4 class="media-heading">Media heading</h4>
															</div>
														</li>	
														<li class="media">
															<a class="pull-left" href="\\#">
																<img class="media-object" src="http://www.inkium.com/accounts/view-image.do?width=100&height=150&imageId=1" alt="...">
															</a>
															<div class="media-body">									
																<p><textarea class="form-control" rows="3"></textarea></p>
																<button type="button" class="btn btn-info">확인</button>
															</div>
														</li>																	
													</ul>	
										</div>
									</div>
								</div>			
							</div>  
								
						<!-- end photo details -->
						</div>					
					</div>
				</div>			
			</div>
					</div>			
				</div>							
			</div>							
		</div>				
	</div>		
</script>

<script type="text/x-kendo-template" id="photo-view-template">	
		<figure>			
			<a href="\\#photo-#:imageId#">			
			<img src="${request.contextPath}/community/download-my-image.do?imageId=#:imageId#" width="100%" alt="#:name# 이미지"/>			
			</a>
			<figcaption>
				<ul class="list-inline">
					<small class="text-muted" data-bind="text: modifiedDate"></small>
				</ul>
				<div class="blank-top-5 "></div>
				<ul class="pager">
					#if ( index > 0 || page > 1 ) { # 
						<li class="previous"><i class="fa fa-chevron-left fa-2x"></i></li>
						# } #	
						<li class="next"><i class="fa fa-chevron-right fa-2x"></i></li>
				</ul>										
			</figcaption>			
		</figure>
		<div class="lb-overlay" id="photo-#:imageId#">			
			<a href="\\#page" class="lb-overlay-close">Close</a>
			<div class="splitlayout" >
				<div class="splitlayout-side splitlayout-side-left " >
					<img src="${request.contextPath}/community/view-my-image.do?imageId=#:imageId#" />
				</div>
				<div class="splitlayout-side splitlayout-side-right " >
				
				</div>			
			</div>
		</div>		
</script>

<script type="text/x-kendo-template" id="file-view-template">
	<div class="panel panel-default">
		<div class="panel-heading">#= name # 미리보기<button id="image-view-btn-close" type="button" class="close">&times;</button></div>
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
		<div class="panel-footer">
			<a class="btn btn-default" href="${request.contextPath}/community/download-my-attachment.do?attachmentId=#= attachmentId #" ><i class="fa fa-download"></i> 다운로드</a>
			<button  type="button" class="btn btn-danger custom-attachment-delete"  data-for-attachmentId="#=attachmentId #" ><i class="fa fa-trash-o"></i> 삭제</button>		
			<button  type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown"><i class="fa fa-upload"></i> 파일 변경하기</button>				
			<ul class="dropdown-menu" style="min-width:400px; padding:10px;">
				<li role="presentation" class="dropdown-header">마우스로 새로운 파일을 끌어 놓으세요.</li>
				<li>
					<input name="update-attach-file" id="update-attach-file" type="file"class="pull-right" />
				</li>
			</ul>			
		</div>
	</div>
</script>

<!-- EVENT -->
<script type="text/x-kendo-tmpl" id="announcement-detail-panel-template">		
	<div class="panel panel-default">
		<div class="panel-heading">
			<button type="button" class="close" aria-hidden="true"><img src="${request.contextPath}/images/close.png" /></button>
			<h4 data-bind="html:subject"></h4>
			<small class="text-muted"><span class="label label-info">게시 기간</span> #: kendo.toString(startDate, "g") # ~  #: kendo.toString(endDate, "g") #</small>					
		</div>
		<div class="panel-body" data-bind="html:body"></div>	
	</div>
</script>
<!-- ============================== -->
<!-- announce view panel template                    -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="announcement-view-template">		
	<div class="page-heading">
		<h4 data-bind="html:subject"></h4>		
		<small class="text-muted"><span class="label label-primary">게시 기간</span> #: kendo.toString(startDate, "g") # ~  #: kendo.toString(endDate, "g") #</small>
		<p class="text-muted">
			<small><span class="label label-default">생성일</span> #: kendo.toString(creationDate, "g") #</small>
			<small><span class="label label-default">수정일</span> #: kendo.toString(modifiedDate, "g") #</small>
		</p>
	</div>
	<div class="media">
		<a class="pull-left" href="\\#">
		<img src="${request.contextPath}/download/profile/#: user.username #?width=150&height=150" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">
				# if( user.nameVisible ){#
				#: user.name # (#: user.username #)
				# } else { #
				#: user.username #
				# } # 		
				# if( user.emailVisible ){#
				<br>(#: user.email #)
				# } #	
			</h5>		
		</div>
	</div>	
	<div class="blank-top-5" ></div>
	<div data-bind="html:body"></div>	
	<div class="blank-top-5" ></div>
	<div class="btn-group pull-right">
		<button  type="button" class="btn btn-info btn-sm custom-list "><i class="fa fa-angle-double-up"></i> 목록</button>
		# if ("${ action.view! }" == "personalized" && modifyAllowed ) {#  										
		<button  type="button" class="btn btn-info btn-sm custom-edit"><i class="fa fa-pencil-square-o"></i> 수정</button>
		# } #		
	</div>
</script>

<script type="text/x-kendo-tmpl" id="announcement-editor-template">		
	<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
		<div class='modal-dialog modal-lg'>
			<div class='modal-content'>
			<!--
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>					
				</div>
			-->	
				<div class='modal-body'>			
					<div class="page-header text-primary">
						<h5 >
						<small><span class="label label-danger" data-bind="invisible: announceId">NEW</span>&nbsp; 우측버튼을 클릭하여 공지 및 이벤트를 추가할 대상을 선택하세요.</small>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-info btn-sm active">
							<input type="radio" name="announce-type" value="30" data-bind="checked: objectType">사이트
							</label>
							<label class="btn btn-info btn-sm">
							<input type="radio" name="announce-type" value="1" data-bind="checked: objectType">회사
							</label>
						</div>						
						</h5>
					</div>	
					<div  class="form">
						<div class="form-group">
							<label class="control-label">제목</label>							
							<input type="text" placeholder="제목을 입력하세요." data-bind="value: subject"  class="form-control" placeholder="제목" />
						</div>
						<div class="form-group">
							<label class="control-label">공지 기간</label>
							<div class="col-sm-12" >
								<input data-role="datetimepicker" data-bind="value:startDate"> ~ <input data-role="datetimepicker" data-bind="value:endDate">
								<span class="help-block"><small>지정된 기간 동안만 이벤트 및 공지가 보여집니다. </small></span>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label">본문</label>
							<textarea class="editor" data-bind='value:body'></textarea>
						</div>
						<div class="status"></div>
					</div>								
				</div>
				<div class='modal-footer'>
					<div class="btn-group">
						<button type="button" class="btn btn-primary" data-dismiss='modal' aria-hidden='true'>취소</button>					
						<button type="button" class="btn btn-primary custom-update" disabled="disabled"><i class="fa fa-check"></i> 저장</button>	
					</div>	
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>
<!--
<script type="text/x-kendo-tmpl" id="announcement-edit-template">		
	<div  class="form">
		<div class="form-group">
			<label class="control-label">제목</label>
			<input type="text" placeholder="제목을 입력하세요." data-bind="value: subject"  class="form-control" placeholder="제목" />
		</div>
		<div class="form-group">
			<label class="control-label">기간</label>
			<div class="col-sm-12" >
			<input data-role="datetimepicker" data-bind="value:startDate"> ~ <input data-role="datetimepicker" data-bind="value:endDate">
			<span class="help-block">지정된 기간 동안만 이벤트 및 공지가 보여집니다. </span>
			</div>
		</div>
		<div class="form-group">
			<textarea class="editor" data-bind='value:body'></textarea>		
		</div>
	</div>	  
	<div class="status"></div>	
	<div class="btn-group">
		<button type="button" class="btn btn-primary custom-update" ><i class="fa fa-check"></i> 저장</button>
		# if( announceId > 0 ){#
		<button type="button" class="btn btn-primary custom-cancle" >취소</button>
		<button type="button" class="btn btn-danger custom-delete" ><i class="fa fa-trash-o"></i> 삭제</button>			
		# } #
	</div>
</script>-->

<script type="text/x-kendo-tmpl" id="announcement-template">
	<tr class="announce-item" onclick="viewAnnounce(#: announceId#);">
		<th>#: announceId#</th>
		<td>#: subject#</td>
	</tr>
</script>

<!-- ============================== -->
<!-- my socialnetwork view panel template          -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="social-view-panel-template">
	<div class="custom-panels-group" style="display:none;"> 
		<div id="#: serviceProviderName #-panel-#:socialAccountId#" class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-#: serviceProviderName # fa-fw"></i>&nbsp;&nbsp;#: serviceProviderName # &nbsp; 소식
				<div class="k-window-actions panel-header-actions">
					<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a>
					<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
					<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
					<a role="button" href="\\#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>
					<a role="button" href="\\#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a>
				</div>							
			</div>
			<div class="panel-body hide" style="max-height:500px;">
				<button type="button" class="close" aria-hidden="true">&times;</button>	

				<div class="page-header text-primary">
					<h5><i class="fa fa-circle"></i>&nbsp;<strong>스크롤</strong>&nbsp;<small>스크롤을 OFF 하면 페널의 스크롤이 없이 보여집니다.</small></h5>
				</div>
				<p>
				<div class="btn-group" data-toggle="buttons">
						<label class="btn btn-primary btn-xs active">
							<input type="radio" name="options-scrollable" value="1">ON
						</label>
						<label class="btn btn-primary btn-xs">
							<input type="radio" name="options-scrollable" value="0">OFF
						</label>
				</div>	
				</p>
				<div class="page-header text-primary">
					<h5><i class="fa fa-circle"></i>&nbsp;<strong>속성</strong>&nbsp;<small>쇼셜 패널에 대한 속성입니다.</small></h5>
				</div>
				<div id="#: serviceProviderName #-panel-#:socialAccountId#-prop-grid"></div>			
				
			</div>
			<div class="panel-body scrollable" style="max-height:500px;"> 
				<ul class="media-list">
					<div id="#:serviceProviderName#-streams-#:socialAccountId#">&nbsp;</div>
				</ul>
			</div>
		</div>	
	</div>				
</script>

<script type="text/x-kendo-tmpl" id="facebook-homefeed-template">
		#if (type != "STATUS") {#
		<li class="media">
		    <a class="pull-left" href="\\#">
		    	<img class="media-object img-rounded" src="http://graph.facebook.com/#=from.id#/picture" alt="프로파일 이미지">
		    </a>
		    <div class="media-body">
		      <h5 class="media-heading">
		      <span class="label label-primary">#: type #</span>
		      #= from.name #  (#: ui.util.prettyDate(updatedTime) #) 
		      </h5>		     	
		     	#if ( typeof( message ) == 'string'  ) { #
		     	<p>
		     	#= message #
		     	</p>
		     	# } #				     	     	
		     	#if ( name !=null ) { #
		     	<p>#= name  #</p>
		     	# } #		     	     	
		     	#if ( type == 'LINK' ) { #
		     	<p>
		     	<a href="#= link #" target="_blank"><span class="glyphicon glyphicon-link"></span> #= link #</a>
		     	</p>
		     	# } else if ( type == 'PHOTO' ) { #
		     		<p>
		     		<img src="#: picture.replace("_s.", "_n.")  #" alt="media" class="img-rounded img-responsive">
		     		</p>
		     	# } else if ( type === 'VIDEO' ) { #
		     		#if ( source !=null && source.indexOf("www.youtube.com") > -1 ) { #
					<div class="flex-video">
						<iframe width="100%" heigh="auto" src="#= source #" frameborder="0" allowfullscreen></iframe>						
					</div>		     				     		
		     		# } #		     		
		     	# } else { #		     	
		     		#if ( picture !=null ) { #
		     		<br><img src="#: picture.replace("_s.", "_n.")  #" alt="media" class="img-rounded img-responsive">
		     		# } #		     		
		     		#if ( source !=null ) { #
		     		<p class="text-muted">source : <a href="#= source #" target="_blank"><span class="glyphicon glyphicon-link"></span> #= source #</a></p>
		     		# } #
		     	# } #		     	
		     	#if ( typeof( caption ) == 'string'  ) { #
		     	<blockquote>
		     	<p>#= caption #</p>
			     	#if ( typeof( description ) == 'string'  ) { #
			     	 <footer>
			     	 #= description #
			     	 </footer>
			     	# } #	
				</blockquote>
		     	# } #			     				     							
				#if ( comments.length > 0  ) { #
				<div class="panel-group" id="accordion-#= id #">
					<div class="panel panel-default borderless">
						<div class="panel-heading comments-heading">
							<a data-toggle="collapse" data-parent="\\#accordion-#= id #" href="\\##= id #">
								<h4 class="panel-title"><i class="fa fa-comment"></i>&nbsp;<small>댓글 보기 (#= comments.length  #)</small></h4>
							</a>
						</div>
						<div id="#= id #" class="panel-collapse collapse">
							<div class="panel-body">	
				# } #				
				# for (var i = 0; i < comments.length ; i++) { #					
				# var comment = comments[i] ; #							
					<div class="media">
						<a class="pull-left" href="\\#">
							<img class="media-object img-rounded" src="http://graph.facebook.com/#=comment.from.id#/picture" alt="프로파일 이미지">
						</a>	
						<div class="media-body">
							 <h6 class="media-heading">#: comment.from.name # &nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-thumbs-up"></span>#:comment.likesCount#</h6>
							 <p class="text-muted">#=comment.message#</p>
						</div>				
					</div>
				# } #
				#if ( comments.length > 0  ) { #
							</div>
						</div>
					</div>
				</div>
				# } #				
			</div>
		</li>					
		# } #  	
</script>		

<script type="text/x-kendo-tmpl" id="twitter-timeline-template">
		<li class="media">
		    <a class="pull-left" href="\\#">
		      <img src="#: user.profileImageUrl #" alt="#: user.name#" class="media-object img-circle">
		    </a>
		    <div class="media-body">
		      <h5 class="media-heading">
		      #if(retweet){# <small><i class="fa fa-retweet"></i>&nbsp; #: user.name # 님이 리트윗함 </small> #}#
		      	#= user.name # (#: ui.util.prettyDate(createdAt) #)
		      	</h5>
		     	<p>#= text #</p>		     	
				# for (var i = 0; i < entities.urls.length ; i++) { #
				# var url = entities.urls[i] ; #		
				<p><a href="#: url.expandedUrl  #" target="_blank"><span class="glyphicon glyphicon-link"></span> #: url.displayUrl #</a></p>
				# } #	
				<p>
					# for (var i = 0; i < entities.media.length ; i++) { #	
					# var media = entities.media[i] ; #					
					<img src="#: media.mediaUrl #" width="100%" alt="media" class="img-rounded">
					# } #
				</p>
				
				
				<p class="text-muted"><i class="fa fa-retweet"></i> #= retweetCount #
				#if (retweeted) {#					
				<div class="media">
					<a class="pull-left" href="\\#">
						<img src="#: retweetedStatus.user.profileImageUrl #" width="100%" alt="media" class="img-circle">
					</a>
					<div class="media-body">
						<h4 class="media-heading">#: retweetedStatus.user.name #</h4>
					</div>
				</div>						
				# } #
		    </div>
		  </li>					
</script>

<script type="text/x-kendo-tmpl" id="tumblr-dashboard-template">
		<li class="media">
			<a class="pull-left" href="\\#">		     
			<img src="http://222.122.63.146/community/show-tumblr-avatar.do?blogName=#: blogName#&blogAvatarSize=48" alt="#: blogName #" class="media-object img-rounded">
			</a>
			<div class="media-body">
				<h5 class="media-heading">#:blogName#</h5>
				<p>#:postUrl#</p>
				
				#if (type == 'PHOTO') {#	
					<div class="row marginless">
					# for (var i = 0; i < photos.length ; i++) { #	
					# var post_photo = photos[i] ; #
					# var post_photo_url = post_photo.sizes[0].url ; #	
					
					#if (photos.length == 1) {#
					<div class="col-xs-12 col-lg-12">	
						<figure>	
						<img src="#: post_photo_url  #" alt="media" class="img-responsive">
							<figcaption class="pull-right">							
								<button type="button" class="btn btn-primary custom-upload-by-url"  data-source="#:postUrl#" data-url="#: post_photo_url#"><i class="fa fa-cloud-upload"></i>&nbsp 내 사진으로 복사</button>
							</figcaption>		
						</figure>		
					</div>			
					#} else { #
					<div class="col-xs-12 col-lg-4 image-grid">	
						<img src="#: post_photo_url  #" alt="media">				
					</div>	
					# } #	
					# } #	
					</div>				
				# } #							
				<p>#= caption #</p>		
				<p class="text-muted"><i class="fa fa-comment-o"></i>&nbsp; #= noteCount# </p>
			</div>
		</li>	
</script>


<!-- ============================== -->
<!-- Top Nav Account Status Template               -->
<!-- ============================== -->
<script id="account-template" type="text/x-kendo-template">
<li class="dropdown">
		<a href="\\#" class="btn btn-img dropdown-toggle" data-toggle="dropdown">
		# if ( anonymous ) { # 
			<img src="${request.contextPath}/images/common/anonymous.png" height="34"/>	
		# }else{ # 
			<img src="${request.contextPath}/download/profile/#: username #?width=100&height=150" height="34">
		# } #
		
		<span class="caret"></span>
		</a>			
		<ul class="dropdown-menu">
			# if ( !anonymous ) { # 
			<li>
				<div class="blank-space-5">	
					<ul class="media-list">
						<li class="media">
							<a class="pull-left" href="\\#">
								<img class="media-object img-thumbnail" src="${request.contextPath}/download/profile/#: username #?width=100&height=150" />
							</a>
							<div class="media-body" style="color:ccc;">
								<p class="text-muted"><strong> #:name#</strong></p>
								<p class="text-muted"> #:email #</p>	
								<p><a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-primary btn-sm" data-toggle="modal" data-target="\\#myProfileModal" ><i class="fa fa-user"></i> 프로필 보기</a></p>		
								<!--						
								<ul class="nav nav-pills nav-stacked">
									<li class="active">
										<a href="\\#">
										<span class="badge pull-right">3</span>
										Home
										</a>
									</li>
									<li>
										<a href="\\#">
										<span class="badge pull-right">1</span>
										알림
										</a>
									</li>
									<li>
										<a href="\\#">
										<span class="badge pull-right">2</span>
										메시지
										</a>
									</li>																			
								</ul>
								-->
							</div>
						</li>
					</ul>
		
			</li>
			<li class="divider"></li>
			<!--<li><a href="/community/view-myprofile.do?view=modal-dialog" data-toggle="modal" data-target="\\#myModal" ><i class="fa fa-user"></i> 프로필 보기</a></li>-->			
			<li><a href="${request.contextPath}/main.do?view=personalized">마이 페이지</a></li>
			<li><a href="${request.contextPath}/main.do?view=streams">마이 스트림</a></li>
			#if ( isSystem ) {#
			<li><a href="/secure/main-site.do">시스템 관리</a></li>
			# } #
			<li class="divider"></li>
			<li><a href="/logout"><i class="fa fa-sign-out"></i> 로그아웃</a></li>
			# } else { # 						
			<li>
				<div class="container" style="width:100%;">
					<div class="row blank-top-5 ">
						<div class="col-lg-12">
							<button class="btn btn-block btn-primary btn-external-login-control-group" data-target="facebook"><i class="fa fa-facebook"></i> | 페이스북으로 로그인</button>
						</div>
					</div>		
					<div class="row blank-top-5 ">
						<div class="col-lg-12">
							<button class="btn btn-block btn-info btn-external-login-control-group" data-target="twitter"><i class="fa fa-twitter"></i> | 트위터로 로그인</button>
						</div>
					</div>					
				</div>
			</li>
			<li class="divider"></li>
			<li>
				<div class="container bg-white" id="login-navbar" style="width:100%;">													
					<div class="row blank-top-5 ">
						<div class="col-lg-12">
							<form role="form" name="login-form" method="POST" accept-charset="utf-8">
								<input type="hidden" id="output" name="output" value="json" />		
								<div class="form-group">
									<label for="login-username">아이디 또는 이메일</label>
									<input type="text" class="form-control col-lg-12" id="login-username" name="username" placeholder="아이디 또는 이메일" required validationMessage="아이디 또는 이메일을 입력하여 주세요.">
								</div>
								<div class="form-group">
									<label for="login-password">비밀번호</label>
										<input type="password" class="form-control " id="login-password" name="password"  placeholder="비밀번호"  required validationMessage="비밀번호를 입력하여 주세요." >
								</div>				 
								<button type="button" id="login-btn" class="btn btn-primary btn-block btn-internal-login-control-group" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-sign-in"></i> 로그인</button>
							</form>						
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12">
							<div class="login-form-message blank-top-5"/>
						</div>
					</div>	
				</div>
			</li>
			<li class="divider"></li>
			<li><a href="\\#">아이디/비밀번호찾기</a></li>
			<li><a href="${request.contextPath}/accounts/signup.do">회원가입</a></li>
			# } #
		</ul>
	</div>			
</li>				
</script>	

<!-- ============================== -->
<!-- Image Broswer Template                            -->
<!-- ============================== -->
<script id="image-broswer-template" type="text/x-kendo-template">
	<div class='modal editor-popup  fade' tabindex='-1' role='dialog' aria-labelledby=#:title_guid# aria-hidden='true'>
		<div class='modal-dialog modal-lg'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title' id=#: title_guid #>이미지 삽입</h5>
				</div>
				<div class='modal-body'>		
					<div class="row">
						<div class="col-sm-3">
							<!-- Nav tabs -->
							<ul class="nav nav-pills nav-stacked">
							  <li class="active"><a href="\\##=upload_guid#" data-toggle="tab">업로드</a></li>
							  <li><a href="\\##=my_guid#" data-toggle="tab">My 포토에서 선택</a></li>
							  <li><a href="\\##=website_guid#" data-toggle="tab">사이트 이미지에서 선택</a></li>
							  <li><a href="\\##=domain_guid#" data-toggle="tab">회사 이미지에서 선택</a></li>
							  <li><a href="\\##=url_guid#" data-toggle="tab">URL에서 선택</a></li>
							</ul>
						</div>
						<div class="col-sm-9">
							<!-- Tab panes -->
							<div class="tab-content">
								<div class="tab-pane fade  active" id=#:upload_guid#>
									<div class="page-header text-primary">
										<h5 ><strong>업로드</strong>&nbsp;<small>여러개의 파일을 한번에 업로드할 수 있습니다.</small></h5>
									</div>														  
								</div>
								<div class="tab-pane fade" id=#:my_guid#>
									<div class="page-header text-primary">
										<h5 ><strong>MY 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>
									</div>
									<div class="panel panel-default panel-flat">								
										<div class="panel-body scrollable" style="max-height:450px; min-height:360px;">											
											<div style="width:100%; padding:0px; border: 0px; min-height: 200px;"></div>
										</div>	
										<div class="panel-footer" style="padding:0px;">
											<div></div>
										</div>
									</div>																											  
								</div>
							  <div class="tab-pane fade" id=#:domain_guid#>
								<div class="page-header text-primary">
									<h5 ><strong>도메인 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>
								</div>		
								<div class="panel panel-default panel-flat">								
									<div class="panel-body scrollable" style="max-height:450px; min-height:360px;">											
										<div style="width:100%; padding:0px; border: 0px; min-height: 200px;"></div>
									</div>	
									<div class="panel-footer" style="padding:0px;">
										<div></div>
									</div>
								</div>														  
							  </div>
 							  <div class="tab-pane fade" id=#:website_guid#>
								<div class="page-header text-primary">
									<h5 ><strong>사이트 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>
								</div>		
								<div class="panel panel-default panel-flat">								
									<div class="panel-body scrollable" style="max-height:450px; min-height:360px;">											
										<div style="width:100%; padding:0px; border: 0px; min-height: 200px;"></div>
									</div>	
									<div class="panel-footer" style="padding:0px;">
										<div></div>
									</div>
								</div>														  
							  </div>							  
							  <div class="tab-pane fade" id=#:url_guid#>
								<div class="page-header text-primary">
									<h5 ><strong>URL 이미지</strong>&nbsp;<small>삽입할 이미지 URL 경로를 입력하세요.</small></h5>
								</div>
								<div class='form-group'>					
									<input type="url" name="custom-selected-url" class="form-control" placeholder="URL 입력">
								</div>								
								<img class="img-responsive hide" /> 				  
							  </div>
							</div>
						</div>
					</div>
				</div>
				<div class='modal-footer'>
					<button type="button" class="btn btn-primary custom-insert-img" disabled="disabled">이미지 삽입</button>	
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>취소</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>				

<script id="editor-popup-template" type="text/x-kendo-template">
	<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>
		<div class='modal-dialog modal-sm'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title'>#= title #</h5>
				</div>
				<div class='modal-body'>
				#if( type == 'createLink' ){ #
					<div class="form">
						<div class="form-group">
							<label class="control-label">표시할 텍스트</label>
							<input type="text" class="form-control" data-bind="value:linkTitle">
						</div>						
						
						<div class="form-group">	
							<label class="control-label">웹주소</label>
							<input type="url" class="form-control" placeholder="http://" data-bind="value:linkUrl">
						</div>
							
						<div class="form-group">
								<div class="checkbox">
								<label>
									<input type="checkbox" data-bind="checked:linkTarget" > 새창에서 링크 열기
								</label>
								</div>
						</div>
					</div>
				# } #
				</div>
				<div class='modal-footer'>		
					<button type="button" class="btn btn-primary custom-update" disabled="disabled">확인</button>	
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>취소</button>				
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>		
		