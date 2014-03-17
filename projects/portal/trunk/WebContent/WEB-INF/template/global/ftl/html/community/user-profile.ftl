<#ftl encoding="UTF-8"/>
<html decorator="none">
	<body>
		<script type="text/javascript">
		<!--
		
		 	alert( 
		 		kendo.stringify( $("#account-panel").data("currentUser") ) 
		 	);
			$("#my-profile-dialog a").each(function( index ) {
				var dialog_action = $(this);		
				dialog_action.click(function (e) {
					e.preventDefault();		
					alert( $(this).html() );
				});
			});			
		-->
		</script>
			
		<div id="my-profile-dialog" class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">내정보</h4>
				</div>
				<div class="modal-body">
					<div class="media">
						<a class="pull-left" href="#">
							<#if user.properties.imageId??>
							<img class="media-object img-thumbnail" src="PHOTO_URL = "/accounts/view-image.do?width=100&height=150&imageId=${user.properties.imageId}"," />
							<#else> 
							<img class="media-object img-thumbnail" src="http://placehold.it/100x150&amp;text=[No Photo]" />
							</#if>  
						</a>
						<div class="media-body">
							<h4 class="media-heading">${ user.username }</h4>							
							<form class="form-horizontal" role="form">
								<fieldset disabled>
									<div class="form-group">
										<label class="col-sm-2 control-label">아이디</label>
										<div class="col-sm-10">
											<h5 data-bind="text:name" >${ user.name }</h5>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">이름</label>
										<div class="col-sm-10">
											<input type="email" class="form-control" placeholder="이름" data-bind="value:name" value="${ user.name }"/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">메일</label>
										<div class="col-sm-10">
											<input type="email" class="form-control" placeholder="메일" data-bind="value:email" value="${ user.email }"/>
										</div>
									</div>
									<div class="form-group">
										<div class="col-sm-offset-2 col-sm-10">
											<label class="checkbox-inline">
												<input type="checkbox" data-bind="checked: nameVisible" <#if user.nameVisible >checked="checked"</#if>> 이름 공걔
											</label>
											<label class="checkbox-inline">
												<input type="checkbox" data-bind="checked: emailVisible" <#if user.emailVisible >checked="checked"</#if>> 메일 공개
											</label>
										</div>
									</div>
									<div class="form-group">
										<div class="col-sm-offset-2 col-sm-10 pull-right">
											<button type="submit" class="btn btn-primary">비밀번호 변경</button>
										</div>
									</div>
								</fieldset>
							</form>								
						</div>
					</div>
					<div>
						<!-- Nav tabs -->
						<ul class="nav nav-tabs" id="my-profile-tab">
							<li class="active"><a href="#home" data-toggle="tab">Home</a></li>
							<li><a href="#profile" data-toggle="tab">Profile</a></li>
						</ul>
						<!-- Tab panes -->
						<div class="tab-content">
							<div class="tab-pane active" id="home">
							<#list roles as item >								
								<span class="label label-primary">${item}</span>						
							</#list>
							</div>
							<div class="tab-pane" id="profile">...</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->				
	</body> 
</html>