/**
* Metaworkflow.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
  	
  	title: {
  		type: 'string'
  	},
    intent: {
      type: 'string'
    },

  	metatasks: {
  		collection: 'Metatask',
  		via: 'metaworkflow'
  	}, 

    ticket: {
      model: 'WorkflowGeneratorTicket'
    },
    ingredient :{
      type: 'array'
    }
    
  }, 

   afterDestroy: function (metaworkflow, cb) {
      cb()
   }



};
