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
		params = req.params.all();

		if (req.isSocket && req.method === 'POST'){

			console.log("socket received");

			SubTask.findOne(params.SubTaskID).exec(function (err,subtask) {

				console.log(subtask.id);

				SubTask.subscribe(req.socket,subtask,['update']);

				subtask.start();
			})
		}
	},
	test : function(req, res){
		params = req.params.all();
		if (req.method === 'POST'){
			
			SubTask.allSubTasks(params.day);
		}
	}

};
