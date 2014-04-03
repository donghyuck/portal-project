<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title>기업소개</title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!${request.contextPath}/styles/jquery.extension/component.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',			
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/jquery.extension/modernizr.custom.js',
			'${request.contextPath}/js/jquery.extension/classie.js',
			],
			complete: function() {
			
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
				      
				// START SCRIPT	

				var currentUser = new User({});			
				// ACCOUNTS LOAD	
				var accounts = $("#account-navbar").kendoAccounts({
					connectorHostname: "${ServletUtils.getLocalHostAddr()}",	
					authenticate : function( e ){
						currentUser = e.token;						
					},
					<#if CompanyUtils.isallowedSignIn(action.company) ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					afterAuthenticate : function(){
						//$('.dropdown-toggle').dropdown();
						if( currentUser.anonymous ){
							var validator = $("#login-navbar").kendoValidator({validateOnBlur:false}).data("kendoValidator");							
							$("#login-btn").click(function() { 
								$("#login-status").html("");
								if( validator.validate() )
								{								
									accounts.login({
										data: $("form[name=login-form]").serialize(),
										success : function( response ) {
											$("form[name='login-form']")[0].reset();               
											$("form[name='login-form']").attr("action", "/main.do").submit();										
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
					}
				});				

				// 1. Announces 				
				
				//var effect =  kendo.fx($("#announce-list-view-panel")).fadeOut().duration(700); 
				$("#announce-list-view").data( "announcePlaceHolder", new Announce () );	
				$("#announce-grid").kendoGrid({
					dataSource: new kendo.data.DataSource({
						transport: {
							read: {
								type : 'POST',
								dataType : "json", 
								url : '${request.contextPath}/community/list-announce.do?output=json'
							},
							parameterMap: function(options, operation) {
								if (operation != "read" && options.models) {
									return {models: kendo.stringify(options.models)};
								}
							},
						},
						pageSize: 15,
						error:common.api.handleKendoAjaxError,				
						schema: {
							data : "targetAnnounces",
							model : Announce
						}
					}),	
					columns: [
						{field: "subject", title: "제목", sortable : false },
						{field: "creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}"}
					],
					sortable: true,
					pageable: false,
					selectable: "single",
					rowTemplate: kendo.template($("#announce-row-template").html()),
					height: 430,
					change: function(e) { 
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						$("#announce-gird").data( "announcePlaceHolder", selectedCell );
						displayAnnouncement();							
					}			
				});				
					
				<#if !action.user.anonymous >				
				
				</#if>	
				// END SCRIPT            
			}
		}]);	
		
		function displayAnnouncement () {			
			var announcePlaceHolder = $("#announce-grid").data( "announcePlaceHolder" );
			
			var template = kendo.template($('#announcement-detail-panel-template').html());			
			$("#announce-view-panel").html( template(announcePlaceHolder) );
			kendo.bind($("#announce-view-panel"), announcePlaceHolder );		
			
			$("#announce-view-panel").removeClass('hide');		
			
			var zoom = kendo.fx($("#announce-list-section")).zoom("out").endValue(0).startValue(1), slide = kendo.fx($("#announce-view-content-section")).slideIn("up") ;
			zoom.play();
			
			setTimeout(function() {
				zoom.stop();
				slide.play();
			}, 100);			
			
			$("#announce-view-panel").find(".close").click(function (e) {
				slide.reverse();
				setTimeout(function() {
					slide.stop();
					zoom.reverse();
					$("#announce-view-panel").addClass('hide');
				}, 100);
			});
			
		}				
		-->
		</script>		
		<style scoped="scoped">
		blockquote p {
			font-size: 15px;
		}

		.k-grid table tr.k-state-selected{
			background: #428bca;
			color: #ffffff; 
		}

		.k-listview div.k-state-selected{
			/*background: #F98262;*/
			background-color: transparent;
			color: #ffffff; 
		}
		
		#announce-list-section .k-grid-header .k-header {
			text-align: center;
		}


		.k-listview:after
		{
			content: ".";
			display: block;
			height: 0;
			clear: both;
			visibility: hidden;
		}
		
		.k-listview
		{
			padding: 0;
			min-width: 300px;
			min-height: 100px;
			background-color: transparent;
		}
				
		#announce-list-view {
			padding: 0px;
			border: 0px;		
		}
				
		.announcement {
			cursor: pointer;
		}
		
		.content-main-section {
			/** background: #F98262;	 */
			overflow: hidden;			
			width: 100%;
			height: 100%;
			min-height:500px;
		}
							
		</style>   	
	</head>
	<body>
		<!-- START HEADER -->
		<#include "/html/common/common-homepage-menu.ftl" >	
		<#assign current_menu = action.findMenuComponent("USER_MENU", "MENU_1_2") />
		<header class="cloud">
			<div class="container">
				<div class="col-lg-12">	
					<h1>${ current_menu.title }</h1>
					<h4><i class="fa fa-quote-left"></i>&nbsp;모든 이벤트와 공지사항을 한눈에 ~! &nbsp;<i class="fa fa-quote-right"></i></h4>
				</div>
			</div>
		</header>		
		<!-- END HEADER -->			
		<!-- START MAIN CONTENT -->	
		<div class="container layout">			
			<div class="row">
				<div class="col-lg-3 visible-lg">		
					<!-- start side menu -->		
					<div class="list-group">
					<#list current_menu.parent.components as item >
						<#if item.name ==  current_menu.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>										
					</div>	
					<!-- end side menu -->				
				</div>
				<div class="col-lg-9">		
				<div class="content-main-section">
					<section id="announce-list-section" style="position: absolute;	">
						<div id="announce-grid"></div>
					</section>
					<section id="announce-view-content-section" style="display:none;">						
						<div id="announce-view-panel"></div>
					</section>						
				</div>
				</div>				
			</div>
		</div>									 			
		<!-- END MAIN CONTENT -->	
		<script id="announce-row-template" type="text/x-kendo-tmpl">
			<tr data-uid="#: uid #">
				<td><span class="label label-info">공지</span>&nbsp;#: subject #	 </td>
				<td class="text-center">#: kendo.toString(creationDate, "yyyy.MM.dd") #</td>
			</tr>
		</script>
						
		<script id="alert-message-template" type="text/x-kendo-tmpl">
			<div class="alert alert-warning">새로운 공지 & 이벤트가 없습니다.</div>
		</script>			
			
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->	
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>