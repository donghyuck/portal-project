<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<script type="text/javascript">
		<!--
		var jobs = [];
		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',	
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.core.js',
			'${request.contextPath}/js/common/common.ui.connect.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],
			complete: function() {			
			
				common.ui.setup({
					features:{
						backstretch : false,
						lightbox : true,
						landing : true
					}
				});
				var currentUser = new User();		
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if action.isAllowedSignIn() ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);
					},				
					shown : function(e){					
						createConnectedSocialNav();	
					}
				});						
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED']").addClass("active");				
				preparePersonalizedArea($("#personalized-area"), 3, 6 );				
				
				$(document).on("click","[data-upload='photo']", function(e){		
				
					var btn = $(this) ;
					btn.parent().toggleClass('active');
					btn.button('loading');
					common.api.uploadMyImageByUrl({
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
			}
		}]);	
		<!-- ============================== -->
		<!-- create media connect nav buttons                -->
		<!-- ============================== -->				
		function createConnectedSocialNav(){				
			var renderTo = $('#navbar-btn-my-streams');	
			var myConnectBtn = renderTo.find('button[data-action="media-list"]').button('loading');	
			var myConnectDataSource = common.ui.connect.newConnectListDataSource({
				change:function(e){
					var $this = this;
					var template = kendo.template('<label class="btn btn-primary"><input name="selectedSocialConnect" type="checkbox" value="#:socialConnectId#"><i class="fa fa-#= providerId #"></i></label>');
					var html = kendo.render(template, $this.data());
					renderTo.html(html);	
					renderTo.find("label").first().addClass("rounded-bottom-left");
					renderTo.find("label").last().addClass("rounded-bottom-right");
					renderTo.find("input[type=checkbox]").bind("change", function(e){		
						var myConnect = $this.get(this.value);
						if($(this).is(":checked")){
							showMediaPanel(myConnect);
						}else{
							
						}
					});								
				}
			}).read();		
		}	
		<!-- ============================== -->
		<!-- display media stream panel                        -->
		<!-- ============================== -->		
		function showMediaPanel(connect){				
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.panel({ 
				appendTo: appendTo,
				title: "<i class='fa fa-" + connect.providerId + " fa-fw'></i>" + connect.providerId  , 
				actions:["Custom", "Minimize", "Refresh", "Close"],
				data: connect,
				template: kendo.template("<ul class='media-list no-border' style='min-height:150px;'></ul>"),
				close: function(e) {
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialConnectId + '"]').parent().toggleClass("disabled");	
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialConnectId + '"]').parent().toggleClass("active");	
				},
				refresh: function(e){
					var view = e.target.element.find(".panel-body ul.media-list");
					if(view.data("kendoListView")){
						view.data("kendoListView").dataSource.read();
					}
				},
				custom: function(e){
					alert("준비중입니다.");
				},
				open: function(e){
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialConnectId + '"]').parent().toggleClass("disabled");		
					var view = e.target.element.find(".panel-body ul.media-list");
					common.ui.connect.listview( view, connect );
				}
			});	
		}
				
		function mediaEditorSource (media){			
			var modal = $('#media-editor-modal').data("kendoExtModalWindow");			
			if(  typeof media === 'undefined' ){
				if( modal ){
					return modal.data().media
				}else{
					return new SocialNetwork();
				}
			}else{
				if( modal ){
					media.copy( modal.data().media);
				}
			}
		}
		

				
		function displayMediaPanel(media){				
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.panel({ 
				appendTo: appendTo,
				title: "<i class='fa fa-" + media.serviceProviderName + " fa-fw'></i>" + media.serviceProviderName , 
				actions:["Custom", "Minimize", "Refresh", "Close"],
				data: media,
				template: kendo.template("<ul class='media-list'></ul>"),
				close: function(e) {
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("disabled");	
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("active");	
				},
				refresh: function(e){
					var streams = e.target.element.find(".panel-body ul.media-list");
					if( streams.length > 0 && streams.data('kendoExtMediaStreamView') ){
						streams.data('kendoExtMediaStreamView').dataSource.read();
					}
				},
				custom: function(e){
					var modal = common.ui.modal({
						renderTo : "media-editor-modal",
						data: new kendo.data.ObservableObject({
							media : mediaEditorSource(),
							scrollable:false
						}),
						open: function(e){			
							var renderTo = e.target.element;
							var grid = renderTo.find(".modal-body .media-props-grid");		
							var scrollable =  renderTo.find(".modal-body input[name='options-scrollable']");
							if( grid.length > 0 && !grid.data('kendoGrid') ){	
								
								scrollable.on("change", function(e){
									var isSlimscroll = panel.element.find(".panel-body").parent().hasClass("slimScrollDiv");									
									if( this.value == 1 && !isSlimscroll ){									
										panel.element.find(".panel-body").slimscroll({ height: "500px"});
									}else if ( this.value == 0 && isSlimscroll ){
										panel.element.find(".panel-body").slimscroll({ destroy:"destroy" });										
									}
								});							
																	
								grid.kendoGrid({
									dataSource : {		
										transport: { 
											read: { url:'/community/get-my-socialnetwork-property.do?output=json', type:'post' },
											create: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post' },
											update: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post'  },
											destroy: { url:'/community/delete-my-socialnetwork-property.do?output=json', type:'post' },
											parameterMap: function (options, operation){			
										 		if (operation !== "read" && options.models) {
										 			return { socialNetworkId: mediaEditorSource().socialAccountId, items: kendo.stringify(options.models)};
												} 
												return { socialNetworkId: mediaEditorSource().socialAccountId }				
											}									
										},						
										batch: true, 
										schema: {
											data: "socialNetworkProperties",
											model: Property
										},
										error:common.api.handleKendoAjaxError
									},
									columns: [
										{ title: "속성", field: "name" },
										{ title: "값",   field: "value" },
										{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
									],
									pageable: false,
									resizable: true,
									editable : true,
									scrollable: true,
									height: 180,
									autoBind: false,
									toolbar: [
										{ name: "create", text: "추가" },
										{ name: "save", text: "저장" },
										{ name: "cancel", text: "취소" }
									],				     
									change: function(e) {
									}
								});		
							}
							grid.data('kendoGrid').dataSource.read();
						},
						template: kendo.template($("#media-editor-modal-template").html())
					});
					
					if( common.api.property( e.target.data().properties, "options.scrollable", false ) ){
						modal.data().set("scrollable", 1);
					}else{
						modal.data().set("scrollable", 0);
					}
					mediaEditorSource( e.target.data() );					
					modal.open();							
				},
				open: function(e){					
					$('#navbar-btn-my-streams').find('input[value="' + e.target.data().socialAccountId + '"]').parent().toggleClass("disabled");					
					var streams = e.target.element.find(".panel-body ul.media-list");
					if( streams.length > 0 && !streams.data('kendoExtMediaStreamView') ){
						streams.extMediaStreamView({
							id:  e.target.data().socialAccountId,
							media: e.target.data().serviceProviderName,
							change : function(e){		
								streams.find('button.custom-upload-by-url').click(function(e){
									var btn = $(this) ;
									btn.parent().toggleClass('active');
									btn.button('loading');
									common.api.uploadMyImageByUrl({
										data : {sourceUrl: btn.attr('data-source'), imageUrl: btn.attr('data-url')} ,
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
							}
						});
					}
				}
			});			
		}
		
		
		function displayMediaStream(streamsPlaceHolder){					
			var renderToString =  streamsPlaceHolder.serviceProviderName + "-panel-" + streamsPlaceHolder.socialAccountId ;
			var renderToString2 =  streamsPlaceHolder.serviceProviderName + "-streams-" + streamsPlaceHolder.socialAccountId ;				
			if( $("#" + renderToString ).length == 0  ){
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template($("#social-view-panel-template").html());
				$("#personalized-area").append( template( streamsPlaceHolder ) );
				$( '#'+ renderToString ).parent().addClass("col-sm-" + grid_col_size.newValue );	
				common.api.handlePanelHeaderActions( $( '#'+ renderToString), {
					custom : true,
					refresh : function(){
						$( '#'+ renderToString2 ).data('kendoExtMediaStreamView').dataSource.read();
					},
					close : function(){
						$('#navbar-btn-my-streams').find('input[value="' + streamsPlaceHolder.socialAccountId + '"]').click();				
					}
				} );									
				if(! common.api.property(streamsPlaceHolder.properties, "options.scrollable", true ) ){					
					$("#" + renderToString).find(".panel-body:first input[name='options-scrollable']:last").click();
				}				
				$( '#'+ renderToString2 ).extMediaStreamView({ 
					id: streamsPlaceHolder.socialAccountId, 
					media: streamsPlaceHolder.serviceProviderName,
					change : function(e){			
									$( '#'+ renderToString2 ).find('button.custom-upload-by-url').click(function(e){
										var btn = $(this) ;
										btn.parent().toggleClass('active');
										btn.button('loading');
										common.api.uploadMyImageByUrl({
											data : {sourceUrl: btn.attr('data-source'), imageUrl: btn.attr('data-url')} ,
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
					}
				});							
				if( ! $( "#" + renderToString + "-prop-grid" ).data("kendoGrid") ){
					$( "#" + renderToString + "-prop-grid").kendoGrid({
						dataSource : {		
							transport: { 
								read: { url:'/community/get-my-socialnetwork-property.do?output=json', type:'post' },
								create: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post' },
								update: { url:'/community/update-my-socialnetwork-property.do?output=json', type:'post'  },
								destroy: { url:'/community/delete-my-socialnetwork-property.do?output=json', type:'post' },
						 		parameterMap: function (options, operation){			
							 		if (operation !== "read" && options.models) {
							 			return { socialNetworkId: $( '#'+ renderToString2 ).data('kendoExtMediaStreamView').id(), items: kendo.stringify(options.models)};
									} 
									return {socialNetworkId :$( '#'+ renderToString2 ).data('kendoExtMediaStreamView').id() }
									}
								},						
								batch: true, 
								schema: {
									data: "socialNetworkProperties",
									model: Property
								},
								error:common.api.handleKendoAjaxError
							},
							columns: [
								{ title: "속성", field: "name" },
								{ title: "값",   field: "value" },
								{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
							],
							pageable: false,
							resizable: true,
							editable : true,
							scrollable: true,
							height: 180,
							toolbar: [
								{ name: "create", text: "추가" },
								{ name: "save", text: "저장" },
								{ name: "cancel", text: "취소" }
							],				     
							change: function(e) {
							}
					});
				}
			}
			kendo.fx($( '#'+ renderToString ).parent()).zoom("in").startValue(0).endValue(1).play();			
		}
				
		function closeMediaStream(streamsPlaceHolder){		
			var renderToString =  streamsPlaceHolder.serviceProviderName + "-panel-" + streamsPlaceHolder.socialAccountId ;
			kendo.fx($( '#'+ renderToString ).parent()).zoom("in").startValue(0).endValue(1).reverse().then( function(e){
				$("#" + renderToString ).parent().remove();
			});							
		}

		<!-- ============================== -->
		<!-- create info alert 										-->
		<!-- ============================== -->							
		function createInfoPanel(){		
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var renderTo = common.api.guid();
			appendTo.extAlert({
				template :  kendo.template($("#alert-panel-template").html()),
				data : { id: renderTo },
				close : function () {
					$( '#'+ renderTo ).remove();
				}
			});
			kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).play();		
		}	
				
		-->
		</script>		
		<style scoped="scoped">

		
		</style>   	
	</head>
	<body id="doc" class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
		<!-- START HEADER -->		
		<#include "/html/common/common-homepage-menu.ftl" >		
		<!-- END HEADER -->	
		<!-- START MAIN CONTENT -->
		<div class="breadcrumbs breadcrumbs-personalized">
		
		
		
		
				<div class="navbar navbar-personalized navbar-inverse padding-xs" role="navigation" style="top:-4px;">
								<ul class="nav navbar-nav pull-right">
									<li>
										<div id="navbar-btn-my-streams" class="navbar-btn btn-group" data-toggle="buttons">
											<button type="button" class="btn btn-primary rounded-bottom" data-action="media-list" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>미디어</button>
										</div>
									</li>								
									<li class="hidden-xs">
										<p class="navbar-text">레이아웃</p>
										<div class="btn-group navbar-btn" data-toggle="buttons">
											<label class="btn btn-info rounded-bottom-left">
												<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
											</label>
											<label class="btn btn-info active">
										 		<input type="radio" name="personalized-area-col-size" value="6"> <i class="fa fa-th-large"></i>
											</label>
											<label class="btn btn-info rounded-bottom-right">
												<input type="radio" name="personalized-area-col-size" value="4"> <i class="fa fa-th"></i>
											</label>
										</div>
									</li> 		
								</ul>
					</div><!-- ./navbar-personalized -->	
		</div>
		<div id="main-content" class="container-fluid" style="min-height:300px;">			
				<div id="personalized-area" class="row"></div>	
		</div>
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->
		</div>						
		<!-- START TEMPLATE -->	
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
					<h5 class="media-heading">
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
					<img src="#: media.mediaUrl #" width="100%" alt="media" class="img-responsive">
					# } #
										
					<ul class="list-unstyled list-inline text-muted">
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
							<img src="#: photo.sizes[1].url  #" alt="media" class="img-responsive lightbox" style="padding:0px 1px 1px 0px;" data-ride="lightbox">
								<figcaption class="no-padding-hr" style="height:10px;">
									<button type="button" class="btn btn-primary btn-sm rounded-buttom-right custom-upload-by-url" data-upload="photo" data-source="#:postUrl#" data-url="#: photo.sizes[0].url #" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><i class="fa fa-cloud-upload"></i> #if( common.ui.connect.columns(i, totalPhoto) > 4 ){ # My 클라우드로 복사 #}#</button>
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
				<h5 class="media-heading">
					#:from.name#
					#if( to != null ){ # 
					<i class="fa fa-angle-right"></i>  #:to[0].name # 					
					#}# 
					#if( application !=null ){# 
					<span class="label label-success"><i class="fa fa-mobile"></i> #:application.name#  </span> 
					#}#
				</h5> 	
				# if ( story != null ) { #
				<div style="padding-bottom:10px;">						
				<span class="label label-blue rounded"><i class="fa fa-quote-left"></i> #: story # <i class="fa fa-quote-right"></i></span>
				</div>
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
			
					#if ( likes.length > 0  ) { #
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