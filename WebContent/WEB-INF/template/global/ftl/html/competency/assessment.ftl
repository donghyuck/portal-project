<#ftl encoding="UTF-8"/>
<#assign page = action.getPage() >
<html decorator="unify">
<head>
<#compress>
<title>${page.title}</title>
<script type="text/javascript">
<!--
var jobs = [];	
yepnope([{
    load: [        
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/codrops/codrops.svgcheckbox.css"/>',	
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/codrops/codrops.svgcheckbx.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],   			     
		complete : function() {
			common.ui.setup({
				jobs:jobs
			});		
			
			<#if RequestParameters['id']?? >
			var	assessmentId = ${ TextUtils.parseLong( RequestParameters['id'] ) } ;			
			common.ui.ajax( '<@spring.url "/data/accounts/get.json?output=json"/>' , {
				success : function(response){
					var currentUser = new common.ui.data.User($.extend( response.user, { roles : response.roles }));					
					common.ui.ajax( '<@spring.url "/data/me/competency/assessment/get.json?output=json"/>' , {
						data : { assessmentId : assessmentId},
						success : function(response){
							var assessment = new common.ui.data.competency.Assessment(response);		
							
							console.log(common.ui.stringify(assessment));
						}
					});
					
				}
			});			
			<#else>
			alert("잘못된 접근입니다.");
			</#if>		
			
			var formWrap = document.getElementById( 'fs-form-wrap' );

				[].slice.call( document.querySelectorAll( 'select.cs-select' ) ).forEach( function(el) {	
					new SelectFx( el, {
						stickyPlaceholder: false,
						onChange: function(val){
							document.querySelector('span.cs-placeholder').style.backgroundColor = val;
						}
					});
				} );

				new FForm( formWrap, {
					onReview : function() {
						classie.add( document.body, 'overview' ); // for demo purposes only
					}
				} );
					
		}
	} ]);
		
	-->
</script>
<style>
	h2{
	    display: block;
	    line-height: 1.5em;
	    font-size: 1.5em;
	    -webkit-margin-before: 0.83em;
	    -webkit-margin-after: 0.83em;
	    -webkit-margin-start: 0px;
	    -webkit-margin-end: 0px;
	    font-weight: bold;
	}
</style>
</#compress>
</head>
<body class="bg-dark">
	<div class="page-loader"></div>
 	<div class="wrapper">
 	</div>
  		<div class="container">
 
 <div class="fs-form-wrap" id="fs-form-wrap">
				<div class="fs-title">
					<h1>Project Worksheet</h1>
					<div class="codrops-top">
						<a class="codrops-icon codrops-icon-prev" href="http://tympanus.net/Development/NotificationStyles/"><span>Previous Demo</span></a>
						<a class="codrops-icon codrops-icon-drop" href="http://tympanus.net/codrops/?p=19520"><span>Back to the Codrops Article</span></a>
						<a class="codrops-icon codrops-icon-info" href="#"><span>This is a demo for a fullscreen form</span></a>
					</div>
				</div>
				<form id="myform" class="fs-form fs-form-full" autocomplete="off">
					<ol class="fs-fields">
						<li class="fs-current">
							<label class="fs-field-label fs-anim-upper" for="q1">What's your name?</label>
							<input class="fs-anim-lower" id="q1" name="q1" type="text" placeholder="Dean Moriarty" required="">
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q2" data-info="We won't send you spam, we promise...">What's your email address?</label>
							<input class="fs-anim-lower" id="q2" name="q2" type="email" placeholder="dean@road.us" required="">
						</li>
						<li data-input-trigger="">
							<label class="fs-field-label fs-anim-upper" for="q3" data-info="This will help us know what kind of service you need">What's your priority for your new website?</label>
							<div class="fs-radio-group clearfix fs-anim-lower">
								<span><input id="q3b" name="q3" type="radio" value="conversion"><label for="q3b" class="radio-conversion">Sell things</label></span>
								<span><input id="q3c" name="q3" type="radio" value="social"><label for="q3c" class="radio-social">Become famous</label></span>
								<span><input id="q3a" name="q3" type="radio" value="mobile"><label for="q3a" class="radio-mobile">Mobile market</label></span>
							</div>
						</li>
						<li data-input-trigger="">
							<label class="fs-field-label fs-anim-upper" data-info="We'll make sure to use it all over">Choose a color for your website.</label>
							
						<div class="cs-select cs-skin-boxes fs-anim-lower" tabindex="0"><span class="cs-placeholder">Pick a color</span><div class="cs-options"><ul><li class="color-588c75" data-option="" data-value="#588c75"><span>#588c75</span></li><li class="color-b0c47f" data-option="" data-value="#b0c47f"><span>#b0c47f</span></li><li class="color-f3e395" data-option="" data-value="#f3e395"><span>#f3e395</span></li><li class="color-f3ae73" data-option="" data-value="#f3ae73"><span>#f3ae73</span></li><li class="color-da645a" data-option="" data-value="#da645a"><span>#da645a</span></li><li class="color-79a38f" data-option="" data-value="#79a38f"><span>#79a38f</span></li><li class="color-c1d099" data-option="" data-value="#c1d099"><span>#c1d099</span></li><li class="color-f5eaaa" data-option="" data-value="#f5eaaa"><span>#f5eaaa</span></li><li class="color-f5be8f" data-option="" data-value="#f5be8f"><span>#f5be8f</span></li><li class="color-e1837b" data-option="" data-value="#e1837b"><span>#e1837b</span></li><li class="color-9bbaab" data-option="" data-value="#9bbaab"><span>#9bbaab</span></li><li class="color-d1dcb2" data-option="" data-value="#d1dcb2"><span>#d1dcb2</span></li><li class="color-f9eec0" data-option="" data-value="#f9eec0"><span>#f9eec0</span></li><li class="color-f7cda9" data-option="" data-value="#f7cda9"><span>#f7cda9</span></li><li class="color-e8a19b" data-option="" data-value="#e8a19b"><span>#e8a19b</span></li><li class="color-bdd1c8" data-option="" data-value="#bdd1c8"><span>#bdd1c8</span></li><li class="color-e1e7cd" data-option="" data-value="#e1e7cd"><span>#e1e7cd</span></li><li class="color-faf4d4" data-option="" data-value="#faf4d4"><span>#faf4d4</span></li><li class="color-fbdfc9" data-option="" data-value="#fbdfc9"><span>#fbdfc9</span></li><li class="color-f1c1bd" data-option="" data-value="#f1c1bd"><span>#f1c1bd</span></li></ul></div><select class="cs-select cs-skin-boxes fs-anim-lower">
								<option value="" disabled="" selected="">Pick a color</option>
								<option value="#588c75" data-class="color-588c75">#588c75</option>
								<option value="#b0c47f" data-class="color-b0c47f">#b0c47f</option>
								<option value="#f3e395" data-class="color-f3e395">#f3e395</option>
								<option value="#f3ae73" data-class="color-f3ae73">#f3ae73</option>
								<option value="#da645a" data-class="color-da645a">#da645a</option>
								<option value="#79a38f" data-class="color-79a38f">#79a38f</option>
								<option value="#c1d099" data-class="color-c1d099">#c1d099</option>
								<option value="#f5eaaa" data-class="color-f5eaaa">#f5eaaa</option>
								<option value="#f5be8f" data-class="color-f5be8f">#f5be8f</option>
								<option value="#e1837b" data-class="color-e1837b">#e1837b</option>
								<option value="#9bbaab" data-class="color-9bbaab">#9bbaab</option>
								<option value="#d1dcb2" data-class="color-d1dcb2">#d1dcb2</option>
								<option value="#f9eec0" data-class="color-f9eec0">#f9eec0</option>
								<option value="#f7cda9" data-class="color-f7cda9">#f7cda9</option>
								<option value="#e8a19b" data-class="color-e8a19b">#e8a19b</option>
								<option value="#bdd1c8" data-class="color-bdd1c8">#bdd1c8</option>
								<option value="#e1e7cd" data-class="color-e1e7cd">#e1e7cd</option>
								<option value="#faf4d4" data-class="color-faf4d4">#faf4d4</option>
								<option value="#fbdfc9" data-class="color-fbdfc9">#fbdfc9</option>
								<option value="#f1c1bd" data-class="color-f1c1bd">#f1c1bd</option>
							</select></div></li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q4">Describe how you imagine your new website</label>
							<textarea class="fs-anim-lower" id="q4" name="q4" placeholder="Describe here"></textarea>
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="q5">What's your budget?</label>
							<input class="fs-mark fs-anim-lower" id="q5" name="q5" type="number" placeholder="1000" step="100" min="100">
						</li>
					</ol><!-- /fs-fields -->
					<button class="fs-submit" type="submit">Send answers</button>
				</form><!-- /fs-form -->
			<div class="fs-controls"><button class="fs-continue fs-show">Continue</button><nav class="fs-nav-dots fs-show"><button class="fs-dot-current"></button><button disabled=""></button><button disabled=""></button><button disabled=""></button><button disabled=""></button><button disabled=""></button></nav><span class="fs-numbers fs-show"><span class="fs-number-current">1</span><span class="fs-number-total">6</span></span><div class="fs-progress fs-show"></div></div><span class="fs-message-error"></span></div>
			
 
  		
			<section class="animated fadeInUP">
				<form class="ac-custom ac-radio ac-fill">
					<h2>Where do you proactively envision multimedia based expertise and cross-media growth strategies?</h2>
					<ul>
						<li><input id="r1" name="r1" type="radio"><label for="r1">Seamlessly visualize quality intellectual capital</label><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M15.833,24.334c2.179-0.443,4.766-3.995,6.545-5.359 c1.76-1.35,4.144-3.732,6.256-4.339c-3.983,3.844-6.504,9.556-10.047,13.827c-2.325,2.802-5.387,6.153-6.068,9.866 c2.081-0.474,4.484-2.502,6.425-3.488c5.708-2.897,11.316-6.804,16.608-10.418c4.812-3.287,11.13-7.53,13.935-12.905 c-0.759,3.059-3.364,6.421-4.943,9.203c-2.728,4.806-6.064,8.417-9.781,12.446c-6.895,7.477-15.107,14.109-20.779,22.608 c3.515-0.784,7.103-2.996,10.263-4.628c6.455-3.335,12.235-8.381,17.684-13.15c5.495-4.81,10.848-9.68,15.866-14.988 c1.905-2.016,4.178-4.42,5.556-6.838c0.051,1.256-0.604,2.542-1.03,3.672c-1.424,3.767-3.011,7.432-4.723,11.076 c-2.772,5.904-6.312,11.342-9.921,16.763c-3.167,4.757-7.082,8.94-10.854,13.205c-2.456,2.777-4.876,5.977-7.627,8.448 c9.341-7.52,18.965-14.629,27.924-22.656c4.995-4.474,9.557-9.075,13.586-14.446c1.443-1.924,2.427-4.939,3.74-6.56 c-0.446,3.322-2.183,6.878-3.312,10.032c-2.261,6.309-5.352,12.53-8.418,18.482c-3.46,6.719-8.134,12.698-11.954,19.203 c-0.725,1.234-1.833,2.451-2.265,3.77c2.347-0.48,4.812-3.199,7.028-4.286c4.144-2.033,7.787-4.938,11.184-8.072 c3.142-2.9,5.344-6.758,7.925-10.141c1.483-1.944,3.306-4.056,4.341-6.283c0.041,1.102-0.507,2.345-0.876,3.388 c-1.456,4.114-3.369,8.184-5.059,12.212c-1.503,3.583-3.421,7.001-5.277,10.411c-0.967,1.775-2.471,3.528-3.287,5.298 c2.49-1.163,5.229-3.906,7.212-5.828c2.094-2.028,5.027-4.716,6.33-7.335c-0.256,1.47-2.07,3.577-3.02,4.809" style="stroke-dasharray: 499.664px, 499.664px; stroke-dashoffset: 0px; transition: stroke-dashoffset 0.8s ease-in-out 0s;"></path></svg></li>
						<li><input id="r2" name="r1" type="radio"><label for="r2">Collaboratively administrate turnkey channels</label><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"></svg></li>
						<li><input id="r3" name="r1" type="radio"><label for="r3">Objectively seize scalable metrics</label><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"></svg></li>
						<li><input id="r4" name="r1" type="radio"><label for="r4">Energistically scale future-proof core competencies</label><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"></svg></li>
					</ul>
				</form>
			</section>
		</div>	
			
</body>
</html>