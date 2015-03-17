/**
* User.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	username: {
      type: 'string',
      required: true
  	},
  	password: {
  	  type : 'string',
  	  required: true ,
  	  minLength:6
  	},
  	admin :{
  		type: 'boolean',
  		defaultsTo: false
  	},
    ingredient:{
      type: 'array'
    }




  },

  addIngredient: function(userID, newIngre, cb){
      var ingre =[];

      User.findOne(userID).exec(function(err,user){
        if (err) return res.json({err: "database error when add ingredient"});

        if (!user) return res.json({err :"user doesn't exist"});

        console.log("findone "+user.ingredient);

         ingre= newIngre.concat(user.ingredient);
        console.log(ingre+" rien");

      User.update({id:userID},{ingredient:ingre}).exec(function(err,newusers){

        if (err) cb(err);
        console.log("update "+newusers[0].id+"has "+newusers[0].ingredient+' of ingredient');
        cb(null,newusers[0]);
      })
      })

    },

  beforeCreate: function(user,cb){
  	var bcrypt = require('bcrypt');

  	bcrypt.genSalt(10,function(err,salt) {
  		if (err) return res.json('error genSalt');

  		bcrypt.hash(user.password,salt,function(err,hash){

  			if (err) return cb(err);

  			user.password=hash;
  			cb();
  		});
  	});
  }
};

