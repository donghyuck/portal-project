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
			customized : { type: "boolean", defaultValue: false },
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
	    	target.set("customized",this.get("customized") );
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

