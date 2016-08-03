<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >
		<title><>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		var jobs = [];					
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',

			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',			
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',						
			
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
						
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
						
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 					
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',	
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
					
			],			
			complete: function() {		
								
				common.ui.setup({
					features:{
						wallpaper : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								console.log(common.ui.stringify(currentUser));
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},	
					jobs:jobs
				});	
				var currentUser = new common.ui.data.User();
				console.log( common.ui.stringify(currentUser));	
				$(".tab-v1").find(".nav-tabs a[data-toggle=tab]:first").tab('show');
				
				<!----- 자유 게시판 그리드 ------>
				<!-- toolbar 사용하여 버튼을 그리드 상단에 넣을 수 있습니다. -->
					var renderTo = $("#board-list-grid");
 					var listGrid = renderTo.kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/board/free/list.json?output=json" />",
                                	type:'POST', 
                                	contentType : 'application/json'
                                },
                                parameterMap: function (options, type){	
                                	options.boardCode = 'B001';
                                	options.boardName = 'free';							
									return common.ui.stringify( options );
								}
                            },
                            schema: {
                                model: common.ui.data.community.Board,
                                data: "items",
                                total: "totalCount"
                            },
                            serverPaging:true,
                            serverFiltering: true,
                            pageSize: 10
                        },
                        autoBind: true,
                        height: 545,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                    	toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger rounded" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 글쓰기 </button></div>'),					
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 100 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo#' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 150 },
                        	{ title: "작성일", field: "writeDate", width: 150, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 100 }
                        ],
                        change: function(e) {
                        	var data = common.ui.grid($('#board-list-grid')).dataSource.view();
                        	var current_index = this.select().index();
                        	var total_index = common.ui.grid($('#board-list-grid')).dataSource.view().length - 1;
                        	var list_view_pager = common.ui.pager($("#free-grid-pager"));
                        	var item = data[current_index];
                        },
                        dataBound: function(e) {
							var $this = this;
							var renderTo = $("#board-write-form");
							if(renderTo.data('model') && renderTo.is(":visible")){
								var list_view_pager = common.ui.pager($("#free-grid-pager"));
								var data = common.ui.grid($('#board-list-grid')).dataSource.view();
								if(renderTo.data("model").page > list_view_pager.page()){
									var item = data[renderTo.data("model").pageSize - 1];
									item.set("index", renderTo.data("model").pageSize - 1);
									writeBoard(item);
								} else {
									var item = data[0];
									item.set("index", 0);
									writeBoard(item);
								}
							}
						}
                    });
                    
                  /*  renderTo.on('click', '[data-action=view]', function(e){
                    	var $this = $(this);
                   		var objectId = $this.data("object-id");	
                   		var item = common.ui.grid(renderTo).dataSource.get(objectId);
                   		console.log(common.ui.stringify(item));
                   		renderTo.fadeOut(function(e){
                   			writeBoard(item);
                   		});
                    	
                    });  */       
                        
                    renderTo.on('click', '[data-action=create]', function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newBoard ;
						if( objectId > 0){
							newBoard = common.ui.grid(renderTo).dataSource.get(objectId);
						}else{
							newBoard = new common.ui.data.community.Board();
							newBoard.boardCode = 'B001';
							newBoard.boardName = 'free';
						}
	                   	renderTo.fadeOut(function(e){
                   			$('#board-write-form').fadeIn();
                   			console.log(common.ui.stringify(newBoard));
                   			writeBoard(newBoard);
                   		});                    	
                    });
                    
                    renderTo.on('click', '[data-action=view]', function(e){
                    	var index = $(this).closest("[data-uid]").index();
                    	var data = common.ui.grid(renderTo).dataSource.view();
                    	var item = data[index];
                    	item.set("index", index);
                    	console.log(common.ui.stringify(item));
                    	renderTo.fadeOut(function(e){
                   			writeBoard(item);
                   		});
                    });
                    
               <!----- 공지사항 게시판 그리드 ------>
               		var noticeRenderTo = $('#notice-list-grid');
                    var noticeGrid = noticeRenderTo.kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/board/notice/list.json?output=json" />",
                                	type:'POST', 
                                	contentType : 'application/json'
                                },
                                parameterMap: function (options, type){	
                                	options.boardCode = 'B002';		
                                	options.boardName = 'notice';						
									return common.ui.stringify( options );
								}
                            },
                            schema: {
                                model: common.ui.data.community.Board,
                                data: "items",
                                total: "totalCount"
                            },
                            serverPaging:true,
                            serverFiltering: true,
                            pageSize: 10
                        },
                        autoBind:true,
                        height: 545,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                        toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-primary rounded" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 글쓰기 </button></div>'),					
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 100 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo #' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 150 },
                        	{ title: "작성일", field: "writeDate", width: 150, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 100 }
                        ],
                        change: function(e) {
                        	var data = common.ui.grid($('#notice-list-grid')).dataSource.view();
                        	var current_index = this.select().index();
                        	var total_index = common.ui.grid($('#notice-list-grid')).dataSource.view().length - 1;
                        	var list_view_pager = common.ui.pager($("#notice-grid-pager"));
                        	var item = data[current_index];
                        },
                        dataBound: function(e) {
							var $this = this;
							var renderTo = $("#notice-write-form");
							if(renderTo.data('model') && renderTo.is(":visible")){
								var list_view_pager = common.ui.pager($("#notice-grid-pager"));
								var data = common.ui.grid($('#notice-list-grid')).dataSource.view();
								if(renderTo.data("model").page > list_view_pager.page()){
									var item = data[renderTo.data("model").pageSize - 1];
									item.set("index", renderTo.data("model").pageSize - 1);
									writeNotice(item);
								} else {
									var item = data[0];
									item.set("index", 0);
									writeNotice(item);
								}
							}
						}
                    });
                    
                    noticeRenderTo.on('click', '[data-action=view]', function(e){
                    	var index = $(this).closest("[data-uid]").index();
                    	var data = common.ui.grid(noticeRenderTo).dataSource.view();
                    	var item = data[index];
                    	item.set("index", index);
                    	console.log(common.ui.stringify(item));
                    	noticeRenderTo.fadeOut(function(e){
                   			writeNotice(item);
                   		});
                    });
                    
                    noticeRenderTo.on('click', '[data-action=create]', function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newNotice ;
						if( objectId > 0){
							newNotice = common.ui.grid(noticeRenderTo).dataSource.get(objectId);
						}else{
							newNotice = new common.ui.data.community.Board();
							newNotice.boardCode = 'B002';
							newNotice.boardName = 'notice';
						}
	                   	noticeRenderTo.fadeOut(function(e){
                   			$('#notice-write-form').fadeIn();
                   			console.log(common.ui.stringify(newNotice));
                   			writeNotice(newNotice);
                   		});
                    	
                    });
                    
                    
                   
                   
 			 <!----- QnA 게시판 그리드 ------>
               		var qnaRenderTo = $('#qna-list-grid');
                    var qnaGrid = qnaRenderTo.kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/board/qna/list.json?output=json" />",
                                	type:'POST', 
                                	contentType : 'application/json'
                                },
                                parameterMap: function (options, type){
                                	options.boardCode = 'B003';				
                                	options.boardName = 'qna';					
									return common.ui.stringify( options );
								}
                            },
                            schema: {
                                model: common.ui.data.community.QnaBoard,
                                data: "items",
                                total: "totalCount"
                            },
                            serverPaging: true,
                            serverFiltering: true,
                            pageSize: 10
                        },
                        autoBind:true,
                        height: 545,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                        toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-success rounded" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 글쓰기 </button></div>'),					
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 80 },
                        	{ title: "분류", field: "category", width: 130 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo #' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 120 },
                        	{ title: "작성일", field: "writeDate", width: 120, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 80 }
                        ],
                        change: function(e) {
                        	var data = common.ui.grid($('#qna-list-grid')).dataSource.view();
                        	var current_index = this.select().index();
                        	var total_index = common.ui.grid($('#qna-list-grid')).dataSource.view().length - 1;
                        	var list_view_pager = common.ui.pager($("#qna-grid-pager"));
                        	var item = data[current_index];
                        },
                        dataBound: function(e) {
							var $this = this;
							var renderTo = $("#qna-write-form");
							if(renderTo.data("model") && renderTo.is(":visible")){
								var list_view_pager = common.ui.pager($("#qna-grid-pager"));
								var data = common.ui.grid($('#qna-list-grid')).dataSource.view();
								if(renderTo.data("model").page > list_view_pager.page()){
									var item = data[renderTo.data("model").pageSize - 1];
									item.set("index", renderTo.data("model").pageSize - 1);
									writeQna(item);
								} else {
									var item = data[0];
									item.set("index", 0);
									writeQna(item);
								}
							}
						}
                    });
                    
                    qnaRenderTo.on('click', '[data-action=view]', function(e){
                    	var index = $(this).closest("[data-uid]").index();
                    	var data = common.ui.grid(qnaRenderTo).dataSource.view();
                    	var item = data[index];
                    	item.set("index", index);
                    	console.log(common.ui.stringify(item));
                    	qnaRenderTo.fadeOut(function(e){
                   			writeQna(item);
                   		});
                    });
                    
                    qnaRenderTo.on('click', '[data-action=create]', function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newQna ;
						if( objectId > 0){
							newQna = common.ui.grid(qnaRenderTo).dataSource.get(objectId);
						}else{
							newQna = new common.ui.data.community.QnaBoard();
							newQna.boardCode = 'B003';
							newQna.boardName = 'qna';
						}
	                   	qnaRenderTo.fadeOut(function(e){
                   			$('#qna-write-form').fadeIn();
                   			console.log(common.ui.stringify(newQna));
                   			writeQna(newQna);
                   		});
                    	
                    });
                                       
			}
			
		}]);
		
		
	<!---- 자유게시판 쓰기/수정/삭제 폼 ---->	
		function writeBoard(source){
			$('#board-list-grid > .k-grid-pager').attr("id", "free-grid-pager");
			
			var renderTo = $('#board-write-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					board: new common.ui.data.community.Board(),
					editable: false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					page: 0,
					pageSize: 0,
					hasPreviousPage: false,
					hasNextPage: false,
					hasPrevious: false,
					hasNext: false,
					edit: function(){
						this.set('editable', true);
					},
					reply: function(e){
						var $this = $(this)
						var writingRef = document.getElementById("boardNo");
						var newBoardReply;
						
						newBoardReply = new common.ui.data.community.Board();
						newBoardReply.boardCode = 'B002';
						newBoardReply.boardName = 'notice';
						newBoardReply.writingRef = writingRef.getAttribute("data-value");

	                   	$('#board-write-form').fadeOut(function(e){
                   			$('#board-reply-form').fadeIn();
                   			console.log(common.ui.stringify(newBoardReply));
                   			writeBoardReply(newBoardReply);
                   		});
						
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log(kendo.stringify($this.board));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/free/write.json?output=json" />' , 
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "작성하신 글이 저장되었습니다."	},"success");
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "글 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#board-list-grid')).dataSource.read();
									common.ui.grid($('#board-list-grid')).refresh();
									$this.close();
								}
							});	
							return false;
					},
					delete: function(source){
						var $this = this;
						console.log(kendo.stringify($this.board));
						conf = confirm("이 글을 정말 삭제하시겠습니까?");
						if(conf) {
							common.ui.ajax(
							'<@spring.url "/data/podo/board/free/delete.json?output=json" />',
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){		
									common.ui.notification().show({ title:null, message: "글이 삭제되었습니다." },"success");							
								},
								fail: function(){								
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#board-list-grid')).dataSource.read();
									common.ui.grid($('#board-list-grid')).refresh();
									$this.close();
								}
							});	
						}
					},
					preView: function(){
						var $this = this;
						if( $this.hasPrevious ){
							var index = $this.board.index - 1;
							var data = common.ui.grid($('#board-list-grid')).dataSource.view();					
							var item = data[index];				
							item.set("index", index);
							writeBoard(item);		
						}
					},
					nextView: function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.board.index + 1;
							var data = common.ui.grid($('#board-list-grid')).dataSource.view();					
							var item = data[index];		
							item.set("index", index);
							writeBoard(item);					
						}
					},
					preFreePage: function(){
						var $this = this;
						if( $this.hasPreviousPage ){
							var pager = common.ui.pager($("#free-grid-pager"));
							pager.page($this.page - 1);
						}
					},
					nextFreePage: function(){
						var $this = this;
						if( $this.hasNextPage ){
							var pager = common.ui.pager($("#free-grid-pager"));
							pager.page($this.page + 1);
						}
					},
					setPagination: function(){
						var $this = this;
						var pageSize = common.ui.grid($('#board-list-grid')).dataSource.view().length;	
						var pager = common.ui.pager($("#free-grid-pager"));
						var page = pager.page();
						var totalPages = pager.totalPages();		
						if( $this.board.index > 0 && ($this.board.index - 1) >= 0 )
							$this.set("hasPrevious", true); 
						else 
							$this.set("hasPrevious", false); 							
						if( ($this.board.index + 1) < pageSize && (pageSize - $this.board.index) > 0 )
							$this.set("hasNext", true); 
						else 
							$this.set("hasNext", false); 	
						if( ($this.board.index + 1) >= pageSize && totalPages > page )
							$this.set("hasNextPage", true);
						else
							$this.set("hasNextPage", false);
						if( ($this.board.index - 1) < 0 && page > 1 )
							$this.set("hasPreviousPage", true);
						else 
							$this.set("hasPreviousPage", false);
						
						//$this.set("hasPreviousPage", page > 1 );				
						//$this.set("hasNextPage", totalPages > page );		
						$this.set("page", page);			
						$this.set("pageSize", pageSize);																	
					},
					setSource: function(source){
						var $this = this;
						source.copy($this.board);
						$this.set('editable', ($this.board.boardNo > 0 ? false : true ));
						$this.setPagination();
					/*	if($this.board.boardNo > 0) {
							common.ui.ajax(
							'<@spring.url "/data/podo/board/free/updateReadCount.json?output=json" />',
							{
								async : false,
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){
									common.ui.grid($('#board-list-grid')).refresh();
								},
								fail: function(){								
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
								}
							});	
							return false;
						}*/
					},
					close: function(){
						renderTo.fadeOut(function(e){ 
							$("#board-list-grid").fadeIn();
							common.ui.grid($('#board-list-grid')).dataSource.read();
						});
					}
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			renderTo.data("model").setSource(source);	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}
		
	<!---- 공지게시판 쓰기/수정/삭제 폼 ---->		
		function writeNotice(source){
			$('#notice-list-grid > .k-grid-pager').attr("id", "notice-grid-pager");
			
			var renderTo = $('#notice-write-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					notice : new common.ui.data.community.Board(),
					editable : false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					page: 0,
					pageSize: 0,
					hasPreviousPage: false,
					hasNextPage: false,
					hasPrevious: false,
					hasNext: false,
					edit:function(){
						this.set('editable', true);
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log(kendo.stringify($this.notice));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/notice/write.json?output=json" />' , 
							{
								data : kendo.stringify($this.notice),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "작성하신 글이 저장되었습니다."	},"success");	
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "글 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#notice-list-grid')).dataSource.read();
									common.ui.grid($('#notice-list-grid')).refresh();											
									$this.close();
								}
							});	
						return false;	
					},
					preView: function(){
						var $this = this;
						if( $this.hasPrevious ){
							var index = $this.notice.index - 1;
							var data = common.ui.grid($('#notice-list-grid')).dataSource.view();					
							var item = data[index];				
							item.set("index", index);
							writeNotice(item);		
						}
					},
					nextView: function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.notice.index + 1;
							var data =  common.ui.grid($('#notice-list-grid')).dataSource.view();					
							var item = data[index];		
							item.set("index", index);
							writeNotice(item);					
						}
					},
					preNoticePage: function(){
						var $this = this;
						if( $this.hasPreviousPage ){
							var pager = common.ui.pager($("#notice-grid-pager"));
							pager.page($this.page - 1);
						}
					},
					nextNoticePage: function(){
						var $this = this;
						if( $this.hasNextPage ){
							var pager = common.ui.pager($("#notice-grid-pager"));
							pager.page($this.page + 1);
						}
					},
					setPagination: function(){
						var $this = this;
						var pageSize = common.ui.grid($('#notice-list-grid')).dataSource.view().length;	
						var pager = common.ui.pager($("#notice-grid-pager"));
						var page = pager.page();
						var totalPages = pager.totalPages();		
						if( $this.notice.index > 0 && ($this.notice.index - 1) >= 0 )
							$this.set("hasPrevious", true); 
						else 
							$this.set("hasPrevious", false); 							
						if( ($this.notice.index + 1) < pageSize && (pageSize - $this.notice.index) > 0 )
							$this.set("hasNext", true); 
						else 
							$this.set("hasNext", false); 	
						if( ($this.notice.index + 1) >= pageSize && totalPages > page )
							$this.set("hasNextPage", true);
						else
							$this.set("hasNextPage", false);
						if( ($this.notice.index - 1) < 0 && page > 1 )
							$this.set("hasPreviousPage", true);
						else 
							$this.set("hasPreviousPage", false);
						
						//$this.set("hasPreviousPage", page > 1 );				
						//$this.set("hasNextPage", totalPages > page  );		
						$this.set("page", page);			
						$this.set("pageSize", pageSize);																	
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.notice);
						$this.set('editable', ($this.notice.boardNo > 0 ? false : true ));
						$this.setPagination();
						/*if($this.notice.boardNo > 0) {
							common.ui.ajax(
								'<@spring.url "/data/podo/board/notice/updateReadCount.json?output=json" />',
								{
									//async : false,
									data : kendo.stringify( $this.notice ),
									contentType : "application/json",
									success : function(response){
										common.ui.grid($('#notice-list-grid')).refresh();
									},
									fail: function(){								
									},
									requestStart : function(){
										kendo.ui.progress(renderTo, true);
									},
									requestEnd : function(){
										kendo.ui.progress(renderTo, false);
									},
									complete : function(e){
									}
								});	
							return false;
						}*/
					},
					delete: function(source){
						var $this = this;
						console.log(kendo.stringify($this.board));
						conf = confirm("이 글을 정말 삭제하시겠습니까?");
						if(conf){
							common.ui.ajax(
							'<@spring.url "/data/podo/board/notice/delete.json?output=json" />',
							{
								data : kendo.stringify( $this.notice ),
								contentType : "application/json",
								success : function(response){	
									common.ui.notification().show({ title:null, message: "글이 삭제되었습니다." },"success");								
									common.ui.grid($('#notice-list-grid')).dataSource.read();	
									common.ui.grid($('#notice-list-grid')).refresh();
								},
								fail: function(){								
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#notice-list-grid')).dataSource.read();
									common.ui.grid($('#notice-list-grid')).refresh();														
									$this.close();
								}
							});	
						}
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#notice-list-grid").fadeIn();
							common.ui.grid($('#notice-list-grid')).dataSource.read();
						});
					}
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			renderTo.data("model").setSource(source);	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}
		

	<!---- QnA게시판 쓰기/수정/삭제 폼 ---->		
		function writeQna(source){
			$('#qna-list-grid > .k-grid-pager').attr("id", "qna-grid-pager");
			
			var data = ["수업", "학적", "유학/연수/교류", "교직", "장학/융자", "학생생활상담", "기타"];
			$("#dropdownlist").kendoDropDownList({
				dataSource: data
			});
			
			var renderTo = $('#qna-write-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					qna : new common.ui.data.community.QnaBoard(),
					editable : false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					page: 0,
					pageSize: 0,
					hasPreviousPage: false,
					hasNextPage: false,
					hasPrevious: false,
					hasNext: false,
					edit:function(){
						this.set('editable', true);
					},
					reply : function(e){
						var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newQnaReply ;
						if( objectId > 0){
							newQnaReply = common.ui.grid($('#qna-list-grid')).dataSource.get(objectId);
						}else{
							newQnaReply = new common.ui.data.community.QnaBoard();
							newQnaReply.boardCode = 'B003';
							newQnaReply.boardName = 'qna';
							newQnaReply.type = '답변';
							newQnaReply.writer = '관리자';
						}
	                   	$('#qna-write-form').fadeOut(function(e){
                   			$('#qna-reply-form').fadeIn();
                   			console.log(common.ui.stringify(newQnaReply));
                   			writeQnaReply(newQnaReply);
                   		});
						
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.qna) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/qna/write.json?output=json" />' , 
							{
								data : kendo.stringify( $this.qna ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "작성하신 글이 저장되었습니다."	},"success");	
									common.ui.grid($('#qna-list-grid')).dataSource.read();	
									common.ui.grid($('#qna-list-grid')).refresh();
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "글 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#qna-list-grid')).dataSource.read();	
									common.ui.grid($('#qna-list-grid')).refresh();														
									$this.close();
								}
							});	
						return false;	
					},
					preView: function(){
						var $this = this;
						if( $this.hasPrevious ){
							var index = $this.qna.index - 1;
							var data = common.ui.grid($('#qna-list-grid')).dataSource.view();					
							var item = data[index];				
							item.set("index", index);
							writeQna(item);		
						}
					},
					nextView: function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.qna.index + 1;
							var data = common.ui.grid($('#qna-list-grid')).dataSource.view();					
							var item = data[index];		
							item.set("index", index);
							writeQna(item);					
						}
					},
					preQnaPage: function(){
						var $this = this;
						if( $this.hasPreviousPage ){
							var pager = common.ui.pager($("#qna-grid-pager"));
							pager.page($this.page - 1);
						}
					},
					nextQnaPage: function(){
						var $this = this;
						if( $this.hasNextPage ){
							var pager = common.ui.pager($("#qna-grid-pager"));
							pager.page($this.page + 1);
						}
					},
					setPagination: function(){
						var $this = this;
						var pageSize = common.ui.grid($('#qna-list-grid')).dataSource.view().length;	
						var pager = common.ui.pager($("#qna-grid-pager"));
						var page = pager.page();
						var totalPages = pager.totalPages();		
						if( $this.qna.index > 0 && ($this.qna.index - 1) >= 0 )
							$this.set("hasPrevious", true); 
						else 
							$this.set("hasPrevious", false); 							
						if( ($this.qna.index + 1) < pageSize && (pageSize - $this.qna.index) > 0 )
							$this.set("hasNext", true); 
						else 
							$this.set("hasNext", false); 	
						if( ($this.qna.index + 1) >= pageSize && totalPages > page )
							$this.set("hasNextPage", true);
						else
							$this.set("hasNextPage", false);
						if( ($this.qna.index - 1) < 0 && page > 1 )
							$this.set("hasPreviousPage", true);
						else 
							$this.set("hasPreviousPage", false);
						
						//$this.set("hasPreviousPage", page > 1 );				
						//$this.set("hasNextPage", totalPages > page  );		
						$this.set("page", page );			
						$this.set("pageSize", pageSize );																	
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.qna);
						$this.set('editable', ($this.qna.boardNo > 0 ? false : true ));
						$this.setPagination();
						/*if($this.qna.boardNo > 0) {
							common.ui.ajax(
								'<@spring.url "/data/podo/board/qna/updateReadCount.json?output=json" />',
								{
									//async : false,
									data : kendo.stringify( $this.qna ),
									contentType : "application/json",
									success : function(response){	
										common.ui.grid($('#qna-list-grid')).refresh();
									},
									fail: function(){								
									},
									requestStart : function(){
										kendo.ui.progress(renderTo, true);
									},
									requestEnd : function(){
										kendo.ui.progress(renderTo, false);
									},
									complete : function(e){
									}
								});
							return false;	
						}*/
					},
					delete: function(source){
						var $this = this;
						console.log(kendo.stringify($this.qna));
						conf = confirm("이 글을 정말 삭제하시겠습니까?");
						if(conf){
							common.ui.ajax(
							'<@spring.url "/data/podo/board/qna/delete.json?output=json" />',
							{
								data : kendo.stringify( $this.qna ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "글이 삭제되었습니다." },"success");									
									common.ui.grid($('#qna-list-grid')).dataSource.read();	
									common.ui.grid($('#qna-list-grid')).refresh();
								},
								fail: function(){								
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#qna-list-grid')).dataSource.read();	
									common.ui.grid($('#qna-list-grid')).refresh();					
									$this.close();
								}
							});	
						}
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#qna-list-grid").fadeIn();
							common.ui.grid($('#qna-list-grid')).dataSource.read();
						});
					}
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			renderTo.data("model").setSource(source);	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}
		
		
	<!---- 자유게시판 답글쓰기 폼 ---->	
		function writeBoardReply(source){
			var renderTo = $('#board-reply-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					board : new common.ui.data.community.Board(),
					editable : false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					save : function(e){
						var $this = this;
						console.log(kendo.stringify($this.board));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/writeReply.json?output=json" />' , 
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "작성하신 글이 저장되었습니다."	},"success");
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "글 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#board-list-grid')).dataSource.read();
									common.ui.grid($('#board-list-grid')).refresh();
									$this.close();
								}
							});	
							return false;
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.board);
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#board-list-grid").fadeIn();
						});
					}
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			renderTo.data("model").setSource(source);	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}
				
	
				
	<!---- QnA게시판 답글쓰기 폼 ---->	
		function writeQnaReply(source){
			var renderTo = $('#qna-reply-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					qna : new common.ui.data.community.QnaBoard(),
					editable : false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					save : function(e){
						var $this = this;
						console.log(kendo.stringify($this.qna));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/writeReply.json?output=json" />' , 
							{
								data : kendo.stringify( $this.qna ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "작성하신 글이 저장되었습니다."	},"success");
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "글 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid($('#qna-list-grid')).dataSource.read();
									common.ui.grid($('#qna-list-grid')).refresh();
									$this.close();
								}
							});	
							return false;
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.qna);
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#qna-list-grid").fadeIn();
						});
					}
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			renderTo.data("model").setSource(source);	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}


		</script>
		<style>
			#board-list-grid td,
			#notice-list-grid td,
			#qna-list-grid td {
				text-align: center;
				height: 30px;
				line-height: 30px;
			}
			#board-list-grid th,
			#notice-list-grid th,
			#qna-list-grid th {
				text-align: center;
				font-weight: bold;
				font-size: 16px;
				height: 30px;
				line-height: 30px;
			}
			#board-list-grid th { background: pink; }
			#board-list-grid td { background: #FBEFF2; }
			#board-list-grid td:nth-child(1000000n+2), 
			#notice-list-grid td:nth-child(1000000n+2), 
			#qna-list-grid td:nth-child(1000000n+3) {
				text-align: left;
				padding-left: 15px;
			}
			.bottom { border-bottom: 1px solid lightgray; }
			#notice-list-grid th {
				background: #2E64FE;
				color: white;
			}
			#notice-list-grid td {
				color: #2E2E2E;
				background: #CED8F6;
			}
			#qna-list-grid th {
				background: #31B404;
				color: white;
			}
			#qna-list-grid td {
				color: #2E2E2E;
				background: #CEF6CE;
			}
			#lastTd { border: 1px solid lightgray; }
			.tb_writeForm {
				width: 100%;
				border-top: 3px solid #F7819F;
				border-right: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			#tb_noticeForm {
				width: 100%;
				border-top: 3px solid #0404B4;
				border-right: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			#tb_qnaForm {
				width: 100%;
				border-top: 3px solid #298A08;
				border-right: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			.input_title {
				height: 50px; 
				width: 188px;
				background: pink;
				text-align: center;
				font-size: 17px;
				color: #6E6E6E;
				padding: 0;
				margin: 0;
				border: none;
			}
			.notice_title {
				height: 50px; 
				width: 188px;
				background: #2E64FE;
				text-align: center;
				font-size: 17px;
				color: white;
				padding: 0;
				margin: 0;
				border: none;
			}
			.qna_title {
				height: 50px; 
				width: 188px;
				background: #04B404;
				text-align: center;
				font-size: 17px;
				color: white;
				padding: 0;
				margin: 0;
				border: none;
			}
			.formTd {
				height: 50px;
				border: 1px solid lightgray;
			}
			.formInput {
			 border: none; 
			 width: 100%; 
			 padding: 10px; 
			 font-size: 14px;
			}
			a{color:#2E2E2E;}
			a:hover{color:#2E2E2E;}
			a:visited{color:#2E2E2E;}
			a:active{color:white;}
			.BoardViewBtn i { 
				display: block;
				color: white;
				background: lightgray; 
				position:fixed; 
				top: 50%;
				width: 40px;
    			height: 160px;
    			line-height: 160px;
			}
			.BoardViewBtn i:hover { color: white; width: 60px; background: black;}
			.BoardViewBtn i:visited { color: white; }
			.BoardViewBtn i:active { color: white; }
			.BoardViewBtn .preBtn { left: 0; }
			.BoardViewBtn .nextBtn { right: 0; }
		</style>
		</#compress>
		<link rel="stylesheet" href="//cdn.jsdelivr.net/xeicon/2/xeicon.min.css">
	</head>
	<body id="doc" class="bg-white">
		<!--<div class="page-loader"></div>-->
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1  bg-dark arrow-up">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote">${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if>	${ navigator.title }</h1>					
				</div><!--/end container-->
			</div>
			</#if>	
			<div class="container content" style="min-height:450px;">
				<div class="tab-v1">
					<ul class="nav nav-tabs" style="margin-bottom: 50px;">
						<li><a href="#freeBoard" data-toggle="tab" class="m-l-sm rounded-top">자유게시판</a></li>
						<li><a href="#noticeBoard" data-toggle="tab" class="m-l-sm rounded-top">공지게시판</a></li>
						<li><a href="#qnaBoard" data-toggle="tab" class="m-l-sm rounded-top">QnA게시판</a></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane fade" id="freeBoard">
							<span style="color: #FE2E64; font-size:30px; font-weight:bold">자유게시판</span>&nbsp;&nbsp;&nbsp;<span style="color: gray">이곳은 누구나 글을 작성하실 수 있습니다.</span>
							<div id="board-list">
								<div id="board-list-grid"></div>
							</div>
							<div id="board-write-form" style="display: none;">
								<div class="BoardViewBtn" data-bind="invisible:editable">
								 	<i title="이전글" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPrevious, click: preView"></i>
						 			<i title="다음글" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNext, click: nextView"></i>
						 			<i title="이전페이지" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPreviousPage, click: preFreePage"></i>
						 			<i title="다음페이지" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNextPage, click: nextFreePage"></i>
								</div>
							<form id="writeForm" action="#">
								<table class="tb_writeForm">
						            <tr>
						                <td class="input_title bottom" >
						                	제목
						                </td>
						                <td colspan="5" class="bottom">
						                	<span data-bind="text:board.title, invisible:editable" class="formInput bottom"></span>
						                	<input type="text" class="formInput" data-bind="value: board.title, visible:editable" required/>
						                </td>
						            </tr>
						            <tr>
						            	<td class="input_title" >
						                	작성자
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: board.writer, invisible:writable" readonly/>
				                        </td>
				                        <td class="input_title" >
						                	작성일
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: board.formattedWriteDate, invisible:writable" readonly/>
				                        </td>
				                        <td class="input_title" >
						                	조회수
						                </td>
				                        <td class="formTd"> 
				                            <input type="text" class="formInput" data-bind="value: board.readCount, invisible:writable" readonly size="4"/>
				                        </td>
				                    </tr>
						            <tr>
						                <td colspan="6" id="lastTd" >
						                	<div data-bind="html:board.content, invisible:editable, writable" style="height:350px; padding: 5px; white-space:pre; overflow:auto;"></div>
						                	<textarea id="content" style="width: 100%; height:350px; border : none; padding: 5px; resize: none;" 
						                		data-role="editor" 
							                    data-tools="['bold',
							                                   'italic',
							                                   'underline',
							                                   'strikethrough',
							                                   'justifyLeft',
							                                   'justifyCenter',
							                                   'justifyRight',
							                                   'justifyFull',
							                                   'insertImage']"                                   
						                		data-bind="value:board.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="input_title bottom">
						                	첨부파일
						                </td>
						                <td colspan="5" class="bottom">
						                	<span data-bind="text:board.image, invisible:editable" style="border: none; width: 100%; padding: 10px; font-size: 14px"></span>
						                	<input type="file" data-bind="value: board.image, visible:editable"/>
						                </td>
						            </tr>
								</table>
								<button type="button" class="btn btn-danger" style="float: left; border-radius: 5px" data-bind="click:delete , invisible:editable">삭제</button>
								<button type="button" class="btn btn-primary" style="float: left; border-radius: 5px" data-bind="click:edit , invisible:editable">수정</button>
								<button type="button" class="btn btn-success" style="float: left; border-radius: 5px" data-bind="click:reply, invisible:editable">답글</button>
								<button type="button" class="btn btn-info btn-md" style="float: right; border-radius: 5px" data-bind="click:saveOrUpdate, visible:editable">확인</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, visible:editable">취소</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, invisible:editable">목록</button>
						    </form>
						 </div>
						 <div id="board-reply-form" style="display: none;">
							<form id="replyForm" action="#">
								<input type="hidden" id="boardNo" data-bind="value: board.boardNo"/>
								<div><span class="back" style="position:relative;" data-bind="click:close"></span></div>
								<table class="tb_writeForm">
						            <tr>
						                <td class="input_title bottom" >
						                	제목
						                </td>
						                <td colspan="5" class="bottom">
						                	<input type="text" class="formInput" data-bind="value: board.title"/>
						                </td>
						            </tr>
						            <tr>
						            	<td class="input_title" >
						                	작성자
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: board.writer" readonly/>
				                        </td>
				                        <td class="input_title" >
						                	작성일
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: board.formattedWriteDate" readonly/>
				                        </td>
				                        <td class="input_title" >
						                	조회수
						                </td>
				                        <td class="formTd"> 
				                            <input type="text" class="formInput" data-bind="value: board.readCount" readonly size="4"/>
				                        </td>
				                    </tr>
						            <tr>
						                <td colspan="6" id="lastTd" >
						                	<textarea id="content" style="width: 100%; height:350px; border : none; padding: 5px; resize: none;" 
						                		data-role="editor"
							                    data-tools="['bold',
							                                   'italic',
							                                   'underline',
							                                   'strikethrough',
							                                   'justifyLeft',
							                                   'justifyCenter',
							                                   'justifyRight',
							                                   'justifyFull',
							                                   'insertImage']"   
						                		data-bind="value:board.content"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="input_title bottom">
						                	첨부파일
						                </td>
						                <td colspan="5" class="bottom">
						                	<input type="file" data-bind="value: board.image"/>
						                </td>
						            </tr>
								</table>
								<button type="button" class="btn btn-info btn-md" style="float: right; border-radius: 5px" data-bind="click:saveOrUpdate">확인</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close">취소</button>
						    </form>
						 </div>
					</div>
					<div class="tab-pane fade" id="noticeBoard">
						<span style="color: #2E2EFE; font-size:30px; font-weight:bold">공지게시판</span>&nbsp;&nbsp;&nbsp;<span style="color: gray">공지사항을 알려드립니다.</span>
						<div>
							<div id="notice-list-grid"></div>
						</div>
						<div id="notice-write-form" style="display: none;">
							<div class="BoardViewBtn" data-bind="invisible:editable">
								<i title="이전글" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPrevious, click: preView"></i>
						 		<i title="다음글" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNext, click: nextView"></i>
						 		<i title="이전페이지" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPreviousPage, click: preNoticePage"></i>
						 		<i title="다음페이지" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNextPage, click: nextNoticePage"></i>
							 </div>
							 <form id="noticeForm" action="#">
								<table id="tb_noticeForm">
						            <tr>
						                <td class="notice_title bottom" >
						                	제목
						                </td>
						                <td colspan="5" class="bottom">
						                	<span data-bind="text:notice.title, invisible:editable" class="formInput"></span>
						                	<input type="text" class="formInput" data-bind="value: notice.title, visible:editable" required/>
						                </td>
						            </tr>
						            <tr>
						            	<td class="notice_title" >
						                	작성자
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: notice.writer" readonly/>
				                        </td>
				                        <td class="notice_title" >
						                	작성일
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: notice.formattedWriteDate" readonly/>
				                        </td>
				                        <td class="notice_title" >
						                	조회수
						                </td>
				                        <td class="formTd"> 
				                            <input type="text" class="formInput" data-bind="value: notice.readCount" readonly size="4"/>
				                        </td>
				                    </tr>
						            <tr>
						                <td colspan="6" id="lastTd" >
						                	<div data-bind="html:notice.content, invisible:editable" style="height:350px; padding: 5px; white-space:pre; overflow:auto;"></div>
						                	<textarea id="content" style="width: 100%; height:350px; border : none; padding: 5px; resize: none;" 
						                		data-role="editor"
							                    data-tools="['bold',
							                                   'italic',
							                                   'underline',
							                                   'strikethrough',
							                                   'justifyLeft',
							                                   'justifyCenter',
							                                   'justifyRight',
							                                   'justifyFull',
							                                   'insertImage']"   
						                		data-bind="value:notice.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="notice_title bottom">
						                	첨부파일
						                </td>
						                <td colspan="5" class="bottom">
						                	<span data-bind="text:notice.image, invisible:editable" style="border: none; width: 100%; padding: 10px; font-size: 14px"></span>
						                	<input type="file" data-bind="value: board.image, visible:editable"/>
						                </td>
						            </tr>
								</table><br/>
								<button type="button" class="btn btn-danger" style="float: left; border-radius: 5px" data-bind="click:delete , invisible:editable">삭제</button>
								<button type="button" class="btn btn-primary" style="float: left; border-radius: 5px" data-bind="click:edit , invisible:editable">수정</button>
								<button type="button" class="btn btn-info btn-md" style="float: right; border-radius: 5px" data-bind="click:saveOrUpdate, visible:editable">확인</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, visible:editable">취소</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, invisible:editable">목록</button>
						    </form>
						 </div>
					</div>
					<div class="tab-pane fade" id="qnaBoard">
						<span style="color: #04B404; font-size:30px; font-weight:bold">QnA게시판</span>&nbsp;&nbsp;&nbsp;<span style="color: gray">궁금한 점을 물어보세요.</span>
						<div>
							<div id="qna-list-grid"></div>
						</div>
						<div id="qna-write-form" style="display: none;">
							<div class="BoardViewBtn" data-bind="invisible:editable">
								<i title="이전글" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPrevious, click: preView"></i>
						 		<i title="다음글" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNext, click: nextView"></i>
						 		<i title="이전페이지" class="xi-angle-left-thin xi-3x preBtn" data-bind="visible: hasPreviousPage, click: preQnaPage"></i>
						 		<i title="다음페이지" class="xi-angle-right-thin xi-3x nextBtn" data-bind="visible: hasNextPage, click: nextQnaPage"></i>
							</div>
							<form id="qnaForm" action="#">
								<table id="tb_qnaForm">
									<tr>
										<td class="qna_title">
											유형
										</td>
										<td colspan="5" style="padding-left: 10px">
											<span data-bind="text:qna.category, invisible:editable" class="formInput"></span>
											<input id="dropdownlist" data-bind="value:qna.category, visible: editable" required />
										</td>
									</tr>
						            <tr>
						                <td class="qna_title bottom">
						                	제목
						                </td>
						                <td colspan="5" style="border-top:1px solid lightgray" class="bottom">
						                	<span data-bind="text:qna.title, invisible:editable" class="formInput"></span>
						                	<input type="text" class="formInput" data-bind="value: qna.title, visible:editable" required/>
						                </td>
						            </tr>
						            <tr>
						            	<td class="qna_title" >
						                	작성자
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: qna.writer" readonly/>
				                        </td>
				                        <td class="qna_title" >
						                	작성일
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: qna.formattedWriteDate" readonly/>
				                        </td>
				                        <td class="qna_title" >
						                	조회수
						                </td>
				                        <td class="formTd"> 
				                            <input type="text" class="formInput" data-bind="value: qna.readCount" readonly size="4"/>
				                        </td>
				                    </tr>
						            <tr>
						                <td colspan="6" id="lastTd" >
						                	<div data-bind="html:qna.content, invisible:editable" style="height:350px; padding: 5px; white-space:pre; overflow:auto;"></div>
						                	<textarea id="content" style="width: 100%; height:350px; border : none; padding: 5px; resize: none;" 
						                		data-role="editor"
							                    data-tools="['bold',
							                                   'italic',
							                                   'underline',
							                                   'strikethrough',
							                                   'justifyLeft',
							                                   'justifyCenter',
							                                   'justifyRight',
							                                   'justifyFull',
							                                   'insertImage']"   
						                		data-bind="value:qna.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="qna_title bottom">
						                	첨부파일
						                </td>
						                <td colspan="5" class="bottom">
						                	<span data-bind="text:qna.image, invisible:editable" style="border: none; width: 100%; padding: 10px; font-size: 14px"></span>
						                	<input type="file" class="formInput" data-bind="value: qna.image, visible:editable"/>
						                </td>
						            </tr>
								</table><br/>
								<button type="button" class="btn btn-danger" style="float: left; border-radius: 5px" data-bind="click:delete , invisible:editable">삭제</button>
								<button type="button" class="btn btn-primary" style="float: left; border-radius: 5px" data-bind="click:edit , invisible:editable">수정</button>
								<button type="button" class="btn btn-success" style="float: left; border-radius: 5px" data-bind="click:reply , invisible:editable">답글</button>
								<button type="button" class="btn btn-info btn-md" style="float: right; border-radius: 5px" data-bind="click:saveOrUpdate, visible:editable">확인</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, visible:editable">취소</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close, invisible:editable">목록</button>
						    </form>
						 </div>
						 <div id="qna-reply-form" style="display: none;">
							<form id="qnaReplyForm" action="#">
								<div><span class="back" style="position:relative;" data-bind="click:close"></span></div>
								<table id="tb_qnaForm">
									<tr>
										<td class="qna_title">
											유형
										</td>
										<td colspan="5" style="padding-left: 10px">
											<input type="text" class="formInput" data-bind="value: qna.category" readonly/>
										</td>
									</tr>
						            <tr>
						                <td class="qna_title bottom">
						                	제목
						                </td>
						                <td colspan="5" style="border-top:1px solid lightgray" class="bottom">
						                	<input type="text" class="formInput" data-bind="value: qna.title" required/>
						                </td>
						            </tr>
						            <tr>
						            	<td class="qna_title" >
						                	작성자
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: qna.writer" readonly/>
				                        </td>
				                        <td class="qna_title" >
						                	작성일
						                </td>
				                        <td class="formTd">
				                            <input type="text" class="formInput" data-bind="value: qna.formattedWriteDate" readonly/>
				                        </td>
				                        <td class="qna_title" >
						                	조회수
						                </td>
				                        <td class="formTd"> 
				                            <input type="text" class="formInput" data-bind="value: qna.readCount" readonly size="4"/>
				                        </td>
				                    </tr>
						            <tr>
						                <td colspan="6" id="lastTd" >
						                	<textarea id="content" style="width: 100%; height:350px; border : none; padding: 5px; resize: none;" 
						                		data-role="editor"
							                    data-tools="['bold',
							                                   'italic',
							                                   'underline',
							                                   'strikethrough',
							                                   'justifyLeft',
							                                   'justifyCenter',
							                                   'justifyRight',
							                                   'justifyFull',
							                                   'insertImage']"   
						                		data-bind="value:qna.content"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="qna_title bottom">
						                	첨부파일
						                </td>
						                <td colspan="5" class="bottom">
						                	<input type="file" class="formInput" data-bind="value: qna.image"/>
						                </td>
						            </tr>
								</table><br/>
								<button type="button" class="btn btn-info btn-md" style="float: right; border-radius: 5px" data-bind="click:saveOrUpdate">확인</button>
								<button type="button" class="btn btn-warning btn-md" style="float: right; border-radius: 5px" data-bind="click:close">취소</button>
						    </form>
						 </div>
					</div>
				</div>
			</div>
	     </div>
	  </div><!-- /.container -->
										
	<!-- ./END MAIN CONTENT -->				
	<!-- START FOOTER -->
	<#include "/html/common/common-homepage-globalfooter.ftl" >
<!-- ./END FOOTER -->				
</div>									
<!-- START TEMPLATE -->			
   
	<#include "/html/common/common-homepage-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>fade