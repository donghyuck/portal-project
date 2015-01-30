<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
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
				
				createMemoryGauge();
				
											

					

				
							
				
				
				
				displayDiskUsage();
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
				alert(e.field );
				if( e.field === 'maxHeap' ){
					if( $("#mem-gen-gauge").data("kendoRadialGauge") )
				 		$("#mem-gen-gauge").data("kendoRadialGauge").value(sender.maxHeap);
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
												
								
					}
				})
			}, 6000);			
			
				
					/*
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
					
				});	
				
			
			
			*/
			
							
		}
		
		function displayDiskUsage () {
			var template = kendo.template( $("#disk-usage-row-template").html() );
			var dataSource = common.ui.datasource(
				'<@spring.url "/secure/view-system-diskusage.do?output=json"/>', // the remove service url
				{
					schema: { 
						data: "diskUsages"
                    },
                    change:function(e){
                    	if(this.view().length>0)			
							$("table .disk-usage-table-row").html(kendo.render(template, this.view()))
                    }		
			}).read();
		}		
				
		function displaySystemDetails (){		
			common.ui.ajax(
				'<@spring.url "/secure/view-system-details.do?output=json"/>',
				{
					success : function( response ){
						var data = response ;	
						kendo.bind($(".system-details"), data.systemInfo );			
						kendo.bind($(".license-details"), data.licenseInfo );					
					}
			});	
						
				$('#myTab a').click(function (e) {
					e.preventDefault();					
					if(  $(this).attr('href') == '#setup-info' ){
						if(!common.ui.exists($("#setup-props-grid")) ){
							common.ui.grid($('#setup-props-grid'), {
								dataSource : {
									transport: { 
										read: { url:'/secure/view-system-setup-props.do?output=json', type:'post' }
									},
									schema: {
										data: "setupApplicationProperties",
										model: common.ui.data.Property
									}
								},
								columns: [
										{ title: "속성", field: "name", width:400 },
										{ title: "값",   field: "value"}
									],
								pageable: false,
								resizable: true,
								editable : false,
								scrollable: true,
								height: 600
							});									
						}
					}else if(  $(this).attr('href') == '#database-info' ){
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
										},
										error:common.ui.handleAjaxError
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
					}
					$(this).tab('show');		
			});				
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
				<div class="row">	
				
						
					<div class="col-xs-12 col-lg-6">
						<div class="stat-panel system-details">
							<div class="stat-row">
								<!-- Bordered, without right border, top aligned text -->
								<div class="stat-cell col-sm-12 bordered no-border-r padding-sm-hr valign-top">									
									<h4 class="padding-sm no-padding-t padding-xs-hr"><i class="fa fa-desktop text-primary"></i></h4>
									<!-- Without margin -->
									<i class="fa fa-desktop bg-icon" style="font-size:60px;line-height:80px;height:80px;top: 0;"></i>
									<ul class="list-group no-margin">
										<li class="list-group-item no-border-hr padding-xs-hr">
											CPU <span class="label label-danger pull-right" data-bind="text: availableProcessors">0</span>
										</li> <!-- / .list-group-item -->
										<li class="list-group-item no-border-hr padding-xs-hr">
											OS <span class="pull-right" data-bind="text: operatingSystem">Unknown</span>
										</li> <!-- / .list-group-item -->
									</ul>
									<div class="table-light m-t-sm">
										<div class="table-header">
											<div class="table-caption">
												DISK 정보
											</div>
										</div>
										<table class="table table-bordered">
											<thead>
												<tr>
													<th>위치</th>
													<th>사용 중인 공간</th>
													<th>사용 가능한 공간</th>
													<th>전체 용량</th>
												</tr>
											</thead>
											<tbody class="valign-middle disk-usage-table-row"></tbody>
										</table>		
										<div class="table-footer">
										<small class="text-danger"><i class="fa fa-danger"></i>  사용가능 공간은 자바 가상 머신상에서 사용 가능한 공간을 의미합니다. </small>
										</div>
									</div>	
								</div> <!-- /.stat-cell -->
							</div>
						</div><!-- ./stat-panel -->					
					</div>	
					<div class="col-xs-6 col-lg-3">
						<div class="stat-panel text-center animated fadeIn memory-details" data-bind="visible: visible" style="display:none;">
							<div class="stat-row">						
								<div class="stat-cell bg-dark-gray padding-sm text-xs text-semibold">
									<i class="fa fa-flash"></i> Heap 메모리
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
									<i class="fa fa-flash"></i> PermGen 메모리
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
									<li class="active">
										<a href="#license-info" data-toggle="tab">라이센스 정보</a>
									</li>
									<li>
										<a href="#setup-info" data-toggle="tab">셋업 프로퍼티 정보</a>
									</li>
									<li>
										<a href="#system-info" data-toggle="tab">시스템 환경 정보</a>
									</li>
									<li>
										<a href="#database-info" data-toggle="tab">데이터베이스 정보</a>
									</li>							
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->					
							<div class="tab-content">
								<div class="tab-pane active" id="license-info">

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
								<div class="tab-pane" id="setup-info">
									<div class="panel-body padding-sm">
									<div class="note note-default no-margin-b no-border-vr">
										<h4 class="note-title">프로퍼티 요약</h4> 아래의 표를 참조하세요.
										<table class="table table-striped">
											<thead>
														<tr>
															<th>#</th>
															<th>이름(키)</th>
															<th>설명</th>														
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>1</td>
															<td>##</td>
															<td><code>true</code> ##</td>														
														</tr>											
													</tbody>
									</table></div>		
									</div>						
									<div id="setup-props-grid" class="no-border-hr no-border-b" ></div>		
								</div>
								<div class="tab-pane" id="system-info">
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
		<script id="disk-usage-row-template" type="text/x-kendo-template">			
			<tr>
				<td>
					#: absolutePath #
				</td>
				<td>#: common.ui.admin.bytesToSize(totalSpace - freeSpace) #
					<small class="text-light-gray">#= kendo.toString(( totalSpace - freeSpace), '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.ui.admin.bytesToSize(usableSpace) #
					<small class="text-light-gray">#= kendo.toString(usableSpace, '\\#\\#,\\#') #</small>
				</td>
				<td>#: common.ui.admin.bytesToSize(totalSpace) #
					<small class="text-light-gray">#= kendo.toString(totalSpace, '\\#\\#,\\#') #</small>
				</td>
			</tr>
		</script>								
												
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>