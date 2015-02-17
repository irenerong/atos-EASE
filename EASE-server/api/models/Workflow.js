/**
* Workflow.js
*
* @description :: Server-side Workflow
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {


  	generationParams: {
  		type: 'json', 
      required: true
  	},

    tasks: {
      collection: 'Task',
      via: 'workflow'
    }, 

    metaworkflow : {
      model: 'Metaworkflow'
    },

    ticket: {
      model: 'WorkflowGeneratorTicket'
    }


  }


};

