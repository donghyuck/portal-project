
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