/**
 * AgentController
 *
 * @description :: Server-side logic for managing agents
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

	launch : function(req, res){
		// if (req.isSocket && req.method === 'POST'){			
		var	socketId = sails.sockets.id(req.socket);
		// }
		// console.log("socketID "+socketId);
		var param = req.params.all()
		SubTask.findOne(param.subTask).exec(function(err, subTask){
			Agent.findOne(param.agentID).exec(function(err, agent){
	      		// console.log("agentID "+ agent.id)
	      		agent.subTaskInProgress = param.subTask;
	      		agent.timeLeft = subTask.duration;
	      		// console.log("subtask" + param.subTask + " launched, subTask duration is "+ subTask.duration);
	      		// sails.sockets.emit(socketId, 'rest', {timeLeft:subTask.duration});
      		})
		})	
		
		res.json({
     		 message: 'TimeLeft sent!'
   		});

	},
	joinRoom: function (req, res){
		var param = req.params.all()
		sails.sockets.join(req.socket, param.agentID)
	},
	taskDone : function(req, res){
		var param = req.params.all();
		// if(req.isSocket && req.methode === 'POST')
			console.log("Subtask "+ param.subTask +" is done on agent "+ param.agentID)
	}
};

