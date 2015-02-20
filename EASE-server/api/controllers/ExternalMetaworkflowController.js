/**
 * ExternalMetaworkflowController
 *
 * @description :: Server-side logic for managing Externalmetaworkflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	reset: function (req, res) {

		ExternalMetaworkflow.destroy({})
		.exec(function (err) {
			res.status(200)
			res.json('ok')
		})
	}
};

