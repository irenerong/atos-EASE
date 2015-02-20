/**
* TaskAgentAdaptationInfos.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
  	task: {
  		model: 'Task'
  	}, 

  	subtasks: {
  		collection: 'SubTask', 
  		via: 'taskAgentAdaptationInfos'
  	}, 

  	params: {
  		type: 'json'
  	}

  }, 
  
  afterDestroy: function (infos, cb) {
    sails.log('Destroy infos : ' + JSON.stringify(infos))
    cb()
  }
};

