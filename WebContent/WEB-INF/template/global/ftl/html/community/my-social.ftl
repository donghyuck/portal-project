<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >		
		<title>${page.title}</title>
		<script type="text/javascript">
		<!--
		var jobs = [];
		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 	
			'<@spring.url "/js/common.plugins/switchery.min.js"/>',	
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 		
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
			],
			complete: function() {			
			
				// FEATURES SETUP	
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
									//createConnectedSocialNav();												 
									createSocialNavs();
								}
							} 
						}	
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},					
					jobs:jobs
				});		
				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				
				// menu active setting		
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_3']").addClass("active");			
					
				// personalized grid setting																																					
				preparePersonalizedArea($("#personalized-area"), 3, 4 );
			}
		}]);	
		<!-- ============================== -->
		<!-- create media connect nav buttons -->
		<!-- ============================== -->			
					
		function createSocialNavs(){
			var renderTo = $('#my-social-navbar');	
			kendo.ui.progress(renderTo, true);
			var dataSource = common.ui.connect.list.datasource({
				change:function(e){
					var $this = this;
					var template = kendo.template($('#my-social-navbar-template').html());
					renderTo.html(template({ items : $this.data() }));
					renderTo.find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					  var target = $(e.target);
					  createSoicalTabPanel( $this.get(target.data("object-id")), $(target.attr('href')) );
					})
					kendo.ui.progress(renderTo, false);						
				}
			}).read();
			
			$(document).on("click","[data-upload='photo']", function(e){						
				var btn = $(this) ;
				btn.parent().toggleClass('active');
				btn.button('loading');
				common.ui.data.image.uploadByUrl({
					data : {sourceUrl: btn.data('source'), imageUrl: btn.data('url')} ,
					success : function(response){
						btn.attr("disabled", "disabled");
						btn.addClass('hide');
					},
					always : function(){
						btn.parent().toggleClass('active');
						btn.button('reset');
					}
				});					
			});			
			
			$("button[data-action=settings], a[data-action=settings]").click(function(e){
				createSocialSettingModal();
				return false;
			});	
				
		}		
		
		function createSocialSettingModal(){
			if( !getCurrentUser().anonymous ){
			
				var renderTo = $("#my-social-setting-modal");
				if( !renderTo.data('bs.modal')){	
					var listview = $("#my-social-listview");
					if( !common.ui.exists( listview ) ){

						common.ui.listview( listview, {
										dataSource : common.ui.connect.all.datasource(),
										template : kendo.template($("#my-social-listview-template").html()),
										dataBound : function(e) {
											console.log("loading from remote");
											
											var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
											elems.forEach(function(html) {
											  var switchery = new Switchery(html);
											});

										}
						});
						listview.removeClass("k-widget");
															
					
					}					
				}
				renderTo.modal('show');	
			}
		}
		
		function createSoicalTabPanel( connect , renderTo ){					
			var view = renderTo.find(".ibox-content>.social-feed-list");
			if( !common.ui.exists(view) ){				
				var listview = common.ui.connect.listview( view, connect );
				var observable =  common.ui.observable({
					pageIndex : 0,
					pageSize : 20,
					next: function(){
						var _offset = this.get('pageIndex') + this.get('pageSize');
						this.set('pageIndex', _offset);
						listview.dataSource.read({offset: _offset });							
					}
				});
				renderTo.find("[data-action='more']").click(function(e){							
					observable.next();	
				});
				//renderTo.data("model", observable );
			}					
		}		
		
		function createConnectedSocialNav(){				
			var renderTo = $('#navbar-btn-my-streams');	
			var myConnectBtn = renderTo.find('button[data-action="media-list"]').button('loading');	
			var myConnectDataSource = common.ui.connect.list.datasource({
				change:function(e){
					var $this = this;
					var template = kendo.template('<label class="btn btn-primary"><input name="selectedSocialConnect" type="checkbox" value="#:socialConnectId#"><i class="fa fa-#= providerId #"></i> #: providerId #</label>');
					var html = kendo.render(template, $this.data());
					renderTo.html(html);	
					renderTo.find("label").first().addClass("rounded-left");
					renderTo.find("label").last().addClass("rounded-right");
					renderTo.find("input[type=checkbox]").bind("change", function(e){		
						var myConnect = $this.get(this.value);
						if($(this).is(":checked")){
							showMediaPanel(myConnect);
						}
					});								
				}
			}).read();	
		}	
		<!-- ============================== -->
		<!-- display media stream panel     -->
		<!-- ============================== -->		
		
		function showMediaPanel(connect){	

			if( $("article.bg-sky").is(":hidden") ){
				$("article.bg-sky").show();
			} 		
		
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.extPanel(
			appendTo,
			{ 
				title: "<i class='fa fa-" + connect.providerId + " fa-fw'></i>" + connect.providerId  , 
				actions:["Custom", "Minimize", "Refresh", "Close"],
				data: connect,
				css : "panel-primary rounded",
				scrollTop : true,
				template: kendo.template("<ul class='media-list no-border' style='min-height:150px;'></ul>"),
				close: function(e) {
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialConnectId + '"]').parent().toggleClass("disabled");	
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialConnectId + '"]').parent().toggleClass("active");	
				},
				refresh: function(e){
					var view = e.target.element.find(".panel-body ul.media-list");
					if( common.ui.exists(view) ){
						common.ui.listview(view).refersh();
					}
				},
				custom: function(e){					
					alert("준비중입니다.");
				},
				open: function(e){
					var that = e.target;					
					$('#navbar-btn-my-streams').find('input[value="' + that.data().socialConnectId + '"]').parent().toggleClass("disabled");					
					var renderTo = that.element.find(".panel-body ul.media-list");
					common.ui.connect.listview( renderTo, connect );
					if( connect.providerId === 'tumblr' ){							
						that.options.pageSize = 20 ;
						that.options.pageIndex = 0 ;
						var footer =that.element.find(".panel-footer");
						footer.prepend('<button class="btn btn-primary btn-sm rounded m-r-xs" type="button" data-action="more"><i class="fa fa-angle-double-down"></i> 더 보기</button>');
						footer.find("[data-action='more']").click(function(e){							
							that.options.pageIndex = that.options.pageIndex + that.options.pageSize ;
							var data = common.ui.connect.listview( renderTo ).dataSource.view();	
							common.ui.connect.listview( renderTo ).dataSource.read({offset: that.options.pageIndex });
						});
					}
				}
			});
			panel.show();
		}
						
		-->
		</script>		
		<style scoped="scoped">
			.breadcrumbs-v3 {
				position:relative;
			}
			.breadcrumbs-v3 p	{
				color : #fff;
				font-size: 24px;
				font-weight: 200;
				margin-bottom: 0;
			}	
			
			.breadcrumbs-v3.img-v1 {
				background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
				background-size: cover;
				background-position: center center;			
			}		
			
			.social-feed-list {
				min-height : 150px;
			}
			
			.social-feed-list .media-body>ul {
				padding-top : 5px;
			}
			
			.ibox.feed
			{
				position : relative;
			}
			
			.ibox.feed .ibox-title button[data-action=more]{			
				top: 21px;
	    		right: 15px;
	    		position: absolute;
			}
			
			.switchery>small {
				border-radius : 100%!important;
			}
			
		</style>   	
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- END HEADER -->	
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>
				</div><!--/end container-->
			</div>
			</#if>	
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<button class="btn-link hvr-pulse-shrink" type="button" data-action="settings"><i class="icon-flat icon-flat settings"></i></button>
					<button class="btn-link hvr-pulse-shrink disabled"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>	
			<div class="container content">
				<div class="row">
					<div id="my-social-navbar"></div>
				</div>
			
				<!--
				<div class="row">
					<div class="col-md-6">
						<h4>쇼셜네트워크</h4>
						<div class="btn-toolbar">
							<div id="navbar-btn-my-streams" class="btn-group btn-group-lg" data-toggle="buttons">
								<button type="button" class="btn btn-primary rounded" data-action="media-list" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>미디어</button>
							</div>	
						</div>							
					</div>
					<div class="col-md-6">
								<div class="pull-right">
									<h4>레이아웃</h4>
									<div class="btn-group navbar-btn no-margin" data-toggle="buttons">
										<label class="btn btn-info rounded-left">
											<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
										</label>
										<label class="btn btn-info">
									 		<input type="radio" name="personalized-area-col-size" value="6"> <i class="fa fa-th-large"></i>
										</label>
										<label class="btn btn-info active rounded-right">
											<input type="radio" name="personalized-area-col-size" value="4"> <i class="fa fa-th"></i>
										</label>
									</div>														
								</div>						
					</div>
				</div>	-->		
			</div>
			<article class="bg-sky animated fadeInUp" style="min-height:200px; display:none;">			
				<div class="container-fluid content" >
					<div id="personalized-area" class="row"></div>
				</div>
			</article>		

	
			
			<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
		<!-- END FOOTER -->
		</div>						



		<div id="my-social-setting-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-view-form">	
					<div class="modal-header">
						<h2>쇼셜 계정 관리</h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">
						<div id="my-social-grid"></div>	
						<div id="my-social-listview" class="forum-container"></div>	
					</div>
				</div>
			</div>
		</div>
		
		
		
		<!-- START TEMPLATE -->
		<script type="text/x-kendo-template" id="my-social-listview-template">
<div class="forum-item">
                                <div class="row">
                                    <div class="col-md-9">
                                        <div class="forum-icon">
                                            <i class="icon-flat icon-svg social-color-#=name# #if(!connected){# grayscale #}#"></i>
                                        </div>
                                        #if(connected){#  
                                        
                                        <input type="checkbox" class="js-switch" checked />
                                        
                                        
	                                   <a class="forum-avatar" href="\\#">
	                                   #if( connect.imageUrl != null ){ # 
	                                   <img src="#: connect.imageUrl #" class="img-circle" alt="image">
	                                   #} #
	                                    <div class="author-info">
	                                        <span>
	                                        # if ( connect.displayName != null ) { #
	                                        #: connect.displayName #
	                                        # } else { #
	                                        
	                                        # } #
	                                        </span>
	                                    </div>
	                                	</a>
                                        #}#
                                    </div>
                                    <div class="col-md-1 forum-info">
                                        <span class="views-number">
                                            765
                                        </span>
                                        <div>
                                            <small>Views</small>
                                        </div>
                                    </div>
                                    <div class="col-md-1 forum-info">
                                        <span class="views-number">
                                            90
                                        </span>
                                        <div>
                                            <small>Topics</small>
                                        </div>
                                    </div>
                                    <div class="col-md-1 forum-info">
                                        <span class="views-number">
                                            11
                                        </span>
                                        <div>
                                            <small>Posts</small>
                                        </div>
                                    </div>
                                </div>
                            </div>		
		
		</script>

		<script type="text/x-kendo-template" id="my-social-navbar-template">
		#if(items.length == 0 ){#
		<div class="alert alert-info" role="alert">연결된 쇼셜 계정이 없습니다.</div>
		#}#
	  	<!-- Nav tabs -->
		<ul class="nav nav-pills" role="tablist">
		# for (var i = 0; i < items.length ; i++) { #
			<li role="presentation"><a href="\\##= items[i].socialConnectId #-#= items[i].providerId #-tabpanel" aria-controls="#= items[i].socialConnectId #-#= items[i].providerId #-tabpanel" role="tab" data-toggle="tab" data-object-id="#= items[i].socialConnectId #" ><i class="fa fa-lg fa-#= items[i].providerId #"></i> #: items[i].providerId #</a></li>
	  	# } #
		</ul>
		<!-- Tab panes -->
		<div class="tab-content">
		# for (var i = 0; i < items.length ; i++) { #
			<div role="tabpanel" class="tab-pane fade" id="#= items[i].socialConnectId #-#= items[i].providerId #-tabpanel">	
				<div class="ibox feed float-e-margins">
					<div class="ibox-title">
						#if( items[i].providerId == 'tumblr' ){#
						<button class="btn btn-flat btn-outline btn-primary rounded" type="button" data-action="more"><i class="fa fa-angle-double-down"></i> 더 보기</button>
						#}#
						<i class="icon-flat icon-svg social-color-#=items[i].providerId#"></i>
					</div>
					<div class="ibox-content">
						<ul class="social-feed-list no-border"></ul>
					</div>	
				</div>
			</div>
		# } #
		</div>
		</script>					
		<script type="text/x-kendo-template" id="alert-panel-template">
				<div  id="#: id #" data-alert class="alert alert-info" style="min-height:50px; display:none;">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					<p> 쇼셜 아이콘을 클릭하면 연결된 미디어 뉴스가 보여집니다. </p>				
					<p><small>새로운 쇼셜 미디어 연결은 프로필 보기의 쇼셜네트워크 탭에서 지원합니다.</small></p>
					<p><a href="/community/view-myprofile.do?view=modal-dialog" class="btn btn-info btn-sm" data-toggle="modal" data-target="\\#myProfileModal">프로필 보기</a></p>
				</div>
		</script>								
		<script type="text/x-kendo-tmpl" id="twitter-timeline-template">
			<li class="media">
				<a class="pull-left" href="\\#">
					#if(retweet){#
					<img src="#: retweetedStatus.user.profileImageUrl #" alt="#: retweetedStatus.user.name#" class="media-object img-circle">
					#}else{#
					<img src="#: user.profileImageUrl #" alt="#: user.name#" class="media-object img-circle">
					#}#
				</a>
				<div class="media-body">
					<h5 class="media-heading p-xs">
						 #if(retweet){# 
						 <small><i class="fa fa-retweet"></i>&nbsp; #: user.name # 님이 리트윗함 </small> 
						 <p>#= retweetedStatus.user.name # <small>@#= retweetedStatus.user.screenName #</small></p>
						 #}else{#
						 <p> #= user.name # <small>@#= user.screenName #</small></p>
						 #}#						 
					</h5>
					<p>#= text #</p>
					# for (var i = 0; i < entities.urls.length ; i++) { #
					# var url = entities.urls[i] ; #	
					<p><a href="#: url.expandedUrl  #" target="_blank"><i class="fa fa-link"></i> #: url.displayUrl #</a></p>
					#}#
					# for (var i = 0; i < entities.media.length ; i++) { #	
					# var media = entities.media[i] ; #					
					<img src="#: media.mediaUrl #" alt="media" class="img-responsive">
					# } #
					<ul class="list-unstyled list-inline text-muted ">
                            <li><i class="fa fa-retweet"></i> #= retweetCount #</li>
                            <li><i class="fa fa-star-o"></i> #= favoriteCount #</li>
                     </ul>
				</div>
			</li>
		</script>
		<script type="text/x-kendo-tmpl" id="tumblr-dashboard-template">
			<li class="media">
				<a class="pull-left" href="\\#">
					<img src="/connect/tumblr/#: blogName#/avatar?size=small" style="width:48px;" alt="#: blogName #" class="media-object img-rounded">
				</a>
				<div class="media-body">
					<h5 class="media-heading">
					#:blogName#
					</h5>
					<p>#:postUrl#</p>
					#if (type == 'PHOTO' ) {#		
						# var totalPhoto = photos.length ; #
						<div class="row no-margin">
						# for (var i = 0; i < photos.length ; i++) { #	
							# var photo = photos[i] ; #							
						<div class="col-xs-#=common.ui.connect.columns(i, totalPhoto)# no-padding">
							<figure>
							<img src="#: photo.sizes[1].url  #" alt="media" class="img-responsive lightbox" style="padding:0px 1px 1px 0px;" data-toggle="lightbox" #if(totalPhoto>1){# data-selector="[data-uid='#=uid#'] figure > img.lightbox" #}#>
								<figcaption class="no-padding-hr" style="height:10px;">									
									<button type="button" class="btn btn-primary btn-sm rounded-3x custom-upload-by-url" data-upload="photo" data-source="#:postUrl#" data-url="#: photo.sizes[0].url #" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-cloud-upload"></i> #if( common.ui.connect.columns(i, totalPhoto) > 4 ){ # My 클라우드로 복사 #}#</button>
								</figcaption>
							</figure>
						</div>	
											
						#}#
						</div>
					#}#
					# if ( caption != null ) { #						
					<p>#= caption #</p>
					# } #
					<p class="text-muted"><i class="fa fa-comment-o"></i>&nbsp; #= noteCount# </p>
				</div>
			</li>
		</script>		
		<script type="text/x-kendo-tmpl" id="facebook-homefeed-template">
		<li class="media">
			<a class="pull-left" href="\\#">
				<img src="http://graph.facebook.com/#=from.id#/picture" style="width:48px;" alt="#: from.name #" class="media-object img-circle">
			</a>
			<div class="media-body">
				<h5 class="media-heading p-xs">
					#:from.name#
					#if( to != null ){ # 
					<i class="fa fa-angle-right"></i>  #:to[0].name # 					
					#}# 
					#if( application !=null ){# 
					<span class="label label-success"><i class="fa fa-mobile"></i> #:application.name#  </span> 
					#}#
				</h5> 	
				# if ( story != null ) { #
				<p><span class="label label-blue rounded"><i class="fa fa-quote-left"></i> #: story # <i class="fa fa-quote-right"></i></span></p>
				# } #		
									
				# if ( type === 'STATUS' ) { #
					#= id.replace( from.id + "_" , "") #
				# } else if (type === 'LINK' ) { #
					# if ( picture != null ){#
					<a href="#: link #" target="_blank;">	
					<img src="#: picture  #" alt="media" class="padding-sm">
					</a>
					#}else{#
					<a href="#: link #" target="_blank;">#: link #</a>
					#}#
					#if (caption !=null ) { #
					<blockquote>
						<p>#: caption #</p>
						#if ( description != null ) { #
						<footer>
							#: description #
						</footer>
						# } #	
					</blockquote>
					# } #		
				#} else if (type === 'PHOTO' ) {#			
					#if ( description != null ) { #
					<p>#: description #<p>		
					# }#						
					# if ( picture != null ){#
					<img src="#: picture  #" alt="media" class="img-responsive padding-sm">
					# }#												
				# } #	
				
				# if ( message != null ) { #						
				<p>#: message #</p>
				# } #	
			
				#if ( commentCount > 0 || likes != null  ) { #
				<div class="panel-group" id="accordion-#= id #">
			
					#if ( likes!= null &&  likes.length > 0  ) { #
					<div class="panel panel-default no-border rounded-2x">
						<div class="panel-heading comments-heading">	
							<a data-toggle="collapse" data-parent="\\#accordion-#= id #" href="\\#likes-#= id #">
								<h4 class="panel-title"><i class="fa fa-thumbs-up"></i> <small>좋아요 (#=  likes.length #)</small></h4>
							</a>
						</div>	
						<div id="likes-#= id #" class="panel-collapse collapse">
							<div class="panel-body">
								# for (var i = 0; i < likes.length ; i++) { #	
									<img class="img-circle" src="http://graph.facebook.com/#=likes[i].id#/picture" alt="#=likes[i].name#">
								# } #
							</div>
						</div>
					</div>
					# } #
			
					#if ( commentCount > 0  ) { #
					<div class="panel panel-default no-border rounded-2x">
						<div class="panel-heading comments-heading">	
							<a data-toggle="collapse" data-parent="\\#accordion-#= id #" href="\\#comments-#= id #">
								<h4 class="panel-title"><i class="fa fa-comment"></i> <small>댓글 (#= commentCount  #)</small></h4>
							</a>
						</div>
						<div id="comments-#= id #" class="panel-collapse collapse">
							<div class="panel-body">
							# for (var i = 0; i < commentCount ; i++) { #	
								# var comment = comments[i] ; #	
									<div class="media">
										<a class="pull-left" href="\\#">
											<img class="media-object img-circle" src="http://graph.facebook.com/#=comment.from.id#/picture" alt="#=comment.from.name#">
										</a>	
										<div class="media-body">
											 <h6 class="media-heading">#: comment.from.name # <i class="fa fa-thumbs-up"></i> #:comment.likesCount#</h6>
											 <div class="text-muted">#=comment.message#</div>
										</div>				
									</div>								
								# } #							
							</div>
						</div>
					</div>
					# } #	
				</div>
				# } #
					
			</div>
		</li>
		</script>			
		<#include "/html/common/common-homepage-templates.ftl" >		
	
		<!-- END TEMPLATE -->
	</body>    
</html>