/**
* SubTask.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	
  	taskAgentAdaptationInfos: {
  		model: 'TaskAgentAdaptationInfos'
  	}, 

    agent: {
      model: 'Agent'
    }, 

    action: {
      type: 'json'
    }, 

    status: {
    	type: 'string'
    }, 

    consumption : {
      type: 'json'
    },



    /*START CONDITION
      
    */
    

    startCondition: {
      model: 'StartCondition'
    }, 

    nextStartConditions: {
      collection: 'StartCondition', 
      via: 'waitFor'
    }



  }, 
  afterDestroy: function (subtask, cb) {
    sails.log('Destroy subtask : ' + JSON.stringify(subtask))
    cb()
  }
};

