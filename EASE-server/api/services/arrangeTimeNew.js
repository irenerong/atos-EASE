/**
 * Constructor
 */
var Arrangement = function(){
}

// Optional, because all in "services" is available through the project
module.exports = Arrangement;

/** 
 * Initialization with the constraint and timetable of agents(list of periodes not available)
 * @Param constraint Constraint given by the user, containing the temporal constraints of a work flow
 * @Param agentsNonDispo Containing the periodes not avaibles of each agent. See its structure in ArrangeTimeExample.js 
 */
Arrangement.init = function(constraint, agentsNonDispo){
	this.constraint = JSON.parse(JSON.stringify(constraint));
	//console.log(this.constraint.type)
	this.agentsNonDispo = agentsNonDispo;
}

/**
 * This function is called after the decomposition of tasks to subtasks. Attention, as here the information
 * of "predecessors" in a subtask is no longer correct, we need to modify them according
 * to the dependencies between them, more exactly, modify the attribut "predecessors" of subtasks. 
 * If the ID of two subtasks has the same first number, this means that
 * they are to be done by a same agent. But here, all the subtasks coming from one same task 
 * have still the same predecessor as if they are a task,
 * for example, subtask22 and subtask21 have both as predecessor task 1(because before decomposition
 * task2's predecesssor is task1). Attention: here the second number of ID of all subtasks starts from 1, like subtask11,subtask12,subtask21,subtask22,subtask23
 * if the second number of ID is "1", it is surely the first subtask of the corresponding task
 * Here after modifications, we should have for example :
 * subtask 12 should wait the end of subtask 11,  subtask 21 wait subtask 12(last subtask of task1) etc.
 * @Param subtasks2 Subtasks need to deal with
 * @return subtasks Subtasks after modification
 */
Arrangement.reconstitute = function(subtasks2){
	// Copy the subtasks
	var subtasks = JSON.parse(JSON.stringify(subtasks2));
	var max = 0;
	
	// For each subtask
	subtasks.forEach(function(e,i,a){
		//If this subtask has no predecessor
		if(e.predecessor.length == 0){
			// If this is not the first subtask of the task
			if(e.subTask % (10) != 1){  // e.subTask is the ID of this subtask
				e.predecessor.push(e.subTask - 1)  // His predecessor is the last subtask, for example, subtask13's predecessor is subtask12
			}
		}
		else{ // If this subtask has predecessor(s)
			//If this is the first subtask
			if(e.subTask % 10 == 1){ 
				// For each of his predecesssors
				e.predecessor.forEach(function(e3,i3,a3){
					max = 0; // Remember the last subtask of his predecessor
					// Remplace the old predecessor(task) by the new predecessor(last subtask of the task)
					subtasks.forEach(function(e2,i2,a2){
						if(e3 == Math.floor(e2.subTask/10)){
							if(e2.subTask % 10 > max){
								e.predecessor.splice(i3,1, e2.subTask);
								max = e2.subTask % 10;
							}
						}
					});
				});
			}
			else{ // If not the first subtask, just put the last subtask in his list of predecessors
				e.predecessor.length = 0;
				e.predecessor.push(e.subTask - 1);
			}
		}	
	});
	return subtasks;
}

/**
 * This function will arrange time to the subtasks
 * @Param arrangeElements Containing the information of subtasks waiting to be given a start time
 * @Return res See @return in function arrangeTimeNonDispo
 */
Arrangement.arrange = function(arrangeElements){
	var res = {};
	var margin = 15; // A default margin(in advance or a delay according to the "type", unit minute)
	var marginBetweenTasks = 5; // Default margin between sub tasks
	var compatible = false;
	var coef1 = 0; // 0 if "at", -1 if "before" and 1 if "after" according to the constraints
	var coef2 = 0; // 0 if "Begin", 1 if "Finish" according to the constraints
	var length = arrangeElements.length;
	var comflit = [];
	//var be;
	var message = "";
	var sortedTasks;
	
	//By default, coef2 = 0
	if(this.constraint.type == 1) // If "Finish"
		coef2 = 1;

	//By default, coef1 = 0
	if(this.constraint.option == 0)// if "Before"
		coef1 = -1;
	else
		if(this.constraint.option == 1)// If "After"
			coef1 = 1;


	// Sorts the subtasks  See function sortTasks
	sortedTasks = sortTasks(arrangeElements); 
	
	// Gets workflow's duration with margins between the tasks(we suppose to have the maximum of margins)
	wfDuration = getDuration(sortedTasks) + (length - 1) * marginBetweenTasks;
	
	// Begin time of work flow 
	var dateString = this.constraint.time;
	//console.log(dateString);
	var beginWF = new Date(dateString);
	// var beginWF = new Date(this.constraint.time);
	//console.log("beginWF "+beginWF);
	// Sets minutes of the begin time according to the constraints
	beginWF.setMinutes(beginWF.getMinutes() - coef2 * wfDuration + coef1 * margin);
	
	// Arrange time
	res = arrangeTimeNonDispo(sortedTasks, beginWF, this.agentsNonDispo)

	res.consumption = getConsumption(sortedTasks);

	
	// If every subtasks receives a begin time. See @return of function arrangeTimeNonDispo

	if(res.subtasks.length == length){
		return res;
	}
	else{
		// TODO:
		// copy.forEach(function(e,i,a){
		// 	if(res.indexOf(e.subTask) == -1)
		// 		comflit.push(e.subTask);
			
		// });
		// if(comflit.length == 1)
		// 	be = "is";
		// else{
		// 	be = "are";
		// }
		// message += "comflit: sub-task ";
		// comflit.forEach(function(e,i,a){
		// 	console.log(e)
		// 	message += e
		// 	if(i != comflit.length-1)
		// 		message += ", "
		// })
		// message += " " + be + " not available"
			// return message;
		return "comflit";
	}
	
};


function getConsumption(arrangeElements){
	var arrangeElements2 = JSON.parse(JSON.stringify(arrangeElements));
	var total=0;
	arrangeElements2.forEach(function(e,i,a){
		if (e.consumption.CO2!=null){
				total+=e.consumption.CO2;

		}else{
				total+=e.consumption.WATER;

		}
	
	})
	return total;

}


/**
 * Gets the duration of the work flow

 */




function getDuration(arrangeElements){
	var arrangeElements2 = JSON.parse(JSON.stringify(arrangeElements));
	var tmpTime;
	var finishTime = [];
	var max = 0;
	arrangeElements2.forEach(function(e,i,a){
		if(e.predecessor.length == 0){
			e.beginTime = 0;
		}
		else{
			finishTime.length = 0;
			getPreds(e, arrangeElements2).forEach(function(e3,i3,a3){
				finishTime.push(e3.beginTime + e3.duration);
			});
			// console.log("finishTime " + finishTime)
			nextBegin = Math.max.apply(null,finishTime);
			e.beginTime = nextBegin;
		}
		if(e.beginTime + e.duration > max){
			max = e.beginTime + e.duration;
		}
	});
	return max;
}


//Test
function salut(){
	console.log("salut")
}

/**
 * Arrange times
 * @Param arrangeElements Containing information of subtasks
 * @Param time Begin time of the work flow
 * @Param agentsNonDispo Periodes not available of all agents. More information of its structure, see arrangeTimeExample.js
 */ 
function arrangeTimeNonDispo(arrangeElements, time, agentsNonDispo){
	// Copy the arrange elements
	var arrangeElements2 = JSON.parse(JSON.stringify(arrangeElements));
	var decision = {}; decision.subtasks = []; decision.duration = 0;
	var agentTimeTable;
	var possibleTime = []; // Possible begin times (for now, we use only the first one)
	var finishTime = []; // Finish time of predecessors
	var tmpFinish;
	var nextBegin;
	var defaultMargin = 5; // Margin 5min between the tasks
	var tmpTime;
	var e;
	var count;
	var beginWF = 0;
	var endWF = 0;
	
	// For each arrangeElements
	for (var i = 0; i <= arrangeElements2.length - 1; i++) {
		e = arrangeElements2[i];
		
		// Finds the agent doing this task and gets his time table
		agentTimeTable = agentsNonDispo.filter(function(e1,i1,a1){if(e1.id == e.agentID) return true; return false;})[0]; 
		
		possibleTime = []; // Possible begin times 
		finishTime = []; // Finish time of predecessors		
		if(e.predecessor.length == 0){
			count = 0;
			// tmpFinish is the finish time of this subtask
			tmpFinish = new Date(time);
			tmpFinish.setMinutes(tmpFinish.getMinutes() + e.duration);
			// For all the periodes not available for a given agent
			agentTimeTable.periodes.forEach(function(e2,i2,a2){
				tmpTime = new Date(e2.begin);
				tmpTime.setMinutes(tmpTime.getMinutes()+e2.duration)	
				if(tmpFinish < e2.begin || time > tmpTime)
					count++;
			});
			// If this subtask is compatible with all other subtasks waiting to be done by this agent
			if(count == agentTimeTable.periodes.length){
				// It could start at time "time"
				e.beginTime = time;
				possibleTime.push(time);
				
				//Updates the earliest begin time of the work flow in order to calculate the duration of the work flow
				if(beginWF == 0){
					beginWF = e.beginTime;
				}
				else{
					if(e.beginTime < beginWF)
						beginWF = e.beginTime;
				}
			}
			else{
				break;
			}
		}
		else{
			// Nearly the same thing to those in "if", but for the subtasks who have predecessors,
			// we should calculate the latest finish time of his predecessors as his begin time
			count = 0;
			finishTime.length = 0;
			// For each predecessor
			getPreds(e, arrangeElements2).forEach(function(e3,i3,a3){ 
				tmpTime = new Date(e3.beginTime);
				tmpTime.setMinutes(tmpTime.getMinutes() + e3.duration);
				finishTime.push(tmpTime);
			});
			// Gets the latest finish time
			tmpFinish = new Date(Math.max.apply(null,finishTime));
			tmpFinish.setMinutes(tmpFinish.getMinutes()+ defaultMargin);
			nextBegin = tmpFinish;
			tmpFinish = new Date(nextBegin)
			tmpFinish.setMinutes(tmpFinish.getMinutes() + e.duration);
			agentTimeTable.periodes.forEach(function(e4,i4,a4){
				tmpTime = new Date(e4.begin);
				tmpTime.setMinutes(tmpTime.getMinutes()+e4.duration)
				if(tmpFinish < e4.begin || nextBegin > tmpTime)
					count ++;
			});
			if(count == agentTimeTable.periodes.length){
				e.beginTime = nextBegin;
				possibleTime.push(nextBegin);
				if(endWF == 0){
					endWF = tmpFinish;
				}
				else{
					if(endWF < tmpFinish){
						endWF = tmpFinish;
					}
				}
			}
			else{
				// console.log(e.subTask + " not possible "+ count+" time :" + nextBegin)
				break;
			}
		}
		if(possibleTime.length > 0){
			decision.subtasks.push(e);
		}		
		else{
			break;
		}
	}
	decision.duration = Math.round((endWF - beginWF)/60000); // minutes

	return decision;
};

/**
 * This function sorts the subtasks in order that when we go through the list to arrange time, we are sure of having 
 * finished all his predecessors before traiting a subtask.
 */
function sortTasks(arrangeElements){
	var length = arrangeElements.length;
	var res = [];
	var predsDone = true;
	var preds = [];
	
	// For each iteration, we go through the rest terms in arrangeElements to check if some of them could be added in to "res"
	while(res.length != length){
		arrangeElements.forEach(function(e,i,a){
			predsDone = true;
			if(getPreds(e, arrangeElements).length == 0){
				res.push(e); // Push it into the final subtasks
				arrangeElements.splice(arrangeElements.indexOf(e),1); // Remove this element from arrangeElements
			}
			else{
				preds = getPreds(e, arrangeElements);
				for (var i = preds.length - 1; i >= 0; i--) {
					if(preds[i].beginTime == 0){
						predsDone = false;
						break;
					}
				};
				if(predsDone){
					res.push(e);
					arrangeElements.splice(arrangeElements.indexOf(e),1);
				}

			}			
		});
	}
	return res;
}; 

/**
 * Gets the predecessors of a subtask
 * @Param subTask The current subtask
 * @Param arrangeElements Containing all the subtasks
 */
function getPreds(subTask, arrangeElements){
	var preds = new Array();
	for (var i = arrangeElements.length - 1; i >= 0; i--) {
		if(subTask.predecessor.indexOf(arrangeElements[i].subTask) != -1)
			preds.push(arrangeElements[i]);
	}
	return preds;
};


var ReturnElement = function(subTask, beginTime){
	this.subTask = subTask;
	this.beginTime = beginTime;
};
