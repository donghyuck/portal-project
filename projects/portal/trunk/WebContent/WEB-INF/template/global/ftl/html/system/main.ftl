<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',	
			'css!${request.contextPath}/styles/codedrop/codedrop.overlay.css',			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
       	    '${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',      	    
       	    '${request.contextPath}/js/kendo/kendo.ko_KR.js',
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',       	    
       	    '${request.contextPath}/js/common/common.modernizr.custom.js',
       	    '${request.contextPath}/js/common/common.models.js',
       	    '${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.api.js',
			],        	  	   
			complete: function() {      
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
										
				// 2. ACCOUNTS LOAD		
				var currentUser = new User({});
				var accounts = $("#account-panel").kendoAccounts({
					visible : false,
					authenticate : function( e ){
						currentUser = e.token;						
					}
				});
										
				var currentCompany = new Company();							
				var selectedCompany = new Company();	
										
				// 3.MENU LOAD
				var currentPageName = "MENU_1_1";
				
				var topBar = $("#navbar").extTopBar({ 
					template : kendo.template($("#topbar-template").html() ),
					data : currentUser,
					menuName: "SYSTEM_MENU",
					items: {
						id:"companyDropDownList", 
						type: "dropDownList",
						dataTextField: "displayName",
						dataValueField: "companyId",
						value: ${action.companyId},
						enabled : false,
						dataSource: {
							transport: {
								read: {
									type: "json",
									url: '${request.contextPath}/secure/list-company.do?output=json',
									type:'POST'
								}
							},
							schema: { 
								data: "companies",
								model : Company
							}
						},
						change : function(data){
							currentCompany = data ;
							kendo.bind($("#company-info-panel"), selectedCompany );   
						}
					},
					doAfter : function(that){
						var menu = that.getMenuItem(currentPageName);
						kendo.bind($(".page-header"), menu );   
					}
				 });	
				 
				 
				 
					$("#splitter").height( $(window).height() - 150 );
				
 				var splitter = $("#splitter").kendoSplitter({
					orientation: "horizontal",
						panes: [
							{ collapsible: false, size: "50%" },
							{ collapsible: true, size: "50%" }
						],
					resize: function () {
					        if(splitter) {
					            //alert(splitter.wrapper.height());
					$("#splitter").height( $(window).height() - 150 );            
					$("#splitter").find(".k-splitbar").height( $(window).height() - 150 );
					$("#splitter").find(".k-pane").height( $(window).height() - 150 );
					        }
					        //you can also get the panes each on it's own.
					        //check: console.log(splitter); to see what options are available           
					    }						
				}).data("kendoSplitter");
				
				splitter.resize();
				
				// END SCRIPT
			}
		}]);
		-->
		</script> 		 
		<style>

		</style>
	</head>
	<body>
		<!-- START HEADER -->
		<section id="navbar"></section>
		<!-- END HEADER -->
		<!-- START MAIN CONTNET -->
		<div class="container-fluid">		
			<div class="row">			
				<div class="col-sm-12">
					<div class="page-header">
						<h1><span data-bind="text: title"></span>     <small><i class="fa fa-quote-left"></i>&nbsp;<span data-bind="text: description"></span>&nbsp;<i class="fa fa-quote-right"></i></small></h1>
					</div>	
				</div>			
			</div>	
			<div class="row">		
				<div class="col-sm-12">
				
			<div id="splitter">
                <div id="list_pane" class="color1">
                    <p>
                        Left pane
                    </p>
                </div>
                <div id="detail_pane" class="color2">
                    <p>
                        Right pane
                    </p>
                </div>
			</div>
					
				</div>
			</div>
		</div>				
		<div id="account-panel"></div>
		<!-- END MAIN CONTENT -->					
		<!-- START FOOTER -->
		<!-- END FOOTER -->				
		<!-- 공용 템플릿 -->
		<#include "/html/common/common-secure-templates.ftl" >
	</body>    
</html>