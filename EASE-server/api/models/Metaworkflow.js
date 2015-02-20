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

  	metatasks: {
  		collection: 'Metatask',
  		via: 'metaworkflow'
  	}, 

    ticket: {
      model: 'WorkflowGeneratorTicket'
    }
    
  }, 

   afterDestroy: function (metaworkflow, cb) {
      Metatask.destroy(metaworkflow.metatasks).exec(function(err){cb()})
   }



};
