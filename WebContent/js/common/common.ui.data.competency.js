(function($, undefined) {
	
	var extend = $.extend;

	var Job = kendo.data.Model.define( {
	    id: "jobId", // the identifier of the model
	    fields: {
	    	jobId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType: { type: "number", editable: true, defaultValue: 0  },   
	    	objectId: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true },
	        description: { type: "string", editable: true },
	        properties : { type: "object", editable: true, defaultValue:[]},   
	        jobLevels : { type: "object", editable: true, defaultValue:[]},   
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	        
	    },	    
	    copy : function ( target ){
	    	target.set("jobId", this.get("jobId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("jobLevels", this.get("jobLevels"));
	    	target.set("properties", this.get("properties"));
	    	if( typeof this.get("classification") === 'object' ){
	    		target.set("classification", this.get("classification"));
	    	}else{
	    		target.set("classification", {
	    			classifyType:0,
	    			classifiedMajorityId:0,
	    			classifiedMiddleId:0,
	    			classifiedMinorityId:0
	    		} );
	    	}	 
	    }    
	});
	
	var JobLevel = kendo.data.Model.define( {
	    id: "jobLevelId", // the identifier of the model
	    fields: {
	    	jobLevelId: { type: "number", editable: true, defaultValue: 0  },    	
	    	jobId: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true },
	        description: { type: "string", editable: true },
	        level: { type: "number", editable: true, defaultValue: 0  },   
	        minWorkExperienceYear: { type: "number", editable: true, defaultValue: 0  },   
	        maxWorkExperienceYear: { type: "number", editable: true, defaultValue: 0  },
	        strong : { type: "boolean", editable: true, defaultValue: false  }
	    },	    
	    copy : function ( target ){
	    	target.set("jobLevelId", this.get("jobLevelId"));
	    	target.set("jobId", this.get("jobId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("level", this.get("level"));
	    	target.set("strong", this.get("strong"));
	    	target.set("minWorkExperienceYear", this.get("minWorkExperienceYear"));
	    	target.set("maxWorkExperienceYear", this.get("maxWorkExperienceYear"));
	    }    
	});
	
	var Competency = kendo.data.Model.define( {
	    id: "competencyId", // the identifier of the model
	    fields: {
	    	competencyId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType: { type: "number", editable: true, defaultValue: 0  },   
	    	objectId: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true },
	        level: { type: "number", editable: true, defaultValue: 0  },   
	        competencyUnitCode : { type:"string", editable:true },
	        competencyGroupCode : { type:"string", editable:true, defaultValue:null },
	        description: { type: "string", editable: true },
	        job: {type:"object", defaultValue: new Job()}
	    },	    
	    copy : function ( target ){
	    	target.set("competencyId", this.get("competencyId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("level", this.get("level"));
	    	target.set("competencyUnitCode", this.get("competencyUnitCode"));
	    	target.set("competencyGroupCode", this.get("competencyGroupCode"));
	    	
	    	if( this.get("job") == null ){
	    		target.set("job", new Job());	    	
	    	}else{
	    		target.set("job", this.get("job"));	    		
	    	}
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});


	
	var EssentialElement = kendo.data.Model.define( {
	    id: "essentialElementId", // the identifier of the model
	    fields: {
	    	essentialElementId: { type: "number", editable: true, defaultValue: 0  },    	
	    	competencyId: { type: "number", editable: true, defaultValue: 0  },   
	    	description: { type: "string", editable: true },
	    	level: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true }
	    },	    
	    copy : function ( target ){
	    	target.set("essentialElementId", this.get("essentialElementId"));
	    	target.set("competencyId", this.get("competencyId"));
	    	target.set("level", this.get("level"));
	    	target.set("description", this.get("description"));
	    	target.set("name", this.get("name"));
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});	
	
	var PerformanceCriteria = kendo.data.Model.define( {
	    id: "performanceCriteriaId", // the identifier of the model
	    fields: {
	    	performanceCriteriaId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType : { type: "number", editable: true, defaultValue: 0},
	    	objectId : { type: "number", editable: true, defaultValue: 0 },	    	
	    	sortOrder : { type: "number", editable: true, defaultValue: 0 },	    	
	    	description: { type: "string", editable: true  },   
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	
	    },	    
	    copy : function ( target ){
	    	target.set("performanceCriteriaId", this.get("performanceCriteriaId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));	    	
	    	target.set("sortOrder", this.get("sortOrder"));	    	
	    	target.set("description", this.get("description"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});		

	var Ability = kendo.data.Model.define( {
	    id: "abilityId", // the identifier of the model
	    fields: {
	    	abilityId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType : { type: "number", editable: true, defaultValue: 0},
	    	objectId : { type: "number", editable: true, defaultValue: 0 },	   
	    	abilityType: { type: "string", editable: true , defaultValue:'NONE'},
	        name: { type: "string", editable: true },
	    	description: { type: "string", editable: true }
	    },	    
	    copy : function ( target ){
	    	target.set("abilityId", this.get("abilityId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
    		target.set("abilityType", this.get("abilityType"));
	    }    
	});		

	
	var AssessmentScheme = kendo.data.Model.define( {
		id : "assessmentSchemeId",
		fields: {
			assessmentSchemeId: { type: "number", defaultValue: 0},
			objectType : { type: "number"},
	    	objectId : { type: "number"},
			name : { type: "string" },	   
			description:  { type: "string" },
			multipleApplyAllowed:{ type:'boolean', defaultValue:false},
			feedbackEnabled:{ type:'boolean', defaultValue:false}, 
			properties : {type: "object" , defaultValue:"[]"},
			jobSelections : {type:"object", defalutValue:"[]"},
			subjects : {type:"object", defalutValue:"[]"},
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	
		},
		copy : function ( target ){
			target.set("assessmentSchemeId", this.get("assessmentSchemeId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("scale", this.get("scale"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));	
	    	target.set("multipleApplyAllowed", this.get("multipleApplyAllowed"));
	    	target.set("feedbackEnabled", this.get("feedbackEnabled"));

	    	if( typeof this.get("subjects") === 'object' )
	    		target.set("subjects", this.get("subjects"));
	    	else
	    		target.set("jobSelections", []);	
	    	
	    	if( typeof this.get("jobSelections") === 'object' )
	    		target.set("jobSelections", this.get("jobSelections"));
	    	else
	    		target.set("jobSelections", []);	
	    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", []);	 	    	
	    	
	    	if( this.get("ratingScheme"))
	    		target.set("ratingScheme", this.get("ratingScheme"));
	    	else
	    		target.set("ratingScheme", new RatingScheme());	  
		}
	});
	
	var JobSelection = kendo.data.Model.define( {
		id : "selectionId",
		fields: {
			selectionId: { type: "number", defaultValue: 0},
			objectType : { type: "number", defaultValue:0},
	    	objectId : { type: "number", defaultValue:0},
	    	classifyType : { type: "number", defaultValue:0 },
	    	classifiedMajorityId : { type: "number", defaultValue:0},
	    	classifiedMiddleId : { type: "number", defaultValue:0},
	    	classifiedMinorityId : { type: "number", defaultValue:0},
	    	jobId : { type: "number", defaultValue:0},
	    	classifyTypeName:  { type: "string" },
	    	classifiedMajorityName:  { type: "string" },
	    	classifiedMiddleName:  { type: "string" },
	    	classifiedMinorityName:  { type: "string" },
			jobName:  { type: "string" }
		},
		copy : function ( target ){
			target.set("selectionId", this.get("selectionId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("classifyType", this.get("classifyType"));
	    	target.set("classifiedMajorityId", this.get("classifiedMajorityId"));
	    	target.set("classifiedMiddleId", this.get("classifiedMiddleId"));
	    	target.set("classifiedMinorityId", this.get("classifiedMinorityId"));
	    	target.set("jobId", this.get("jobId"));	 
	    	target.set("classifyTypeName", this.get("classifyTypeName"));	 
	    	target.set("classifiedMajorityName", this.get("classifiedMajorityName"));	 
	    	target.set("classifiedMiddleName", this.get("classifiedMiddleName"));	 
	    	target.set("classifiedMinorityName", this.get("classifiedMinorityName"));	 
	    	target.set("jobName", this.get("jobName"));	 
		}
	});

	var AssessmentSubject = kendo.data.Model.define( {
		id : "subjectId",
		fields: {
			subjectId: { type: "number", defaultValue: 0},
			objectType : { type: "number", defaultValue:0},
	    	objectId : { type: "number", defaultValue:0},
	    	subjectObjectType : { type: "number", defaultValue:0},
	    	subjectObjectId : { type: "number", defaultValue:0},
			subjectObjectName:  { type: "string" }
		},
		copy : function ( target ){
			target.set("subjectId", this.get("subjectId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("subjectObjectType", this.get("subjectObjectType"));
	    	target.set("subjectObjectId", this.get("subjectObjectId"));
	    	target.set("subjectObjectName", this.get("subjectObjectName"));
		}
	});
	
	var RatingScheme = kendo.data.Model.define( {
		id : "ratingSchemeId",
		fields: {
			ratingSchemeId: { type: "number", defaultValue: 0},
			objectType : { type: "number"},
	    	objectId : { type: "number"},
			name : { type: "string" },	   
			description:  { type: "string" },
			scale: { type: "number", defaultValue:0 },
			properties : {type: "object" , defaultValue:"[]"},
			ratingLevels : {type: "object" , defaultValue:"[]"},
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	
		},
		copy : function ( target ){
			target.set("ratingSchemeId", this.get("ratingSchemeId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("scale", this.get("scale"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));	 
	    	
	    	if( typeof this.get("ratingLevels") === 'object' )
	    		target.set("ratingLevels", this.get("ratingLevels"));
	    	else
	    		target.set("ratingLevels", []);	  
	    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", []);	 
		}
	});

	var RatingLevel = kendo.data.Model.define( {
		id : "ratingLevelId",
		fields: {
			ratingSchemeId: { type: "number", defaultValue: 0},
			ratingLevelId: { type: "number", defaultValue: 0},
			title : { type: "string" },
			score: { type: "number", defaultValue:0 }
		},
		copy : function ( target ){
			target.set("ratingSchemeId", this.get("ratingSchemeId"));
	    	target.set("ratingLevelId", this.get("ratingLevelId"));
	    	target.set("title", this.get("title"));
	    	target.set("score", this.get("score"));    	
		}
	});
	
	var CodeSet = kendo.data.Model.define( {
	    id: "codeSetId", // the identifier of the model
	    parentId : "parentCodeSetId",
	    fields: {
	    	codeSetId: { type: "number"},
	    	parentCodeSetId : { field:"parentCodeSetId", nullable:true },
	    	objectType : { type: "number"},
	    	objectId : { type: "number"},
	    	description:  { type: "string" },
	    	name : { type: "string", defaultValue:null},	        
	    	code : { type: "string", defaultValue:null },	        
	    	groupCode : { type: "string", defaultValue:null },	        
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" },
	    	enabled : {type: "boolean" },
	    	properties : {type: "object" }
	    },    
	    copy : function ( target ){
	    	target.set("codeSetId", this.get("codeSetId"));
	    	target.set("parentCodeSetId", this.get("parentCodeSetId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("code", this.get("code"));
	    	target.set("groupCode", this.get("groupCode"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));
	    	target.set("enabled", this.get("enabled"));
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", []);	    	
	    }    
	});

	
	var AssessmentPlan = kendo.data.Model.define( {
		id : "assessmentId",
		fields: {
			assessmentId: { type: "object", defaultValue: 0},
			objectType : { type: "number"},
	    	objectId : { type: "number"},
			name : { type: "string" },	   
			description:  { type: "string" },
			multipleApplyAllowed:{ type:'boolean', defaultValue:false},
			feedbackEnabled:{ type:'boolean', defaultValue:false}, 
			properties : {type: "object" , defaultValue:"[]"},
			jobSelections : {type:"object", defalutValue:"[]"},
			subjects : {type:"object", defalutValue:"[]"},
			state : { type : "string", editable : true, defaultValue : "INCOMPLETE"	},			
			startDate: { type: "date"},
			endDate: { type: "date"},
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	
		},
		copy : function ( target ){
			target.set("assessmentId", this.get("assessmentId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("ratingScheme", this.get("ratingScheme"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));	
	    	target.set("multipleApplyAllowed", this.get("multipleApplyAllowed"));
	    	target.set("feedbackEnabled", this.get("feedbackEnabled"));
	    	target.set("startDate", this.get("startDate"));
	    	target.set("endDate", this.get("endDate"));
	    	target.set("state", this.get("state"));

	    	if( typeof this.get("subjects") === 'object' )
	    		target.set("subjects", this.get("subjects"));
	    	else
	    		target.set("jobSelections", []);	
	    	
	    	if( typeof this.get("jobSelections") === 'object' )
	    		target.set("jobSelections", this.get("jobSelections"));
	    	else
	    		target.set("jobSelections", []);	
	    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", []);	 	    	
	    	
	    	if( this.get("ratingScheme"))
	    		target.set("ratingScheme", this.get("ratingScheme"));
	    	else
	    		target.set("ratingScheme", new RatingScheme());	  
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    },
		formattedStartDate : function(){
			if( typeof this.get('startDate') == 'string' ){
				return kendo.toString( new Date(this.get("startDate")), "g");
			}
	    	return kendo.toString(this.get("startDate"), "g");
	    },
	    formattedEndDate : function(){
			if( typeof this.get('endDate') == 'string' ){
				return kendo.toString( new Date(this.get("endDate")), "g");
			}	    	
	    	return kendo.toString(this.get("endDate"), "g");
	    }
	});	
	
	var Assessment = kendo.data.Model.define( {
	    id: "assessmentId", // the identifier of the model
	    fields: {
	    	assessmentId: { type: "number", defaultValue: 0},
	    	assessmentPlan: { type: "object", defaultValue: new AssessmentPlan(),parse: function( value ){
	    		console.log( value );
	    		return new AssessmentPlan( value );
	    	} },	    	
	    	assessors:  { type: "object" ,  defaultValue:[]},
	    	'candidate' : { defaultValue:new common.ui.data.User() , parse: function( value ){
	    		console.log( value );
	    		return new common.ui.data.User( value );
	    	} },
	    	job : { type: "object", nullable:true , defaultValue:new Job() },
	    	jobLevelId:  { type: "number", defaultValue: 0 },
	    	jobLevel : { type: "number", defaultValue: 0},
	    	competencies : { type: "object" ,  defaultValue:[]},
	    	totalScore:  { type: "number", defaultValue: 0 },
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" },
	        jobLevelName: { type : "string" },
	        state : { type : "string", editable : true, defaultValue : "INCOMPLETE"	}    	
	    },    
	    copy : function ( target ){
	    	target.set("assessmentId", this.get("assessmentId"));
	    	target.set("assessmentPlan", this.get("assessmentPlan"));
	    	target.set("assessors", this.get("assessors"));
	    	target.set("competencies", this.get("competencies"));
	    	target.set("candidate", this.get("candidate"));
	    	target.set("state", this.get("state"));
	    	target.set("job", this.get("job"));
	    	target.set("jobLevel", this.get("jobLevel"));
	    	target.set("jobLevelName", this.get("jobLevelName"));
	    	target.set("totalScore", this.get("totalScore"));
	    	target.set("createdDate", this.get("createdDate"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
		},
		
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    }
	});
	
	var AssessmentStats = kendo.data.Model.define( {
		id: "assessmentPlanId", // the identifier of the model
		fields: {
			assessmentPlanId: { type: "number", defaultValue: 0},
	    	assessmentPlan: { type: "AssessmentPlan", defaultValue:new AssessmentPlan() },	    	
	    	userAssessments:  { type: "object" ,  defaultValue:[]},
	    	userAssessedCount : { type: "number", defaultValue: 0 },
	    	userIncompleteCount : { type: "number", defaultValue: 0 },
	    	'assessmentPlan.startDate': { type: "date"}
	    },
		copy : function ( target ){
	    	target.set("assessmentPlanId", this.get("assessmentPlanId"));
	    	target.set("assessmentPlan", this.get("assessmentPlan"));
	    	target.set("userAssessments", this.get("userAssessments"));
	    	target.set("userAssessedCount", this.get("userAssessedCount"));
	    	target.set("userIncompleteCount", this.get("userIncompleteCount"));
		}
	});

	var AssessmentQuestion = kendo.data.Model.define( {
		id : "questionId",
		fields: {
			questionId: { type: "number", defaultValue: 0},
			assessmentId: { type: "number", defaultValue: 0},
			competencyId : { type: "number", defaultValue:0},
			essentialElementId : { type: "number", defaultValue:0},
			competencyLevel : { type: "number", defaultValue:0},
			candidateId : { type: "number", defaultValue:0},
			assessorId : { type: "number", defaultValue:0},
			seq : { type: "number", defaultValue:0},
			competencyName:  { type: "string" },
			essentialElementName:  { type: "string" },
			question:  { type: "string" },
			score : { type: "number", defaultValue:0},
		},
		copy : function ( target ){
			target.set("questionId", this.get("questionId"));
			target.set("assessmentId", this.get("assessmentId"));
	    	target.set("competencyId", this.get("competencyId"));
	    	target.set("essentialElementId", this.get("essentialElementId"));
	    	target.set("competencyLevel", this.get("competencyLevel"));
	    	target.set("candidateId", this.get("candidateId"));
	    	target.set("assessorId", this.get("assessorId"));
	    	target.set("seq", this.get("seq"));
	    	target.set("competencyName", this.get("competencyName"));
	    	target.set("essentialElementName", this.get("essentialElementName"));
	    	target.set("question", this.get("question"));
	    	target.set("score", this.get("score"));
		}
	});
	
	var AssessmentCreatePlan = kendo.data.Model.define( {
	    id: "name", // the identifier of the model
	    fields: {
	    	name: { type: "string"},
	    	description : { type: "string", nullable:true },
	    	objectType : { type: "number"},
	    	objectId : { type: "number"},
	    	assessmentSchemeId:  { type: "number" },
	    	startDate : { type: "date" },	        
	    	endDate : { type: "date"}
	    },    
	    copy : function ( target ){
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("assessmentSchemeId", this.get("assessmentSchemeId"));
	    	target.set("startDate", this.get("startDate"));    	
	    	target.set("endDate", this.get("endDate"));    	
	    }    
	});
	
	extend( common.ui.data, {
		competency:{
			Job : Job,
			JobLevel : JobLevel,
			CodeSet : CodeSet,
			Competency : Competency,
			EssentialElement : EssentialElement,
			PerformanceCriteria : PerformanceCriteria,
			Ability : Ability,
			RatingScheme:RatingScheme,
			RatingLevel:RatingLevel,
			AssessmentScheme:AssessmentScheme,
			JobSelection:JobSelection,
			AssessmentSubject:AssessmentSubject,
			AssessmentCreatePlan:AssessmentCreatePlan,
			AssessmentPlan:AssessmentPlan,
			Assessment:Assessment,
			AssessmentStats:AssessmentStats,
			AssessmentQuestion:AssessmentQuestion
		}  
	} );
	
})(jQuery);
