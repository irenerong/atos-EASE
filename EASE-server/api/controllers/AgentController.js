/**
 * AgentController
 *
 * @description :: Server-side logic for managing agents
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

	// See sails documentation: sails.sockets.join
	joinRoom: function (req, res){
		var param = req.params.all()
		sails.sockets.join(req.socket, param.agentName)
	},
	
	taskDone : function(req, res){
		var param = req.params.all();

			console.log("Subtask "+ param.subTask +" is done on agent "+ param.agentID)
	},

// currentStatus return the minutes left for one task, and each time when the left time decrease ,oven will send msg to 
// the server, and server will also communicate left time with user side application 
	currentStatus : function(req, res){
		var param = req.params.all();
		console.log('in current status '+param.timeLeft);
		SubTask.update({id:param.subTask},{timeLeft:param.timeLeft}).exec(function (err,updateds){
				if (err){console.log(err)};
				//console.log('current status update')

						SubTask.publishUpdate(updateds[0].id,{timeLeft:updateds[0].timeLeft});
				
				})


	}
};

