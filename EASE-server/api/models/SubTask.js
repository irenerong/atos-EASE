/**
* SubTask.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	
  	task: {
  		model: 'task'
  	}
  	, 

  	beginAfter: {
      collection: 'SubTask',
      via: 'endBefore'
    },

    beginAfterDuration: {
    	type: 'time'
    },

    endBefore: {
      model: 'SubTask'
    },


    agent: {
      model: 'Agent'
    }, 

    action: {
      type: 'json'
    }, 

    isDone: {
    	type: 'string'
    }

  }
};

