
<script type="text/x-kendo-template" id="photo-view-template">	
	<figure class="effect-marley">
		<img src="${request.contextPath}/community/download-my-image.do?imageId=#:imageId#" alt="#:name# 이미지">
		<figcaption>
			<h2>#: name # <span></span></h2>
			<p>#: formattedModifiedDate #</p>
			<a href="\\#">View more</a>
		</figcaption>			
	</figure>
	<!--			
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
	-->		
</script>
<script id="photo-editor-modal-template" type="text/x-kendo-template">
	<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>
		<div class='modal-dialog'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title'>포토 수정</h5>
				</div>
				<div class='modal-body'>
				
				</div>
				<div class='modal-footer'>		
					<button type="button" class="btn btn-primary custom-update" disabled="disabled">확인</button>	
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>취소</button>				
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>	