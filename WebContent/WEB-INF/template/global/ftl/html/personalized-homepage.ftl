<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!${request.contextPath}/styles/codedrop/cbpSlidePushMenus.css',
			'css!${request.contextPath}/styles/codedrop/codedrop.overlay.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',	
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/pdfobject/pdfobject.js',
			'${request.contextPath}/js/common/common.modernizr.custom.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'],
			complete: function() {			
			
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
				
				// 2.  MEUN 설정
				var slide_effect = kendo.fx($("body div.overlay")).fadeIn();																																													
				$("#personalized-area").data("sizePlaceHolder", { oldValue: 6 , newValue : 6} );	
				common.api.handleNavbarActions( $('.personalized-navbar'), {
					handlers : [
						{ selector: "input[name='personalized-area-col-size']",
						  event : 'change',
						  handler : function(){
							var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
							grid_col_size.oldValue = grid_col_size.newValue;
							grid_col_size.newValue = this.value;			
							$(".custom-panels-group").each(function( index ) {
								var custom_panels_group = $(this);				
								custom_panels_group.removeClass("col-sm-" + grid_col_size.oldValue );		
								custom_panels_group.addClass("col-sm-" + grid_col_size.newValue );		
							});
						  }	
						}
					],
					onClick : function (e) {												
						if( $(this).hasClass('custom-nabvar-hide')){
							$('body nav').first().removeClass('hide');
						}else if ($(this).hasClass('custom-nabvar-up')){ 
						
						}else if ($(this).hasClass('custom-nabvar-down')){ 
						
						}else if ($(this).hasClass('custom-nabvar-show-opts')){ 
							$('body').toggleClass('modal-open');						
							if( $('#personalized-controls-section').hasClass("hide") )
								$('#personalized-controls-section').removeClass("hide");							
							$('body div.overlay').toggleClass('hide');							
							slide_effect.play().then(function(){							
								$('#personalized-controls-section').toggleClass('cbp-spmenu-open');
							});	
						}
					}
				});				
				$("#personalized-controls-menu-close").on( "click" , function(e){						
					$('body').toggleClass('modal-open');		
					$('#personalized-controls-section').toggleClass('cbp-spmenu-open');					
					setTimeout(function() {
						slide_effect.reverse().then(function(){
							$('body div.overlay').toggleClass('hide');
						});
					}, 100);					
				});
								
				// photo panel showing				
				createPhotoListView();
								
				$('#photo-list-view').data('kendoListView').one('dataBound', function(){
					this.select(this.element.children().first());
				});

				// 3. ACCOUNTS LOAD	
				var currentUser = new User({});			
				var accounts = $("#account-navbar").kendoAccounts({				
					connectorHostname: "${ServletUtils.getLocalHostAddr()}",	
					authenticate : function( e ){
						currentUser = e.token;
						if(!currentUser.anonymous){							
							$('body nav').first().addClass('hide');
						}
					},
					shown : function(e){
						$('#account-navbar').append('<li><a href="#&quot;" class="btn-link custom-nabvar-hide"><img src="${request.contextPath}/images/cross.png" height="18"></a></li>' );	
						$('#account-navbar li a.custom-nabvar-hide').on('click', function(){
							$('body nav').first().addClass('hide');
						});	
					},
					<#if CompanyUtils.isallowedSignIn(action.company) ||  !action.user.anonymous  || action.view! == "personalized" >
					template : kendo.template($("#account-template").html()),
					</#if>
					afterAuthenticate : function(){													
						var validator = $("#login-navbar").kendoValidator({validateOnBlur:false}).data("kendoValidator");						
						$("#login-btn").click( function() { 
							$("#login-status").html("");
							if( validator.validate() )
							{								
								accounts.login({
									data: $("form[name=login-form]").serialize(),
									success : function( response ) {
										var refererUrl = "/main.do";
										if( response.item.referer ){
											refererUrl = response.item.referer;
										}
										$("form[name='login-form']")[0].reset();    
										$("form[name='login-form']").attr("action", refererUrl ).submit();						
									},
									fail : function( response ) {  
										$("#login-password").val("").focus();												
										$("#login-status").kendoAlert({ 
											data : { message: "입력한 사용자 이름 또는 비밀번호가 잘못되었습니다." },
											close : function(){	
												$("#login-password").focus();										
											}
										}); 										
									},		
									error : function( thrownError ) {
										$("form[name='login-form']")[0].reset();                    
										$("#login-status").kendoAlert({ data : { message: "잘못된 접근입니다." } }); 									
									}																
								});															
							}else{	}
						});	
					}
				});	
				
				// 4. CONTENT 	
				
				// 1. Announces 							
				$("#announce-panel").data( "announcePlaceHolder", new Announce () );	
				createNoticeGrid();
																			
				// 4. Right Tabs								
				$('#myTab').on( 'show.bs.tab', function (e) {
					//e.preventDefault();		
					var show_bs_tab = $(e.target);
					if( show_bs_tab.attr('href') == '#my-notice' ){						
						createNoticeGrid();											
					} else if( show_bs_tab.attr('href') == '#my-files' ){					
						createAttachmentListView();
					} else if(show_bs_tab.attr('href') == '#my-photo-stream' ){					
						createPhotoListView();
					}					
				});

				$('#myTab a:first').tab('show') ;
				// END SCRIPT 
			}
		}]);	
						
		function createAttachmentListView(){			
			if( !$('#attachment-list-view').data('kendoListView') ){														
				var attachementTotalModle = kendo.observable({ 
					totalAttachCount : "0",
					totalImageCount : "0",
					totalFileCount : "0"							
				});							
				kendo.bind($("#attachment-list-filter"), attachementTotalModle );													
					$("#attachment-list-view").kendoListView({
						dataSource: {
							type: 'json',
							transport: {
								read: { url:'${request.contextPath}/community/list-my-attachement.do?output=json', type: 'POST' },		
								destroy: { url:'${request.contextPath}/community/delete-my-attachment.do?output=json', type:'POST' },                                
								parameterMap: function (options, operation){
									if (operation != "read" && options) {										                        								                       	 	
										return { attachmentId :options.attachmentId };									                            	
									}else{
										 return { startIndex: options.skip, pageSize: options.pageSize }
									}
								}
							},
							pageSize: 12,
							error:common.api.handleKendoAjaxError,
							schema: {
								model: Attachment,
								data : "targetAttachments",
								total : "totalTargetAttachmentCount"
							},
							sort: { field: "attachmentId", dir: "desc" },
							filter :  { field: "contentType", operator: "neq", value: "" }
						},
						selectable: "single",									
						change: function(e) {									
							var data = this.dataSource.view() ;
							var item = data[this.select().index()];		
							$("#attachment-list-view").data( "attachPlaceHolder", item );												
							displayAttachmentPanel( ) ;	
						},
						navigatable: false,
						template: kendo.template($("#attachment-list-view-template").html()),								
						dataBound: function(e) {
							var attachment_list_view = $('#attachment-list-view').data('kendoListView');
							var filter =  attachment_list_view.dataSource.filter().filters[0].value;
							var totalCount = attachment_list_view.dataSource.total();
							if( filter == "image" ) 
							{
								attachementTotalModle.set("totalImageCount", totalCount);
							} else if ( filter == "application" ) {
								attachementTotalModle.set("totalFileCount", totalCount);
							} else {
								attachementTotalModle.set("totalAttachCount", totalCount);
							}
						}
					});																	
				
					$("#attachment-list-view").on("mouseenter",  ".img-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
					}).on("mouseleave", ".img-wrapper", function(e) {
						kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
					});															
														
					$("input[name='attachment-list-view-filters']").on("change", function () {
						var attachment_list_view = $('#attachment-list-view').data('kendoListView');
						switch(this.value){
							case "all" :
								attachment_list_view.dataSource.filter(  { field: "contentType", operator: "neq", value: "" } ) ; 
								break;
							case "image" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "image" }) ; 
								break;
							case "file" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "application" }) ; 
								break;
						}
					});
							
					$("#pager").kendoPager({
						refresh : true,
						buttonCount : 5,
						dataSource : $('#attachment-list-view').data('kendoListView').dataSource
					});								

					common.ui.handleActionEvents(
						$("#my-files .btn-group button"), 
						{
							event:'click',
							handler : function(e){
								var btn_icon = $(this).find("i");		
								if( btn_icon.hasClass('fa-cloud-upload') ){								
									if( !$('#attachment-files').data('kendoUpload') ){		
										$("#attachment-files").kendoUpload({
										 	multiple : false,
										 	width: 300,
										 	showFileList : false,
										    localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
										    async: {
												saveUrl:  '${request.contextPath}/community/save-my-attachments.do?output=json',							   
												autoUpload: true
										    },
										    upload: function (e) {								         
										    	 e.data = {};														    								    	 		    	 
										    },
										    success : function(e) {								    
												if( e.response.targetAttachment ){
													e.response.targetAttachment.attachmentId;
													// LIST VIEW REFRESH...
													$('#attachment-list-view').data('kendoListView').dataSource.read(); 
												}				
											}
										});						
									}
									$("#my-files .custom-upload").toggleClass("hide");					
								}
							} 
						}							
					);							
			}		
		}
		
		<!-- ============================== -->
		<!-- create my photo grid									-->
		<!-- ============================== -->						
		function createPhotoListView(){
			if( !$('#photo-list-view').data('kendoListView') ){			
				$("#photo-list-view").kendoListView({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/community/list-my-image.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { imageId :options.imageId };									                            	
											}else{
												 return { startIndex: options.skip, pageSize: options.pageSize }
											}
										}
									},
									pageSize: 12,
									error:common.api.handleKendoAjaxError,
									schema: {
										model: Image,
										data : "targetImages",
										total : "totalTargetImageCount"
									},
									serverPaging: true
								},
								selectable: "single",									
								change: function(e) {									
									var data = this.dataSource.view() ;
									var current_index = this.select().index();
									var total_index = this.dataSource.view().length -1 ;
									var list_view_pager = $("#photo-list-pager").data("kendoPager");	
									var item = data[current_index];			
									item.manupulate();								
									common.api.pager(item, current_index,total_index, list_view_pager.page(), list_view_pager.totalPages());
									$("#photo-list-view").data( "photoPlaceHolder", item );														
									displayPhotoPanel( ) ;										
								},
								navigatable: false,
								template: kendo.template($("#photo-list-view-template").html()),								
								dataBound: function(e) {;		
								}
				});								
																	
				$("#photo-list-view").on("mouseenter",  ".img-wrapper", function(e) {
					kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
				}).on("mouseleave", ".img-wrapper", function(e) {
					kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
				});		
																
				$("#photo-list-pager").kendoPager({
					refresh : true,
					buttonCount : 5,
					dataSource : $('#photo-list-view').data('kendoListView').dataSource
				});		
					
				common.ui.handleActionEvents(
					$("#my-photo-stream .btn-group button"), 
					{
						event:'click',
						handler : function(e){
							var btn_icon = $(this).find("i");		
							if( btn_icon.hasClass('fa-cloud-upload') ){
							
										if( !$("#photo-files").data("kendoUpload")	){						
											$("#photo-files").kendoUpload({
												 	multiple : true,
												 	width: 300,
												 	showFileList : false,
												    localization:{ select : '사진 선택' , dropFilesHere : '업로드할 사진들을 이곳에 끌어 놓으세요.' },
												    async: {
														saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',							   
														autoUpload: true
												    },
												    upload: function (e) {				
												    	 e.data = {};							
												    },
												    success : function(e) {								    
														if( e.response.targetImage ){
															//e.response.targetImage.imageId;
															// LIST VIEW REFRESH...
															var photo_list_view = $('#photo-list-view').data('kendoListView');
															photo_list_view.dataSource.read();
															var selectedCells = photo_list_view.select();
															photo_list_view.select("tr:eq(1)");															
														}				
													}
											});		
										}
										$("#my-photo-stream .custom-upload").toggleClass("hide");					
							}
						} 
					}							
				);
			}
		}
		<!-- ============================== -->
		<!-- create notice grid									-->
		<!-- ============================== -->								
		function createNoticeGrid(){
			if( !$("#announce-grid").data('kendoGrid') ){				
				$("#announce-grid").data('announceSourcePlaceHolder', 30);
				$("#announce-grid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport: {
							read: {
								type : 'POST',
								dataType : "json", 
								url : '${request.contextPath}/community/list-announce.do?output=json'
							},
							parameterMap: function(options, operation) {
								if (operation != "read" && options.models) {
									return {models: kendo.stringify(options.models)};
								}else{								
									return {objectType: $("#announce-grid").data('announceSourcePlaceHolder') };								
								}
							} 
						},
						pageSize: 10,
						error:common.api.handleKendoAjaxError,
						schema: {
							data : "targetAnnounces",
							model : Announce,
							total : "totalAnnounceCount"
						}
					}),
					sortable: true,
					columns: [ 
						{field:"creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}", attributes: { "class": "table-cell", style: "text-align: center " }} ,
						{field:"subject", title: "제목"}
					],
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },									
					selectable: "row",
					change: function(e) { 
						var selectedCells = this.select();
						if( selectedCells.length > 0){
							var selectedCell = this.dataItem( selectedCells );	    							
							var announcePlaceHolder = $("#announce-panel").data( "announcePlaceHolder" );
							announcePlaceHolder.announceId = selectedCell.announceId;
							announcePlaceHolder.subject = selectedCell.subject;
							announcePlaceHolder.body = selectedCell.body;
							announcePlaceHolder.startDate = selectedCell.startDate ;
							announcePlaceHolder.endDate = selectedCell.endDate;
							announcePlaceHolder.modifiedDate = selectedCell.modifiedDate;
							announcePlaceHolder.creationDate = selectedCell.creationDate;
							announcePlaceHolder.user = selectedCell.user;							
							if( announcePlaceHolder.user.userId == $("#account-navbar").data("currentUser").userId ){
								announcePlaceHolder.modifyAllowed = true;
							}else{
								announcePlaceHolder.modifyAllowed = false;
							}
							$("#announce-panel").data( "announcePlaceHolder", announcePlaceHolder );							 
							showAnnouncePanel();	
						}
					},
					dataBound: function(e) {					
						//var selectedCells = this.select();
						//this.select("tr:eq(1)");						
					}
				});		

/**
				$("#my-notice .btn-group button").each(function( index ) { 
					var control_button = $(this);								
					var control_button_icon = control_button.find("i");				
					if (control_button_icon.hasClass("fa-plus")){
						control_button.click( function(e){								
							// editer start .....																		
							if( $( "#announce-creator" ).children().length < 1 ){
								$("#announce-creator").data( "announcePlaceHolder" , new Announce() );	
								var announcePlaceHolder = $("#announce-creator").data( "announcePlaceHolder" );	
								var template = kendo.template($('#announcement-edit-template').html());
								$("#announce-creator").html( template(announcePlaceHolder) );
								kendo.bind($("#announce-creator"), announcePlaceHolder );			
								createEditor($("#announce-creator .editor"));	
								$("#announce-creator div button").each(function( index ) {			
									var panel_button = $(this);			
									if( panel_button.hasClass( 'custom-update') ){
										panel_button.click(function (e) { 
											e.preventDefault();					
											var data = $("#announce-creator").data( "announcePlaceHolder" );												
											var hasError = false;
											if( data.subject == null || data.subject == '' ){
												hasError = true;
											}											
											if( data.body == null || data.body == '' ){
												hasError = true;
											}											
											if( hasError ) {
												$("#announce-creator .form-group").addClass("has-error");
												var template = kendo.template('<div class="alert alert-danger">#:message#</div>');
												$("#announce-creator .status").html(template({message: "모든 항목을 입력하여 주세요. " }));
											}
											if( !hasError ) {											
												$.ajax({
													dataType : "json",
													type : 'POST',
													url : '${request.contextPath}/community/update-announce.do?output=json',
													data : { announceId: data.announceId, item: kendo.stringify( data ) },
													success : function( response ){		
														$('#announce-grid').data('kendoGrid').dataSource.read();	
														$("#my-notice .btn-group button").first().click();
													},
													error:common.api.handleKendoAjaxError
												});				
											}							
										} );
									}			
								} );									
							}else{
								$("#announce-creator .form-group").removeClass("has-error");
								$("#announce-creator .status").html("");
								$("#announce-creator").data( "announcePlaceHolder" ).reset();	
							}
							$("#my-notice .side1").toggleClass("hide");
							$("#my-notice .side2").toggleClass("hide");
						});						
					}else if (control_button_icon.hasClass("fa-th-list")){
						control_button.click( function(e){										
							$("#my-notice .side2").toggleClass("hide");
							$("#my-notice .side1").toggleClass("hide");
						});								
					}
				});		
				**/
				
				common.api.handlePanelHeaderActions($("#announce-panel"));
				common.ui.handleActionEvents( $('input[name="announce-selected-source"]'), { event: 'change' , handler: function(e){				
					var oldSelectedSource = $("#announce-grid").data('announceSourcePlaceHolder');
					if( oldSelectedSource != this.value ){
						$("#announce-grid").data('announceSourcePlaceHolder', this.value );
						$("#announce-grid").data('kendoGrid').dataSource.read();
						//$("#announce-view").html("");		
					}					
				}});
				
				$('#announce-panel .panel-body button.custom-add').click(function(e){
					$("#announce-panel").data( "announcePlaceHolder" ).reset();
					$("#announce-panel").data( "announcePlaceHolder" ).objectType = $("#announce-grid").data('announceSourcePlaceHolder');
					createAnnounceEditor();
				});		
				$("#announce-panel" ).show();
			}	
		}	
				
		function showAnnouncePanel (){		
			var announcePlaceHolder = $("#announce-panel").data( "announcePlaceHolder" );
			var template = kendo.template($('#announcement-view-template').html());			
			$("#announce-view").html( template(announcePlaceHolder) );				
			kendo.bind($("#announce-view"), announcePlaceHolder );			
			
			if( announcePlaceHolder.editable ){							
				$("#announce-view button[class*=custom-edit]").click( function (e){	
					createAnnounceEditor();	
				} );			
			}						
			$("#announce-view button[class*=custom-list]").click( function (e){
					$('html,body').animate({ scrollTop:  0 }, 300);
			} );									
			$('html,body').animate({scrollTop: $("#announce-view").offset().top - 80 }, 300);			 
		}
						
		function createAnnounceEditor(){			
			if( $('#announce-editor').text().trim().length == 0 ){					
				$('#announce-editor').data("announcePlaceHolder", new Announce({}));	
				var announceEditorTemplate = kendo.template($('#announcement-editor-template').html());	
				$('#announce-editor').html( announceEditorTemplate );					
				kendo.bind($('#announce-editor'), $('#announce-editor').data("announcePlaceHolder") );					
				if($('#announce-editor').data("announcePlaceHolder").objectType == 1){
					$('#announce-editor input[name="announce-type"]:first').select();
				}else{
					$('#announce-editor input[name="announce-type"]:last').select();
				}
				createEditor($("#announce-editor .editor"));	
				var announce_editor_update = $('#announce-editor .modal-footer .btn.custom-update');								
				$('#announce-editor').data("announcePlaceHolder").bind( 'change', function(e){
					if( e.field != "objectType" ){
						announce_editor_update.removeAttr('disabled');
					}					
					
					//alert( kendo.stringify( e ) );
				});							
				announce_editor_update.click(function(e){
					e.preventDefault();
					$.ajax({
						dataType : "json",
						type : 'POST',
						url : '${request.contextPath}/community/update-announce.do?output=json',
						data : { objectType: $("#announce-grid").data('announceSourcePlaceHolder'), item: kendo.stringify( $("#announce-editor").data( "announcePlaceHolder" ) ) },
						success : function( response ){						
							
							$("#announce-grid").data('kendoGrid').dataSource.read();
							$("#announce-view").html("");
							$('#announce-editor .modal').modal('hide');
						},
						error:common.api.handleKendoAjaxError
					});
				});						
			}
			// save button disable.. 		
			var announcePlaceHolder = $("#announce-panel").data( "announcePlaceHolder" );				
			announcePlaceHolder.copy( $('#announce-editor').data("announcePlaceHolder")) ; 			
			$('#announce-editor .modal-footer .btn.custom-update').attr('disabled', 'disabled');				
			$('#announce-editor .modal').modal('show');
		}		

		function createEditor( renderTo ){
			if(!renderTo.data("kendoEditor") ){			
				var imageBrowser = $('#image-broswer').extImageBrowser({
					template : $("#image-broswer-template").html(),
					apply : function(e){						
					alert( e );
						renderTo.data("kendoEditor").exec("inserthtml", { value : e.html } );
						imageBrowser.close();
					}
				});				
				renderTo.kendoEditor({
						tools : [
							'bold',
							'italic',
							'insertUnorderedList',
							'insertOrderedList',
							'createLink',
							'unlink',
							{	
								name: "insertImage",
								exec: function(e){
									imageBrowser.show();
									return false;
								}
							},
							{	
								name: "viewHtml"
							}
						],
						stylesheets: [
							"${request.contextPath}/styles/bootstrap/3.1.0/bootstrap.min.css",
							"${request.contextPath}/styles/common/common.ui.css"
						]
					});
				}		
		}
		
		
		
		function editAnnouncePanel (){		
			var announcePlaceHolder = $("#announce-panel").data( "announcePlaceHolder" );		
			if( announcePlaceHolder.modifyAllowed ){						
				var template = kendo.template($('#announcement-edit-template').html());
				$("#announce-view").html( template(announcePlaceHolder) );	
				kendo.bind($("#announce-view"), announcePlaceHolder );		
				createEditor($("#announce-panel .editor"));		
				$("#announce-view div button").each(function( index ) {			
					var panel_button = $(this);			
					if( panel_button.hasClass( 'custom-update') ){
						panel_button.click(function (e) { 
							e.preventDefault();					
							var data = $("#announce-panel").data( "announcePlaceHolder" );								
							//alert( kendo.stringify( data ) );
							$.ajax({
									dataType : "json",
									type : 'POST',
									url : '${request.contextPath}/community/update-announce.do?output=json',
									data : { announceId: data.announceId, item: kendo.stringify( data ) },
									success : function( response ){		
										showAnnouncePanel();
									},
									error:common.api.handleKendoAjaxError
							});	
						} );
					}else if ( panel_button.hasClass('custom-delete') ){
						panel_button.click(function (e) { 
							e.preventDefault();
							if( confirm("삭제하시겠습니까 ?") ) {
							}
						} );
					}else if ( panel_button.hasClass('custom-cancle') ){
						panel_button.click(function (e) { 
							showAnnouncePanel();
						} );
					}			
				} );							
			}
		}
		
		
		/**
		function createPanel(){					
			var renderTo = ui.generateGuid();
			var grid_col_size = $("#personalized-area").data("sizePlaceHolder");			
			var template = kendo.template($("#empty-panel-template").html());	
			$("#personalized-area").append( template( { id: renderTo, colSize: grid_col_size.newValue } ) );
			$( '#'+ renderTo + ' .panel-header-actions a').each(function( index ) {
				var panel_header_action = $(this);
				panel_header_action.click(function (e){
					e.preventDefault();		
					var panel_header_action_icon = panel_header_action.find('span');
					switch( panel_header_action_icon.text() )
					{
						case "Minimize" :
							$( "#"+ renderTo +" .panel-body").toggleClass("hide");		
							panel_header_action.toggleClass("hide");		
							break;
						case "Refresh" :
							break;
						case "Close" :							
							kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).reverse().then( function(e){							
								$("#" + renderTo ).remove();
							});							
							break;	
						case "Custom" :
							break;																		
					}
				});		
			});					
			kendo.fx($( '#'+ renderTo )).zoom("in").startValue(0).endValue(1).play();
		}						
			**/
								

		<!-- ============================== -->
		<!-- display attachement panel                          -->
		<!-- ============================== -->			
		function displayAttachmentPanel(){			
		
			var renderToString =  "attachement-panel-0";	
			var attachPlaceHolder = $("#attachment-list-view").data( "attachPlaceHolder" );		
			
			if( $("#" + renderToString ).length == 0  ){			
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template('<div id="#: panelId #" class="custom-panels-group col-sm-#: colSize#" style="display:none;"></div>');				
				$("#personalized-area").append( template( {panelId:renderToString, colSize: grid_col_size.newValue } ) );	
			}	
						
			if( !$( "#" + renderToString ).data("extPanel") ){					
				$("#" + renderToString ).data("extPanel", 
					$("#" + renderToString ).extPanel({
						template : kendo.template($("#file-panel-template").html()),
						data : attachPlaceHolder,
						refresh : true, 
						afterChange : function ( data ){
							if( data.contentType == "application/pdf" ){
								var loadSuccess = new PDFObject({ url: "${request.contextPath}/community/view-my-attachment.do?attachmentId=" + data.attachmentId, pdfOpenParams: { view: "FitV" } }).embed("pdf-view");				
							}		
							
							$("#update-attach-file").kendoUpload({
								multiple: false,
								async: {
									saveUrl:  '${request.contextPath}/community/update-my-attachment.do?output=json',							   
									autoUpload: true
								},
								localization:{ select : '파일 변경하기' , dropFilesHere : '새로운 파일을 이곳에 끌어 놓으세요.' },	
								upload: function (e) {				
									e.data = { attachmentId: $("#attach-view-panel").data( "attachPlaceHolder").attachmentId };														    								    	 		    	 
								},
								success: function (e) {				
									if( e.response.targetAttachment ){
										 $("#attach-view-panel").data( "attachPlaceHolder",  e.response.targetAttachment  );
										kendo.bind($("#attach-view-panel"), e.response.targetAttachment );
									}
								} 
							});												
						},
						commands:[
							{ selector :   "#" + renderToString + " .panel-body:first .btn", 
							  handler : function(e){
								e.preventDefault();
								var _ele = $(this);
								if( _ele.hasClass( 'custom-delete') ){
									alert( $("#attachment-list-view").data( "attachPlaceHolder" ).attachmentId );
									/**
									$.ajax({
										dataType : "json",
										type : 'POST',
										url : '${request.contextPath}/community/delete-my-attachment.do?output=json',
										data : { attachmentId: attachPlaceHolder.attachmentId },
										success : function( response ){
											$('#' + renderToString ).remove();
										},
										error:common.api.handleKendoAjaxError
									});
									*/								
								}
							}}
						]
					})
				 );				 
			}else{
				$("#" + renderToString ).data("extPanel").data(attachPlaceHolder);
			}			
			//CHANGE
			var panel = $("#" + renderToString ).data("extPanel");
			panel.show();		
		}	
						
		<!-- ============================== -->
		<!-- display photo  panel                                  -->
		<!-- ============================== -->
				
		function displayPhotoPanel(){					
			var renderToString =  "photo-panel-0";	
			var photoPlaceHolder = $("#photo-list-view").data( "photoPlaceHolder");		
			if( $("#" + renderToString ).length == 0  ){			
				var grid_col_size = $("#personalized-area").data("sizePlaceHolder");
				var template = kendo.template('<div id="#: panelId #" class="custom-panels-group col-sm-#: colSize#" style="display:none;"></div>');				
				$("#personalized-area").append( template( {panelId:renderToString, colSize: grid_col_size.newValue } ) );	
			}				
			
			if( !$("#" + renderToString ).data("extPanel") ){					
				$("#" + renderToString ).data("extPanel", 
					$("#" + renderToString ).extPanel({
						template : kendo.template($("#photo-panel-template").html()),
						data : photoPlaceHolder,
						commands:[
							{ selector :   "#" + renderToString + " .panel-body:first .btn", 
							  handler : function(e){
								e.preventDefault();
								var _ele = $(this);
								if( _ele.hasClass( 'custom-delete') ){
									//alert( $("#photo-list-view").data( "photoPlaceHolder").imageId );
									/**
									$.ajax({
										dataType : "json",
										type : 'POST',
										url : '${request.contextPath}/community/delete-my-image.do?output=json',
										data : { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId },
										success : function( response ){
											$("#" + renderToString ).remove();
										},
										error:common.api.handleKendoAjaxError
									});
									*/								
								}
							}}
						],						
					}).bind('open', function( e ) {
						// start open event handler  	
						common.api.streams.details({
							imageId : $("#photo-list-view").data( "photoPlaceHolder").imageId ,
							success : function( data ) {
								if( data.photos.length > 0 ){
									$("#photo-list-view").data( "photoPlaceHolder").shared = true ;
									$("input[name='photo-public-shared']").first().click();
								}else{
									$("#photo-list-view").data( "photoPlaceHolder").shared = false ;
									$("input[name='photo-public-shared']").last().click();
								}
							}
						});						
						if( ! $('#photo-prop-grid').data("kendoGrid") ){
							$('#photo-prop-grid').kendoGrid({
								dataSource : {		
									transport: { 
										read: { url:'/community/get-my-image-property.do?output=json', type:'post' },
										create: { url:'/community/update-my-image-property.do?output=json', type:'post' },
										update: { url:'/community/update-my-image-property.do?output=json', type:'post'  },
										destroy: { url:'/community/delete-my-image-property.do?output=json', type:'post' },
								 		parameterMap: function (options, operation){			
									 		if (operation !== "read" && options.models) {
									 			return { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId, items: kendo.stringify(options.models)};
											} 
											return { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId }
										}
									},						
									batch: true, 
									schema: {
										data: "targetImageProperty",
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
						// start open event handler 
					})													
				);	

				$("input[name='photo-public-shared']").on("change", function () {
					var newValue = ( this.value == 1 ) ;
					var oldValue =  $("#photo-list-view").data( "photoPlaceHolder").shared ;					
					if( oldValue != newValue){
						if(newValue){
							common.api.streams.add({
								imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});							
						}else{
							common.api.streams.remove({
								imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId,
								success : function( data ) {
									kendo.stringify(data);
								}
							});					
						}
					}					
				});												
				$("#update-photo-file").kendoUpload({
					showFileList: false,
					multiple: false,
					async: {
						saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',
						autoUpload: true
					},
					localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
					upload: function (e) {				
						e.data = { imageId: $("#photo-list-view").data( "photoPlaceHolder").imageId };
					},
					success: function (e) {				
						if( e.response.targetImage ){
							$('#photo-list-view').data('kendoListView').dataSource.read();								
							var item = e.response.targetImage;
							item.index = $("#photo-list-view").data( "photoPlaceHolder" ).index;			
							item.page = $("#photo-list-view").data( "photoPlaceHolder" ).page;		
							// need fix!!
							$("#photo-list-view").data( "photoPlaceHolder",  item );
							displayPhotoPanel();
						}
					} 
				});																
				var overlay  = $("#" + renderToString ).find('.overlay').extOverlay();					
				// start define over nav events				
				common.ui.handleActionEvents( $("#" + renderToString ), {
					handlers : [
						{selector: ".panel-body:last >figure", event : 'click', handler : function(e){
							e.preventDefault();
							overlay.toggleOverlay();
						}},						
						{selector: ".overlay  a.btn", event : 'click', handler : function(e){
							e.preventDefault();
							var _command = $(this);
							if( _command.hasClass('custom-previous') ){
								previousPhoto();
							}else if ( _command.hasClass('custom-next') ) {
								nextPhoto();
							}
						}},
						{selector: ".overlay  input[name='lightning-box-photo-scale']", event : 'change', handler : function(e){
							e.preventDefault();		
							var newValue = this.value ;
							var _img = $("#" + renderToString ).find(".panel-body:last figure.img-full-width img");
							if( newValue == 0 ){
								if( _img.hasClass('img-full-height') )
									_img.removeClass('img-full-height'); 		
								if( _img.hasClass('img-full-width') )
									_img.removeClass('img-full-width'); 			
								_img.addClass('img-fit-screen-width'); 										
							}else if ( newValue == 1 ) {
								if( _img.hasClass('img-full-height') )
									_img.removeClass('img-full-height'); 			
								if( _img.hasClass('img-fit-screen-width') )
									_img.removeClass('img-fit-screen-width'); 															
								_img.addClass('img-full-width');								
							}else if ( newValue == 2 ){
								if( _img.hasClass('img-full-width') )
									_img.removeClass('img-full-width'); 			
								if( _img.hasClass('img-fit-screen-width') )
									_img.removeClass('img-fit-screen-width'); 																
								_img.addClass('img-full-height');
							}
						}}						
					]
				});				
			}else{
				$("#" + renderToString ).data("extPanel").data(photoPlaceHolder);
				kendo.bind($("#" + renderToString ).data("extPanel").body(), $("#" + renderToString ).data("extPanel").data());
			}			
			var panel = $("#" + renderToString ).data("extPanel");
			panel.show();			
		}	
												
		function previousPhoto (){
			var listView =  $('#photo-list-view').data('kendoListView');
			var list_view_pager = $("#photo-list-pager").data("kendoPager");			
			var current_index = $("#photo-list-view").data("photoPlaceHolder").index;
			var total_index = listView.dataSource.view().length -1 ;
			var current_page = list_view_pager.page();		
			var total_page = list_view_pager.totalPages();	
			if( current_index == 0 && current_page > 1 ){
				listView.one('dataBound', function(){
					if( $("#photo_overlay.open").length  > 0 ){
						var previous_index = this.dataSource.view().length -1;
						var item = this.dataSource.view()[previous_index];
						item.manupulate();
						common.api.pager( item, previous_index, previous_index, current_page - 1, total_page );	
						$("#photo-list-view").data( "photoPlaceHolder", item );
						displayPhotoPanel( );
					}
				});
				list_view_pager.page(current_page - 1);
			}else{
				var previous_index = current_index - 1;
				var item = listView.dataSource.view()[previous_index];		
				item.manupulate();
				common.api.pager( item, previous_index, total_index, current_page, total_page );
				$("#photo-list-view").data( "photoPlaceHolder", item );
				displayPhotoPanel( );
			}
		}
		
		function nextPhoto (){
			var listView =  $('#photo-list-view').data('kendoListView');
			var list_view_pager = $("#photo-list-pager").data("kendoPager");			
			var current_index = $("#photo-list-view").data( "photoPlaceHolder").index;
			var total_index = listView.dataSource.view().length -1 ;
			var current_page = list_view_pager.page();		
			var total_page = list_view_pager.totalPages();						
			if( current_index == total_index && ( total_page - current_page ) > 0 )	{		
				listView.one('dataBound', function(){
					if( $("#photo_overlay.open").length  > 0 ){
						var item = this.dataSource.view()[0];
						item.manupulate();
						common.api.pager( item, 0, this.dataSource.view().length -1, current_page + 1, total_page );	
						$("#photo-list-view").data( "photoPlaceHolder", item );
						displayPhotoPanel( );
					}
				});
				list_view_pager.page(current_page + 1);			
			}else{
				var next_index = current_index + 1;				
				var item = listView.dataSource.view()[next_index];
				item.manupulate();
				common.api.pager( item, next_index, total_index, current_page, total_page );
				$("#photo-list-view").data( "photoPlaceHolder", item );
				displayPhotoPanel( );
			}
		}
					
		-->
		</script>		
		<style scoped="scoped">
		
		#announce-grid .k-grid-content {
			min-height : 300px;
		}
		
		#pdf-view {
			height: 500px;
			margin: 0 auto;
			border: 0px solid #787878;
		}
		
		#pdf-view p {
		   padding: 1em;
		}
		
		#pdf-view object {
		   display: block;
		   border: solid 1px #787878;
		}		
		
		.attach
		{
			float: left;
			position: relative;
			width: 160px;
			height: 160px;
			padding: 0;
			cursor: pointer;
			overflow: hidden;
		}
		
		.attach img
		{
			width: 160px;
			height: 160px;
		}
				
		.attach-description {
			position: absolute;
			top: 0;
			width: 160px	;
			height: 0;
			overflow: hidden;
			background-color: rgba(0,0,0,0.8)
		}
	
		.attach h3
		{
			margin: 0;
			padding: 10px 10px 0 10px;
			line-height: 1.1em;
			font-size : 12px;
			font-weight: normal;
			color: #ffffff;
			word-wrap: break-word;
		}

		.attach p {
			color: #ffffff;
			font-weight: normal;
			padding: 0 10px;
			font-size: 12px;
        }
		
		/** image grid  */		
		#photo-list-view.k-listview ,#attachment-list-view.k-listview {
			width: 100%;
			padding: 0px;
			border: 0px;		
			min-height: 200px;
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

		
		.image-broswer .img-wrapper.k-state-selected img {
			border-bottom: 5px solid #FF2A68;
			-webkit-transition: all .2s ease-in-out;
			transition: all .2s ease-in-out;
			position: relative;
			margin-top: -5px;
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
            color: #ffffff;
            word-wrap: break-word;
		}

		.img-wrapper p {
			color: #ffffff;
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

				

		table.k-editor {
			height: 400px;
		}
		
		.k-editor-inline {
			margin: 0;
			#padding: 21px 21px 11px;
			border-width: 0;
			box-shadow: none;
			background: none;
		}

		.k-editor-inline.k-state-active {
			border-width: 1px;
			#padding: 20px 20px 10px;
			#background: none;
			#border-color : red;
  			border-color: #66afe9;
			#  outline: 0;
			-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(102, 175, 233, 0.6);
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(102, 175, 233, 0.6);
		}

		.inline-column-editor {
			display: inline-block;
			vertical-align: top;
			max-width: 600px;
			width: 100%;
		}
				
		#personalized-controls {
			position: absolute;
			top: 50px;
			left:0;
			min-height: 300px;
			padding: 10px;
			width: 100%;
			z-index: 1000;
			overflow: hidden;
			background-color: rgba(91,192,222,0.8)		
		}		
		
		#personalized-controls-section{
			margin-top: 0px;
			padding : 0px;
		}
		
		#personalized-controls-section.cbp-spmenu-vertical {
			width: 565px;
		}
		
		#personalized-controls-section.cbp-spmenu-right {
			right: -565px;
			z-index: 2000;
		}
		
		#personalized-controls-section.cbp-spmenu-right.cbp-spmenu-open {
			right : 0px;
			overflow-x:hidden;
			overflow-y:auto;			
		}

		@media (max-width: 768px ) {
			#personalized-controls-section.cbp-spmenu-vertical {
				width: 100%;
			}			
			#personalized-controls-section.cbp-spmenu-right {
				right: -100%;
			}		
		} 
		
		.cbp-spmenu {
			background : #ffffff;
		}
		
		.cbp-spmenu-vertical header {
			1px solid #258ecd;
			margin : 0px;
			padding : 5px;
			color : #000000;
			background : #5bc0de; /* transparent;        	*/
			height: 90px;        	
		}
		
		.image-grid {
			padding-top:2px;
			padding-buttom:0px;
			padding-right:2px;
			padding-left:0px;
		}
		
		.image-grid img {
			display: block;
			max-width: 100%;
			height: 350px;
		}
				
				
		.cbp-hsmenu-wrapper .cbp-hsmenu {
			width:100%;
		}
		
		.cbp-hsmenu > li > a {
			color: #fff;
			font-size: 1em;
			line-height: 3em;
			display: inline-block;
			position: relative;
			z-index: 10000;
			outline: none;
			text-decoration: none;
		}
		
		blockquote {
			font-size: 11pt;
		}
		
		.panel .comments-heading {
		
		}
		
		.panel .comments-heading a {
			color: #555;
		}
		
		#photo_overlay nav.navbar {
			margin-bottom: 0px; 
		}		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-gray">
		<!-- START HEADER -->		
		<#include "/html/common/common-homepage-menu.ftl" >		
		<!-- start of personalized menu -->
		<nav class="personalized-navbar navbar" role="navigation">
			<div class="container-fluid">
				<ul class="nav navbar-nav navbar-left">				
					<p class="navbar-text hidden-xs">&nbsp;</p>	
					<!--<li><a href=#" class="btn-link custom-nabvar-hide"><i class="fa fa-chevron-left fa-lg"></i></a></li>-->
					<p class="navbar-text hidden-xs">&nbsp;</p>						
					<li class="navbar-btn hidden-xs">
						<div class="btn-group navbar-btn" data-toggle="buttons">
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
							</label>
							<label class="btn btn-info active">
						 		<input type="radio" name="personalized-area-col-size"  value="6"> <i class="fa fa-th-large"></i>
							</label>
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size"  value="4"> <i class="fa fa-th"></i>
							</label>
						</div>										
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">		
					<p class="navbar-text hidden-xs">&nbsp;</p>
					<li><a href="${request.contextPath}/main.do?view=streams" class="btn-link custom-nabvar-up">마이 스트림</a></li>
					<li><a href="#" class="btn-link custom-nabvar-down"><i class="fa fa-chevron-down fa-lg"></i></a></li>
					<li><a href="#" class="btn-link custom-nabvar-show-opts"><i class="fa fa-cloud fa-lg"></i></a></li>
					<li><a href="#&quot;" class="btn-link custom-nabvar-hide">
						<img src="${request.contextPath}/images/cross.png" height="18"/>
					</a></li>
					<p class="navbar-text hidden-xs">&nbsp;</p>
				</ul>
			</div>
		</nav>
		<!-- end of personalized menu -->
		<!-- END HEADER -->	
		<!-- START MAIN CONTENT -->
		<section class="container-fluid" style="min-height:600px;">		
			<div id="personalized-area" class="row blank-top-10">				
				<div id="announce-panel" class="custom-panels-group col-sm-6" style="display:none;">	
					<div class="panel panel-default">
						<div class="panel-heading"><i class="fa fa-bell-o"></i>&nbsp;공지 & 이벤트
							<div class="k-window-actions panel-header-actions">										
								<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
								<a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
								<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>										
								<a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a>
							</div>									
							</div>
							<div class="panel-body">		
							<div class="page-header text-primary">
								<h5 ><small>우측 회사 버튼을 클릭하면 회사(${user.company.displayName}) 에 해당하는 공지 & 이벤트 목록이 보여집니다. </small>
								&nbsp;
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-info btn-sm active">
										<input type="radio" name="announce-selected-source" value="30" >사이트
									</label>
									<label class="btn btn-info btn-sm ">
										<input type="radio" name="announce-selected-source" value="1">회사
									</label>
								</div>	
								<#if action.webSite.user.userId == action.user.userId >
								
								</#if>
								<button type="button" class="btn btn-primary btn-sm custom-add"><i class="fa fa-plus"></i> 공지 및 이벤트 추가</button>	
								</h5>						
							</div>										
							<div  id="announce-grid"></div>	
							</div>
							<div class="panel-body">					
								<div  id="announce-view"></div>
							</div>
						</div>		
					</div>
				</div>		
			</div>				
		</section>		
		<div class="overlay hide"></div>		
		<!-- start side menu -->
		<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right hide"  id="personalized-controls-section">			
			<header>							
				<div class="btn-group">
					<button type="button" class="btn btn-info"><i class="fa fa-cog"></i></button>
					<button type="button" class="btn btn-info"><i class="fa fa-comment"></i></button>
					<button type="button" class="btn btn-info"><i class="fa fa-envelope"></i></button>
				</div>
				<button id="personalized-controls-menu-close" type="button" class="btn-close">Close</button>
			</header>					
				<div class="blank-top-5" ></div>	
									<ul class="nav nav-tabs" id="myTab" style="padding-left:5px;">
										<li><a href="#my-notice" tabindex="-1" data-toggle="tab">공지 & 이벤트</a></li>					
										<#if !action.user.anonymous >	
										<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
										<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
										</#if>						
									</ul>								
									<div class="tab-content" style="background-color : #FFFFFF; padding:5px;">	
										<div class="tab-pane" id="my-notice">
											<section class="side2 hide">
												<div class="btn-group">			
													<button type="button" class="btn btn-info"><i class="fa fa-th-list"></i>&nbsp;  목록보기</button>
												</div>
												<div id="announce-creator" class="blank-top-15" ></div>
											</section>
											<section class="side1">
												<div class="btn-group">			
													<button type="button" class="btn btn-info"><i class="fa fa-plus"></i> &nbsp; 공지 & 이벤트 추가</button>		
												</div>		
												<div class="blank-top-5" ></div>
												
											</section>											
										</div>
									<!-- start attachement tab-pane -->
									<div class="tab-pane" id="my-files">
										<section class="custom-upload hide">
											<#if !action.user.anonymous >			
											<div class="page-header text-primary">
												<h5><i class="fa fa-upload"></i>&nbsp;<strong>파일 업로드</strong>&nbsp;<small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
											</div>								
											<input name="uploadAttachment" id="attachment-files" type="file" />												
											</#if>								
										</section>										
										<div class="page-header text-primary">
											<h5 >											
												<small>파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small>
												<#if !action.user.anonymous >		
												<div class="btn-group">			
													<button type="button" class="btn btn-info" data-toggle="button"><i class="fa fa-cloud-upload"></i> &nbsp; 파일업로드</button>		
												</div>		
												</#if>												
											</h5>
										</div>
										<div class="btn-group" data-toggle="buttons" id="attachment-list-filter">
												<label class="btn btn-warning active">
													<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
												</label>
												<label class="btn btn-warning">
													<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
												</label>
												<label class="btn btn-warning">
													<input type="radio" name="attachment-list-view-filters"  value="file"><i class="fa fa-filter"></i> 파일
												</label>	
										</div>
										<div class="blank-top-5" ></div>		
										<div class="panel panel-default panel-flat">
												<div class="panel-body scrollable" style="max-height:450px;">
													<div id="attachment-list-view" ></div>
												</div>	
												<div class="panel-footer" style="padding:0px;">
													<div id="pager" class="k-pager-wrap"></div>
												</div>
										</div>																				
									</div><!-- end attachements  tab-pane -->		
									<!-- start photos  tab-pane -->
									<div class="tab-pane" id="my-photo-stream">
										<section class="custom-upload hide">
											<#if !action.user.anonymous >			
											<div class="page-header text-primary">
												<h5><i class="fa fa-upload"></i>&nbsp;<strong>사진 업로드</strong>&nbsp;<small>아래의 <strong>사진 선택</strong> 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
											</div>
											<div id="my-photo-upload">	
												<input name="uploadPhotos" id="photo-files" type="file" />					
											</div>
											</#if>
										</section>	
										<div class="page-header text-primary">
												<h5 >											
													<small>사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small>
													<#if !action.user.anonymous >		
													<div class="btn-group">			
														<button type="button" class="btn btn-info" data-toggle="button"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>		
													</div>		
													</#if>												
												</h5>
											</div>													
											<div class="blank-top-5" ></div>
											<div class="panel panel-default panel-flat">								
												<div class="panel-body scrollable" style="max-height:450px;">
													<div id="photo-list-view" ></div>
												</div>	
												<div class="panel-footer" style="padding:0px;">
													<div id="photo-list-pager" class="k-pager-wrap"></div>
												</div>
										</div>	
									</div><!-- end photos  tab-pane -->
								</div><!-- end of tab content -->					
			</div>	
		</section>		
		
		<section id="image-broswer" class="image-broswer"></section>
		
		<section id="announce-editor"></section>
		
		<!-- END MAIN CONTENT -->		
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->			
		<!-- START TEMPLATE -->				

		<script type="text/x-kendo-tmpl" id="attachment-list-view-template">
			<div class="img-wrapper">			
			#if (contentType.match("^image") ) {#
				<img src="${request.contextPath}/community/view-my-attachment.do?width=150&height=150&attachmentId=#:attachmentId#" alt="#:name# 이미지" />
			# } else { #			
				<img src="http://placehold.it/146x146&amp;text=[file]"></a>
			# } #	
				<div class="img-description">
					<h3>#:name#</h3>
					<p>#:size# 바이트</p>
				</div>
			</div>
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
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>