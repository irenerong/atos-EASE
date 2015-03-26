
// Constructor
function Workflow(metaworkflow) {
  this.metaworkflowID = metaworkflow.id

  //console.log(metaworkflow.metatasks.length+"\n");
  this.tasks = []
  //var tmp = [];
   // sails.models.metaworkflow.findOne({id:metaworkflow.id}).populate('metatasks').exec(
  // 	function(err,metaworkflow){
  // 		console.log(metaworkflow.metatasks.length)
  		
  // 		for (var i = 0; i < metaworkflow.metatasks.length; i++) {

		// var task = new Task(oldthis, metaworkflow.metatasks[i])

		// //console.log(task)
		// tmp.push(task)

  // };



  // 	})
  		//console.log(metaworkflow.metatasks.length)
  		
  		for (var i = 0; i < metaworkflow.metatasks.length; i++) {

		var task = new Task(this, metaworkflow.metatasks[i])

		//console.log(task)
		this.tasks.push(task) }


}




function Task(workflow, metatask) {
	//this.workflow = workflow
	this.agentTypes = metatask.agentTypes
	this.agentAdaptations = [];
	this.metatask = metatask;
	this.id= metatask.idTask;
	this.waitFor=metatask.waitFor;
//	console.log("n "+this.agentTypes+" \n");
}


Task.prototype.getSubtasks = function(cb) {

	var task = this;

	sails.models.agent.find({agentType: task.agentTypes}) //Finding all the agents which might be able to perform this task


    .exec(function (err, agents) { 

    	async.map(agents, function (agent, cb2)
    	{
    		var agentAdaptation = {agentID: agent.id}
    		agent.subTasksForTask(task, function(err, subtasks)
    		{
    			agentAdaptation.subtasks = subtasks;
    			cb2(err, agentAdaptation)
    		}

    		)

    	}, 

    	function (err, agentAdaptations) 
    	{
    		task.agentAdaptations = agentAdaptations;
    	//	console.log("Agent adaptations : " + JSON.stringify(agentAdaptations, null, 4));
    		cb(err) 

    	}

    	)

    })

}


function SubTask() {

}


module.exports = {

	workflow : Workflow,
	task: Task,


	generateWorkflows: function (metaworkflow, params) {

		sails.session.generatedWorkflows = sails.session.generatedWorkflows || []

		async.waterfall(
			[function (cb){
				workflow = new Workflow(metaworkflow);
				 cb (null,workflow);
			}
			,
			function (workflow,cb)
			{	
				//console.log(workflow);
// until here, task undefined
				async.each(workflow.tasks, 

					function (task, cb2)
					{	
						//console.log(task);
						task.getSubtasks(function (err) {cb2(err)})
					}, 

					function (err)
					{
						cb(err)
					}

				)
			}



			], 

			function (err) {
					
					//console.log('Workflow : \n ' + JSON.stringify(workflow, null, 4))

					var agentAdaptations = [];

					for (var i = 0; i < workflow.tasks.length; i++)
					{
						var task = workflow.tasks[i];
						//console.log('Task : \n' + JSON.stringify(task, null, 4));
						agentAdaptations.push(task.agentAdaptations);
					}

					workflow.paths = paths = MathService.cartesianProduct(agentAdaptations);
					console.log('Cartesian : \n' + JSON.stringify(workflow.paths, null, 4));

					arrangeTimeNew.init({ _type: 0,
										  _option: 1,
										  _time: new Date("Sun Feb 01 2015 2:00:00 GMT+0100 (CET)") 
										},

										[ 
										 { 
										  _id: 0,
										  _periodes: 
										   [ 
										   	 { _duration: 15,
										       _begin: new Date("Sun Feb 01 2015 01:40:00 GMT+0100 (CET)")},
										     { _duration: 30,
										       _begin: new Date("Mon Feb 01 2015 04:00:00 GMT+0100 (CET)")}
										   ]
										 },

										 {
										  _id: 1,
										  _periodes: 
										   [ { _duration: 60,
										       _begin: new Date("Sun Feb 01 2015 03:40:00 GMT+0100 (CET)")}
										   ]
										 },
										 {
										  _id: 2,
										  _periodes: 
										   [ { _duration: 20,
										       _begin: new Date("Sun Feb 01 2015 04:40:00 GMT+0100 (CET)")}
										   ]
										 },
										 {
										  _id: 3,
										  _periodes: 
										   [ { _duration: 10,
										       _begin: new Date("Sun Feb 01 2015 05:20:00 GMT+0100 (CET)")}
										   ]
										 },
										 {
										  _id: 4,
										  _periodes: 
										   [ { _duration: 19,
										       _begin: new Date("Sun Feb 01 2015 06:00:00 GMT+0100 (CET)")  } 
										   ] 
										 }
										])

					for (var i =0; i < workflow.paths.length; i++){

						var oneworkflow=workflow.paths[i];
						var ae=[];
						var num=0;

						for (var j=0; j<workflow.paths[i].length;j++){


							var onetask=workflow.paths[i][j];
							for (var k=0; k< workflow.paths[i][j].subtasks.length; k++){

									var subtask={};
								    subtask._subTask=workflow.paths[i][j].subtasks[k].id

								    subtask._predecessor= workflow.paths[i][j].subtasks[k].waitFor

								    subtask._beginTime= 0
								    subtask._agentID=onetask.agentID
								    subtask._duration=Math.round(workflow.paths[i][j].subtasks[k].consumption.time);

								    ae.push(subtask);

								}

							}

							console.log(ae);

							var res2=arrangeTimeNew.whatTheFuck(ae);

							console.log(res2);

							var res = arrangeTimeNew.arrange(res2);

							console.log(res);
					}



					}

				

				

		)

	


	}
}
















