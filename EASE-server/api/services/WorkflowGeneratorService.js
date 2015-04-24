
// Constructor
function Workflow(metaworkflow) {
  this.metaworkflowID = metaworkflow.id

  //console.log(metaworkflow.metatasks.length+"\n");
  this.tasks = []

  		
  		for (var i = 0; i < metaworkflow.metatasks.length; i++) {

		var task = new Task(this, metaworkflow.metatasks[i])

		//console.log(task)
		this.tasks.push(task) }


}




function Task(workflow, metatask) {
	//this.workflow = workflow
	this.agentTypes = metatask.agentTypes
	this.agentAdaptations = [];
	this.metatask = metatask.id;
	this.id= metatask.idTask;
	this.waitFor=metatask.waitFor;
//	console.log("n "+this.agentTypes+" \n");
}


Task.prototype.getSubtasks = function(cb) {

	var task = this;

	sails.models.agent.find({agentType: task.agentTypes}) //Finding all the agents which might be able to perform this task


    .exec(function (err, agents) { 
    	if (err){console.log(err)}
    	if(agents.length == 0){console.log('non agentType find')};

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

	generateWorkflows: function (metaworkflow, params,fn) {

		var generatedWorkflows = [];
		var agentNondispo = [];
		var flag =0// stop flag

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
			},
			function(cb){
				
				agentNondispo = [];
					sails.models.agent.find().exec(
						function(err,agents){
							agents.forEach(function(e,i,a){
								var periodes=[];
								e.agentNonDispo(function(non){
									non.forEach(function(noni,e2,a2){
										periodes.push({begin:noni.startDate,duration:noni.duration}) 

									})

								})
								var tmp ={}
								tmp = {id:e.id, periodes: periodes}
								//console.log(tmp);
								agentNondispo.push(tmp);
								})
								
								
							})
							

							
						
					// cb(null);

					setTimeout(
								function(){
									//console.log(JSON.stringify(agentNondispo,null,4));
									//console.log(params);

										arrangeTimeNew.init(params,agentNondispo)//finish init
										cb(null);
							},250)
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
	

					for (var i =0; i < workflow.paths.length; i++){

						var oneworkflow=workflow.paths[i];
						var ae=[];
						var num=0;

						for (var j=0; j<workflow.paths[i].length;j++){


							var onetask=workflow.paths[i][j];
							for (var k=0; k< workflow.paths[i][j].subtasks.length; k++){

									var subtask={};
								    subtask.subTask=workflow.paths[i][j].subtasks[k].id

								    subtask.predecessor= workflow.paths[i][j].subtasks[k].waitFor

								    subtask.beginTime= 0
								    subtask.agentID=onetask.agentID
								    subtask.action= workflow.paths[i][j].subtasks[k].action.action
								    //console.log(subtask.action);
								    subtask.consumption=workflow.paths[i][j].subtasks[k].consumption
								    subtask.duration=Math.round(workflow.paths[i][j].subtasks[k].consumption.time)
								    subtask.metatask=workflow.paths[i][j].subtasks[k].metatask;

								    ae.push(subtask);

								}

							}

							//console.log(ae);

							var res2=arrangeTimeNew.reconstitute(ae);

							//console.log(res2);

							var res = arrangeTimeNew.arrange(res2);
								// res.subtasks.forEach(function(e,i,a) {
								//     res.consumption += e.consumption.CO2;
								// }); // add up comsumption of each subtask
							//console.log("total consumption "+res.consumption);
							res.metaworkflow = metaworkflow.id;
							res.title=metaworkflow.title;
							res.color = res.metaworkflow%5;

							generatedWorkflows.push(res);
					}
					
							fn(generatedWorkflows); // call back of controller


					}

		)

	// // console.log(JSON.stringify(generatedWorkflows,null,4));
	// while(flag == 0)
	// 	if(flag == 1)
		  // return generatedWorkflows;
	}
}
















