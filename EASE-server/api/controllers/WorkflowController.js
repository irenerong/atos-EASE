/**
 * WorkflowController
 *
 * @description :: Server-side logic for managing workflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

	createwf : function(req,res){
// 		ExternalMetaworkflow.findOne({id: 1}).exec(function (err,externalMetaworkflow){
// 		console.log(externalMetaworkflow);
// 		Metaworkflow.create({title: externalMetaworkflow.data.title, metatasks:externalMetaworkflow.data.metatasks,
// 			ingredient: externalMetaworkflow.data.ingredient}).exec(function(err,metaworkflow){
// 		var workflow=WorkflowGeneratorService.generateWorkflows(metaworkflow,15);

// 	})
// })
	Metaworkflow.findOne({id:25}).populate('metatasks').exec(function(err,metaworkflow){
	//console.log(metaworkflow);
		async.waterfall([function(cb){

			//req.session.generatedWorkflows = [{"consumption":100,"metaworkflow":12,"array":[{"subTask":11,"predecessor":[],"beginTime":"2015-02-01T01:15:00.000Z","agentID":1,"duration":20},{"subTask":12,"predecessor":[11],"beginTime":"2015-02-01T01:40:00.000Z","agentID":1,"duration":10},{"subTask":21,"predecessor":[12],"beginTime":"2015-02-01T01:55:00.000Z","agentID":1,"duration":20},{"subTask":31,"predecessor":[12],"beginTime":"2015-02-01T01:55:00.000Z","agentID":4,"duration":20},{"subTask":22,"predecessor":[21],"beginTime":"2015-02-01T02:20:00.000Z","agentID":1,"duration":10},{"subTask":32,"predecessor":[31],"beginTime":"2015-02-01T02:20:00.000Z","agentID":4,"duration":10},{"subTask":41,"predecessor":[22,32],"beginTime":"2015-02-01T02:35:00.000Z","agentID":2,"duration":20},{"subTask":42,"predecessor":[41],"beginTime":"2015-02-01T03:00:00.000Z","agentID":2,"duration":10}],"duration":115}] 
			req.session.generatedWorkflows=WorkflowGeneratorService.generateWorkflows(metaworkflow, 15);
			setTimeout(function(){
			console.log(req.session.generatedWorkflows);
			cb(err,req.session.generatedWorkflows);
			},250);
			
	

		},
		function(workflows,cb){

			//console.log('req.session'+req.session.generatedWorkflows);
			res.json({"workflows":workflows});
			cb();


		}

		],
		
		function (err){
		


		}) ;
	

	})


	}



};

