/**
 * SubTaskController
 *
 * @description :: Server-side logic for managing Subtasks
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



module.exports = {
	reset: function (req, res) {
		SubTask.destroy({}).exec(function (err) {res.status(200), res.json("ok")})
	},
	start : function (req, res) {
		var params = req.params.all();
		req.session.userSocket = req.socket;
		if (req.isSocket && req.method == 'POST'){

			console.log("socket received");
				
				SubTask.update({id:params.id},{status:'start'}).exec(function(err,updateds){
				if (err){console.log(err)};

				console.log(updateds[0].id +' is start to be executed'+updateds[0].status);
				SubTask.publishUpdate(updateds[0].id,{status:updateds[0].status})
				// sails.sockets.emit(sails.sockets.id(req.socket),'message',{msg:'working fine with emit'});

				//SubTask.subscribe(req.session.socket,subtask,['update']);
				//no need to subcribe socket because, when the subtask was create, socket has already been subscribed to it  

				updateds[0].start(function(connected){if (!connected){sails.sockets.emit(sails.sockets.id(req.socket), 'notConnected',{subTaskID:this.id})}});
				})
		}
	},
	getSubtasksAtDay : function(req, res){
		params = req.params.all();
		if (req.method === 'POST'){
			
			SubTask.allSubTasks(params.day,function(r){
				res.json(r);
			});
		}
	},
	finish : function(req, res){
		params = req.params.all();
		// console.log(params.subTask)

		SubTask.findOne({id:params.subTask}).exec(function(err, subtask){
			subtask.finish();
		})
	},
	reconnectSocket : function(req,res){

		if (req.isSocket){
			SubTask.find({status:{'!':'finish'}}).exec(
				function(err, subtasks){
					if (err) console.log(err);
					else{SubTask.subscribe(req,subtasks);}
					
				}
				)
		}

	}

};
