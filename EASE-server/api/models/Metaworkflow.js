/**
* Metaworkflow.js
*
* @description ::metaWorkflow is the like a recipe for cooking which stored in database, 
* each time when user want to generate a workflow, he can search for several 'recipe/metaworkflow',
* and in metaworkflow ,  there're metatask, which could be adapted by  different 'agent' according to his agent type
* for ex: a metaworkflow is exotic chicken, and the first metatask is 'cut some potatoes', this could only be done 'agent:user'
* the second metatask is 'cook the chicken', this could be done by 'agent:oven' or 'agent: microwave'
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
    ingredient :{
      collection: 'Ingredient',
      via:'metaworkflow'
    }
    
  }, 

   afterDestroy: function (metaworkflow, cb) {
      cb()
   }



};
