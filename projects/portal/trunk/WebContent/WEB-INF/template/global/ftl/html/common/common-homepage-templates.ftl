<script type="text/x-kendo-template" id="file-panel-template">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title"><i class="fa fa-cloud"></i> <span data-bind="text: name"></span></h3>
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
			<h3 class="panel-title"><i class="fa fa-cloud"></i> 포토</h3>
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
<!-- Top Nav Account Status Template               -->
<!-- ============================== -->
<script id="account-template" type="text/x-kendo-template">
	<li class="account">
		<a href="\\#my-aside-menu" class="btn btn-link btn-account dropdown-toggle navbar-toggle-aside-menu">
		# if ( anonymous ) { # 
			<img src="${request.contextPath}/images/common/anonymous.png" height="34"/>	
		# }else{ # 
			<img src="${request.contextPath}/download/profile/#: username #?width=100&height=150" class="rounded-top" height="34">
		# } #
		</a>
	</li>	
</script>	
<script id="account-sidebar-template" type="text/x-kendo-template">
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
			<div class="row">
				<div class="col-xs-6">
			<div class="side-section-nav">	
			<nav class="navbar navbar-default  navbar-inverse no-margin-b navbar-static-top">
				<ul class="nav navbar-nav">		
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
				 </div>
				<div class="col-xs-6">
					<h3 class="heading-xs">전체 사용량 <span class="pull-right">88%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%">
                                        </div>
                                    </div>

                                    <h3 class="heading-xs">메일 <span class="pull-right">76%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="76" aria-valuemin="0" aria-valuemax="100" style="width: 76%">
                                        </div>
                                    </div>

                                    <h3 class="heading-xs">파일<span class="pull-right">97%</span></h3>
                                    <div class="progress progress-u progress-xs">
                                        <div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="97" aria-valuemin="0" aria-valuemax="100" style="width: 97%">
                                        </div>
					</div>				
				 </div>			 
			</div>
		</div>
		# } # 		
	</section>
</script>	
		