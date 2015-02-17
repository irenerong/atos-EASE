/**
 * WorkflowController
 *
 * @description :: Server-side logic for managing workflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	
	hi: function(req, res) {

		var params = req.params.all();
		Workflow.create(params, function(err, sleep) {

            if (err) return next(err);

            res.status(201);

            res.json(sleep);

        });


	},

	plop: function(res) {
		res.json({status: "ok"})
	}

};

