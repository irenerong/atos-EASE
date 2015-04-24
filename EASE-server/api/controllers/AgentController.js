/**
 * AgentController
 *
 * @description :: Server-side logic for managing agents
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
// launch is controlled by user side, when user start a task 'preheat the oven', 
//then the agent 'oven' will call his function Launch
// this methode is communicate by socket
	// launch : function(req, res){
				
	// 	var	socketId = sails.sockets.id(req.socket);
	
	// 	var param = req.params.all()
	// 	SubTask.findOne({id:param.subTask}).exec(function(err, subTask){
	// 		Agent.findOne(param.agentID).exec(function(err, agent){
				
	//       		// agent.subTaskInProgress = param.subTask;
	//       		agent.timeLeft = subTask.duration;
	      	
	// 	})	
		
	// 	res.json({
 //     		 message: 'TimeLeft sent!'
 //   		});
	// })
	// },
	// NonDispo : function(req,res){
	// 	var params =req.params.all();
	// 	var id= params.id;
	// 	var nondispo=[];
	// 	Agent.findOne(id).exec(function(err,agent){
	// 		if (err) console.log(err)
	// 			else {
	// 				agent.agentNonDispo(function(non){nondispo=non,res.json({'nondispo':nondispo})});
	// 			}
			

	// 	})

	// }, just for test with postman

	// launch : function(req, res){
	// 	var	socketId = sails.sockets.id(req.socket);  // Gets socketID

	// 	var param = req.params.all()// Gets all the parameters in the socket

	// 	// SubTask.findOne(param.subTask).exec(function(err, subTask){
	// 	// 	Agent.findOne(param.agentID).exec(function(err, agent){
	//  //      		// console.log("agentID "+ agent.id)
	//  //      		agent.subTaskInProgress = param.subTask;
	//  //      		agent.timeLeft = subTask.duration;
	//  //      		// console.log("subtask" + param.subTask + " launched, subTask duration is "+ subTask.duration);
	//  //      		// sails.sockets.emit(socketId, 'rest', {timeLeft:subTask.duration});
 //  //     		})
	// 	// })	
		
	// 	res.json({
 //     		 message: 'TimeLeft sent!'
 //   		});

	// },
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

