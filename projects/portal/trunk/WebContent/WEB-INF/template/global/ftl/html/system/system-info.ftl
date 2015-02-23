<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css"/>',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css"/>',	
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo/kendo.dataviz.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/fastclick.js"/>', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>'
			],
			complete: function() {
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				common.ui.admin.setup({					 
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});		
				
				//createMemoryGauge();
				//displayDiskUsage();
				displaySystemDetails();					
				// END SCRIPT
			}
		}]);
		
		function createMemoryGauge(){		
			var observable =  common.ui.observable({ 
				visible : false,
				allocateHeap : 0,
				availableHeap : 0,
				maxHeap : 0,
				usedHeap : 0,
				freeAllocatedHeap : 0,
				maxPermGen : 0,
				availablePermGen : 0,
				usedPermGen : 0				
			});				
			observable.bind("change", function(e){		
				var sender = e.sender ;				
				if( e.field === 'usedHeap' ){
					if( $("#mem-gen-gauge").data("kendoRadialGauge") )
				 		$("#mem-gen-gauge").data("kendoRadialGauge").value(sender.usedHeap);
				}else if (e.field === 'usedPermGen'){
					if( $("#perm-gen-gauge").data("kendoRadialGauge") )
						$("#perm-gen-gauge").data("kendoRadialGauge").value(sender.usedPermGen);
				}
			});									
			common.ui.bind($(".memory-details"), observable );								
			setInterval(function(){
				common.ui.ajax('<@spring.url "/secure/data/stage/memory/get.json?output=json"/>', {
					success : function(response){
						observable.set("allocateHeap", response.allocateHeap.megabytes );
						observable.set("availableHeap", response.availableHeap.megabytes );
						observable.set("maxHeap", response.maxHeap.megabytes );
						observable.set("usedHeap", response.usedHeap.megabytes );
						observable.set("freeAllocatedHeap", response.freeAllocatedHeap.megabytes );
						observable.set("maxPermGen", response.maxPermGen.megabytes );
						observable.set("availablePermGen", response.availablePermGen.megabytes );
						observable.set("usedPermGen", response.usedPermGen.megabytes );
						observable.set("visible", true );		
						
						if( ! $("#mem-gen-gauge").data("kendoRadialGauge") ){	
								$("#mem-gen-gauge").kendoRadialGauge({
									theme: "white",
									pointer: {
										value: observable.usedHeap,
										color: "#ea7001"									
									},
									scale: {
										majorUnit: 100,
										minorUnit: 10,
										startAngle: -30,
	                            		endAngle: 210,
										max: observable.maxHeap,
										ranges: [
											{
												from:  ( observable.maxHeap -  ( ( observable.maxHeap / 10 ) * 2 ) ) ,
												to:  ( observable.maxHeap -  observable.maxHeap / 10 ) ,
												color: "#ff7a00"
											}, {
												from: ( observable.maxHeap -  observable.maxHeap / 10 ) ,
												to: observable.maxHeap,
												color: "#c20000"
											}
										]			
									}
								});						
						}							
						if( ! $("#perm-gen-gauge").data("kendoRadialGauge") ){	
							$("#perm-gen-gauge").kendoRadialGauge({
								theme: "white",
								pointer: {
									value: observable.usedPermGen,
									color: "#ea7001"		
								},
								scale: {
									majorUnit: 50,
									minorUnit: 10,
									startAngle: -30,
									endAngle: 210,
									max: observable.maxPermGen,
									ranges: [
										{
											from:  ( observable.maxPermGen -  ( ( observable.maxPermGen / 10 ) * 2 ) ) ,
											to:  ( observable.maxPermGen -  observable.maxPermGen / 10 ) ,
											color: "#ff7a00"
										}, {
											from: ( observable.maxPermGen -  observable.maxPermGen / 10 ) ,
											to: observable.maxPermGen,
											color: "#c20000"
										}
									]								
								}
							});	
						}		
					}
				})
			}, 6000);						
		}
		
		function displayDiskUsage () {
			var template = kendo.template( $("#disk-usage-row-template").html() );
			var dataSource = common.ui.datasource(	'<@spring.url "/secure/data/stage/disk/list.json?output=json"/>', {
				 change:function(e){
					if(this.view().length>0)			
						$("table .disk-usage-table-row").html(kendo.render(template, this.view()))
				}		
			}).read();
			
			$(".system-details .table-header button" ).click(function(e){
				dataSource.read();
			});
			
		}		
				
		function displaySystemDetails (){				
			common.ui.ajax('<@spring.url "/secure/data/stage/os/get.json?output=json"/>', {
				success : function( data ){
					kendo.bind($(".system-details"), data );
				}
			});				
			$('#myTab').on( 'show.bs.tab', function (e) {		
					var target = $(e.target);
					switch( target.attr('href') ){
						case "#library-info" :
							if(! common.ui.exists($("#library-info-grid")) ){
								common.ui.grid($('#library-info-grid'), {
									dataSource: {
										transport: { 
											read: { url:'/secure/data/stage/more/list_library.json?output=json', type:'post' }
										},						
										batch: false, 
										schema: {
											model: {
												fields: {
													name: {type: "string"},
													group: { type: "string", defaultValue: "-" },
													artifact:{ type:"string", defaultValue: "-"},
													version: {type: "string", defaultValue: "-"},
													timestamp: {type: "string", defaultValue: "-"},
													lastModified : { type:"date"}
												}										
											}
										},
										sort: { field: "name", dir: "asc" }
									},
									columns: [
										{ title: "Name", field: "name"},
										{ title: "Group", field: "group" },
										{ title: "Artifact", field: "artifact" },
										{ title: "Version", field: "version", width:90 , filterable: false},
										{ title: "Timestamp", field: "timestamp" , filterable: false },
										{ title: "Last Modified", field: "lastModified", format: "{0:yyyy.MM.dd HH:mm:ss}" , filterable: false },
									],
									pageable: false,
									resizable: true,
									filterable: true,
									editable : false,
									sortable: true,
									scrollable: true,
									height: 500,
									change: function(e) {
									}
								});
							}														
							break;
						case "#database-info" :
							if(! common.ui.exists($("#database-info-grid")) ){
								common.ui.grid($('#database-info-grid'), {
									dataSource: {
										transport: { 
											read: { url:'/secure/view-system-databases.do?output=json', type:'post' }
										},						
										batch: false, 
										schema: {
											data: "databaseInfos",
											model: common.ui.data.DatabaseInfo
										}
									},
									columns: [
										{ title: "데이터베이스", field: "databaseVersion"},
										{ title: "JDBC 드라이버", field: "driverName + ' ' + driverVersion" },
										{ title: "ISOLATION", field: "isolationLevel", width:90 },
									],
									pageable: false,
									resizable: true,
									editable : false,
									scrollable: true,
									height: 200,
									change: function(e) {
									}
								});
							}								
							break;
						case  '#license-info' :
							if( !$("#license-info").data("on") ){
								common.ui.ajax('<@spring.url "/secure/data/config/license/get.json?output=json"/>', {
									success : function( data ){
										kendo.bind($(".license-details"), data );
										$("#license-info").data("on", true)
									}
								});			
							} 
							break;
					}					
			});				
			$('#myTab a:first').tab('show');								
		}
		-->
		</script> 		 
		<style>
			.table-light .table thead th {
				text-align: center;
			}
			
			table-light .table-footer {
				margin-top:-20px;
			}
			
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_5") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row"  style="min-height:328px;">						
					<div class="col-xs-6 col-lg-3">
						<div class="stat-panel text-center animated fadeIn memory-details" data-bind="visible: visible" style="display:none;">
							<div class="stat-row">						
								<div class="stat-cell bg-dark-gray padding-sm text-xs text-semibold">
									<i class="fa fa-flash"></i> Heap Memory
								</div>
							</div><!-- /.stat-row -->
							<div class="stat-row">								
								<div class="stat-cell bordered no-border-t no-padding-hr" style="padding: 0 0 0 0;">								
									<div id="mem-gen-gauge" style="display: inline-block !important;"></div>									
								</div>							
							</div> <!-- /.stat-row -->						
							<div class="stat-row">
								<div class="stat-counters bg-primary bordered no-border-t text-center">
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: maxHeap"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Total Memory</span>
									</div>
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: usedHeap"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Used Memory</span>
									</div>
								</div> <!-- /.stat-counters -->
							</div>						
						</div> <!-- /.stat-panel -->
					</div>					
					<div class="col-xs-6 col-lg-3">
						<div class="stat-panel text-center animated fadeIn memory-details" data-bind="visible: visible" style="display:none;">
							<div class="stat-row">
								<!-- Dark gray background, small padding, extra small text, semibold text -->
								<div class="stat-cell bg-dark-gray padding-sm text-xs text-semibold">
									<i class="fa fa-flash"></i> PermGen Memory
								</div>
							</div> <!-- /.stat-row -->
							<div class="stat-row">
								<!-- Bordered, without top border, without horizontal padding -->
								<div class="stat-cell bordered no-border-t no-padding-hr" style="padding: 0 0 0 0;">	
									<div id="perm-gen-gauge" style="display: inline-block !important;"></div>
								</div>							
							</div> <!-- /.stat-row -->
							<div class="stat-row">
								<div class="stat-counters bg-danger bordered no-border-t text-center">
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: maxPermGen"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Total Memory</span>
									</div>
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: usedPermGen"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Used Memory</span>
									</div>
								</div> <!-- /.stat-counters -->
							</div>													
						</div> <!-- /.stat-panel -->
					</div>									
				</div><!-- memory status end -->
				<hr class="no-grid-gutter-h grid-gutter-margin-b no-margin-t">				
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="myTab">
									<li>
										<a href="#license-info" data-toggle="tab">라이센스</a>
									</li>
									<li>
										<a href="#system-info" data-toggle="tab">시스템 환경</a>
									</li>
									<li>
										<a href="#library-info" data-toggle="tab">라이브러리</a>
									</li>
									<!--<li>
										<a href="#database-info" data-toggle="tab">데이터베이스 정보</a>
									</li>-->							
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->					
							<div class="tab-content">
								<div class="tab-pane active" id="license-info">
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-sm-3 hidden-xs text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-certificate bg-icon bg-icon-left"></i>								
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-sm-9 no-padding valign-bottom">		
											<p class="text-success m-sm"><i class="fa fa-info"></i>  설치된 라이센스 정보입니다.</p>	
													<table class="table table-hover license-details">
														<tbody>
															<tr>
																<th>발급 ID</th>
																<td><span data-bind="text: licenseId"></span></td>
															</tr>								
															<tr>
																<th>제품</th>
																<td><span data-bind="text: name"></span></td>
															</tr>			
															<tr>
																<th>버전</th>
																<td><span data-bind="text: version.versionString"></span></td>
															</tr>				
															<tr>
																<th>에디션</th>
																<td><span class="label label-info"><span data-bind="text: edition"></span></span></td>
															</tr>																
															<tr>
																<th>타입</th>
																<td><span class="label label-danger"><span data-bind="text: type"></span></span></td>
															</tr>																	
															<tr>
																<th>발급일</th>
																<td><span data-bind="text: creationDate"></span></td>
															</tr>	
															<tr>
																<th>발급대상</th>
																<td><span data-bind="text: client.company"></span>(<span data-bind="text: client.name"></span>)</td>
															</tr>	
													 	</tbody>
													</table>		
										</div>
									</div>													
								</div>
								<div class="tab-pane" id="system-info">
									<div class="stat-panel no-margin-b">
										<div class="stat-cell col-xs-3 text-center">
											<!-- Stat panel bg icon -->
											<i class="fa fa-server bg-icon bg-icon-left"></i>								
										</div> <!-- /.stat-cell -->
										<div class="stat-cell col-xs-9 no-padding valign-bottom">		
											<p class="text-success m-sm"><i class="fa fa-info"></i>  시스템 환경 정보는 자바 가상머신에서 제공하는 정보를 의미합니다. </p>
											<table class="table table-hover system-details">
													<tbody>
														<tr>
															<th>운영시스템</th>
															<td><span data-bind="text: operatingSystem"></span></td>
														</tr>
														<tr>
															<th>시스템 언어</th>
															<td><span data-bind="text: systemLanguage"></span></td>
														</tr>						
														<tr>
															<th>표준 시간대</th>
															<td><span data-bind="text: systemTimezone"></span></td>
														</tr>																			
														<tr>
															<th>시스템 날짜</th>
															<td><span data-bind="text: date"></span></td>
														</tr>
														<tr>
															<th>시스템 시간</th>
															<td><span data-bind="text: time"></span></td>
														</tr>							
														<tr>
															<th>임시 디렉터리</th>
															<td><span data-bind="text: tempDirectory"></span></td>
														</tr>									
														<tr>
															<th>파일 시스템 인코딩</th>
															<td><span data-bind="text: fileSystemEncoding"></span></td>
														</tr>
														<tr>
															<th>작업 디렉터리</th>
															<td><span data-bind="text: workingDirectory"></span></td>
														</tr>										
														<tr>
															<th>자바 실행환경</th>
															<td><span data-bind="text: javaRuntime"></span></td>
														</tr>			
														<tr>
															<th width="150">자바 벤더</th>
															<td><span data-bind="text: javaVendor"></span></td>
														</tr>		
														<tr>
															<th>자바 버전</th>
															<td><span data-bind="text: javaVersion"></span></td>
														</tr>			
														<tr>
															<th>가상머신</th>
															<td><span data-bind="text: javaVm"></span></td>
														</tr>	
														<tr>
															<th>가상머신 벤더</th>
															<td><span data-bind="text: jvmVendor"></span></td>
														</tr>
														<tr>
															<th>가상머신 버전</th>
															<td><span data-bind="text: jvmVersion"></span></td>
														</tr>																				
														<tr>
															<th>가상머신 구현 버전</th>
															<td><span data-bind="text: jvmImplementationVersion"></span></td>
														</tr>											
														<tr>
															<th>가상머신 옵션</th>
															<td><span data-bind="text: jvmInputArguments"></span></td>
														</tr>											
													</tbody>
											</table>	
										</div>
									</div>
								</div>
								<div class="tab-pane" id="library-info">
									<div id="library-info-grid" class="no-border-hr no-border-b"></div>
								</div>	
								<div class="tab-pane" id="database-info">
									<div id="database-info-grid" class="no-border-hr no-border-b"></div>
								</div>		
							</div><!-- tab contents end -->
							<div class="panel-footer no-padding-vr"></div>
						</div><!-- /.panel -->
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>