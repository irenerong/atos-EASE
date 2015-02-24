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
  	}


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

