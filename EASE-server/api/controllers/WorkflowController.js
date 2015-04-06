/**
 * WorkflowController
 *
 * @description :: Server-side logic for managing workflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

	createwf : function(req,res){
		WFC=this;
		params= req.body;
		var sortFunction = null
	if (req.session.lastsearch == params.intent){
		console.log("this is a sort by"+req.session.lastsearch);
		sortFunction = this.sort(params.sortBy);
		req.session.generatedWorkflows.sort(sortFunction) ;
		// if the the user just wants to do a workflow sort

		res.json({"workflows":req.session.generatedWorkflows}) // with pagination

	}else{
		// generate new workflows
		console.log("generating workflows")
		req.session.generatedWorkflows=[];
		req.session.lastsearch = params.intent;
		Metaworkflow.find({intent:params.intent}).populate('metatasks').exec(function(err,metaworkflows){

			//console.log(metaworkflow);

				async.waterfall([function(cb){

					async.each(metaworkflows,
						function(metaworkflow,cb2)
						{WorkflowGeneratorService.generateWorkflows(metaworkflow, 15, 
							function(generatedWorkflows)
							{req.session.generatedWorkflows=req.session.generatedWorkflows.concat(generatedWorkflows);cb2(null);})},
						function(err){
							//console.log("all generatedWorkflows \n"+JSON.stringify(req.session.generatedWorkflows) )
							//sort all generated workflows by params.sort

							sortFunction = WFC.sort(params.sortBy);
							req.session.generatedWorkflows.sort(sortFunction) ;
							cb(null);
						});// fin async each
					
					// WorkflowGeneratorService.generateWorkflows(metaworkflows[0], 15, 
					// 		function(generatedWorkflows)
					// 		{ console.log(metaworkflows[0]);
					// 		req.session.generatedWorkflows=req.session.generatedWorkflows.concat(generatedWorkflows);
					// 		sortFunction = WFC.sort(params.sortBy);
					//  		req.session.generatedWorkflows.sort(sortFunction) ;
					//  		cb(null);})



					
					
					
					
			

				}// first cb of waterfall

				],
				
				function (err){
					//console.log('req.session'+req.session.generatedWorkflows);
					res.json({"workflows":req.session.generatedWorkflows});
				


				}) ;
			

			})
	}
	
	


	},
sort :function(sortBy){

					if (sortBy == 'title') {



					return sortFunction = function(a, b) {

							var order = 1
							//console.log("a "+a.metaworkflow+" b "+b.metaworkflow)

							if (a.metaworkflow < b.metaworkflow)
								return  -1*order
							if (a.metaworkflow > b.metaworkflow)
								return  1*order

							return 0
	
						}
					}
					else {

					return sortFunction = function(a, b) {

							var order = 1
							if (sortBy == 'consumption'){
								if (a.consumption < b.consumption)
								return  -1*order
								if (a.consumption > b.consumption)
								return  1*order

							return 0

							}else{
								if (a.duration < b.duration)
								return  -1*order
								if (a.duration > b.duration)
								return  1*order

							return 0

							}
							

							
	
						}

					}

}



};

