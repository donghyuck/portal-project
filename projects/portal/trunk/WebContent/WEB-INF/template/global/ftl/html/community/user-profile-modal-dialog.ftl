<#ftl encoding="UTF-8"/>
<html decorator="none">
	<body>
		<script type="text/javascript">
		<!--
						
			var myProfileModel = new kendo.data.ObservableObject({
				user : $("#account-navbar").data("kendoExtAccounts").token, 
				click: function(e){
					var btn = $(e.target),
					action = btn.data("action");
					alert( action ) ;
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
				}		
			});
			
			kendo.bind( $("#my-profile-dialog" ), myProfileModel );
			
			if(!$("#my-photo-upload").data("kendoUpload")){
				$("#my-photo-upload").kendoUpload({
					multiple : false,
					showFileList : false,
					localization:{ select : '사진 선택' , dropFilesHere : '업로드할 이미지를 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '${request.contextPath}/community/update-my-photo.do?output=json',							   
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
									"/connect/list.json",
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
											"/connect/" + selectedCell.providerId + "/user/lookup.json",
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

			$('#my-profile-tab a.a').click(function (e) {
				e.preventDefault();				
				if( $(this).attr('href') == '#profile-social-network' ){					
					if( !$("#my-social-grid" ).data('kendoGrid') ){
						$("#my-social-network-grid").kendoGrid({
							dataSource: common.api.social.dataSource({type:'all'}),
							selectable: "single",
							rowTemplate: kendo.template($("#social-network-grid-row-template").html()),
							change: function(e) { 				
								var selectedCells = this.select();
								if( selectedCells.length == 1){
									var selectedCell = this.dataItem( selectedCells );	    									
									$("#my-social-network-grid").data( "networkPlaceHolder", selectedCell );			
									if( selectedCell.connected ){				
										common.api.social.profile({
											media : selectedCell.serviceProviderName ,
											data: { socialNetworkId: selectedCell.socialAccountId },
											success : function(response){
												var myMediaAccountTemplate = kendo.template($('#my-social-network-account-details-template').html());			
												$("#my-social-network-account-details").html( myMediaAccountTemplate(response) );	
											},
											beforeSend : function() {
												kendo.ui.progress($("#my-social-network-account-details"), true);
											},
											complete : function(){
												kendo.ui.progress($("#my-social-network-account-details"), false);
											}												
										});
									}	
								}							
							},
							dataBound: function(e) {
								$("#my-social-network-grid button").each(function( index ) {
									var grid_action = $(this);									
									if( grid_action.hasClass("custom-social-network-connect") ){
										grid_action.click(function (e) {
											e.preventDefault();	
											var networkPlaceHolder = $("#my-social-network-grid").data( "networkPlaceHolder");
											goSocialPopup(networkPlaceHolder);
										});
									} else if( grid_action.hasClass("custom-social-network-disconnect") ){
										grid_action.click(function (e) {
											e.preventDefault();			
											var networkPlaceHolder = $("#my-social-network-grid").data( "networkPlaceHolder");
											alert( networkPlaceHolder.socialAccountId +  " 준비중입니다." ) ;									
										});									 	
									 }
								});
							},
							height: 300
						});								
					}				
				}
				$(this).tab('show')
			})		 	
						
			
			if(!$("#my-photo-upload").data("kendoUpload")){
				$("#my-photo-upload").kendoUpload({
					multiple : false,
					showFileList : false,
					localization:{ select : '사진변경' , dropFilesHere : '업로드할 이미지를 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '${request.contextPath}/community/update-my-photo.do?output=json',							   
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
		}
		
		#my-profile-dialog .tab-content .tab-pane {
			padding: 20px;
			background: #fff;
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
			display: block;
		}
		
		#my-profile-dialog .profile-bio hr {
			margin: 12px 0 10px;
		}	
		
		#my-profile-dialog .profile-bio {
			background: #fff;
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
						<div class="profile-bio rounded margin-bottom-20">
							<div class="row">
								<div class="col-md-5">
									<div class="dropdown">
									<img id="my-photo-image" class="img-responsive md-margin-bottom-10" src="/download/profile/${user.username}" alt="">
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
									<span><strong>Job:</strong> <i class="fa fa-question text-muted"></i></span>
									<span><strong>Position:</strong> <i class="fa fa-question text-muted"></i></span>
									<hr>
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
										<button class="btn btn-primary btn-sm rounded pull-right" data-action="basic-modify-mode" data-toggle="button" data-bind="click: click"><i class="fa fa-pencil"></i> 변경</button>
									</h2>
									<p class="text-muted"><i class="fa fa-info"></i> 마지막으로 ${user.lastProfileUpdate} 일에 사용자 정보를 수정하였습니다. </p>
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
										<dt><strong>롤</strong></dt>
										<dd>
											<#list roles as item >								
												<span class="label label-success rounded"><i class="fa fa-key"></i> ${item}</span>						
											</#list>																																				
										</dd>
										<hr>																									
									</dl>	
									<div class="panel panel-default no-margin-b rounded" style="display:none;">
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
																<input type="text" name="name" value="${ user.name }" class="form-control" placeholder="이메일" required="" validationmessage="이름을 입력하여 주세요.">
															</div>	
														</div>
													</div>
													<div class="form-group">
														<label class="col-sm-2 control-label">변경할 메일</label>
														<div class="col-sm-10">
															<div class="input-group">
																<span class="input-group-addon"><i class="fa fa-envelope"></i></span>
																<input type="text" name="email" value="${ user.email }" class="form-control" placeholder="이메일" pattern="[^-][A-Za-z0-9]{2,20}" required="" validationmessage="이메일 주소를 입력하여 주세요.">
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
															<button type="submit" class="btn btn-danger custom-modify">수정 완료</button>		
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
											<div id="my-profile-social-details" >
												<!--<button class="btn btn-danger btn-sm">연결 삭제</button>-->
											
											</div>
										</div>
									</div>				
								</div>
								<!--
										
									<div class="container" style="width:100%">
										<div class="row">			
											<div class="col-sm-5 leftless rightless">		
												<table id="my-social-network-grid">
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
											<div id="my-social-network-account-details" class="col-sm-7 rightless"></div>
										</div>
									</div>
									-->
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
						<span><i class="fa fa-map-marker"></i> <a href="\\#">#: location #</a> </span>
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
			#}#		
							<div class="profile-blog">
                                    <img class="rounded-x" src="assets/img/testimonials/img2.jpg" alt="">
                                    <div class="name-location">
                                        <strong>#= name #</strong>
                                        <span><i class="fa fa-map-marker"></i><a href="\\#">California,</a> <a href="\\#">US</a></span>
                                    </div>
                                    <div class="clearfix margin-bottom-20"></div>    
                                    <p>Donec non dignissim eros. Mauris faucibus turpis volutpat sagittis rhoncus. Pellentesque et rhoncus sapien, sed ullamcorper justo.</p>
                                    <hr>
                                    <ul class="list-inline share-list">
                                        <li><i class="fa fa-bell"></i><a href="\\#">3 Notifications</a></li>
                                        
                                        <li><i class="fa fa-share"></i><a href="\\#">Share</a></li>
                                    </ul>
                                </div>
                                			
			
				#if ( typeof (twitterProfile)  == "object" ){ #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="#=twitterProfile.profileImageUrl#" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h5 class="media-heading">#=twitterProfile.screenName# (#=twitterProfile.name#)</h5>
						#=twitterProfile.description#</br>
						</br>
						트위터 URL : #=twitterProfile.profileUrl#</br>
						표준시간대: #=twitterProfile.timeZone#</br>	
						웹 사이트: #=twitterProfile.url#</br>	
						언어: #=twitterProfile.language#</br>	
						위치: #=twitterProfile.location#</br>	
					</div>			
				</div>
				</br>
				<ul class="list-group">
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.statusesCount#</span>
					트윗
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.friendsCount#</span>
					팔로잉
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.followersCount#</span>
					팔로워
					</li>		
				</ul>			
				# } else if ( typeof (facebookProfile)  == "object" ) { #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="http://graph.facebook.com/#=facebookProfile.id#/picture" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h5 class="media-heading">
						#=facebookProfile.name# (#=facebookProfile.firstName#, #=facebookProfile.lastName#)
						</h5>
						</br>
						URL : #=facebookProfile.link#</br>
						로케일 : #=facebookProfile.locale#</br>
						# if ( typeof (facebookProfile.location)  == "object" ) { #
						위치 : #=facebookProfile.location.name#</br>
						# } #
					</div>		
				</div>						
				# } else if ( typeof (tumblrProfile)  == "object" ) { #
				<ul class="media-list">
					<li class="media">					
						<div class="media-body">
							<h5 class="media-heading">
							#=tumblrProfile.name#
							</h5>
							<p>팔로잉 : #=tumblrProfile.following#, 좋아요 : #=tumblrProfile.likes#</p>
							# for (var i = 0; i < tumblrProfile.blogs.length ; i++) { #												
							# var blog = tumblrProfile.blogs[i] ; #	
							<div class="media">
							<!--
				            <a class="pull-left" href="\\#">
				              <img class="media-object" data-src="holder.js/64x64" alt="Generic placeholder image">
				            </a>
				            -->
				            <div class="media-body">
				              <!--<h4 class="media-heading">Nested media heading</h4>-->
				              #=blog.url #
				            </div>
				          </div>							
						</div>	
						# } #	
					</li>	
					
				</ul>											
				# } else if ( typeof (error)  == "object" ) { #
				
				# } #
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