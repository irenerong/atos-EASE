/**
 * WorkflowGeneratorTicketController
 *
 * @description :: Server-side logic for managing Workflowgeneratortickets
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	


	/*THIS FUNCTION GETS ALL THE WORKFLOW ADAPTATION COMBINATION*/
	getGeneratedWorkflows: function (req, res) {

		/*GETTING PARAMS*/
		var params = req.params.all()

		var betterWF=[];

		var start = 0, end = 9
		var sortBy = 'title'
		var sortOption = 1


		if (params.page && params.pageSize)
		{
			start = params.page*params.pageSize
			end = start+ 1*params.pageSize
		}
		else if (params.start && params.end) {
			start = params.start
			end = params.end
		}
		if (params.sortBy) {
			sortBy = params.sortBy
		}
		if (params.sortOption) {
			sortOption = params.sortOption
		}




		var workflows = []

		console.time('Fetching Workflows')


		async.waterfall([
				function (cb) {

					WorkflowGeneratorTicket.findOne(params.ticketID) //Getting ticket
					.populate('workflows')
					.exec(function (err, ticket) {cb(err, ticket)})

				}, 

				function (ticket, cb) {

					if (!ticket)
						return cb("Ce ticket n'existe pas")

					if (ticket.user != req.session.userID) 
						return cb("Ce n'est pas votre ticket")


					async.each(ticket.workflows, 
						function (workflow, cb2) {
							console.log('Getting subworkflows')



							/*GETTING COMBINATIONS OF WORKFLOWS*/

							workflow.getSubWorkflows(function (err, subworkflows) {
								workflows = subworkflows.concat(workflows) //Add subworkflows to workflows
								cb2(err)

							})

						}, 
						function (err) {
							cb(err)
						})



				}


			], 

			function (err) {
				if (err) {
					res.forbidden(err)
				}
				else
				{	
					//SORT FUNCTION
					var sortFunction = null

					if (sortBy == 'title') {
						sortFunction = function(a, b) {

							var order = sortOption

							if (a.title < b.title)
								return  -1*order
							if (a.title > b.title)
								return  1*order

							return 0
	
						}
					}
					else {

						sortFunction = function(a, b) {

							var order = sortOption

							if (a.consumption[sortBy] < b.consumption[sortBy])
								return  -1*order
							if (a.consumption[sortBy] > b.consumption[sortBy])
								return  1*order

							return 0
	
						}

					}

					workflows.sort(sortFunction)
					console.timeEnd('Fetching Workflows')
					console.log('Il y a ' + workflows.length + ' workflows')

					betterWF = workflows.slice(start, end);

					async.waterfall([
					function (cb) {

						WorkflowGeneratorTicket.findOne(params.ticketID)
						.exec(function (err, ticket) {cb(err, ticket)})

					}, 
					function (ticket, cb) {
						User.findOne(ticket.user).exec(function(err,user){
						var userIngre=user.ingredient;
						console.log('afficher: '+userIngre);
						cb(null,userIngre);
						})
						
					},
					function (userIngre,cb){

						for (var j=0; j<betterWF.length ;j++){
							//console.log('sort with difference of ingredient');
							ingre=betterWF[j].ingredient;

						    var diff =[]; // missing ingredient    
						    var a =[]; // for loop container

						    for (var i=0;i < ingre.length; i++)
						    {
						    	a[ingre[i]]= true;
						    }
						    for (var i=0; i<userIngre.length; i++ ){
						    	if (a[userIngre[i]]) delete a[userIngre[i]];
						    }

						   for (var k in a ){
						   	diff.push(k);
						   }
						   //filter of missing ingredient
						   betterWF[j].ingredient=diff;
						   console.log(betterWF[j].ingredient)

						}

						cb(null,betterWF);

					}],

					function (err,betterWF){

						sortFunc = function(a, b) {

							var order = sortOption

							if (a.ingredient.length < b.ingredient.length )
								return  -1*order
							if (a.ingredient.length  > b.ingredient.length )
								return  1*order

							return 0
	
						}

						betterWF.sort(sortFunc);
						res.status(200)
						res.json({betterWF: betterWF});

					}
					)




					

					//res.json({count: workflows.length, start: start, end: end, workflows: workflows.slice(start, end)})
				}

			}
			)

	

	}

};

