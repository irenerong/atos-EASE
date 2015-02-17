/**
 * MetaworkflowController
 *
 * @description :: Server-side logic for managing Metaworkflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	reset: function (req, res) {
		Metaworkflow.destroy({}).exec(function  (err) {
			res.status(200)
			res.json('ok')
		})

	}
};

