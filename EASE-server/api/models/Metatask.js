/**
* Metatask.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    
    idTask: {
      type: 'integer'
    },

  	metaworkflow: {
  		model: 'Metaworkflow'
  	}, 

  	name: {
  		type: 'string'

  	},

  	agentTypes: {
  		type: 'array'
  	}, 

  	action: {
  		type: 'json'
  	},
   

    afterCreate: function (metatask, cb) {
      Metaworkflow.update(metatask.metaworkflow, {metatask: metatask.id}) //Update the metaworkflow association
      .exec(cb)
    }

  
  }
};

