/**
* Ingredient.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
  	name: {
  		type :'string'

  	},
  	quantity:{
  		type : 'integer'

  	},
  	unit:{
  		type: 'string',
      	enum:['g','kg','cup','tsp','tbsp','L','ml'],

 	  },
  metaworkflow:{
    model:'Metaworkflow'
  }
 }
};

