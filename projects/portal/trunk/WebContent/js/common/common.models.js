(function($, undefined) {
	var common = window.common = window.common || {};
	common.models = {};

	common.models.FileInfo =  kendo.data.Model.define({
		id : "path",
		hasChildren: "directory",
		fields: { 
			absolutePath: { type: "string", defaultValue: "" },
			name: { type: "string", defaultValue: "." },
			path: { type: "string", defaultValue: "." },
			size: { type: "number", defaultValue: 0 },
			directory: { type: "boolean", defaultValue: false },
	        lastModifiedDate: { type: "date"}
		},
	    formattedLastModifiedDate : function(){
	    	return kendo.toString(this.get("lastModifiedDate"), "g");
	    },		
	    formattedSize : function(){
	    	return kendo.toString(this.get("size"), "##,#");
	    },
	    copy: function ( target ){
	    	target.path = this.get("path");
	    	target.set("absolutePath",this.get("absolutePath") );
	    	target.set("name", this.get("name"));
	    	target.set("size",this.get("size") );
	    	target.set("directory", this.get("directory"));
	    	target.set("lastModifiedDate",this.get("lastModifiedDate") );
	    }
	});
	
	
	common.models.Forum =  kendo.data.Model.define({
		id : "forumId",
		fields: { 
			forumId: { type: "number", editable: false, defaultValue: -1 },
			objectType: { type: "number", editable: false, defaultValue: -1 },
			objectId: { type: "number", editable: false, defaultValue: -1 },
			boardName: { type: "string", editable: true },
			boardDesc: { type: "string", editable: true },
			commentYn: { type: "boolean", editable: false},
			fileYn: { type: "boolean", editable: false},
			anonyYn: { type: "boolean", editable: false},
			useYn: { type: "boolean", editable: false},
			lastThreadDate: { type: "date", editable: false},
			totalCnt: { type: "number", editable: false, defaultValue: 0 },
			createId: { type: "number", editable: false},
			modifyId: { type: "number", editable: false},
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" } 			
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    }
	    ,
	    copy: function ( target ){
	    	target.topicId = this.get("topicId");
	    	target.set("subject",this.get("subject") );
	    	target.set("content", this.get("content"));
	    	target.set("viewCnt",this.get("viewCnt") );
	    	target.set("totalReplies", this.get("totalReplies"));
	    	target.set("modifiedDate",this.get("modifiedDate") );
	    	target.set("creationDate", this.get("creationDate") );
	    	target.forumId = this.get("forumId");
	    	if( typeof this.get("user") === 'object' )
	    		target.set("user", this.get("user") );
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties") );
	    }
	});
	
	
	common.models.ForumTopic =  kendo.data.Model.define({
		id : "topicId",
		fields: { 
			topicId: { type: "number", editable: false, defaultValue: 0 },
			subject: { type: "string", editable: true },
			content: { type: "string", editable: true },
			viewCnt: { type: "number", editable: true, defaultValue: 0 },
			forumId: { type: "number", editable: false, defaultValue: 1 },
			totalReplies: { type: "number", editable: true, defaultValue: 0 },
			attachmentId: { type: "number", editable: true, defaultValue: 0 },
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" } 			
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    },
	    copy: function ( target ){
	    	target.topicId = this.get("topicId");
	    	target.set("subject",this.get("subject") );
	    	target.set("content", this.get("content"));
	    	target.set("viewCnt",this.get("viewCnt") );
	    	target.set("totalReplies", this.get("totalReplies"));
	    	target.set("modifiedDate",this.get("modifiedDate") );
	    	target.set("creationDate", this.get("creationDate") );
	    	target.forumId = this.get("forumId");
	    	if( typeof this.get("user") === 'object' )
	    		target.set("user", this.get("user") );
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties") );
	    }
	});
	

	common.models.Timeline =  kendo.data.Model.define({
		id : "timelineId",
		fields: { 
			timelineId: { type: "number", editable: false, defaultValue: 0 },
			objectType: { type: "string", objectType: false, defaultValue:0  },
			objectId: { type: "number", objectId: false, defaultValue:0 },
			headline : { type: "string", editable: true},
			body : { type: "string", editable: true},			
			hasMedia: { type: "boolean", editable: false, defaultValue: false },
			startDate: { type: "date"},
			endDate: { type: "date" } 			
		},
		getFormattedStartDate : function(){
	    	return kendo.toString(this.get("startDate"), "yyyy.MM");
	    },
	    getFormattedEndDate : function(){
	    	return kendo.toString(this.get("endDate"), "yyyy.MM");
	    },
	    isPeriod : function () {
	    	return ( this.get("endDate").getTime() > this.get("startDate").getTime() );
	    },
	    getEndDateYear : function(){
	    	return kendo.toString(this.get("endDate"), "yyyy");
	    }
	});
	
	common.models.Photo =  kendo.data.Model.define({
		id : "externalId",
		fields: { 
			externalId: { type: "string", editable: false },
			imageId : { type: "number", editable: false, defaultValue: 0},
			externalId: { type: "string", editable: false },
			publicShared: { type: "boolean", editable: false, defaultValue: false },
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" } 			
		}
	});
	
	common.models.Page = kendo.data.Model.define({
		id : "pageId",
		fields:{
			pageId:{ type:"number", editable:false, defaultValue:0 },
			objectType:{ type:"number", editable:true, defaultValue: 30 },
			objectId:{ type:"number", editable:true, defaultValue:0 },
			name : { type: "string", editable: true},
			versionId:{ type:"number", editable:true, defaultValue:0 },
			title : { type: "string", editable: true},
			summary :  { type: "string", editable: true},
			pageState : { type: "string", editable: true, defaultValue:"INCOMPLETE"},
			bodyText:  { type: "string", editable: true},
			modifiedDate: { type: "date", editable: false },
			creationDate: { type: "date", editable: false } 				
		},
		copy: function ( target ){
			target.pageId = this.get("pageId");
	    	target.modifiedDate = this.get("modifiedDate");
	    	target.creationDate = this.get("creationDate") ;
	    	target.set("objectType",this.get("objectType") );
	    	target.set("objectId",this.get("objectId") );
	    	target.set("versionId",this.get("versionId") );
	    	target.set("title",this.get("title") );
	    	target.set("name",this.get("name") );
	    	target.set("summary",this.get("summary") );		
	    	target.set("bodyText",this.get("bodyText") );		
	    	target.set("pageState",this.get("pageState") );		
	    	if(typeof  this.get("bodyContent") === 'object')
	    		target.set("bodyContent",this.get("bodyContent") );	
	    	if( typeof this.get("user") === 'object' )
	    		target.set("user", this.get("user") );    		
	    	if( typeof this.get("properties") === 'object' )
	    		target.properties = this.get("properties") ;
	    		
		}
	});

	common.models.Logo =  kendo.data.Model.define({
		id : "logoId",
		fields: { 
			objectType: { type: "number", editable: false, defaultValue: 0 },
			objectId : { type: "number", editable: false, defaultValue: 0},
			primary: { type: "boolean", editable: false, defaultValue: false },
			filename : { type: "string", editable: true},
			imageSize : { type: "number", editable: true, defaultValue: 0},
			imageContentType : { type: "string", editable: true},
			modifiedDate: { type: "date"},
			creationDate: { type: "date" }
		},
		formattedImageSize : function(){
			return kendo.toString(this.get("imageSize"), "##,###");
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    }
	});
	
	common.models.WebSite =  kendo.data.Model.define({
		id : "webSiteId",
		fields: { 
			webSiteId: { type: "number", editable: false , defaultValue: 0},
			name : { type: "string", editable: true},
			description : { type: "string", editable: true},
			displayName : { type: "string", editable: true},
			url : { type: "string", editable: true},
			enabled: { type: "boolean", editable: true , defaultValue: false},
			allowAnonymousAccess: { type: "boolean", editable: true, defaultValue: false },
	        modifiedDate: { type: "date", editable: false },
	        creationDate: { type: "date", editable: false } 			
		},
	    copy: function ( target ){
	    	target.webSiteId = this.get("webSiteId");
	    //	target.set("webSiteId", this.get("webSiteId"));
	    	target.set("name",this.get("name") );
	    	target.set("description",this.get("description") );
	    	target.set("displayName", this.get("displayName"));
	    	target.set("url",this.get("url") );
	    	target.set("enabled", this.get("enabled"));
	    	target.set("allowAnonymousAccess", this.get("allowAnonymousAccess"));
	    	//targettarget.set("modifiedDate",this.get("modifiedDate") );
	    	//target.set("creationDate", this.get("creationDate") );
	    	target.modifiedDate = this.get("modifiedDate");
	    	target.creationDate = this.get("creationDate") ;
	    	if( typeof this.get("menu") === 'object' )
	    		target.set("menu", this.get("menu") );    		    	
	    	if( typeof this.get("user") === 'object' )
	    		target.set("user", this.get("user") );    	
	    	if( typeof this.get("company") === 'object' )
	    		target.set("company", this.get("company") );    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties") );
	    }
	});		
	
	common.models.CacheStats =  kendo.data.Model.define({
		id : "cacheName",
		fields: { 
			cacheName : { type: "string", editable: true},
			statisticsAccuracy : { type: "number", editable: false, defaultValue: 0 },
			cacheHits : { type: "number", editable: false, defaultValue: 0 },
			onDiskHits : { type: "number", editable: false, defaultValue: 0 },
			offHeapHits : { type: "number", editable: false, defaultValue: 0 },
			inMemoryHits : { type: "number", editable: false, defaultValue: 0 },
			misses : { type: "number", editable: false, defaultValue: 0 },
			onDiskMisses : { type: "number", editable: false, defaultValue: 0 },
			offHeapMisses : { type: "number", editable: false, defaultValue: 0 },
			inMemoryMisses : { type: "number", editable: false, defaultValue: 0 },
			size : { type: "number", editable: false, defaultValue: 0 },
			memoryStoreSize : { type: "number", editable: false, defaultValue: 0 },
			offHeapStoreSize : { type: "number", editable: false, defaultValue: 0 },
			diskStoreSize : { type: "number", editable: false, defaultValue: 0 },
			averageGetTime : { type: "number", editable: false, defaultValue: 0 },
			evictionCount : { type: "number", editable: false, defaultValue: 0 },
			searchesPerSecond : { type: "number", editable: false, defaultValue: 0 },
			averageSearchTime : { type: "number", editable: false, defaultValue: 0 },
			writerQueueLength : { type: "number", editable: false, defaultValue: 0 }			
		}
	});
	
})(jQuery);	
	
var SignupForm = kendo.data.Model.define({
	id : "id",
	fields: {
		"media": {
            type: "string",
            defaultValue : "internal"
        },
		"id": {
            type: "string"
        },
		"username": {
            type: "string"
        },
        "firstName": {
            type: "string"
        },
        "lastName": {
            type: "string"
        },        
        "name": {
            type: "string"
        },
        "email": {
            type: "string"
        },
        "locale": {
            type: "string"
        },
        "location": {
            type: "string"
        },
        "languages": {
            type: "string"
        },
        "timezone": {
            type: "string"
        },
        "gender" : {
            type: "string"
        },
        "password1": {
            type: "string"
        },
        "password2": {
            type: "string"
        },
        "onetime": {
            type: "string"
        },
        "nameVisible" : {
        	 type:"boolean", defaultVlaue: false 
        },
        "emailVisible" : {
        	 type:"boolean", defaultVlaue: false 
        },
        "agree":  { type:"boolean", defaultVlaue: false },
        "customClass" : {type:"string" , defaultValue : "" }
	}, 
	isExternal : function (  ) {
		return this.get("media") !== "internal" ;		
	},
    reset: function (){
    	this.set("media", "internal" );
    	this.set("id", null );
    	this.set("firstName", null );
    	this.set("lastName", null );
    	this.set("name", null );
    	this.set("username", null );
    	this.set("email", null );
    	this.set("locale", null );
    	this.set("location", null );
    	this.set("languages", null );
    	this.set("timezone", null );
    	this.set("gender", null );
    	this.set("password1", null );
    	this.set("password2", null );
    	this.set("onetime", null );
    	this.set("agree", false );
    	this.set("customClass", "" );
    },
    inject: function( media, profile ){
    	this.set("media",  media  );
    	if( media == "facebook" ){
        	this.set("id", profile.primaryKeyString );
        	this.set("firstName", profile.firstName );
        	this.set("lastName", profile.lastName );
        	this.set("name", profile.name );
        	this.set("username", profile.username );
        	this.set("email", profile.email );
        	this.set("locale", profile.locale );
        	this.set("location", profile.location.name );
        	this.set("languages", profile.languages );
        	this.set("timezone", profile.timezone  );
        	this.set("gender", profile.gender );
        	this.set("password1", null );
        	this.set("password2", null );
        	this.set("onetime", null );
        	this.set("agree", false );
    	}
    }
});

var _TWITTER_FEED_URL = "/community/get-twitter-hometimeline.do?output=json",
	_FACEBOOK_FEED_URL    = "/community/get-facebook-homefeed.do?output=json",
	_TUMBLR_FEED_URL    = "/community/get-tumblr-dashboard.do?output=json",
	_TWITTER_FEED_DATA  = "homeTimeline",
	_FACEBOOK_FEED_DATA = "homeFeed",	
	_TUMBLR_FEED_DATA = "dashboardPosts",	
	MediaStreams = kendo.Class.extend({
		mediaId : 0,
		name : null,
		data : null,
		url : null,
		dataSource : null,		
		template: null,
		init: function(mediaId, name, url, data) {
			if (mediaId) this.mediaId = mediaId;			
			if (name) this.name = name;			
			
			if( name == 'twitter' )
			{
				this.url = _TWITTER_FEED_URL;
				this.data = _TWITTER_FEED_DATA;
			}
			else if ( name == 'facebook' ){
				this.url = _FACEBOOK_FEED_URL;
				this.data = _FACEBOOK_FEED_DATA;								
			}			
			else if ( name == 'tumblr' ){
				this.url = _TUMBLR_FEED_URL;
				this.data = _TUMBLR_FEED_DATA;								
			}				
			
			if (url) this.url = url;
			if (data) this.data = data;
		},
		createDataSource: function ( options ){
			var that = this ;						
			if( !options.transport ){				
				options.transport = {
					parameterMap	:  function( options,  operation) {
						return {};
					}
				};		
			}
			//alert(  kendo.stringify( options.transport.parameterMap) ) ;
			
			this.dataSource = new kendo.data.DataSource({
				type: "json",
				transport: {
					read: {
						type : 'POST',
						url : that.url
					},
					parameterMap: options.transport.parameterMap
				},
				error:handleKendoAjaxError,
				schema: {
					data : that.data
				},
				requestStart: function() {
					kendo.ui.progress(that.elementToRender(), true);
				},
				requestEnd: function() {
					kendo.ui.progress(that.elementToRender(), false);
				},
				change : function () {
					that.elementToRender().html(kendo.render( that.template, this.view()));
				}
			});		
		},
		setTemplate: function ( template ){
			if (template) this.template = template;	
		},
		renderToString : function () {
			return  "#"+ this.name + "-streams-" + this.mediaId ;
		},
		elementToRender : function (){
			return $(this.renderToString());
		}
	});	

var Announce = kendo.data.Model.define( {
    id: "announceId", // the identifier of the model
    fields: {
    	announceId: { type: "number", editable: false, defaultValue: 0 },
    	objectType: { type: "number", editable: true, defaultValue: 0 },	
    	subject: { type: "string", editable: true },
    	body: { type: "string", editable: true },
    	startDate: { type: "date",  editable: true },
    	endDate: { type: "date" ,  editable: true},
    	user : { type: "User" },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" }
    },
    formattedCreationDate : function(){
    	return kendo.toString(this.get("creationDate"), "g");
    },
    formattedModifiedDate : function(){
    	return kendo.toString(this.get("modifiedDate"), "g");
    },
    formattedStartDate : function(){
    	return kendo.toString(this.get("startDate"), "g");
    },
    formattedEndDate : function(){
    	return kendo.toString(this.get("endDate"), "g");
    },    
    reset: function (){
    	this.set("announceId", 0 );
    	this.set("objectType",  1 );
    	this.set("subject", "" );
    	this.set("body", "" );
    	this.set("startDate", new Date() );
    	this.set("endDate", new Date() );
    },
    copy: function ( target ){
    	target.announceId = this.get("announceId");
    	target.set("objectType",this.get("objectType") );
    	target.set("subject",this.get("subject") );
    	target.set("body", this.get("body"));
    	target.set("startDate",this.get("startDate") );
    	target.set("endDate", this.get("endDate"));
    	target.set("modifiedDate",this.get("modifiedDate") );
    	target.set("creationDate", this.get("creationDate") );
    	if( typeof this.get("user") === 'object' )
    		target.set("user", this.get("user") );
    	if( typeof this.get("properties") === 'object' )
    		target.set("properties", this.get("properties") );
    },
    clone: function () {
    	return new Announce({
    		announceId : this.get("announceId"),
    		subject :  this.get("subject"),
    		objectType: this.get("objectType"),
    		body: this.get("body"),
    		startDate : this.get("startDate"),
    		endDate: this.get("endDate"),
  			modifiedDate: this.get("modifiedDate"),
    		creationDate: this.get("creationDate")
    	});    	
    }
});

var OAuthToken = kendo.data.Model.define( {
    id: "socialAccountId", // the identifier of the model
    fields: {
    	socialAccountId: { type: "number", editable: false, defaultValue: -1  },    	
    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
    	serviceProviderName: { type: "string", editable: true , validation: { required: true }},
    	authorizationUrl : { type: "string", editable: false  },    	
    	accessSecret: { type: "string", editable: true },
    	accessToken : { type: "string", editable: true },
    	signedIn: { type:"boolean", defaultVlaue: false },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" } 
    }
});

var SocialNetwork = kendo.data.Model.define( {
    id: "socialAccountId", // the identifier of the model
    fields: {
    	socialAccountId: { type: "number", editable: false, defaultValue: -1  },    	
    	objectType: { type: "number", editable: true, defaultValue: -1  },    	
    	objectId: { type: "number", editable: true, defaultValue: -1  },    	
    	serviceProviderName: { type: "string", editable: true , validation: { required: true }},
    	authorizationUrl : { type: "string", editable: true  },    	
    	accessSecret: { type: "string", editable: true },
    	accessToken : { type: "string", editable: true },
    	signedIn: { type:"boolean", defaultVlaue: true },
    	connected: { type:"boolean", defaultVlaue: true },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" } 
    },
    copy: function ( target ){
    	target.socialAccountId = this.get("socialAccountId");
    	target.set("objectType",this.get("objectType") );
    	target.set("objectId",this.get("objectId") );
    	target.set("serviceProviderName", this.get("serviceProviderName"));
    	target.set("authorizationUrl",this.get("authorizationUrl") );
    	target.set("accessSecret", this.get("accessSecret"));
    	target.set("accessToken", this.get("accessToken"));
    	target.set("signedIn", this.get("signedIn"));
    	target.set("connected", this.get("connected"));
    	target.modifiedDate = this.get("modifiedDate");
    	target.creationDate = this.get("creationDate") ;  	
    	if( typeof this.get("user") === 'object' )
    		target.set("user", this.get("user") );    	
    	if( typeof this.get("properties") === 'object' )
    		target.set("properties", this.get("properties") );
    }    
});

var SocialAccount = kendo.data.Model.define( {
    id: "socialAccountId", // the identifier of the model
    fields: {
    	socialAccountId: { type: "number", editable: false, defaultValue: -1  },    	
    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
    	serviceProviderName: { type: "string", editable: true , validation: { required: true }},
    	authorizationUrl : { type: "string", editable: false  },    	
    	accessSecret: { type: "string", editable: true },
    	accessToken : { type: "string", editable: true },
    	signedIn: { type:"boolean", defaultVlaue: false },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" } 
    }
});

var Template = kendo.data.Model.define( {
    id: "templateId", // the identifier of the model
    fields: {
    	templateId: { type: "number", editable: false, defaultValue: -1  },    	
    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
    	title: { type: "string", editable: true , validation: { required: true }},
    	templateType: { type: "string", editable: true },
    	location : { type: "string", editable: true },
    	body: { type: "string", editable: true },
    	modifiedDate: { type: "date"},
    	creationDate: { type: "date" } 
    }
});

var Image = kendo.data.Model.define( {
    id: "imageId", // the identifier of the model
    fields: {
    	imageId: { type: "number", editable: false, defaultValue: -1  },   
    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
    	name: { type: "string", editable: true , validation: { required: true }},
        contentType: { type: "string", editable: true },
        size: { type: "number", defaultValue : 0,  editable: true },
        shared : { type: "boolean", defaultValue : false,  editable: true },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" },
        index : {type: "number", defaultValue : 0 }
    },
	formattedSize : function(){
		return kendo.toString(this.get("size"), "##,###");
	},
	formattedCreationDate : function(){
    	return kendo.toString(this.get("creationDate"), "g");
    },
    formattedModifiedDate : function(){
    	return kendo.toString(this.get("modifiedDate"), "g");
    },
    copy : function ( target ){
    	target.imageId = this.get("imageId");
    	target.objectType = this.get("objectType");
    	target.objectId = this.get("objectId");
    	target.set("name", this.get("name"));
    	target.set("contentType", this.get("contentType"));
    	target.set("size", this.get("size"));
    	target.set("shared", this.get("shared"));
    	if( typeof this.get("properties") === 'object' )
    		target.set("properties", this.get("properties") );    	
    	target.set("creationDate", this.get("creationDate"));
    	target.set("modifiedDate", this.get("modifiedDate"));
    },        
    manupulate : function () {
    	this.set( "photoUrl" , '/community/download-my-image.do?imageId=' + this.get('imageId') );
    	this.set( "formattedCreationDate" , kendo.toString(this.get('creationDate'),  'F') );
    	this.set( "formattedModifiedDate" , kendo.toString(this.get('modifiedDate'),  'F') );
    	this.set( "formattedSize" , kendo.toString(this.get('size'),  'n0') );
    }
});

var Attachment = kendo.data.Model.define( {
    id: "attachmentId", // the identifier of the model
    fields: {
    	attachmentId: { type: "number", editable: false, defaultValue: -1  },   
    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
    	name: { type: "string", editable: true , validation: { required: true }},
        contentType: { type: "string", editable: false },
        downloadCount: { type: "number", editable: false },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" }        
    }
});

var Company = kendo.data.Model.define( {
    id: "companyId", // the identifier of the model
    fields: {
    	companyId: { type: "number", editable: false, defaultValue: -1  },    	
        name: { type: "string", editable: true , validation: { required: true }},
        displayName: { type: "string", editable: true },
        domainName: { type: "string", editable: true },
        description: { type: "string", editable: true },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" },
        memberCount: { type: "number", editable: true, defaultValue: 0  },
        adminCount: { type: "number", editable: true, defaultValue: 0  }
    },
    copy : function ( target ){
    	target.companyId = this.get("companyId");
    	target.set("name", this.get("name"));
    	target.set("displayName", this.get("displayName"));
    	target.set("domainName", this.get("domainName"));
    	target.set("description", this.get("description"));
    	target.set("modifiedDate", this.get("modifiedDate"));
    	target.set("creationDate", this.get("creationDate"));
    	target.set("memberCount", this.get("memberCount"));
    	target.set("adminCount", this.get("adminCount"));		
    	target.set("properties", this.get("properties"));
    }    
});


var User = kendo.data.Model.define( {
    id: "userId", // the identifier of the model
    fields: {
    	companyId: {  type: "number", defaultValue: 1 },
    	company: Company,
    	userId: { type: "number", editable: true, defaultValue: -1  },
        username: { type: "string", editable: true },
        name: { type: "string", editable: true },
        email: { type: "string" , editable: true },
        password: { type: "string" , editable: true },
        creationDate: { type: "date" },
        modifiedDate: { type: "date" },
        lastLoggedIn: { type: "date" },
        lastProfileUpdate : { type: "date" },                                    
        enabled : {type: "boolean" },
        nameVisible : {type: "boolean" },	        
        emailVisible: {type: "boolean" },
        //hasProfileImage:{type: "boolean", defaultValue: false},
        formattedLastLoggedIn : { type: "string" },
        formattedLastProfileUpdate : { type: "string" },
        isSystem: { type:"boolean", defaultVlaue: false },
        anonymous : { type:"boolean", defaultVlaue: true },
        //photoUrl : {type: "string", editable: true, defaultVlaue: null },
        roles: {}
    },
    photoUrl : function (){
    	return '/download/profile/' +  this.get("username") + "?width=150&height=150";	    	
    },    
    hasRole : function ( role ) {
    	if( typeof( this.roles ) != "undefined" && $.inArray( role, this.roles ) >= 0 )
			return true
		else 
			return false;    	
    },
    copy : function ( target ){
    	target.userId = this.get("userId");
    	target.set("username", this.get("username"));
    	target.set("name", this.get("name"));
    	target.set("email", this.get("email"));
    	target.set("creationDate", this.get("creationDate"));
    	target.set("lastLoggedIn", this.get("lastLoggedIn"));
    	target.set("lastProfileUpdate", this.get("lastProfileUpdate"));
    	target.set("enabled", this.get("enabled"));
    	target.set("nameVisible", this.get("nameVisible"));
    	target.set("emailVisible", this.get("emailVisible"));
    	target.set("properties", this.get("properties"));
    	target.set("anonymous", this.get("anonymous"));
    	target.set("company", this.get("company"));		
    	target.set("isSystem", this.get("isSystem"));
    	if( typeof this.get("roles") === 'object' )
    		target.set("roles", this.get("roles") );	
    }
});

var Group = kendo.data.Model.define( {
    id: "groupId", // the identifier of the model
    fields: {
    	companyId: { type: "number", defaultValue: 1 },
    	company: Company,
        groupId: { type: "number", editable: false, defaultValue: -1  },
        name: { type: "string", editable: true, validation: { required: true }},
        description: { type: "string", editable: true },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" },
        memberCount: { type: "number", editable: true, defaultValue: 0  },
        adminCount: { type: "number", editable: true, defaultValue: 0  },
        clear: function() {
            this.set("groupId", 0 );
            this.set("name", "");
            this.set("description", "");
            this.set("modifiedDate", null ); 
            this.set("creationDate", null );
        }        
    }
});

var Property = kendo.data.Model.define( {
    id: "name", // the identifier of the model
    fields: {
    	name: { type: "string",  editable: true },
    	value:  { type: "string", editable: true }     
    }
});

var Role = kendo.data.Model.define( {
    id: "roleId", // the identifier of the model
    fields: {
    	roleId: { type: "number", editable: false, defaultValue: -1  },
        name: { type: "string", editable: true, validation: { required: true }},
        description: { type: "string", editable: true },
        modifiedDate: { type: "date"},
        creationDate: { type: "date" }
    }
});

var DatabaseInfo = kendo.data.Model.define( {
    fields: {
    	databaseName: { type: "string",  editable: false },
    	databaseVersion:  { type: "string", editable: false },
    	driverName : { type: "string", editable: false},
    	driverVersion: {type: "string", editable: false},
    	isolationLevel: {type: "string", editable: false}
    }
});

var Menu = kendo.data.Model.define( {
	  	id: "menuId", // the identifier of the model
	    fields: {
	    	menuId: { type: "number", editable: false, defaultValue: -1  }, 
	    	name: { type: "string", editable: true , defaultValue : ""  },
	        title: { type: "string", editable: true , defaultValue : "" },
	        enabled : {type: "boolean", defaultValue : true},
	        location: { type: "string", editable: true ,defaultValue : ""  },
	        properties :{ type: "object", editable: true ,defaultValue : {}  },
	        menuData : { type: "string", editable: true, defaultValue : "" },
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" }
	    },
		copy : function ( target ){
			target.menuId = this.get("menuId");
			target.set("name", this.get("name"));
			target.set("title", this.get("title"));
			target.set("enabled", this.get("enabled"));
			target.set("location", this.get("location"));
			target.set("properties", this.get("properties"));
			target.set("menuData", this.get("menuData"));
			target.set("modifiedDate", this.get("modifiedDate"));
			target.set("creationDate", this.get("creationDate"));
		}
});

