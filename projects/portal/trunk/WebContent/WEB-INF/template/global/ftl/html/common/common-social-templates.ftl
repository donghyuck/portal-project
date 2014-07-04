<script id="media-editor-modal-template" type="text/x-kendo-template">
	<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
		<div class='modal-dialog'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title' data-bind="text: media.serviceProviderName">쇼셜연결 수정</h5>
				</div>
				<div class='modal-body'>					
					<div class="page-header no-margin-t">
						<h4 class="text-primary"><i class="fa fa-arrows-v"></i> <strong>스크롤</strong>&nbsp;<small>스크롤을 OFF 하면 스크롤 기능이 비활성됩니다.</small></h4>
					</div>
					<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-primary btn-xs">
								<input type="radio" name="options-scrollable" value="1" data-bind="checked: scrollable">ON
							</label>
							<label class="btn btn-primary btn-xs">
								<input type="radio" name="options-scrollable" value="0" data-bind="checked: scrollable">OFF
							</label>
					</div>																										
					<div class="page-header">
						<h4 class="text-primary"><i class="fa fa-bars"></i> <strong>속성</strong> <small>수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</small></h4>
					</div>
					<div class="media-props-grid" style="min-height: 300px"></div>																
				</div>
				<div class='modal-footer'>		
					<!--<button type="button" class="btn btn-primary custom-update" disabled="disabled">확인</button>	-->
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>확인</button>				
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>	
<!-- ============================== -->
<!-- my socialnetwork view panel template          -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="social-view-panel-template">
	<div class="custom-panels-group" style="display:none;"> 
		<div id="#: serviceProviderName #-panel-#:socialAccountId#" class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">
					<i class="fa fa-#: serviceProviderName # fa-fw"></i> #: serviceProviderName # 소식		
				</h3>						
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
