/**
 * COMMUNITY UI dependency : common.ui.core, common.ui.kendo
 */
;
(function($, undefined) {
	
	common.ui.data.FileInfo = kendo.data.Model.define({
		id : "path",
		fields : {
			absolutePath : {
				type : "string",
				defaultValue : ""
			},
			name : {
				type : "string",
				defaultValue : "."
			},
			path : {
				type : "string",
				defaultValue : "."
			},
			size : {
				type : "number",
				defaultValue : 0
			},
			directory : {
				type : "boolean",
				defaultValue : false
			},
			customized : {
				type : "boolean",
				defaultValue : false
			},
			lastModifiedDate : {
				type : "date"
			}
		},
		formattedLastModifiedDate : function() {
			return kendo.toString(this.get("lastModifiedDate"), "g");
		},
		formattedSize : function() {
			return kendo.toString(this.get("size"), "##,#");
		},
		hasChildren : function() {
			return this.get("directory");
		},
		copy : function(target) {
			target.path = this.get("path");
			target.set("customized", this.get("customized"));
			target.set("absolutePath", this.get("absolutePath"));
			target.set("name", this.get("name"));
			target.set("size", this.get("size"));
			target.set("directory", this.get("directory"));
			target.set("lastModifiedDate", this.get("lastModifiedDate"));

		}
	});

	common.ui.data.Announce = kendo.data.Model.define({
		id : "announceId", // the identifier of the model
		fields : {
			announceId : {
				type : "number",
				editable : false,
				defaultValue : 0
			},
			objectType : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			objectId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			subject : {
				type : "string",
				editable : true
			},
			body : {
				type : "string",
				editable : true
			},
			startDate : {
				type : "date",
				editable : true
			},
			endDate : {
				type : "date",
				editable : true
			},
			user : {
				type : "common.ui.data.User"
			},
			modifiedDate : {
				type : "date"
			},
			creationDate : {
				type : "date"
			}
		},
		authorPhotoUrl : function() {
			if (typeof this.get("user") === 'object')
				return "/download/profile/" + this.get("user").username + "?width=150&height=150";
			else
				return "/images/common/no-avatar.png";
		},
		formattedCreationDate : function() {
			return kendo.toString(this.get("creationDate"), "g");
		},
		formattedModifiedDate : function() {
			return kendo.toString(this.get("modifiedDate"), "g");
		},
		formattedStartDate : function() {
			return kendo.toString(this.get("startDate"), "g");
		},
		formattedEndDate : function() {
			return kendo.toString(this.get("endDate"), "g");
		},
		copy : function(target) {
			if (typeof this.get("user") === 'object')
				target.set("user", this.get("user"));
			if (typeof this.get("properties") === 'object')
				target.set("properties", this.get("properties"));
			target.announceId = this.get("announceId");
			target.set("objectType", this.get("objectType"));
			target.set("subject", this.get("subject"));
			target.set("body", this.get("body"));
			target.set("startDate", this.get("startDate"));
			target.set("endDate", this.get("endDate"));
			target.set("modifiedDate", this.get("modifiedDate"));
			target.set("creationDate", this.get("creationDate"));

		}
	});

	common.ui.data.EMPTY_ANNOUNCE = new common.ui.data.Announce();

	common.ui.data.Timeline = kendo.data.Model.define({
		id : "timelineId",
		fields : {
			timelineId : {
				type : "number",
				editable : false,
				defaultValue : 0
			},
			objectType : {
				type : "string",
				objectType : false,
				defaultValue : 0
			},
			objectId : {
				type : "number",
				objectId : false,
				defaultValue : 0
			},
			headline : {
				type : "string",
				editable : true
			},
			body : {
				type : "string",
				editable : true
			},
			hasMedia : {
				type : "boolean",
				editable : false,
				defaultValue : false
			},
			startDate : {
				type : "date"
			},
			endDate : {
				type : "date"
			}
		},
		getFormattedStartDate : function() {
			return kendo.toString(this.get("startDate"), "yyyy.MM");
		},
		getFormattedEndDate : function() {
			return kendo.toString(this.get("endDate"), "yyyy.MM");
		},
		isPeriod : function() {
			return (this.get("endDate").getTime() > this.get("startDate").getTime());
		},
		getEndDateYear : function() {
			return kendo.toString(this.get("endDate"), "yyyy");
		}
	});

	common.ui.data.Photo = kendo.data.Model.define({
		id : "externalId",
		fields : {
			externalId : {
				type : "string",
				editable : false
			},
			imageId : {
				type : "number",
				editable : false,
				defaultValue : 0
			},
			externalId : {
				type : "string",
				editable : false
			},
			publicShared : {
				type : "boolean",
				editable : false,
				defaultValue : false
			},
			modifiedDate : {
				type : "date"
			},
			creationDate : {
				type : "date"
			}
		}
	});

	common.ui.data.Page = kendo.data.Model.define({
		id : "pageId",
		fields : {
			pageId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			objectType : {
				type : "number",
				editable : true,
				defaultValue : 30
			},
			objectId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			name : {
				type : "string",
				editable : true
			},
			versionId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			title : {
				type : "string",
				editable : true
			},
			summary : {
				type : "string",
				editable : true
			},
			pageState : {
				type : "string",
				editable : true,
				defaultValue : "INCOMPLETE"
			},
			bodyText : {
				type : "string",
				editable : true
			},
			viewCount : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			commentCount : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			tagsString : {
				type : "string",
				editable : true,
				defaultValue : ""
			},
			modifiedDate : {
				type : "date",
				editable : true
			},
			creationDate : {
				type : "date",
				editable : true
			}
		},
		adultContent : function(){
			if(this.properties.adultContent )
				return Boolean(this.properties.adultContent);
			else
				return false;			
		},
		authorPhotoUrl : function() {
			if (typeof this.get("user") === 'object' && this.get("user") != null)
				return "/download/profile/" + this.get("user").username + "?width=150&height=150";
			else
				return "/images/common/anonymous.png";
		},
		formattedCreationDate : function() {
			return kendo.toString(this.get("creationDate"), "F");
		},
		formattedModifiedDate : function() {
			return kendo.toString(this.get("modifiedDate"), "F");
		},
		copy : function(target) {
			target.pageId = this.get("pageId");
			target.set('modifiedDate', this.get("modifiedDate"));
			target.set('creationDate', this.get("creationDate"));
			target.set("objectType", this.get("objectType"));
			target.set("objectId", this.get("objectId"));
			target.set("versionId", this.get("versionId"));
			target.set("commentCount", this.get("commentCount"));
			target.set("viewCount", this.get("viewCount"));
			target.set("title", this.get("title"));
			target.set("name", this.get("name"));
			target.set("summary", this.get("summary"));
			target.set("bodyText", this.get("bodyText"));
			target.set("pageState", this.get("pageState"));
			if (typeof this.get("bodyContent") === 'object') {
				target.set('bodyContent', this.get("bodyContent"));
			} else {
				target.set('bodyContent', {
					bodyId : 0,
					pageId : 0,
					bodyType : "FREEMARKER",
					bodyText : "",
				});
			}
			if (typeof this.get("user") === 'object')
				target.set('user', this.get("user"));
			else
				target.set('user', null);
			if (typeof this.get('properties') === 'object')
				target.properties = this.get("properties");
			else
				target.properties = {};
			
			if(this.get('tagsString'))
				target.set('tagsString', this.get('tagsString'));
			else
				target.set('tagsString', "");
			
		}
	});
	
	common.ui.data.Comment = kendo.data.Model.define({
		id : "commentId",
		fields : {
			commentId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			objectType : {
				type : "number",
				editable : true,
				defaultValue : 30
			},
			objectId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			body : {
				type : "string",
				editable : true
			},
			name : {
				type : "string",
				editable : true
			},
			email : {
				type : "string",
				editable : true
			},
			ipaddress : {
				type : "string",
				editable : true
			},
			status : {
				type : "string",
				editable : true,
				defaultValue : "PUBLISHED"
			},
			modifiedDate : {
				type : "date",
				editable : true
			},
			creationDate : {
				type : "date",
				editable : true
			}
		},
		authorPhotoUrl : function() {
			if (typeof this.get("user") === 'object' && this.get("user") != null)
				return "/download/profile/" + this.get("user").username + "?width=150&height=150";
			else
				return "/images/common/no-avatar.png";
		},		
		formattedCreationDate : function() {
			return kendo.toString(this.get("creationDate"), "F");
		},
		formattedModifiedDate : function() {
			return kendo.toString(this.get("modifiedDate"), "F");
		}		
	});

	
	
	common.ui.data.Poll = kendo.data.Model.define({
		id : "pollId",
		fields : {
			pollId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			name : {
				type : "string",
				editable : true
			},
			description : {
				type : "string",
				editable : true
			},
			mode : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			objectId : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			objectType : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			status : {
				type : "string",
				editable : true,
				defaultValue : "PUBLISHED"
			},
			creationDate : {
				type : "date",
				editable : true
			},
			startDate : {
				type : "date",
				editable : true
			},
			endDate : {
				type : "date",
				editable : true
			},
			expireDate : {
				type : "date",
				editable : true
			},
			modifiedDate : {
				type : "date",
				editable : true
			},
			anonymousVoteAllowed : {
				type : "boolean",
				editable : true,
				defaultValue : false
			},
			userVoteAllowed : {
				type : "boolean",
				editable : true,
				defaultValue : false
			},
			multipleSelectAllowed :{
				type : "boolean",
				editable : true,
				defaultValue : false
			},
			voteCount : {
				type : "number",
				defaultValue : 0
			},
			commentCount : {
				type : "number",
				defaultValue : 0
			}
		},	
		authorPhotoUrl : function() {
			if (typeof this.get("user") === 'object' && this.get("user") != null)
				return "/download/profile/" + this.get("user").username + "?width=150&height=150";
			else
				return "/images/common/no-avatar.png";
		},
		formattedCreationDate : function() {
			return kendo.toString(this.get("creationDate"), "F");
		},
		formattedModifiedDate : function() {
			return kendo.toString(this.get("modifiedDate"), "F");
		},			
		copy : function(target) {
			target.pollId = this.get("pollId");
			target.set("objectType", this.get("objectType"));
			target.set("objectId", this.get("objectId"));
			target.set("name", this.get("name"));
			target.set("description", this.get("description"));
			target.set("mode", this.get("mode"));
			target.set("status", this.get("status"));
			target.set('modifiedDate', this.get("modifiedDate"));
			target.set('creationDate', this.get("creationDate"));
			target.set('startDate', this.get("startDate"));
			target.set('endDate', this.get("endDate"));	
			target.set('expireDate', this.get("expireDate"));
			target.set('anonymousVoteAllowed', this.get("anonymousVoteAllowed"));
			target.set('userVoteAllowed', this.get("userVoteAllowed"));
			target.set('multipleSelectAllowed', this.get("multipleSelectAllowed"));
			target.set('voteCount', this.get("voteCount"));
			target.set('commentCount', this.get("commentCount"));
			if (typeof this.get("options") === 'object')
				target.set('options', this.get("options"));
			else
				target.set('options', [] );
			
			if (typeof this.get("user") === 'object')
				target.set('user', this.get("user"));
			else
				target.set('user', null);
		}
	});
	
	
	common.ui.data.PollOption = kendo.data.Model.define({
		id : "optionId",
		fields : {
			optionId : {
				type : "number",
				defaultValue : 0
			},
			pollId : {
				type : "number",
				defaultValue : 0
			},
			optionIndex : {
				type : "number",
				editable : true,
				defaultValue : 1, 
				validation: { required: true, min: 1}
			},
			optionText: {
				type:"string",
				editable: true, 
				nullable:false 
			}
		}	
	});
	
	common.ui.data.Vote = kendo.data.Model.define({
		id : "optionId",
		fields : {
			pollId : {
				type : "number",
				defaultValue : 0
			},
			userId : {
				type : "number",
				defaultValue : 0
			},
			uniqueId : {
				type:"string",			
			},
			optionId : {
				type : "number",
				defaultValue : 1
			},
			IPAddress: {
				type:"string",
				defaultValue : "0.0.0.0"
			}
		}	
	});
	

	var Board = kendo.data.Model.define({
		id: 'boardNo',
	    fields: {
	    	boardCode: { type: "string" },
	    	boardName: { type: "string" },
	        boardNo: { type: "number", defaultValue:0 },
	        writer: { type: "string", defaultValue:"관리자" },
	        title: { type: "string" },
	        content: { type: "string" },
	        readCount: { type: "number" },
	        attachFile: { type: "string" },
	        writeDate: { type: "date" },
	        writingRef: { type: "number" },
	        writingSeq: { type: "number", defualtValue:0 },
	        writingLevel: { type: "number", defualtValue:0 },
	        index: {type: "number", defualtValue:0 }
	    },
	    formattedWriteDate : function() {
			return kendo.toString(this.get("writeDate"), "yyyy/MM/dd");
		},
	    copy : function ( target ){
	    	target.set("boardCode", this.get("boardCode"));
	    	target.set("boardName", this.get("boardName"));
	    	target.set("boardNo", this.get("boardNo"));
	    	target.set("writer", this.get("writer"));
	    	target.set("title", this.get("title"));	
	    	target.set("content", this.get("content"));
	    	target.set("readCount", this.get("readCount"));
	    	target.set("attachFile", this.get("attachFile"));
	    	target.set("writeDate", this.get("writeDate"));
	    	target.set("writingRef", this.get("writingRef"));
	    	target.set("writingSeq", this.get("writingSeq"));
	    	target.set("writingLevel", this.get("writingLevel"));
	    	target.set("index", this.get("index"));
	    } 
	});
	
	var QnaBoard = kendo.data.Model.define({
		id: 'boardNo',
	    fields: {
	    	boardCode: { type: "string" },
	    	boardName: { type: "string" },
	        boardNo: { type: "number", defaultValue:0 },
	        writer: { type: "string", defaultValue:"학생1" },
	        title: { type: "string" },
	        content: { type: "string" },
	        readCount: { type: "number" },
	        attachFile: { type: "string" },
	        writeDate: { type: "date" },
	        writingRef: { type: "number" },
	        writingSeq: { type: "number", defualtValue:0 },
	        writingLevel: { type: "number", defualtValue:0 },
	        type: { type: "string", defaultValue:"질문" },
	        category: { type: "string" },
	        index: { type: "number", defualtValue:0 }
	    },
	    formattedWriteDate : function() {
			return kendo.toString(this.get("writeDate"), "yyyy/MM/dd");
		},
	    copy : function ( target ){
	    	target.set("boardCode", this.get("boardCode"));
	    	target.set("boardName", this.get("boardName"));
	    	target.set("boardNo", this.get("boardNo"));
	    	target.set("writer", this.get("writer"));
	    	target.set("title", this.get("title"));	
	    	target.set("content", this.get("content"));
	    	target.set("readCount", this.get("readCount"));
	    	target.set("attachFile", this.get("attachFile"));
	    	target.set("writeDate", this.get("writeDate"));
	    	target.set("writingRef", this.get("writingRef"));
	    	target.set("writingSeq", this.get("writingSeq"));
	    	target.set("writingLevel", this.get("writingLevel"));
	    	target.set("type", this.get("type"));
	    	target.set("category", this.get("category"));
	    	target.set("index", this.get("index"));
	    } 
	});
	
	var extend = $.extend;
	extend( common.ui.data, {
		community:{
			Board : Board,
			QnaBoard : QnaBoard
		}  
	});
})(jQuery);

;
(function($, undefined) {
	
	var ui = common.ui, 
	ajax = common.ui.ajax, 
	DataSource = kendo.data.DataSource,
	handleAjaxError = common.ui.handleAjaxError, 
	isFunction = kendo.isFunction, 
	extend = $.extend;
	
	

	function unsharing(imageId, callback) {
		$.ajax({
			type : 'POST',
			url : '/data/streams/photos/delete.json?output=json',
			data : {
				imageId : imageId
			},
			success : function(response) {
				if (isFunction(callback))
					callback(response);
			},
			error : handleAjaxError,
			dataType : "json"
		});
	}

	function sharing(imageId, callback) {
		$.ajax({
			type : 'POST',
			url : '/data/streams/photos/insert.json?output=json',
			data : {
				imageId : imageId
			},
			success : function(response) {
				if (isFunction(callback))
					callback(response);
			},
			error : handleAjaxError,
			dataType : "json"
		});
	}

	function details(imageId, callback) {
		$.ajax({
			type : 'GET',
			url : "/data/streams/photos/get.json?output=json",
			data : {
				imageId : imageId
			},
			success : function(response) {
				if (isFunction(callback))
					callback(response);
			},
			error : handleAjaxError,
			dataType : "json"
		});
	}
	;

	
	
	function attachmentPorpertyDataSource(fileId){
		return DataSource.create({		
			transport: { 
				read: { url:"/data/files/properties/list.json?output=json", type:'GET' },
				create: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + fileId, type:'POST' ,contentType : "application/json" },
				update: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + fileId, type:'POST'  ,contentType : "application/json"},
				destroy: { url:"/data/files/properties/delete.json?output=json" +  "&fileId=" + fileId, type:'POST' ,contentType : "application/json"},
		 		parameterMap: function (options, operation){			
					if (operation !== "read" && options.models) {
						return kendo.stringify(options.models);
					} 
					return { fileId: fileId }
				}
			},						
			batch: true, 
			schema: {
				model: common.ui.data.Property
			},
			error:handleAjaxError
		});
	}
	
	function pagePorpertyDataSource(page){
		return DataSource.create({		
			transport: { 
				read: { url:"/data/pages/properties/list.json?output=json", type:'GET' },
				create: { url:"/data/pages/properties/update.json?output=json" + "&pageId=" + page.pageId , type:'POST' ,contentType : "application/json" },
				update: { url:"/data/pages/properties/update.json?output=json" + "&pageId=" + page.pageId, type:'POST'  ,contentType : "application/json"},
				destroy: { url:"/data/pages/properties/delete.json?output=json" +  "&pageId=" + page.pageId, type:'POST' ,contentType : "application/json"},
		 		parameterMap: function (options, operation){			
					if (operation !== "read" && options.models) {
						return kendo.stringify(options.models);
					} 
					return { pageId: page.pageId }
				}
			},						
			batch: true, 
			schema: {
				model: common.ui.data.Property
			},
			error:handleAjaxError
		});
	}

	function pollOptionsDataSource(poll){
		return DataSource.create({		
			transport: { 
				read: { url:"/data/polls/options/list.json?output=json", type:'GET' },
				create: { url:"/data/polls/options/update.json?output=json" + "&pollId=" + poll.pollId , type:'POST' ,contentType : "application/json" },
				update: { url:"/data/polls/options/update.json?output=json" + "&pollId=" + poll.pollId, type:'POST'  ,contentType : "application/json"},
				destroy: { url:"/data/polls/options/delete.json?output=json" +  "&pollId=" + poll.pollId, type:'POST' ,contentType : "application/json"},
		 		parameterMap: function (options, operation){			
					if (operation !== "read" && options.models) {
						return kendo.stringify(options.models);
					} 
					return { pollId: poll.pollId }
				}
			},						
			batch: true, 
			schema:{
				model:common.ui.data.PollOption
			},			
			error:handleAjaxError
		});
	}
	
	common.ui.data.page = common.ui.data.page || {};
	common.ui.data.poll = common.ui.data.poll || {};

	extend(common.ui.data.poll,{		
		options : {		
			datasource: pollOptionsDataSource
		}
	});
	
	extend(common.ui.data.page,{		
		properties : {		
			datasource: pagePorpertyDataSource
		}
	});

	extend(common.ui.data.image, {
		share : sharing,
		unshare : unsharing,
		streams : details
	});
	
})(jQuery);