/**
* Ingredient.js
*
* @description :: the relation between ingredient and metaworkflow is many to many, in the same time the relation between ingredient and user is many to many also
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
    },
    user:{
      model:'User'
    }
 }
};

