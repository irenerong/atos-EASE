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

					res.status(200)
					res.json({count: workflows.length, start: start, end: end, workflows: workflows.slice(start, end)})
				}

			}
			)

	

	}

};

