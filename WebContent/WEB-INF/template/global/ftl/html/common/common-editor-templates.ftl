
<!-- ============================== -->
<!-- Image Broswer Template                            -->
<!-- ============================== -->
<script id="image-broswer-template" type="text/x-kendo-template">
	<style type="text/css" media="screen">
		.image-broswer .img-wrapper.k-state-selected img {
			border-bottom: 5px solid \\#FF2A68;
			-webkit-transition: all .2s ease-in-out;
			transition: all .2s ease-in-out;
			position: relative;
			margin-top: -5px;
		}

		.img-wrapper {
			float: left;
			position: relative;
			width: 32.99%;
			height: 170px;
			padding: 0;
			cursor: pointer;
			overflow: hidden;		
		}
		
		.img-wrapper img{
			width: 100%;
			height: 100%;
		}
				
		.img-description {
			position: absolute;
			top: 0;
			width: 100%	;
			height: 0;
			overflow: hidden;
			background-color: rgba(0,0,0,0.8)
		}
	
		.img-wrapper h3
		{
			margin: 0;
            padding: 10px 10px 0 10px;
            line-height: 1.1em;
            font-size : 12px;
            font-weight: normal;
            color: \\#ffffff;
            word-wrap: break-word;
		}

		.img-wrapper p {
			color: \\#ffffff;
			font-weight: normal;
			padding: 0 10px;
			font-size: 12px;
		}		
		
		
		.k-listview:after, .attach dl:after {
			content: ".";
			display: block;
			height: 0;
			clear: both;
			visibility: hidden;
		}
		
		.k-pager-wrap {
			border : 0px;
			border-width: 0px;
			background : transparent;
		}

	</style>				
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
								</small>									
							</h5>
						</div>			
						<div id="htmleditor"></div>									
					</div>
					<div class='modal-footer' style="margin-top: 0px;">
						<button type="button" class="btn btn-primary btn-sm custom-update" data-bind="events:{ click: onSave }" >확인</button>		
						<button type="button" class="btn btn-default  btn-sm" data-dismiss='modal' aria-hidden='true'>취소</button>						
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->				
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