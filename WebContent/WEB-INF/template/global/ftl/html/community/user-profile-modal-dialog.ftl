<#ftl encoding="UTF-8"/>
<#assign user = action.user />			
<html decorator="none">
	<body>
		<script type="text/javascript">
		<!--
						
			var myProfileModel = new kendo.data.ObservableObject({
				user : common.ui.accounts().token,
				click: function(e){
					var btn = $(e.target),
					action = btn.data("action");
					switch (action) {
						case "basic-modify-mode" :
							common.ui.status( $("button[data-action='basic-modify-mode']") , "disable" );
							$("#my-profile-basic-cfg .dl-horizontal").fadeOut("fast", function(e){
								$("#my-profile-basic-cfg .panel").fadeIn();
							});							
							break;			
						case "basic-modify-mode-close" :
							common.ui.status( $("button[data-action='basic-modify-mode']"), "enable");
							$("#my-profile-basic-cfg .panel").fadeOut("fast", function(e){
								$("#my-profile-basic-cfg .dl-horizontal").fadeIn();
							});
							break;	
					}
					return false;
				}		
			});
			
			kendo.bind( $("#my-profile-dialog" ), myProfileModel );
			
			if(!$("#my-photo-upload").data("kendoUpload")){
				$("#my-photo-upload").kendoUpload({
					multiple : false,
					showFileList : false,
					localization:{ select : '사진 선택' , dropFilesHere : '업로드할 이미지를 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '<@spring.url "/community/update-my-photo.do?output=json"/>',							   
						autoUpload: true
					},
					upload: function (e) {
					
					},
					success : function(e) {								    
						if( e.response.photo ){
							var _currentUser = $("#account-panel").data("currentUser" );
							$('#my-photo-image').attr( 'src', common.api.user.photoUrl( currentUser, 100, 150 ) );
						}				
					}	
				});
			}

			$('#my-profile-tab a').click(function (e) {
				$this = $(this);				
				var pane = $this.attr("href");
				switch (pane) {
					case "#my-profile-basic-cfg" :					
						break;
					case "#my-profile-social-cfg" :
						if( !$("#my-profile-social-grid" ).data('kendoGrid') ){
							$("#my-profile-social-grid" ).kendoGrid({
								dataSource : common.ui.datasource(
									"<@spring.url "/connect/list.json"/>",
									{
										schema:{
											data:"connections"
										}
									}
								),
								selectable: "single",
								rowTemplate: kendo.template($("#my-profile-social-connection-grid-row-template").html()),	
								change: function(e) { 				
									var selectedCells = this.select();
									if( selectedCells.length == 1){
										var selectedCell = this.dataItem( selectedCells );	 						
										common.ui.ajax(
											"<@spring.url "/connect/"/>" + selectedCell.providerId + "/user/lookup.json",
											{
												success : function(response){
													var temp = kendo.template($('#my-social-account-details-template').html());	
													$.extend( response , { providerId : selectedCell.providerId } ); 
													$("#my-profile-social-details").html( temp( response ) );	
												},
												beforeSend : function(){
													kendo.ui.progress($("#my-profile-social-details"), true);			
												},
												complete : function(){
													kendo.ui.progress($("#my-profile-social-details"), false);			
												}
											}
										);										
									}
								}
							});
						}							
						break;	
				}
			});
			
			$('#my-profile-tab a:first').tab('show')
			
			// Popup window code
			function goSocialPopup(socialnetwork) {
				var target_url = "http://${ServletUtils.getLocalHostAddr()}/community/connect-socialnetwork.do?media=" + socialnetwork.serviceProviderName + "&domainName=" + document.domain + "&socialNetworkId=" + socialnetwork.socialAccountId ; 
				window.open( 
					target_url,
					'popUpWindow', 
					'height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes');					
			}
			
			function handleSocialCallbackResult( media, onetime, success ){
				if( success ){				
					if( $("#my-social-network-grid" ).data('kendoGrid') ){
						var my_social_network_grid = $("#my-social-network-grid" ).data('kendoGrid');
						var selectedCells = my_social_network_grid.select();
						if( selectedCells.length > 0){
							var selectedCell = my_social_network_grid.dataItem( selectedCells );
														
							common.api.social.update({
								data : {
									media: media,
									onetime: onetime,
									socialNetworkId: selectedCell.socialAccountId
								},
								success : function() {
									my_social_network_grid.dataSource.read();
								}							
							});
						}
					}
				}else{
					alert( "연결에 실패하였습니다." );
				}
			}
		-->
		</script>
		<style>			
		#my-profile-dialog .dropdown-menu {
			top: 120px;
			left: 50px; 
			padding : 20px;
			min-width:300px;
		}	
		
		#my-profile-dialog .profile-body {
			background: #f7f7f7;
			padding: 20px;
			font-size : 14px;
		}
		
		#my-profile-dialog .tab-content .tab-pane {
			padding: 15px;
			background: #fff;
			border-bottom-left-radius: 8px !important;
			border-bottom-right-radius: 8px !important;
		}
		
		#my-profile-dialog .tab-content .tab-pane hr{
			margin: 17px 0 15px;
		}

		#my-profile-dialog .tab-content .tab-pane dl dt {
			text-align: inherit;
		}
		
		#my-profile-dialog .profile-bio a {
			left: 50%;
			bottom: 20px;
			margin-left: -35px;
			text-align: center;
			position: absolute;
		}
		
		#my-profile-dialog .profile-bio span {
			display: inline-block;
		}
		
		#my-profile-dialog .profile-bio hr {
			margin: 6px 0 5px;
		}	
		
		#my-profile-dialog .profile-bio {
			position: relative;
			padding: 15px 10px 5px 15px;
		}		
		
		#my-profile-dialog .panel-profile {
			border: none;
			margin-bottom: 0;
			box-shadow: none;
		}
		
		#my-profile-dialog  .panel-profile .panel-heading {
			color: #585f69;
			background: #fff;
			padding: 7px 15px;
			border-bottom: solid 3px #f7f7f7;
		}	
		
		#my-profile-dialog  .panel-profile .panel-title {
			font-size: 16px;
		}		
		
		#my-profile-dialog .social-contacts-v2 i.twitter {
			color: #159ceb;
		}
		#my-profile-dialog .social-contacts-v2 i.facebook {
			color: #4862a3;
		}		
		#my-profile-dialog .social-contacts-v2 i.fa {
			font-size: 16px;
			min-width: 25px;
			margin-right: 7px;
			text-align: center;
			display: inline-block;
		}						
		</style>			
		
		<div id="my-profile-dialog">
			<div class="modal-content">			
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myProfileModalLabel">프로파일</h4>
				</div>
				<div class="modal-body no-padding">
					<div class="profile-body">						
						<div class="profile-bio rounded m-b-sm">
							<div class="row">
								<div class="col-md-5">
									<div class="dropdown">
									<img id="my-photo-image" class="img-responsive md-margin-bottom-10" src="<@spring.url "/download/profile/${user.username}"/>" alt="">
									<a class="btn-u btn-u-sm dropdown-toggle" href="#" data-toggle="dropdown">
									사진변경	
									</a>
									<ul class="dropdown-menu">
										<li role="presentation" class="dropdown-header">마우스로 사진을 끌어 놓으세요.</li>
										<li>
											<input name="my-photo-upload" id="my-photo-upload" type="file" class="pull-right" />
										</li>
									</ul>	
									</div>										
								</div>
								<div class="col-md-7">
									<h2><#if user.nameVisible >${user.name}<#else>${user.username}</#if></h2>
									<ul class="list-unstyled">
										<li class="text-muted"><span class="label rounded-2x label-orange">직업</span> <i class="fa fa-question fa-lg text-muted"></i></li>
										<hr>
										<li class="text-muted"><span class="label rounded-2x label-orange">직무</span> <i class="fa fa-question fa-lg text-muted"></i></li>
										<hr>										
									</ul>
									<p>하이</p>									
								</div>
							</div>    
						</div><!-- /.profile-bio -->			
						<div class="tab-v1" >					
							<!-- Nav tabs -->
							<ul class="nav nav-tabs" id="my-profile-tab">
								<li class="active"><a href="#my-profile-basic-cfg" data-toggle="tab">기본정보</a></li>
								<li><a href="#my-profile-password-change" data-toggle="tab"><i class="fa fa-lock"></i> 패스워드</a></li>
								<li><a href="#my-profile-social-cfg" data-toggle="tab">쇼셜</a></li>
								<li><a href="#my-profile-notice-cfg" data-toggle="tab">알림 설정</a></li>
							</ul>
							<!-- Tab panes -->
							<div class="tab-content no-padding-t">
								<div class="tab-pane active" id="my-profile-basic-cfg">				
									<h2 class="heading-md">이름과 메일 주소, 이름(메일) 공개 여부를 확인하세요. 
										<button class="btn btn-primary pull-right" data-action="basic-modify-mode" data-toggle="button" data-bind="click: click"><i class="fa fa-pencil"></i> 변경</button>
									</h2>
									<p class="text-danger"><i class="fa fa-info"></i> 마지막으로 ${user.lastProfileUpdate} 일에 사용자 정보를 수정하였습니다. </p>
									<br/>								
									<dl class="dl-horizontal">
										<dt><strong>아이디</strong></dt>
										<dd>
											<span data-bind="text:user.username" >${ user.username }</span>									
										</dd>
										<hr>		
										<dt><strong>이름</strong></dt>
										<dd>
											<span data-bind="text:user.name" >${ user.name }</span>									
										</dd>
										<hr>	
										<dt><strong>메일</strong></dt>
										<dd>
											<span data-bind="text:user.email" >${ user.email }</span>									
										</dd>
										<hr>																												
										<dt><strong>회사</strong></dt>
										<dd>
											<i class="fa fa-building-o"></i> ${user.company.displayName}
											<small class="text-muted">(${user.company.description})</small>
										</dd>
										<hr>
										<dt><strong>외부 연계 계정</strong></dt>
										<dd>
											${user.external?string("네", "아니오")}
										</dd>
										<hr>	
										<#if groups?has_content >
										<dt><strong>그룹</strong></dt>
										<dd>
											<#list groups as item >								
											<span class="label label-primary rounded"><i class="fa fa-users"></i> ${item.displayName}</span>
											</#list> 													
											<span>
												<a class="pull-right" href="#">
													<i class="fa fa-pencil"></i>
												</a>
											</span>
										</dd>
										<hr>									
										</#if>								
										<dt><strong>권한</strong></dt>
										<dd>																																		
										</dd>																						
									</dl>	
									<div class="panel panel-profile no-margin-b rounded" style="display:none;">
										<div class="panel-heading overflow-h">
											<h2 class="panel-title heading-sm pull-left"><i class="fa fa-pencil"></i> 변경</h2>
										</div>
										<div class="panel-body no-padding-b">
											<form class="form-horizontal" role="form">
												<fieldset>
													<div class="form-group">
														<label class="col-sm-2 control-label">변경할 이름</label>
														<div class="col-sm-10">
															<div class="input-group">
																<span class="input-group-addon"><i class="fa fa-user"></i></span>
																<input type="text" name="name" value="${ user.name }"  data-bind="value: user.name"  class="form-control" placeholder="이름" required="" validationmessage="이름을 입력하여 주세요.">
															</div>	
														</div>
													</div>
													<div class="form-group">
														<label class="col-sm-2 control-label">변경할 메일</label>
														<div class="col-sm-10">
															<div class="input-group">
																<span class="input-group-addon"><i class="fa fa-envelope"></i></span>
																<input type="email" name="email" value="${ user.email }" data-bind="value: user.email"  class="form-control" placeholder="이메일" pattern="[^-][A-Za-z0-9]{2,20}" required="" validationmessage="이메일 주소를 입력하여 주세요.">
															</div>
														</div>
													</div>
													<div class="form-group">
														<div class="col-sm-offset-2 col-sm-10">
															<label class="checkbox-inline">
																<input type="checkbox" data-bind="checked: user.nameVisible" <#if user.nameVisible >checked="checked"</#if>> 이름 공걔
															</label>
															<label class="checkbox-inline">
																<input type="checkbox" data-bind="checked: user.emailVisible" <#if user.emailVisible >checked="checked"</#if>> 메일 공개
															</label>
														</div>
													</div>	
												<div class="form-group">
													<div class="col-sm-offset-2 col-sm-10">
														<div class="btn-group pull-right">	
															<button type="submit" class="btn btn-danger custom-modify">변경 완료</button>		
															<button type="submit" class="btn btn-default" data-bind="click:click" data-action="basic-modify-mode-close">취소</button>				
														</div>							
													</div>
												</div>																		
												</fieldset>
											</form>										
										</div>
									</div>												
								</div>
								<div class="tab-pane" id="my-profile-password-change">
									<div style="height:300px" ></div>
									준비중입니다.
								</div>									
								<div class="tab-pane" id="my-profile-social-cfg">
									<div class="row" >
										<div class="col-sm-6">
											<table id="my-profile-social-grid" class="social-contacts-v2">											
												<colgroup>
													<col/>
													<col/>
												</colgroup>
												<thead>
													<tr>
													<th>
													미디어
													</th>
													<th>
													상태
													</th>													
												</tr>
												</thead>
												<tbody>
													<tr>
														<td colspan="2"></td>
													</tr>
												</tbody>
											</table>	
										</div>
										<div class="col-sm-6">										
											<div id="my-profile-social-details" style="min-height:200px;">
											</div>
										</div>
									</div>				
								</div>
								<div class="tab-pane" id="my-profile-notice-cfg">
									<div style="height:300px" ></div>
									준비중입니다.
								</div>	
								
							</div>
						</div><!-- /.tabs -->	
					</div><!-- .profile-body -->						
				</div>
				<div class="modal-footer no-margin-t">
					<button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
				</div>
			</div>
		</div>
		
		<!-- social network -->
		<script type="text/x-kendo-template" id="my-social-account-details-template">
		<div class="panel panel-profile">
			<div class="panel-heading overflow-h">
				<h2 class="panel-title heading-sm pull-left"><i class="fa fa-#=providerId#"></i> &nbsp;</h2>
			</div>		
			<div class="panel-body">		
			#if( providerId === "twitter"){#
				<div class="profile-blog">
					<img class="rounded-x" src="#= profileImageUrl #" alt="">
					<div class="name-location">
						<strong>#= name #</strong>
						<span><i class="fa fa-map-marker"></i> <a href="\\#">#: location #</a> </span>
					</div>
					<div class="clearfix margin-bottom-20"></div>
					<p>#: description #</p>
					<p><i class="fa fa-home"></i> <a href="profileUrl">홈</a></p>
					<hr>
					<ul class="list-inline share-list">						
						<li><i class="fa fa-star-o"></i> <a href="\\#">#: favoritesCount # 관심글</a></li>
						<li><i class="fa fa-group"></i> <a href="\\#">#: followersCount # 팔로잉</a></li>
						<li><i class="fa fa-group"></i> <a href="\\#">#: friendsCount # 팔로워</a></li>
					</ul>
				</div>
			#}else if (providerId === "tumblr"){ #
				<div class="profile-blog">
					<img class="rounded-x" src="/connect/tumblr/#= name #/avatar?size=small" alt="">
					<div class="name-location">
						<strong>#= name #</strong>
					</div>
					<div class="clearfix margin-bottom-20"></div>
					# for (var i = 0; i < blogs.length ; i++) { #												
					<p><i class="fa fa-globe"></i> <a href="blogs[i].url">#: blogs[i].title #</a></p>					
					#}# 					
					<hr>
					<ul class="list-inline share-list">						
						<li><i class="fa fa-group"></i> <a href="\\#">#: following # 팔로잉</a></li>
						<li><i class="fa fa-thumbs-o-up"></i> <a href="\\#">#: likes # 좋아요</a></li>
					</ul>
				</div>	
			#}else if (providerId === "facebook"){ #	
				<div class="profile-blog">
					<img class="rounded-x" src="http://graph.facebook.com/#= id #/picture" alt="">
					<div class="name-location">
						<strong>#= name # </strong>
						#if( location != null ){ #
						<span><i class="fa fa-map-marker"></i> <a href="\\#">#: location.name #</a> </span>
						#} #						
					</div>
					<div class="clearfix margin-bottom-20"></div>
					#if(about!=null){#
					<p>#: about #</p>
					#}#
					<dl class="dl-horizontal">
						<dt>메일</dt>
						<dd>#: email #</dd>
						<dt>연령</dt>
						<dd>#: ageRange #</dd>			
						<dt>성</dt>
						<dd>#: gender #</dd>												
					</dl>
					
					<p><i class="fa fa-home"></i> <a href="link">홈</a></p>
					<hr>					
					<ul class="list-unstyled social-contacts-v2">
						# for (var i = 0; i < education.length ; i++) { #			
						<li><i class="fa fa-graduation-cap"></i> #: education[i].school.name#, #if(education[i].year!=null){# #:education[i].year.name# #}# (#:education[i].type#)</li>
						#}#
					</ul>
					<ul class="list-unstyled social-contacts-v2">
						# for (var i = 0; i < work.length ; i++) { #			
						<li><i class="fa fa-building-o"></i> #: work[i].employer.name# (#: work[i].startDate#~#: work[i].endDate#)</li>
						#}#
					</ul>
				</div>					
			#}#		

			</div>
		</div>				
		</script>
		<script type="text/x-kendo-template" id="my-profile-social-connection-grid-row-template">
			<tr>
				<td><i class="fa rounded-x #= providerId # fa-#= providerId #"></i> #: providerId #</td>
				<td>
				#if ( displayName != null ) { # 
				#: displayName #
				# } # 
				</td>
			</tr>					
		</script>			
	</body> 
</html>