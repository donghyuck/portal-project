		<script id="account-template" type="text/x-kendo-template">
			<a id="account-button" data-dropdown="account-dropdown" href="\\#">
				<span class="avatar-container">				
					#if (photoUrl != null && photoUrl != 'null' && photoUrl != '')  { #
					<span class="avatar-wrapper loaded"><img src="#:photoUrl#" /></span>
					# } else { #
					<span class="avatar-wrapper"><img class="loading"></span>
					# } #
				</span>
				<i></i>
			</a>
			<nav id="account-dropdown" data-dropdown-content >											
				<ul>
					<li class="text">이름 : #:name #</li>
					<li class="text">메일 : #:email #</li>
					<li class="video"><a href="\\#/welcome"><span class="icon"></span>Video Tour</a></li>
					<li class="settings"><a href="\\#"><span class="icon"></span>계정설정</a></li>
					<li class="logout"><a href="/logout"><span class="icon"></span>로그아웃</a></li>
					<li class="shutdown"><a href="\\#"><span class="icon"></span>Shutdown…</a></li>
				</ul>
			</nav>		
		</script>
		
		<script id="image-details-template" type="text/x-kendo-template">	
			<img id="image-preview" src="${request.contextPath}/secure/view-image.do?imageId=#=imageId#" class="img-thumbnail">
		</script>

		<script id="attach-details-template" type="text/x-kendo-template">	
			<a href="${request.contextPath}/secure/download-attachment.do?attachmentId=#= attachmentId #" class="btn btn-warning">다운로드</a>
		</script>
				        
		<script id="topbar-template" type="text/x-kendo-template">
			<div class="navbar navbar-inverse navbar-fixed-top " role="navigation">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="\\#">관리자 콘솔</a>
				</div>
				<form role="navigation" name="navbar-form" method="POST" accept-charset="utf-8">
					<input type="hidden" id="output" name="output" value="html" />
					<input type="hidden" id="companyId" name="companyId" value="${action.companyId}" />
				</form>			
				<div class="navbar-form navbar-left">
					<div class="form-group">
						<div id="companyDropDownList"></div>
					</div>					
				</div>			
				<div class="collapse navbar-collapse navbar-ex1-collapse">					
					<ul class="nav navbar-nav">
					# for (var i = 0; i < data.length; i++) { #
						# var item =data[i] ; #
						#if ( item.components.length > 0) { #	
						<li class="dropdown">
							<a href="\\#" class="dropdown-toggle" data-toggle="dropdown">#= item.title # <b class="caret"></b></a>
							<ul class="dropdown-menu">
							# for ( var j = 0 ; j <item.components.length ; j ++ ) { #
								# var sub_item =item.components[j] ; #
								<li><a href="\\#" #if (sub_item.page != 'null' && sub_item.page != '')  { # action="#=sub_item.page#" description="#=sub_item.description#" # } # >#= sub_item.title #</a></li>
							# } #
							</ul>							
						</li>
						# } else { #	
						<li><a href="\\#">#= item.title #</a></li>
						# } #
					# } #
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="${request.contextPath}/main.do"><i class="fa fa-home"></i> 사용자 홈</a></li>
						<li class="dropdown">
							<a href="\\#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> ${action.user.name} <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="\\#">Action</a></li>
								<li><a href="\\#">Another action</a></li>
								<li><a href="\\#">Something else here</a></li>
								<li><a href="${request.contextPath}/logout"><i class="fa fa-sign-out"></i> 로그아웃</a></li>
							</ul>
						</li>
						<li>
							<p class="navbar-text"></p>
						</li>
					</ul>					
				</div>
			</div>
		</script>	
	    
	    <script id="top-menu-template" type="text/x-kendo-template">	    
			<div class="panel panel-default">
				<div class="panel-heading">
				회사
				</div>
				<div class="panel-body blank-top-5">		
					<input id="companyList" style="width:100%" value="${action.company.companyId}" />	
					<div class="row blank-top-5 layout">
						<div class="col-lg-12">
							<a class="btn btn-success btn-block" href="${request.contextPath}/main.do">사용자화면 바로가기</a>
						</div>
					</div>
				</div>
			</div>			
			<ul id="top-menu">
		    	# for (var i = 0; i < data.length; i++) { #
		    	# var item =data[i] ; #
		    	<li>#= item.title #
			    	#if ( item.components.length > 0) { #	    			      	
			    	<ul>
			    	# for ( var j = 0 ; j <item.components.length ; j ++ ) { #
			    	# var sub_item =item.components[j] ; #
			    		#if (sub_item.page != 'null' && sub_item.page != '')  { #<li action="#=sub_item.page#" description="#=sub_item.description#" ># } else { #<li># } # 
						#= sub_item.title #
			    		#if ( sub_item.components.length > 0) { #	
			    			<ul>
			      	 		# for ( var k = 0 ; k <sub_item.components.length ; k ++ ) { #	 	
			      	 		# var sub_sub_item =sub_item.components[k] ; #
			      	 			#if (sub_sub_item.page != 'null' && sub_sub_item.page != '')  { #<li action="#=sub_sub_item.page#" description="#=sub_sub_item.description#" ># } else { #<li># } #
			      	 			#= sub_sub_item.title #</li>
			      	 		# } #
			    			</ul>	
			    		# } #
			    		</li>
			    	# } #	
			    	</ul>		
			      	# } #
		        </li>
		        # } #
		    </ul>    
			
	    </script>		
	    
	<script type="text/x-kendo-template" id="file-preview-template">
		<div class="blank-top-5"></div>
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