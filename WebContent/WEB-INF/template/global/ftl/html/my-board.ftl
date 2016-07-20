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

			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',	
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',
			
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'
					
			],			
			complete: function() {		
								
				common.ui.setup({
					features:{
						wallpaper : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								console.log( common.ui.stringify(currentUser ));
								
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
				
				<!----- 자유 게시판 그리드 ------>
					var renderTo = $("#board-list-grid");
 					var listGrid = renderTo.kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/board/listView.json?output=json" />",
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
                        //selectable: "row",
                        autoBind:true,
                        height: 515,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 100 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo#' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 150 },
                        	{ title: "작성일", field: "writeDate", width: 150, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 100 }
                        ],
                        dataBound: function(e) {
							var $this = this;
						}
                    });
                    
                    renderTo.on('click' , '[data-action=view]' , function(e){
                    	var $this = $(this);
                   		var objectId = $this.data("object-id");	
                   		var item = common.ui.grid(renderTo).dataSource.get(objectId);
                   		console.log(common.ui.stringify(item));
                   		renderTo.fadeOut(function(e){
                   			writeBoard(item);
                   		});
                    	
                    });
                    
                    $('#btn_write').on('click' , '[data-action=create], [data-action=update]' , function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newBoard ;
						if( objectId > 0){
							newBoard = common.ui.grid(renderTo).dataSource.get(objectId);
						}else{
							newBoard = new common.ui.data.community.Board();
						}
	                   	renderTo.fadeOut(function(e){
                   			$('#board-write-form').fadeIn();
                   			console.log(common.ui.stringify(newBoard));
                   			writeBoard(newBoard);
                   		});
                    	
                    });
                    
                    
               <!----- 공지사항 게시판 그리드 ------>
               		var noticeRenderTo = $('#notice-list-grid');
                    var noticeGrid = noticeRenderTo.kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/board/listView.json?output=json" />",
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
                        height: 515,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 100 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo #' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 150 },
                        	{ title: "작성일", field: "writeDate", width: 150, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 100 }
                        ],
                        dataBound: function(e) {
							var $this = this;
						}
                    });
                    
                    noticeRenderTo.on('click' , '[data-action=view]' , function(e){
                    	var $this = $(this);	
                   		var objectId = $this.data("object-id");	
                   		var item = common.ui.grid(noticeRenderTo).dataSource.get(objectId);
                   		console.log(objectId);
                   		console.log(common.ui.stringify(item));
                   		noticeRenderTo.fadeOut(function(e){
                   			writeNotice(item);
                   		});
                    	
                    });
                    
                    $('#notice_write').on('click' , '[data-action=create], [data-action=update]' , function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newNotice ;
						if( objectId > 0){
							newNotice = common.ui.grid(noticeRenderTo).dataSource.get(objectId);
						}else{
							newNotice = new common.ui.data.community.Board();
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
                                	url: "<@spring.url "/data/podo/board/listView.json?output=json" />",
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
                                model: common.ui.data.community.Board,
                                data: "items",
                                total: "totalCount"
                            },
                            serverPaging:true,
                            serverFiltering: true,
                            pageSize: 10
                        },
                        autoBind:true,
                        height: 515,
                        pageable: {
                       		pageSize: 10,
    						refresh: true
                        },
                        columns: [
                        	{ title: "글번호", field: "boardNo", width: 80 },
                        	{ title: "분류", field: "category", width: 130 },
                        	{ title: "제목", field: "title", template: "<a href='\\#' data-object-id='#= data.boardNo #' data-action='view'>#= title #</a>" },
                        	{ title: "작성자", field: "writer", width: 120 },
                        	{ title: "작성일", field: "writeDate", width: 120, format:"{0:yyyy/MM/dd}" },
                        	{ title: "조회수", field: "readCount", width: 80 }
                        ],
                        dataBound: function(e) {
							var $this = this;
						}
                    });
                    
                     qnaRenderTo.on('click' , '[data-action=view]' , function(e){
                    	var $this = $(this);	
                   		var objectId = $this.data("object-id");	
                   		var item = common.ui.grid(qnaRenderTo).dataSource.get(objectId);
                   		console.log(objectId);
                   		console.log(common.ui.stringify(item));
                   		qnaRenderTo.fadeOut(function(e){
                   			writeQna(item);
                   		});
                    	
                    });
                    
                    $('#qna_write').on('click' , '[data-action=create], [data-action=update]' , function(e){
                    	var $this = $(this);
                    	var objectId = $this.data("object-id");	
						var newQna ;
						if( objectId > 0){
							newNotice = common.ui.grid(qnaRenderTo).dataSource.get(objectId);
						}else{
							newQna = new common.ui.data.community.Board();
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
			
			var renderTo = $('#board-write-form');
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
					edit:function(){
						this.set('editable', true);
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.board) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/write.json?output=json" />' , 
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
									common.ui.grid( $('#board-list-grid') ).dataSource.read();														
									$this.close();
								}
							}
						);	
						return false;	
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.board);
						$this.set('editable', ($this.board.boardNo > 0 ? false: true ));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/updateReadCount.json?output=json" />',
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){	
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
					},
					create : function(e){
						var empty = new common.ui.data.community.Board();
						createBoardEditor(empty);
					},
					update : function(e){
						e.stopPropagation();
						createBoardEditor(this.board);
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
			renderTo.data("model").setSource( source );	
				if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}		
		}
		
	<!---- 공지게시판 쓰기/수정/삭제 폼 ---->		
		function writeNotice(source){
			
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
					edit:function(){
						this.set('editable', true);
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.notice) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/write.json?output=json" />' , 
							{
								data : kendo.stringify( $this.notice ),
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
									common.ui.grid( $('#notice-list-grid') ).dataSource.read();														
									$this.close();
								}
							}
						);	
						return false;	
					},
					setSource : function(source){
						var $this = this;
						//console.log($this.notice);
						source.copy($this.notice);
						$this.set('editable', ($this.notice.boardNo > 0 ? false : true ));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/updateReadCount.json?output=json" />',
							{
								data : kendo.stringify( $this.notice ),
								contentType : "application/json",
								success : function(response){	
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
					},
					create : function(e){
						var empty = new common.ui.data.community.Board();
						createNoticeEditor(empty);
					},
					update : function(e){
						e.stopPropagation();
						createNoticeEditor(this.notice);
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#notice-list-grid").fadeIn();
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
			
			var renderTo = $('#qna-write-form');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					qna : new common.ui.data.community.Board(),
					editable : false,
					propertyDataSource : new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					edit:function(){
						this.set('editable', true);
					},
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.qna) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/write.json?output=json" />' , 
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
									common.ui.grid( $('#qna-list-grid') ).dataSource.read();														
									$this.close();
								}
							}
						);	
						return false;	
					},
					setSource : function(source){
						var $this = this;
						source.copy($this.qna);
						$this.set('editable', ($this.qna.boardNo > 0 ? false : true ));
						common.ui.ajax(
							'<@spring.url "/data/podo/board/updateReadCount.json?output=json" />',
							{
								data : kendo.stringify( $this.qna ),
								contentType : "application/json",
								success : function(response){	
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
					},
					create : function(e){
						var empty = new common.ui.data.community.Board();
						createNoticeEditor(empty);
					},
					update : function(e){
						e.stopPropagation();
						createNoticeEditor(this.qna);
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




		function createBoardEditor(source){
			var renderTo = $("board-write-form");
			if( !renderTo.data("model")){
				var model = common.ui.observable({
					board : new common.ui.data.community.Board(),
					new : true,
					visible : true,
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.board) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/write.json?output=json" />' , 
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
									common.ui.grid( $('#board-list-grid') ).dataSource.read();														
									$this.close();
								}
							}
						);	
						return false;	
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#board-list-grid").fadeIn();
						});
					}
				});
				kendo.bind( renderTo, model);
				renderTo.data("model", model);	
			}
			$("#board-detail-view").fadeOut( "slow", function(e){
				renderTo.fadeIn();
			});
		}
		
		
		
		function createNoticeEditor(source){
			var renderTo = $("notice-write-form");
			if( !renderTo.data("model")){
				var model = common.ui.observable({
					notice : new common.ui.data.community.Board(),
					new : true,
					visible : true,
					saveOrUpdate: function(e){
						var $this = this;
						console.log( kendo.stringify( $this.notice) );
						common.ui.ajax(
							'<@spring.url "/data/podo/board/write.json?output=json" />' , 
							{
								data : kendo.stringify( $this.notice ),
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
									common.ui.grid( $('#notice-list-grid') ).dataSource.read();														
									$this.close();
								}
							}
						);	
						return false;	
					},
					close : function(){
						renderTo.fadeOut(function(e){ 
							$("#notice-list-grid").fadeIn();
						});
					}
				});
				kendo.bind( renderTo, model);
				renderTo.data("model", model);	
			}
			$("#notice-list-grid").fadeOut( "slow", function(e){
				renderTo.fadeIn();
			});
		}
		
		
		
   /*		
		function createBoardDetailView(source){
			var renderTo = $('#board-detail-view');
			//console.log(common.ui.stringify(source));
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({
					board : new common.ui.data.community.Board(),
					setSource : function(source){
						var $this = this;
						source.copy($this.board);
						common.ui.ajax(
							'<@spring.url "/data/podo/board/updateReadCount.json?output=json" />',
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){	
									common.ui.grid($('#board-list-grid')).dataSource.read();						
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
					},
					delete: function(){
						var $this = this;
						source.copy($this.board);
						common.ui.ajax(
							'<@spring.url "/data/podo/board/delete.json?output=json" />',
							{
								data : kendo.stringify( $this.board ),
								contentType : "application/json",
								success : function(response){									
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
					},
					close: function(){
						renderTo.fadeOut(function(e){ 
							$("#board-list-grid").fadeIn();
						});
					}
						
				});			
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
		
			renderTo.data("model").setSource( source );	
			if(!renderTo.is(':visible'))
			{
				renderTo.fadeIn();
			}
			
		}
	*/
	
			
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
			#tb_detailView {
				width: 100%;
				border-top: 2px solid #F7819F;
			}
			#tb_detailView td {	border-bottom: 1px solid lightgray;	}
			#tb_detailView input { border: none; }
			#lastTd { border: 1px solid lightgray; }
			#tb_writeForm {
				width: 100%;
				border-top: 3px solid #F7819F;
				border-bottom: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			#tb_noticeForm {
				width: 100%;
				border-top: 3px solid #0404B4;
				border-bottom: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			#tb_qnaForm {
				width: 100%;
				border-top: 3px solid #298A08;
				border-bottom: 1px solid lightgray;
				padding: 0;
				margin: 0;
			}
			#tb_writeForm td, 
			#tb_noticeForm td, 
			#tb_qnaForm td { border-right: 1px solid lightgray;	}
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
			.formTd input {	border: none; }
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
		</style>
		</#compress>
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
						<li><a href="#noticeBoard" data-toggle="tab" class="m-l-sm rounded-top">공지게시판</a></li>
						<li><a href="#freeBoard" data-toggle="tab" class="m-l-sm rounded-top">자유게시판</a></li>
						<li><a href="#qnaBoard" data-toggle="tab" class="m-l-sm rounded-top">QnA게시판</a></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane fade" id="freeBoard">
							<span style="color: #FE2E64; font-size:30px; font-weight:bold">자유게시판</span>&nbsp;&nbsp;&nbsp;<span style="color: gray">이곳은 누구나 글을 작성하실 수 있습니다.</span>
							<div id="board-list">
								<div id="board-list-grid">
									<div id="btn_write">
										<button type="button" class="btn btn-danger" style="float: right; border-radius: 5px" data-action="create">글쓰기</button>
									</div>
								</div>
							</div>
							<div id="board-write-form" style="display: none;">
							<form id="writeForm" action="#">
								<div><span class="back" style="position:relative;" data-bind="click:close"></span></div>
								<table id="tb_writeForm">
						            <tr>
						                <td class="input_title" >
						                	제목
						                </td>
						                <td colspan="5">
						                	<span data-bind="text:board.title, invisible:editable" class="formInput"></span>
						                	<input type="text" class="formInput" data-bind="value: board.title, visible:editable" required/>
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
						                	<div data-bind="text:board.content, invisible:editable" style="height:300px; padding: 5px"></div>
						                	<textarea id="content" rows="20" style="width: 100%; border : none; padding: 5px; resize: none;" required data-bind="value:board.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="input_title">
						                	첨부파일
						                </td>
						                <td colspan="5">
						                	<span data-bind="text:board.image, invisible:editable" style="border: none; width: 100%; padding: 10px; font-size: 14px"></span>
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
					<div class="tab-pane fade" id="noticeBoard">
						<span style="color: #2E2EFE; font-size:30px; font-weight:bold">공지게시판</span>&nbsp;&nbsp;&nbsp;<span style="color: gray">공지사항을 알려드립니다.</span>
						<div>
							<div id="notice-list-grid">
								<div id="notice_write"><button class="btn btn-primary" style="float: right; border-radius: 5px" data-action="create">글쓰기</button></div>
							</div>
						</div>
						<div id="notice-write-form" style="display: none;">
							<form id="noticeForm" action="#">
								<div><span class="back" style="position:relative;" data-bind="click:close"></span></div>
								<table id="tb_noticeForm">
						            <tr>
						                <td class="notice_title" >
						                	제목
						                </td>
						                <td colspan="5">
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
						                	<div data-bind="text:notice.content, invisible:editable" style="height:300px; padding: 5px"></div>
						                	<textarea id="content" rows="20" style="width: 100%; border : none; padding: 5px; resize: none;" required data-bind="value:notice.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="notice_title">
						                	첨부파일
						                </td>
						                <td colspan="5">
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
							<div id="qna-list-grid">
								<div id="qna_write"><button class="btn btn-success" style="float: right; border-radius: 5px" data-action="create">글쓰기</button></div>
							</div>
						</div>
						<div id="qna-write-form" style="display: none;">
							<form id="qnaForm" action="#">
								<div><span class="back" style="position:relative;" data-bind="click:close"></span></div>
								<table id="tb_qnaForm">
									<tr>
										<td class="qna_title">
											유형
										</td>
										<td colspan="5" style="padding-left: 10px">
											<span data-bind="text:qna.category, invisible:editable" class="formInput"></span>
											<select name="category" style="font-size:14px" data-bind="qna.category, visible:editable" required>
												<option value="">유형을 선택하세요.</option>
												<option value="수업">수업</option>
												<option value="학적">학적</option>
												<option value="유학/연수/교류">유학/연수/교류</option>
												<option value="교직">교직</option>
												<option value="장학/융자">장학/융자</option>
												<option value="기타">기타</option>
											</select>
										</td>
									</tr>
						            <tr>
						                <td class="qna_title">
						                	제목
						                </td>
						                <td colspan="5" style="border-top:1px solid lightgray">
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
						                	<div data-bind="text:qna.content, invisible:editable" style="height:300px; padding: 5px"></div>
						                	<textarea id="content" rows="20" style="width: 100%; border : none; padding: 5px; resize: none;" required data-bind="value:qna.content, visible:editable"></textarea>
						                </td>
						            </tr>
						             <tr>
						                <td class="qna_title">
						                	첨부파일
						                </td>
						                <td colspan="5">
						                	<span data-bind="text:qna.image, invisible:editable" style="border: none; width: 100%; padding: 10px; font-size: 14px"></span>
						                	<input type="file" class="formInput" data-bind="value: qna.image, visible:editable"/>
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