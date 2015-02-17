/**
* Task.js
*
* @description :: Server-Side Task
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    
   	metatask: {
  		model: 'Metatask'
  	}, 

  	workflow: {
  		model: 'Workflow'
  	},

    subtasks: {
      collection: 'subTask',
      via: 'task'
    },

    beginAfter: {
      collection: 'Task',
      via: 'endBefore'
    },

    endBefore: {
      model: 'Task'
    },

    agent: {
      model: 'Agent'
    }, 

    action: {
      type: 'json'
    }
    
  }


};

