/**
 * SubTaskController
 *
 * @description :: Server-side logic for managing Subtasks
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	reset: function (req, res) {
		SubTask.destroy({}).exec(function (err) {res.status(200), res.json("ok")})
	}
};

