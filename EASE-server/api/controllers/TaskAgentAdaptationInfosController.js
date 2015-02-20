/**
 * TaskAgentAdaptationInfosController
 *
 * @description :: Server-side logic for managing Taskagentadaptationinfos
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	reset: function (req, res) {
		TaskAgentAdaptationInfos.destroy({}).exec(function (err) {res.status(200), res.json("ok")})
	}
};

