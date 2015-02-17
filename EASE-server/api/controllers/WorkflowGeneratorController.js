/**
 * WorkflowGeneratorController
 *
 * @description :: Server-side logic for managing Workflowgenerators
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */


module.exports = {
	
	


	generate: function(req, res) {

		var WFC = this
		var userID = req.session.userID
		console.log('User ID : '+ userID + '- BEGIN WORKFLOW GENERATION')
		var params = req.params.all()

		WorkflowGeneratorTicket.destroy({}) //Destroy previous tickets
		.exec( function (err)
		{
		
			console.log('Create new ticket')

			 WorkflowGeneratorTicket.create({user: userID}).exec(function (err, ticket) { //Create new ticket
				console.log('Ticket created')

				//Get and save Metaworkflows
				WFC.getMetaworkflows(ticket.id, params, function () { 
					
					WFC.adaptMetaworkflows(ticket.id, params)

					res.status(200)
					res.json('ok')
				}) 

			})		
		})
	}, 

	getMetaworkflows : function (ticketID, params, cb) {
		var async = require('async')
		var WFC = this

		 ExternalMetaworkflow.find({intent: params.intent}).exec( function(err, metaworkflows) { //Get metaworkflows from ExternalMetalworkflow database



		 	async.each(metaworkflows, function (metaworkflow, cb2) { //For each Metaworkflow

		 		WFC.importMetaworkflowFromOutside(ticketID, metaworkflow.data ,function () {cb2()}) //Import this metaworkflow in the db
		 		
		 	}, function(err) {	
		 		console.log('End of metaworkflows importation')
		 		cb()

		 	})
		})
	},

	 importMetaworkflowFromOutside: function (ticketID, metaworkflow, cb) {
      var async = require('async')
      var WFC = this


      //Create the metaworkflow and link it to the ticket
      Metaworkflow.create({title: metaworkflow.title, ticket: ticketID}).exec(function (err, metaworkflowCreated) {


        async.each(metaworkflow.metatasks, //For each metatask in the metaworkflow
          function (metatask, cb2) {
            WFC.importMetataskFromOutside(metaworkflowCreated.id, metatask,function () {cb2()}) //Create this metatask and link it to the metaworkflow

        }, 
        function (err) {
        } )
        	console.log('	Metaworkflow Imported !')
        	cb()

        })

      

      
    },

    importMetataskFromOutside: function (metaworkflowID, metatask, cb) {
      
      Metatask.create({idTask: metatask.idTask, metaworkflow: metaworkflowID})
      .exec(function(err, task) {
     	cb() 
     	})  //Create the metatask and link it to the metaworkflow
    }, 


	firstMetaworkflowFilter : function (params)
	{

	},


	adaptMetaworkflows : function (ticketID, params) {
		Metaworkflow.find({ticketID: ticketID})
		.exec(function (err, metaworkflows) {

			
		})

	},

	adaptMetaworkflowsToAgents : function (params, metaworkflows)
	{

		console.log('Adapt to agents');

	},

	adaptMetaworkflowsToTime : function (params, metaworkflows)
	{
		console.log('Adapt to time');
	}

	
};

