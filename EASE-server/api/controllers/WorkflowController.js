/**
 * WorkflowController
 *
 * @description :: Server-side logic for managing workflows
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	// Create a workflow
	createwf : function(req,res){
		WFC=this;
		var params= req.body;
		var timeConstraint={}
			timeConstraint.type =req.body.type;
			timeConstraint.option=req.body.option;
			timeConstraint.time=req.body.time;
		var sortFunction = null
		var sortBy = 'consumption'
	
		// generate new workflows
		console.log("generating workflows")
		req.session.generatedWorkflows=[];
		req.session.lastsearch = params.intent;

		// Finds the right workflow
		Metaworkflow.find({intent:params.intent,title:{'like':'%'+params.title+'%'}}).populate('metatasks').exec(function(err,metaworkflows){
			if (err) {console.log(err)}

			console.log(metaworkflows);

				async.waterfall([function(cb){

					async.each(metaworkflows,
						function(metaworkflow,cb2)
						{WorkflowGeneratorService.generateWorkflows(metaworkflow,timeConstraint, 
							function(generatedWorkflows)
							{req.session.generatedWorkflows=req.session.generatedWorkflows.concat(generatedWorkflows);cb2(null);})},
						function(err){
							//console.log("all generatedWorkflows \n"+JSON.stringify(req.session.generatedWorkflows) )
							//sort all generated workflows by params.sort

							if (params.sortBy) sortBy=params.sortBy;

							sortFunction = WFC.sort(sortBy);
							req.session.generatedWorkflows.sort(sortFunction) ;
							cb(null);
						});// fin async each
					

				}// first cb of waterfall

				],
				
				function (err){
					//console.log('req.session'+req.session.generatedWorkflows);
					res.json({"workflows":req.session.generatedWorkflows});
				


				}) ;
			

			})
	},
	// Sort the workflows according to a rule
	sortwf : function(req, res){
		var params= req.body;

		if (req.session.lastsearch != null && req.session.generatedWorkflows!=null){
				console.log("this is a sort by"+req.session.lastsearch);
				sortFunction = this.sort(params.sortBy);
				req.session.generatedWorkflows.sort(sortFunction) ;
				// if the the user just wants to do a workflow sort

				res.json({"workflows":req.session.generatedWorkflows}) // with pagination

		}
		else{
			res.json({error: 'there is not qualified workflow to sort'});
		}

	},
	// Sort the workflows
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

	},
	getPendingTask: function(req,res){
		SubTask.find({status:'pending'}).exec(
			function (err,pendings){
				if(err){
					res.json({error: 'probleme with Getpending'})
				}
				res.json({pending:pendings});

			})

	},
	getWorkingTask: function(req,res){
		SubTask.find({status:'start'}).exec(
			function (err,workings){
				if(err){
					res.json({error: 'probleme with getworking'})
				}
				res.json({working:workings});

			})

	},
	getPendingAndWorkingTasks: function(req,res){
		SubTask.find({ or : [
    { status: 'start' },
    { status: 'pending' }
  ]
}).exec(
			function (err,t){
				if(err){
					res.json({error: 'probleme with getpendingandworking'})
				}
				res.json({tasks:t});

			})

	}





};

