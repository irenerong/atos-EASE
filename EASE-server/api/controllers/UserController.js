/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	
	signin: function(req, res) {

		var bcrypt = require('bcrypt');


		setTimeout(function() { console.log("Salut !")}, 5000);

		User.findOne({username: req.body.username}).exec(function (err, user)
		{
			if (!user)
			{
				return res.json({status: "User does not exist"})
			}

			bcrypt.compare(req.body.password, user.password,function(err,match){
				if (err) {
					res.json({status: "server error"} );
				}
				else if (match){
					req.session.userID= user.id;

					if (user.admin)
						req.session.admin= true;
					res.json({user: user});
				}else{
					if (req.session.user) req.session.userID={};
					res.json({error:'invalid password'});

				}

			});
			
		});

	},

	changeAdmin: function(req,res) {

		User.findOne({id:req.session.userID}).exec(function (err,user) {
			if (err) return res.json({status:'server error'});
			User.update({id:req.session.userID},{admin:false}).exec(function (err,oldAdmin){
				if (err) return res.json(err);
				req.session.admin= false;
				console.log(oldAdmin.username+' n\'est plus admin');
			});
			
			console.log("login as admin"+user.username);

			

		});

		User.update({username:req.body.username},{admin:true}).exec(function (err,newadmin)
			{
				if (err) return res.jason({status: 'database error'});
				if (newadmin){
					
						res.json({status: 'the admin has been changed to '+ newadmin.username+' you\'re no longer admin' });

				}else{
					return res.json({error:'you can not change administrator to'+req.body.username});
				}

			});

	}

};

