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
			<i class="fa fa-cloud"></i>&nbsp;포토
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
			<button type="button" class="close" aria-hidden="true"><i class="fa fa-times fa-2x"></i></button>
			<h4 data-bind="html:subject"></h4>
			<small class="text-muted"><span class="label label-info label-lightweight">게시 기간</span> #: formattedStartDate() # ~  #: formattedEndDate() #</small>					
		</div>
		<div class="panel-body" data-bind="html:body"></div>	
	</div>
</script>
<!-- ============================== -->
<!-- announce viewer template                          -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="announcement-viewer-template">		
	<div class="page-heading">
		<h4 data-bind="html:announce.subject"></h4>		
		<hr class="devider">
		<span class="label label-primary label-lightweight">게시 기간</span> <small class="text-primary"><span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></small>
		<p class="text-muted">
			<span class="label label-default label-lightweight">생성일</span> <small><span data-bind="text: announce.formattedCreationDate"></span> </small>
			<span class="label label-default label-lightweight">수정일</span> <small><span data-bind="text: announce.formattedModifiedDate"></span> </small>
		</p>
	</div>													
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
	<div class="margin-bottom-20"><hr class="devider"></div>
	<div data-bind="html: announce.body " />
</script>

<script type="text/x-kendo-tmpl" id="announcement-view-template">		
	<div class="page-heading">
		<h4 data-bind="html:subject"></h4>		
		<hr class="devider">
		<span class="label label-primary label-lightweight">게시 기간</span> <small class="text-primary"><span data-bind="text: formattedStartDate"></span> ~ <span data-bind="text: formattedEndDate"></span></small>
		<p class="text-muted">
			<span class="label label-default label-lightweight">생성일</span> <small><span data-bind="text: formattedCreationDate"></span> </small>
			<span class="label label-default ">수정일</span> <small><span data-bind="text: formattedModifiedDate"></span> </small>
		</p>
	</div>													
	<div class="media">
		<a class="pull-left" href="\\#">
			<img src="${request.contextPath}/download/profile/#: user.photoUrl #?width=150&height=150" width="30" height="30" class="img-rounded">
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
	<div class="margin-bottom-20"><hr class="devider"></div>
	<div data-bind="html: body " />
	<div class="margin-bottom-20"></div>
	<div class="btn-group pull-right">
		<button  type="button" class="btn btn-info btn-sm custom-list "><i class="fa fa-angle-double-up"></i> 목록</button>		
	</div>
</script>

<script type="text/x-kendo-tmpl" id="announcement-template">
	<tr class="announce-item" onclick="viewAnnounce(#: announceId#);">
		<th>#: announceId#</th>
		<td>#: subject#</td>
	</tr>
</script>



<!-- ============================== -->
<!-- news viewer template                          -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="news-viewer-template">		
	<div class="page-heading">
		<h4 data-bind="html:news.subject"></h4>		
	</div>													
	<div class="media">
		<a class="pull-left" href="\\#">
			<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">																	
				<p><span data-bind="visible:news.user.nameVisible, text: news.user.name"></span> <code data-bind="text: news.user.username"></code></p>
				<p data-bind="visible:news.user.emailVisible, text: news.user.email"></p>
			</h5>		
		</div>
		<div data-bind="html: news.content " />
	</div>	
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
		     		#if ( picture !=null ) { #
		     		<p><img src="#: picture.replace("_s.", "_n.")  #" alt="media" class="img-rounded img-responsive"></p>
		     		# } #		     		
		     		#if ( source !=null ) { #
		     		<p><a href="#= source #" target="_blank" class="btn btn-info btn-sm"><i class="fa fa-film"></i> 동영상 보기</a></p>
		     		# } #       	
		     	# } else { #		     	
		     		#if ( picture !=null ) { #
		     		<p><img src="#: picture.replace("_s.", "_n.")  #" alt="media" class="img-rounded img-responsive"></p>
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
				<p><a href="#: url.expandedUrl  #" target="_blank"><i class="fa fa-link"></i> #: url.displayUrl #</a></p>
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
				<h5 class="media-heading">
				<span class="label label-info">#: type #</span> 
				#:blogName#
				#if( sourceTitle != null && sourceUrl != null){ #
				<a href="#: sourceUrl #" target="_blank"><i class="fa fa-retweet"></i>  #: sourceTitle #</a>
				#}#
				</h5>
				<p>#:postUrl#</p>
				# if (type == 'TEXT') {#
					# if ( body != null ) { #						
					<p>#= body #</p>
					# } #						
				#} if (type == 'LINK') {#
					# if ( description != null ) { #						
					<p>#= description #</p>
					# } #	
					<!--<p><a href="#: url #" target="_blank"><i class="fa fa-link"></i></a></p>	-->				
				#} else if (type == 'PHOTO') {#	
					<div class="row">				
					# for (var i = 0; i < photos.length ; i++) { #	
					# var post_photo = photos[i] ; #
					# var post_photo_url = post_photo.sizes[0].url ; #
					#if (photos.length == 1) {#
					<div class="col-xs-12 col-lg-12">	
						<figure>	
						<img src="#: post_photo_url  #" alt="media" class="img-responsive">
							<figcaption>							
								<button type="button" class="btn btn-primary btn-sm custom-upload-by-url"  data-source="#:postUrl#" data-url="#: post_photo_url#" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-cloud-upload"></i>&nbsp 내 사진으로 복사</button>
							</figcaption>		
						</figure>		
					</div>			
					#} else { #					
					<div class="col-xs-12 col-lg-4" style="padding:2px;">	
						<figure>	
						<img src="#: post_photo_url  #" alt="media" class="img-responsive">
							<figcaption>							
								<button type="button" class="btn btn-primary btn-sm custom-upload-by-url pull-right"  data-source="#:postUrl#" data-url="#: post_photo_url#" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-cloud-upload"></i></button>
							</figcaption>		
						</figure>			
					</div>	
					# } #						
					# } #														
					</div>				
				# } #	
				# if ( caption != null ) { #						
				<p>#= caption #</p>
				# } #		
				<p class="text-muted"><i class="fa fa-comment-o"></i>&nbsp; #= noteCount# </p>
			</div>
		</li>	
</script>


<!-- ============================== -->
<!-- Top Nav Account Status Template               -->
<!-- ============================== -->
<script id="account-template" type="text/x-kendo-template">
	<li class="account">
		<a href="\\#my-aside-menu" class="btn btn-link btn-account dropdown-toggle navbar-toggle-aside-menu">
		# if ( anonymous ) { # 
			<img src="${request.contextPath}/images/common/anonymous.png" height="34"/>	
		# }else{ # 
			<span class="badge badge-blue rounded-2x pull-right">3</span>
			<img src="${request.contextPath}/download/profile/#: username #?width=100&height=150" height="34">
		# } #
		</a>
	</li>		
	<section id="my-aside-menu" class="aside-menu">	
		<button type="button" class="btn-close">Close</button>		
		<h5 class="side-section-title">Optional sidebar menu</h5>		
		# if ( !anonymous ) { # 	
		<div class="account-content" >		
			<img class="img-profile img-rounded" src="${request.contextPath}/download/profile/#: username #?width=100&height=150" />
			<div class="margin-bottom-10">		
			</div>
			<ul class="list-unstyled who margin-bottom-30">
				<li><a href="\\#"><i class="fa fa-user"></i>#:name#</a></li>
				<li><a href="\\#"><i class="fa fa-envelope"></i>#:email #</a></li>
				<li><a href="\\#"><i class="fa fa-building"></i>#:company.displayName #</a></li>
				<!--
				<li><a href="\\#"><i class="fa fa-phone"></i></a></li>
				<li><a href="\\#"><i class="fa fa-globe"></i></a></li>			
				-->
			</ul>		
			<div class="btn-group btn-group-sm">
				<a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-primary" data-toggle="modal" data-target="\\#myProfileModal" ><i class="fa fa-user"></i> 프로필 보기</a>
				#if ( isSystem ) {#
				<a href="/secure/main.do" class="btn btn-primary"><i class="fafa-sign-out"></i> 시스템 관리</a>
				# } #			
			</div>
			<a href="/logout" class="btn btn-danger btn-sm pull-right"><i class="fafa-sign-out"></i> 로그아웃</a>
		</div>
		<h5 class="side-section-title">MY CLOUD MENU</h5>
		<div class="account-content" >
			<div class="header">	
			<nav class="navbar navbar-default">
				<ul class="nav navbar-nav navbar-left">		
					<li class="dropdown">
						<a href="\\#" class="dropdown-toggle" data-toggle="dropdown">My <i class="fa fa-cloud fa-lg"></i></a>
						<ul class="dropdown-menu">
							<li><a href="/main.do?view=personalized">My 페이지</a></li>
							<li><a href="/main.do?view=streams">My 스트림</a></li>
							<li><a href="/main.do?view=manage">My 웹사이트</a></li>					
						</ul>
					</li>
				</ul>		 
			</nav>
			</div>

<div class="col-md-6">
                                    <h3 class="heading-xs">Web Design <span class="pull-right">88%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%">
                                        </div>
                                    </div>

                                    <h3 class="heading-xs">PHP/WordPress <span class="pull-right">76%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="76" aria-valuemin="0" aria-valuemax="100" style="width: 76%">
                                        </div>
                                    </div>

                                    <h3 class="heading-xs">HTML/CSS <span class="pull-right">97%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="97" aria-valuemin="0" aria-valuemax="100" style="width: 97%">
                                        </div>
                                    </div>
                                </div>
                                
			
		</div>
		# } # 		
	</section>		
</script>	

<script id="account-template2" type="text/x-kendo-template">
<li class="account">
	<a href="javascript:void(0);" class="btn btn-link btn-account dropdown-toggle" data-toggle="dropdown">
	# if ( anonymous ) { # 
		<img src="${request.contextPath}/images/common/anonymous.png" height="34"/>	
	# }else{ # 
		<span class="badge badge-blue rounded-2x pull-right">3</span>
		<img src="${request.contextPath}/download/profile/#: username #?width=100&height=150" height="34">
	# } #
	</a>			
	<div class="account-content" >
		# if ( !anonymous ) { # 
		<div class="alert alert-danger fade in">
			<i class="fa fa-warning"></i> <strong>Oh snap!</strong> Change a few things up and try submitting again.
		</div>			
		<img class="img-profile img-thumbnail" src="${request.contextPath}/download/profile/#: username #?width=100&height=150" />
		<div class="overflow-h">
			<span class="font-s">#:name# (#:email #)</span>
			<p class="color-green">소속: <span class="hex"> #= company.displayName #</span></p>	
			<a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-primary btn-sm" data-toggle="modal" data-target="\\#myProfileModal" ><i class="fa fa-user"></i> 프로필 보기</a>
		</div>
		<hr>
		<ul class="list-unstyled save-job">
			<li><a href="${request.contextPath}/main.do?view=personalized" class="btn-link">마이 페이지</a></li>
			#if ( isSystem ) {#
			<li><a href="/secure/main.do" class="btn-link">시스템 관리</a></li>
			# } #			
			<li><a href="/logout"><i class="fa fa-sign-out" class="btn-link"></i> 로그아웃</a></li>
		</ul>		
		# }else{ # 
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
	</div>
</li>				
</script>	
		