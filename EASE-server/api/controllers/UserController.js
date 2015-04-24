/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	
	// Helps users to sign in with their login and password
	signin: function(req, res) {

		var bcrypt = require('bcrypt');
		req.session.machin = "POUET";

		console.log("Salut !");

		User.findOne({username: req.body.username}).exec(function (err, user)
		{
			if (!user)
			{
				return res.json({error: "User does not exist"})
			}

			bcrypt.compare(req.body.password, user.password,function(err,match){
				if (err) {
					res.json({error: "server error"} );
				}
				else if (match){
					req.session.userID= user.id;

					if (user.admin)
						req.session.admin= true;
					res.json({user: user});
					// subscribe this socket to all the workflow and subtasks
					
				}else{
					if (req.session.user) req.session.userID={};
					res.json({error:'invalid password'});

				}

			});


		});

	},
	// Subcribes each user to all their subtasks
	subscribe: function(req, res) {
		if (req.isSocket){

						console.log('socket signin received' + req.session.machin);
						
						SubTask.watch(req);
						Workflow.watch(req);
						SubTask.find({status:{'!':'finish'}}).exec(
						function(err, subtasks){
							if (err) console.log(err);
							else{SubTask.subscribe(req,subtasks);}
							
						}
						)						

						req.session.IOSsocketID = sails.sockets.id(req.socket);
						res.json('OKAY :D'+req.session.IOSsocketID+' is connected');
		}
	},
	// Change administrator rights
	changeAdmin: function(req,res) {

		User.findOne({id:req.session.userID}).exec(function (err,user) {
			if (err) return res.json({error:'server error'});
			User.update({id:req.session.userID},{admin:false}).exec(function (err,oldAdmin){
				if (err) return res.json(err);
				req.session.admin= false;
				console.log(oldAdmin.username+' n\'est plus admin');
			});
			
			console.log("login as admin"+user.username);

			

		});

		User.update({username:req.param('username')},{admin:true}).exec(function (err,newadmins)
			{
				if (err) return res.jason({error: 'database error'});
				if (newadmins[0]){
					
						res.json({error: 'the admin has been changed to '+ newadmins[0].username+' you\'re no longer admin' });

				}else{
					return res.json({error:'you can not change administrator to'+req.param('username')});
				}

			});

	},
	//Add ingredients to a user
	addIngredient: function(req, res){
      var exist =false;
      var params=req.params.all();
      var newIngre=JSON.parse(params.newIngre);
      // var newIngre=params.newIngre.split(',');
      console.log(newIngre);

      User.findOne(req.session.userID).populate('ingredient').exec(function(err,user){
        if (err) return res.json({err: "database error when add ingredient"});

        if (!user) return res.json({err :"user doesn't exist"});

        //console.log("findone "+user.ingredient);

       	newIngre.forEach(function(e,i,a){
          exist=false
          user.ingredient.forEach(function(e1,i1,a1){

            if (e.name == e1.name){
              exist=true;
              e.quantity += e1.quantity;
              Ingredient.update({id:e1.id},{quantity:e.quantity}).exec(function(err,ingre){});
            }

          })

          if (exist==false){
          	console.log(e);
            Ingredient.create({name:e.name,quantity:e.quantity,unit:e.unit,user:req.session.userID}).exec(function(err,ingre){});
          }


        })
       	res.json({'success':newIngre});

      })

    },
    // Gets all the ingredients of a user
    getIngredient:function(req,res){

    	User.findOne(req.session.userID).populate('ingredient').exec(function(err,user){
    		res.json({ingredients:user.ingredient});
    	})
    },


    // Number of ingredients lacked to do a workflow
	NBIngredientManque :function(req,res){

		User.findOne({id:req.session.userID}).exec(function (err,user) {
		    if (err) return res.json({error:'findone error'});
		    ingre=req.param('ingredient').split(',');
		    console.log(user.ingredient.length+' ingredients exist');
		    console.log(ingre.length+' ingredients demande');

		    var diff =[]; // missing ingredient    
		    var a =[]; // for loop container

		    for (var i=0;i < ingre.length; i++)
		    {
		    	a[ingre[i]]= true;
		    }
		    for (var i=0; i<user.ingredient.length; i++ ){
		    	if (a[user.ingredient[i]]) delete a[user.ingredient[i]];
		    }

		   for (var k in a ){
		   	diff.push(k);
		   }

			/*var nb = user.ingredient.length-ingre.length;
			console.log(nb+' ingredients manquant');*/
			console.log('you\'re short of '+diff.length+' ingredient!');
			return res.json({manque:diff}); 
			
		})


		
	}

};

