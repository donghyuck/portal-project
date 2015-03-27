<!-- ============================== -->
<!-- announce viewer template                          -->
<!-- ============================== -->

<script type="text/x-kendo-tmpl" id="announcement-viewer-template">		
	<div class="page-heading">
		<h4 data-bind="html:announce.subject"></h4>		
		<hr class="devider">
		<span class="label label-primary label-lightweight">게시 기간</span> <small class="text-primary"><span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></small>
		<p class="text-muted">
			<span class="label label-default label-lightweight">생성일</span> <small><span data-bind="text: announce.formattedCreationDate"></span> </small>
			<span class="label label-default label-lightweight">수정일</span> <small><span data-bind="text: announce.formattedModifiedDate"></span> </small>
		</p>
	</div>													
	<div class="media">
		<a class="pull-left" href="\\#">
			<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">																	
				<p><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span> <code data-bind="text: announce.user.username"></code></p>
				<p data-bind="visible:announce.user.emailVisible, text: announce.user.email"></p>
			</h5>		
		</div>		
	</div>	
	<div class="margin-bottom-20"><hr class="devider"></div>
	<div data-bind="html: announce.body " />
</script>

<script type="text/x-kendo-tmpl" id="announcement-view-template">		
	<div class="page-heading">
		<h4 data-bind="html:subject"></h4>		
		<hr class="devider">
		<span class="label label-primary label-lightweight">게시 기간</span> <small class="text-primary"><span data-bind="text: formattedStartDate"></span> ~ <span data-bind="text: formattedEndDate"></span></small>
		<p class="text-muted">
			<span class="label label-default label-lightweight">생성일</span> <small><span data-bind="text: formattedCreationDate"></span> </small>
			<span class="label label-default ">수정일</span> <small><span data-bind="text: formattedModifiedDate"></span> </small>
		</p>
	</div>													
	<div class="media">
		<a class="pull-left" href="\\#">
			<img src="<@spring.url '/download/profile/#: user.photoUrl #?width=150&height=150'/>" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">
				# if( user.nameVisible ){#
				#: user.name # (#: user.username #)
				# } else { #
				#: user.username #
				# } # 		
				# if( user.emailVisible ){#
				<br>(#: user.email #)
				# } #	
			</h5>		
		</div>			
	</div>	
	<div class="margin-bottom-20"><hr class="devider"></div>
	<div data-bind="html: body " />
	<div class="margin-bottom-20"></div>
	<div class="btn-group pull-right">
		<button  type="button" class="btn btn-info btn-sm custom-list "><i class="fa fa-angle-double-up"></i> 목록</button>		
	</div>
</script>

<script type="text/x-kendo-tmpl" id="announcement-template">
	<tr class="announce-item" onclick="viewAnnounce(#: announceId#);">
		<th>#: announceId#</th>
		<td>#: subject#</td>
	</tr>
</script>

<script type="text/x-kendo-template" id="notice-view-template">	
<div class="animated fadeIn" data-bind="visible:visible">
	<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:edit}">편집</button> <button type="button" class="btn-u btn-u-red btn-u-small" data-bind="events{click:delete}">삭제</button> <button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
	<div class="panel panel-blue">
		<div class="panel-heading" style="background-color: \\#fff; ">
			<h4 class="panel-title" data-bind="html:announce.subject"></h4>		
		</div>
		<div class="panel-body padding-sm">
			<ul class="list-unstyled text-muted">
				<li><span class="label label-primary label-lightweight">게시 기간</span> <span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></li>
				<li><span class="label label-default label-lightweight">생성일</span> <span data-bind="text: announce.formattedCreationDate"></span></li>
				<li><span class="label label-default label-lightweight">수정일</span> <span data-bind="text: announce.formattedModifiedDate"></span></li>
			</ul>	
			<div class="media">
				<a class="pull-left" href="\\#">
					<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-circle">
				</a>
				<div class="media-body">
					<ul class="list-unstyled text-muted">
						<li><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span><code data-bind="text: announce.user.username"></code></li>
						<li><span data-bind="visible:announce.user.emailVisible, text: announce.user.email"></span></li>
					</ul>	
				</div>		
			</div>	
			<hr class="devider no-margin-t">
			<div data-bind="html: announce.body " />		
		</div>
	</div>	
	<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:edit}">편집</button> <button type="button" class="btn-u btn-u-red btn-u-small" data-bind="events{click:delete}">삭제</button> <button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
</div>
</script>
<!-- ============================== -->
<!-- news viewer template									-->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="news-viewer-template">		
	<div class="page-heading">
		<h4 data-bind="html:news.subject"></h4>		

	</div>													
	<div class="media">
		<a class="pull-left" href="\\#">
			<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
		</a>
		<div class="media-body">
			<h5 class="media-heading">																	
				<p><span data-bind="visible:news.user.nameVisible, text: news.user.name"></span> <code data-bind="text: news.user.username"></code></p>
				<p data-bind="visible:news.user.emailVisible, text: news.user.email"></p>
			</h5>		
		</div>
		<div data-bind="html: news.content " />
	</div>	
</script>

<!-- ============================== -->
<!-- Footer Template            						   -->
<!-- ============================== -->
<script type="text/x-kendo-tmpl" id="footer-notice-template">				
	<li>
		<a href="javascript:common.redirect('<@spring.url "/display/0/events.html" />', { announceId :#= announceId # }, 'get' );"><i class="fa fa-angle-right"></i> #:subject# </a>
		<small>#: formattedModifiedDate() #</small>
	</li>
</script>
<!-- ============================== -->
<!-- Top Nav Account Status Template               -->
<!-- ============================== -->
<script id="account-navbar-template" type="text/x-kendo-template">
	<li>
		<a href="\\#my-aside-menu" class="btn btn-link btn-avatar btn-account dropdown-toggle navbar-toggle-aside-menu">
			<img src="#:photoUrl#" class="rounded-top" height="34">
		</a>		
	</li>	
</script>

<script id="account-template" type="text/x-kendo-template">
	<li class="account">
		<a href="\\#my-aside-menu" class="btn btn-link btn-account dropdown-toggle navbar-toggle-aside-menu">
		# if ( anonymous ) { # 
			<img src="<@spring.url '/images/common/anonymous.png'/>" height="34"/>	
		# }else{ # 
			<img src="<@spring.url '/download/profile/#: username #?width=100&height=150'/>" class="rounded-top" height="34">
		# } #
		</a>
	</li>	
</script>	
<script id="account-sidebar-template" type="text/x-kendo-template">
	<section id="#= uid #" class="aside-menu" data-feature-name="u-accounts-sidebar">	
		<button type="button" class="btn-close btn-sm">Close</button>		
		<h5 class="side-section-title">Optional sidebar menu</h5>		
		# if ( !anonymous ) { # 	
		<div class="account-content" >		
			<img class="img-profile img-rounded" src="<@spring.url '/download/profile/#: username #?width=100&height=150'/>" />			
			<div class="margin-bottom-10">		
			</div>
			<ul class="list-unstyled who margin-bottom-30">
				<li><a href="\\#"><i class="fa fa-user"></i>#:name#</a></li>
				<li><a href="\\#"><i class="fa fa-envelope"></i>#:email #</a></li>
				<li><a href="\\#"><i class="fa fa-building"></i>#:company.displayName #</a></li>
			</ul>		
			<div class="btn-group btn-group-sm">
				<a href="<@spring.url '/display/dialog.html?source=/html/community/user-profile-modal-dialog'/>" class="btn btn-primary" data-toggle="modal" data-target="\\#myProfileModal" ><i class="fa fa-user"></i> 프로필 보기</a>
				#if ( isSystem ) {#
				<a href="<@spring.url '/secure/main.do'/>" class="btn btn-primary"><i class="fafa-sign-out"></i> 시스템 관리</a>
				# } #			
			</div>
			<a href="<@spring.url '/logout'/>" class="btn btn-danger btn-sm pull-right"><i class="fafa-sign-out"></i> 로그아웃</a>
		</div>
		
		<h5 class="side-section-title">MY CLOUD DRIVE</h5>
		<div class="account-content" >	
			<div class="row">
				<div class="col-xs-6">
			<div class="side-section-nav">	
			</div>				 
				 </div>
				<div class="col-xs-6">
					<h3 class="heading-xs">전체 사용량 <span class="pull-right">88%</span></h3>
					<div class="progress progress-u progress-xs">
						<div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%"></div>
					</div>
					<h3 class="heading-xs">메일 <span class="pull-right">76%</span></h3>
					<div class="progress progress-u progress-xs">
						<div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="76" aria-valuemin="0" aria-valuemax="100" style="width: 76%"></div>
					</div>
					<h3 class="heading-xs">파일<span class="pull-right">97%</span></h3>
					<div class="progress progress-u progress-xs">
						<div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="97" aria-valuemin="0" aria-valuemax="100" style="width: 97%">
					</div>
					</div>				
				 </div>			 
			</div>
		</div>
		# } # 		
	</section>
</script>	
		