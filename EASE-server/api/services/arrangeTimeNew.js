var Arrangement = function(){
}
module.exports = Arrangement;
//Initialization with the constraint and timetable of agents
Arrangement.init = function(constraint, agentsNonDispo){
	this.constraint = constraint;
	this.agentsNonDispo = agentsNonDispo;
}
Arrangement.whatTheFuck = function(subtasks2){

	//console.log(subtasks);
	var subtasks = JSON.parse(JSON.stringify(subtasks2));


	var res = [];
	var tmp;
	var max = 0;
	// var nbBytes = 0;
	subtasks.forEach(function(e,i,a){
		// nbBytes = 0;
		// while(e.subTask/10 > 0){
		// 	nbBytes ++;
		// }
		if(e.predecessor.length == 0){
			if(e.subTask % (10) != 1){
				e.predecessor.push(e.subTask - 1)
			}
		}
		else{
			if(e.subTask % 10 == 1){

				e.predecessor.forEach(function(e3,i3,a3){
					max = 0;
					subtasks.forEach(function(e2,i2,a2){
						if(e3 == Math.floor(e2.subTask/10)){
							if(e2.subTask % 10 > max){
								// tmp = e2.subTask;
								e.predecessor.splice(i3,1, e2.subTask);

								max = e2.subTask % 10;
							}
						}
					});
					// e.predecessor.splice(i3,1, tmp);
				});
			}
			else{
				e.predecessor.length = 0;
				e.predecessor.push(e.subTask - 1);
			}
		}	
			
	});

	//console.log(subtasks);
	return subtasks;
}

Arrangement.arrange = function(arrangeElements){
	//res is an array containing the returned information: couples like <subTaskID, beginTime>
	var res = {};
	var margin = 15; // A default margin(in advance or a delay according to the "type")
	var compatible = false;
	var coef1 = 0; // 0 if "at", -1 if "before" and 1 if "after"
	var coef2 = 0; // 0 if "Begin", 1 if "Finish"
	var length = arrangeElements.length;
	var comflit = [];
	var be;;
	var message = "";
	var sortedTasks;
	//By default, coef2 = 0
	if(this.constraint.type == 1) // If Finish
		coef2 = 1;

	//By default, coef1 = 0
	if(this.constraint.option == 0)// if Before
		coef1 = -1;
	else
		if(this.constraint.option == 1)// If after
			coef1 = 1;

	//Gets workflow's duration
	sortedTasks = sortTasks(arrangeElements);
	wfDuration = getDuration(sortedTasks);
	//Begin time of work flow 
	var beginWF = new Date(this.constraint.time);
	beginWF.setMinutes(beginWF.getMinutes() - coef2 * wfDuration + coef1 * margin);
	
	res = arrangeTimeNonDispo(sortedTasks, beginWF, this.agentsNonDispo)
	if(res.array.length == length){
		return res;
	}
	else{
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

function arrangeTimeNonDispo(arrangeElements, time, agentsNonDispo){
	var arrangeElements2 = JSON.parse(JSON.stringify(arrangeElements));
	var decision = {}; decision.array = []; decision.duration = 0;
	var agentTimeTable;
	var possibleTime = []; // Possible begin times 
	var finishTime = []; // Finish time of predecessors
	var tmpFinish;
	var nextBegin;
	var defaultMargin = 5; // Margin 5min between the tasks
	var tmpTime;
	var e;
	var count;
	var beginWF = 0;
	var endWF = 0;
	for (var i = 0; i <= arrangeElements2.length - 1; i++) {
		e = arrangeElements2[i];
		agentTimeTable = agentsNonDispo.filter(function(e1,i1,a1){if(e1.id == e.agentID) return true; return false;})[0] // Finds the agent doing this task and gets his time table
		possibleTime = []; // Possible begin times 
		finishTime = []; // Finish time of predecessors		
		if(e.predecessor.length == 0){
			count = 0;
			tmpFinish = new Date(time);
			tmpFinish.setMinutes(tmpFinish.getMinutes() + e.duration);
			agentTimeTable.periodes.forEach(function(e2,i2,a2){
				tmpTime = new Date(e2.begin);
				tmpTime.setMinutes(tmpTime.getMinutes()+e2.duration)	
				if(tmpFinish < e2.begin || time > tmpTime)
					count++;
			});
			// agentsNonDispo.periodes.forEach(function(e,i,a){
			// 	if(time < e.begin || time > e.begin + e.duration)
			// 		count ++;
			// });
			// if(count == agentsNonDispo.length){
			// 	count = 0;
			// 	tmpTime = new Date(time);
			// 	tmpFinish = tmpTime.setMinutes(tmpTime.getMinutes() + e.duration);
			// 	agentsNonDispo.forEach(function(e,i,a){
			// 		if(( tmpFinish > e.begin + e.duration || tmpFinish < e.begin) && e.duration )
			// 			count++;
			// 	});
			if(count == agentTimeTable.periodes.length){
				e.beginTime = time;
				possibleTime.push(time);
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
			count = 0;
			finishTime.length = 0;
			getPreds(e, arrangeElements2).forEach(function(e3,i3,a3){ 
				tmpTime = new Date(e3.beginTime);
				tmpTime.setMinutes(tmpTime.getMinutes() + e3.duration);
				finishTime.push(tmpTime);
			});
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
				console.log(e.subTask + " not possible "+ count+" time :" + nextBegin)
				break;
			}
		}
		if(possibleTime.length > 0){
			//decision.push(new ReturnElement(e.subTask, possibleTime[0]));
				decision.array.push(e);
		}		
		else{
			break;
		}
	}
	decision.duration = Math.round((endWF - beginWF)/60000); // minutes

	return decision;
};

function sortTasks(arrangeElements){
	var length = arrangeElements.length;
	var res = [];
	var predsDone = true;
	var preds = [];
	while(res.length != length){
		arrangeElements.forEach(function(e,i,a){
			predsDone = true;
			if(getPreds(e, arrangeElements).length == 0){
				res.push(e); // Push it into the final array
				arrangeElements.splice(arrangeElements.indexOf(e),1);
			}
			else{
				preds = getPreds(e,arrangeElements);
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