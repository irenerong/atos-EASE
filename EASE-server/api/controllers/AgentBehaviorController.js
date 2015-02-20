/**
 * AgentBehaviorController
 *
 * @description :: Server-side logic for managing Agentbehaviors
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	callBehavior : function (req, res) {

		var behaviorId = req.body.id;


		AgentBehavior.findOne(behaviorId)
		.exec(function (err, agentBehavior) {
			res.status(200)

			//var sandboxedModule = require('sandboxed-module')
			//var behaviorModule = sandboxedModule.require('oven', {globals: {}})
			var behaviorModule = agentBehavior.module();
			res.json(behaviorModule.subtasks())



		})


	}
};

