
<!-- ============================== -->
<!-- Image Broswer Template         -->
<!-- ============================== -->
<script id="image-broswer-template" type="text/x-kendo-template">
	<style type="text/css" media="screen">
		.image-broswer .image-listview .img-wrapper.k-state-selected:after , 
		.file-broswer .file-listview .file-wrapper.k-state-selected:after  {
			top: 10px;
			right: 15px;
			content: "\\f00c";
			font-size: 2em;
			position: absolute;
			font-weight: normal;
			display: inline-block;
			font-family: FontAwesome;
			color: \\#fff;
		}
		.image-broswer .image-selected:after {
			top: 50px;
			right: 30px;
			content: "\\f03e";
			font-size: 3em;
			position: absolute;
			font-weight: normal;
			display: inline-block;
			font-family: FontAwesome;
			color: \\#6c9fd1;
		}
			
		.image-broswer .image-selected{
			border-bottom: 1px solid \\#e5e5e5;
			padding: 5px;
			min-height:132px;
		}	
								
		.image-broswer .image-selected img{
			height:120px;
			width:120px;
			border: 1px solid \\#fff;
			float: left;
		}	
		
		.image-broswer .image-selected .img-wrapper:hover {
			
		}
		
		.img-wrapper { 
			width: 120px;
			height: 120px;
			padding: 0;		 
		} 			
		
		.image-broswer .img-wrapper {
			float: left;
			position: relative;
			cursor: pointer;
			overflow: hidden;		
		}
		
		.img-wrapper img{
			width: 100%;
			height: 100%;
		}
				
		.image-broswer .img-wrapper .img-description {
			position: absolute;
			top: 0;
			width: 100%	;
			height: 0;
			overflow: hidden;
			background-color: rgba(0,0,0,0.8)
		}
	
		.image-broswer .img-wrapper h3
		{
			margin: 0;
            padding: 10px 10px 0 10px;
            line-height: 1.1em;
            font-size : 12px;
            font-weight: normal;
            color: \\#ffffff;
            word-wrap: break-word;
		}

		.image-broswer .img-wrapper p {
			color: \\#ffffff;
			font-weight: normal;
			padding: 0 10px;
			font-size: 12px;
		}		
		
		
		.image-broswer .k-listview:after, .attach dl:after {
			content: ".";
			display: block;
			height: 0;
			clear: both;
			visibility: hidden;
		}
		
		.image-broswer .k-pager-wrap {
			border : 0px;
			border-width: 0px;
			background : transparent;
		}
		
		.image-broswer .k-upload {
			border : 0;
		}
		.image-broswer .k-dropzone {
			min-height: 60px;
			border-top: solid 3px \\#6c9fd1;
			background-color: \\#eee;		
		}
		
		.mfp-bg {
			z-index : 2001;
		}
		.mfp-wrap {
			z-index : 2002;
		}
	</style>				
	<div class='modal editor-popup image-broswer fade'>
		<div class='modal-dialog modal-lg'>
			<div class='modal-content rounded'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'></button>
					<h5 class='modal-title'>#if( title ){# #: title # #} else { # 이미지 삽입 #}#</h5>
				</div>
				<div class="modal-body no-padding">		
					<!-- options -->
					<form id="#=guid[5]#" action="\\#" class="sky-form collapse" style="
						position: absolute;
						width:  300px;
						z-index: 400;
						top: -1px;
						left: 0;
						border-top:solid 3px \\#8e8e93;
					">
						<header>
							이미지 스타일 옵션
							<span class="btn-up btn-up-gray btn-md"></span>
						</header>
                    <fieldset>                  
                        <section>
                        	<div class="separator-2"/>
                            <label class="label">Template</label>
                            <label class="textarea textarea-expandable">
                                <textarea rows="3" name="image-custom-template"></textarea>
                            </label>
                            <div class="note"><strong>Note:</strong> 템플릿 설정의 주의가 필요합니다.</div>
                            <label class="label">Style</label>
                            <label class="textarea textarea-expandable">
                                <textarea rows="2" name="image-custom-css"></textarea>
                            </label>
                            <div class="note"><strong>Note:</strong> expands on focus.</div>                            
                        </section>
                    </fieldset>
                    <fieldset>
                        <section>
                            <label class="label">Effect</label>
                            <div class="inline-group">	
                                <label class="radio"><input type="radio" name="image-radio-effect" value="none" checked=""><i class="rounded-x"></i>None</label>
                                <label class="radio"><input type="radio" name="image-radio-effect" value="lightbox"><i class="rounded-x"></i>Lightbox</label>
                                <label class="radio"><input type="radio" name="image-radio-effect" value="carousel"><i class="rounded-x"></i>Carousel Slide</label>
                            </div>
                        </section>
                    </fieldset>       
                    <fieldset>
                        <section>
                            <label class="label">Effect Options</label>
                            <div class="inline-group">
                                <label class="checkbox"><input type="checkbox" name="image-checkbox-thumbnail"><i></i>Thumbnail</label>                                
                                <label class="checkbox"><input type="checkbox" name="image-checkbox-gallery"><i></i>Gallery</label>
                            </div>
                        </section>
						<section>
                            <label class="label">Size</label>
                            <div class="inline-group">
                                <label class="input col-sm-6">
                                    <input type="text" name="width" placeholder="Width"></label>
                                <label class="input col-sm-6">
                                    <input type="text" name="height" placeholder="Height"></label>
                                </label>
                            </div>
                        </section>
                    </fieldset>                                 
					</form>
					<!-- /.options -->				
					<div class="row no-margin-hr">
						<div class="col-sm-3 no-padding">
							<!-- Nav tabs -->
							<ul class="nav nav-pills nav-stacked">
								<li class="no-margin-t"><a href="\\##=guid[0]#" data-toggle="tab">업로드</a></li>
								<li class="no-margin-t"><a href="\\##=guid[1]#" data-toggle="tab">My 포토에서 선택</a></li>
								<li class="no-margin-t"><a href="\\##=guid[2]#" data-toggle="tab">My 사이트에서 선택</a></li>
								<li class="no-margin-t"><a href="\\##=guid[3]#" data-toggle="tab">My 회사에서 선택</a></li>
								<li class="no-margin-t"><a href="\\##=guid[4]#" data-toggle="tab">URL에서 선택</a></li>
							</ul>													
						</div>
						<div class="col-sm-9 padding-sm" style="border-left: 1px solid \\#e5e5e5; background:\\#f5f5f5; min-height:250px;">
							<!-- Tab panes -->
							<div class="tab-content">
								<div class="tab-pane fade  active" id=#:guid[0]#>
									<div class="text-primary">
										<h5 ><i class="fa fa-upload"></i> <strong>업로드</strong>&nbsp;<small> 삽입할 이미지를 선택하세요.</small></h5>
										<div class="panel panel-default">		
											<div class="panel-body image-selected scrollable"></div>	
											<div class="panel-body" style="border-bottom: 2px solid \\#e5e5e5;">
												<h4 class="text-muted">
													<i class="fa fa-info"></i> 아래의 파일 선택 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.
												</h4>
												<input name="uploadPhotos" id="#=guid[0]#-upload" type="file" />																									
											</div>											
											<div class="panel-body scrollable" style="max-height:450px; padding:5px;">
												<div class="image-listview" style="padding:0px; border: 0px; min-height: 360px;"></div>
											</div>	
											<div class="panel-footer" style="padding:0px;">
												<div  class="image-pager k-pager-wrap"></div>
											</div>
										</div>						
									</div>														  
								</div>
								<div class="tab-pane fade" id=#:guid[1]#>
									<h5 ><i class="fa fa-picture-o"></i> <strong>MY 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>
									<div class="panel panel-default no-margin-b rounded-top">								
										<div class="panel-body image-selected scrollable"></div>
										<div class="panel-body scrollable color4" style="max-height:450px;">
											<div class="image-listview" style="padding:0px; border: 0px; min-height: 360px;"></div>
										</div>	
										<div class="panel-footer" style="padding:0px;">
											<div class="image-pager k-pager-wrap"></div>
										</div>
									</div>																											  
								</div>
							  <div class="tab-pane fade" id=#:guid[2]#>
								<h5 ><i class="fa fa-picture-o"></i> <strong>사이트 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>
								<div class="panel panel-default no-margin-b rounded-top">			
									<div class="panel-body image-selected scrollable"></div>													
									<div class="panel-body scrollable color4" style="max-height:450px;">
										<div class="image-listview" style="padding:0px; border: 0px; min-height: 360px;"></div>
									</div>	
									<div class="panel-footer" style="padding:0px;">
										<div class="image-pager k-pager-wrap"></div>
									</div>
								</div>														  
							  </div>
 							  <div class="tab-pane fade" id=#:guid[3]#>
								<h5 ><i class="fa fa-picture-o"></i> <strong>회사 이미지</strong>&nbsp;<small>삽입할 이미지를 선택하세요.</small></h5>	
								<div class="panel panel-default no-margin-b rounded-top">								
									<div class="panel-body image-selected scrollable" ></div>							
									<div class="panel-body scrollable color4" style="max-height:450px;">
										<div class="image-listview" style="padding:0px; border: 0px; min-height: 360px;"></div>
									</div>	
									<div class="panel-footer" style="padding:0px;">
										<div  class="image-pager k-pager-wrap"></div>
									</div>
								</div>														  
							  </div>							  
							  <div class="tab-pane fade" id=#:guid[4]#>
								<h5 ><i class="fa fa-link"></i> <strong>URL 이미지</strong>&nbsp;<small>삽입할 이미지 URL 경로를 입력하세요.</small></h5>
								<div class='form-group'>					
									<input type="url" name="custom-selected-url" class="form-control" placeholder="URL 입력">
								</div>								
								<img class="img-responsive hide" /> 				  
							  </div>
							</div>
						</div>
					</div>
				</div>
				<div class='modal-footer no-margin-t'>
					<button class="btn btn-warning btn-flat btn-outline rounded" type="button" data-toggle="collapse" data-target="\\##=guid[5]#" aria-expanded="false" aria-controls="#=guid[5]#"><i class="fa fa-cog"></i> 이미지 스타일 설정</button>
					<button type="button" class="btn btn-primary custom-insert-img" disabled="disabled">선택된 이미지 삽입</button>	
					<button type="button" class="btn btn-default" data-dismiss='modal' aria-hidden='true'>취소</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</script>				

<script id="link-popup-template" type="text/x-kendo-template">
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

	<script id="code-editor-modal-template" type="text/x-kendo-template">
	<style type="text/css" media="screen">
		\\#modal-htmleditor { 
			height: 600px;
			border: 0px solid \\#ddd;
		}		
	</style>			
		<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>
			<div class='modal-dialog' style="width:90%;">
				<div class='modal-content'>
					<div class='modal-header'>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
						<h5 class='modal-title'>#= title #</h5>
					</div>
					<div class='modal-body' style="padding:0px;">					
						<div id="modal-htmleditor"></div>									
					</div>
					<div class='modal-footer' style="margin-top: 0px;">
						<button type="button" class="btn btn-primary btn-sm custom-update" data-bind="events:{ click: onSave }" >확인</button>		
						<button type="button" class="btn btn-default  btn-sm" data-dismiss='modal' aria-hidden='true'>취소</button>						
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->				
	</script>
	
<script type="text/x-kendo-tmpl" id="image-broswer-photo-list-view-template">
	<div class="img-wrapper">			
			#if (contentType.match("^image") ) {#
				<img src="<@spring.url '/download/image/#=imageId#/#=name#?width=150&height=150'/>" alt="#:name# 이미지" />
			# } else { #			
				<img src="http://placehold.it/146x146&amp;text=[file]" />
			# } #	
				<div class="img-description">
					<h3>#:name#</h3>
					<p>#:formattedSize() # 바이트</p>
				</div>
	</div>
</script>			

<script type="text/x-kendo-tmpl" id="image-broswer-photo-carousel-inner-template">	
	<div class="item #if(active){# active #}#">
		<img src="#=url#" alt="..."/>
		<div class="carousel-caption"></div>
	</div>
</script>
<script type="text/x-kendo-tmpl" id="image-broswer-photo-carousel-indicators-template">	
	<li data-target="\\##=uid#" data-slide-to="#= index #" class="#if(active){# active #}#">
		#if(thumbnail){#
		<img src="#=thumbnailUrl #" alt="..."/>
		#}#
	</li>
</script>
<script type="text/x-kendo-tmpl" id="image-broswer-photo-carousel-template">	
<div class="carousel-v1">
<div id="#=uid#" class="carousel slide" data-ride="carousel" style="#if(width){# max-width: #= width #; #}#">
	<div class="carousel-inner" role="listbox">
	</div>	
	<ol class="carousel-indicators">
	</ol>	  
	<a class="left carousel-control" href="\\##=uid#" role="button" data-slide="prev">
	    <span class="btn-flat-icon left" aria-hidden="true"></span>
	    <span class="sr-only">Previous</span>
	  </a>
	  <a class="right carousel-control" href="\\##=uid#" role="button" data-slide="next">
	    <span class="btn-flat-icon right" aria-hidden="true"></span>
	    <span class="sr-only">Next</span>
	  </a>	
</div>
</div>	
</script>

<script type="text/x-kendo-tmpl" id="image-broswer-photo-masonry-template">	
<div id="#=uid#" data-image-layout="masonry">

</div>
</script>

<script type="text/x-kendo-tmpl" id="image-broswer-photo-masonry-item-template">	
	<div class="item">
		<img src="#=imageUrl#" alt="..."/>
	</div>
</script>

	