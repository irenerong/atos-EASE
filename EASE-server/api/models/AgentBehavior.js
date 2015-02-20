/**
* AgentBehavior.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	moduleName : {
  		type: 'string'
  	}, 

  	module : function () {
  		return require('../agentBehaviors/'+this.moduleName)
  	}, 

  	subTasksForTask: function (task) {
  		return this.module().subtasks(task)
  	}

  }
};

