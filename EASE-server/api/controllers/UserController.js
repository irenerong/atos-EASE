/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	
	signin: function(req, res) {

		User.find({username: req.body.username}).exec(function (err, users)
		{
			if (users.length != 1)
			{
				return res.json({status: "User does not exist"})
			}
			req.session.userID = users.pop().id
			var userID = req.session.userID

			return res.json({status: "connected", userID: userID})
			
		})

	}

};

