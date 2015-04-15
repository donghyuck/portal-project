
<!-- ============================== -->
<!-- Image Broswer Template                            -->
<!-- ============================== -->
<script id="image-broswer-template" type="text/x-kendo-template">
	<style type="text/css" media="screen">

		.image-broswer .image-listview .img-wrapper.k-state-selected:after , .file-broswer .file-listview .file-wrapper.k-state-selected:after  {
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
			content: "\\f093";
			font-size: 3em;
			position: absolute;
			font-weight: normal;
			display: inline-block;
			font-family: FontAwesome;
			color: \\#46b8da;
		}
			
		.image-broswer .image-selected{
			border-bottom: 1px solid \\#e5e5e5;
			padding: 5px;
			min-height:132px;
		}	

		.image-broswer .image-selected img{
			height:120px;
			width:120px;
			border: 1px solid \\#46b8da;
		}	
					
		.image-broswer .img-wrapper {
			float: left;
			position: relative;
			width: 120px;
			height: 120px;
			padding: 0;
			cursor: pointer;
			overflow: hidden;		
		}
		
		.image-broswer .img-wrapper img{
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
	</style>				
	<div class='modal editor-popup image-broswer fade'>
		<div class='modal-dialog modal-lg'>
			<div class='modal-content'>
				<div class='modal-header'>
					<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
					<h5 class='modal-title'>#if( title ){# #: title # #} else { # 이미지 삽입 #}#</h5>
				</div>
				<div class="modal-body no-padding">		
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
											<div class="panel-body image-selected"></div>	
											<div class="panel-body padding-sm" style="border-bottom: 1px solid \\#e5e5e5;">
												<p class="text-muted">
													<small><i class="fa fa-info"></i> 업로드 버튼을 클릭하여 여러개의 파일을 한번에 업로드할 수 있습니다.</small>		
												</p>
												<button type="button" class="btn btn-info btn-sm pull-right btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-upload"></i> &nbsp; 이미지 업로드</button>												
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
										<div class="panel-body image-selected"></div>
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
									<div class="panel-body image-selected"></div>													
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
									<div class="panel-body image-selected" ></div>							
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
				<img src="http://placehold.it/146x146&amp;text=[file]"></a>
			# } #	
				<div class="img-description">
					<h3>#:name#</h3>
					<p>#:formattedSize() # 바이트</p>
				</div>
	</div>
</script>					