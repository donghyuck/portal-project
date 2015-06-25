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
			}
		},	
		authorPhotoUrl : function() {
			if (typeof this.get("user") === 'object' && this.get("user") != null)
				return "/download/profile/" + this.get("user").username + "?width=150&height=150";
			else
				return "/images/common/no-avatar.png";
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
			target.set('options', this.get("options"));
			if (typeof this.get("user") === 'object')
				target.set('user', this.get("user"));
			else
				target.set('user', null);
		}
	});
	
	
})(jQuery);

;
(function($, undefined) {
	var ui = common.ui, ajax = common.ui.ajax, handleAjaxError = common.ui.handleAjaxError, isFunction = kendo.isFunction, extend = $.extend;

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

	extend(common.ui.data.image, {
		share : sharing,
		unshare : unsharing,
		streams : details
	});

})(jQuery);