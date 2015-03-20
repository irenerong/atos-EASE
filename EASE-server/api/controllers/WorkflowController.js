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
Metaworkflow.findOne({id:12}).populate('metatasks').exec(function(err,metaworkflow){
	console.log(metaworkflow);
	var workflow=WorkflowGeneratorService.generateWorkflows(metaworkflow,15);

})
return 0;
	}



};

