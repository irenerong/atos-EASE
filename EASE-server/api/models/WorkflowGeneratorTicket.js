/**
* WorkflowGeneratorTicket.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
  	user: {
  		model: 'user'
  	}, 

  	metaworkflows: {
  		collection: 'Metaworkflow', 
  		via: 'ticket'
  	}, 

  	workflows: {
  		collection: 'Workflow', 
  		via: 'ticket'
  	},

    /*
      GENERATING, WAITINGVALIDATION, VALIDATED, FINISHED
    */
  	status: {
  		type: 'string'
  	}, 




  }, 

  

    afterDestroy: function (ticket, cb) {
        console.log('Destroy ticket and its workflows')
         
      Metaworkflow.destroy(ticket.metaworkflows)
      .exec(function (err) {
        Workflow.destroy(ticket.workflows)
        .exec (function (err) {return cb()})

      })
    }
};

