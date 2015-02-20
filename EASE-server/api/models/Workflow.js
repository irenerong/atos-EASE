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


  }, 

   afterDestroy: function (workflow, cb) {
    sails.log('Destroy workflow')
    Task.destroy(workflow.tasks).exec(function (err) {return cb()})
   }


};

