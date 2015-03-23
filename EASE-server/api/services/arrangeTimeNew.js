var Arrangement = function(){
}
module.exports = Arrangement;
//Initialization with the constraint and timetable of agents
Arrangement.init = function(constraint, agentsNonDispo){
	this._constraint = constraint;
	this._agentsNonDispo = agentsNonDispo;
}

Arrangement.arrange = function(arrangeElements){
	//res is an array containing the returned information: couples like <subTaskID, beginTime>
	var res = [];
	var margin = 15; // A default margin(in advance or a delay according to the "type")
	var compatible = false;
	var coef1 = 0; // 0 if "at", -1 if "before" and 1 if "after"
	var coef2 = 0; // 0 if "Begin", 1 if "Finish"
	var length = arrangeElements.length;
	var comflit = [];
	var be;;
	var message = "";
	//By default, coef2 = 0
	if(this._constraint._type == 1) // If Finish
		coef2 = 1;

	//By default, coef1 = 0
	if(this._constraint._option == 0)// if Before
		coef1 = -1;
	else
		if(this._constraint._option == 1)// If after
			coef1 = 1;

	//Gets workflow's duration
	var sumDuration = [];
	arrangeElements.forEach(function(e,i,a){sumDuration.push(e._duration);});
	var wfDuration = sumDuration.reduce(function(previousValue, currentValue, index, array) {
  		return previousValue + currentValue;
  	});
	//Begin time of work flow 
	var beginWF = new Date(this._constraint._time);
	beginWF.setMinutes(beginWF.getMinutes() - coef2 * wfDuration + coef1 * margin);
	// res = arrangeTime(sortTasks(arrangeElements), beginWF, this._agentsDispo);
	res = arrangeTimeNonDispo(sortTasks(arrangeElements), beginWF, this._agentsNonDispo)
	if(res.length == length)
		return res;
	else{
		// copy.forEach(function(e,i,a){
		// 	if(res.indexOf(e._subTask) == -1)
		// 		comflit.push(e._subTask);
			
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


//Test
function salut(){
	console.log("salut")
}

function arrangeTimeNonDispo(arrangeElements, time, agentsNonDispo){
	var decision = [];
	var agentTimeTable;
	var possibleTime = []; // Possible begin times 
	var finishTime = []; // Finish time of predecessors
	var tmpFinish;
	var defaultMargin = 5; // Margin 5min between the tasks
	var tmpTime;
	var e;
	var count;
	for (var i = 0; i <= arrangeElements.length - 1; i++) {
		e = arrangeElements[i];
		agentTimeTable = agentsNonDispo.filter(function(e1,i1,a1){if(e1._id == e._agentID) return true; return false;})[0] // Finds the agent doing this task and gets his time table
		possibleTime = []; // Possible begin times 
		finishTime = []; // Finish time of predecessors		
		if(e._predecessor.length == 0){
			count = 0;
			tmpFinish = new Date(time);
			tmpFinish.setMinutes(tmpFinish.getMinutes() + e._duration);
			agentTimeTable._periodes.forEach(function(e2,i2,a2){
				tmpTime = new Date(e2._begin);
				tmpTime.setMinutes(tmpTime.getMinutes()+e2._duration)	
				if(tmpFinish < e2._begin || time > tmpTime)
					count++;
			});
			// agentsNonDispo._periodes.forEach(function(e,i,a){
			// 	if(time < e._begin || time > e._begin + e._duration)
			// 		count ++;
			// });
			// if(count == agentsNonDispo.length){
			// 	count = 0;
			// 	tmpTime = new Date(time);
			// 	tmpFinish = tmpTime.setMinutes(tmpTime.getMinutes() + e._duration);
			// 	agentsNonDispo.forEach(function(e,i,a){
			// 		if(( tmpFinish > e._begin + e._duration || tmpFinish < e._begin) && e._duration )
			// 			count++;
			// 	});
			if(count == agentTimeTable._periodes.length){
				e._beginTime = time;
				possibleTime.push(time);
			}
			else{
				break;
			}
		}
		else{
			count = 0;
			finishTime.length = 0;
			getPreds(e, arrangeElements).forEach(function(e3,i3,a3){ 
				tmpTime = new Date(e3._beginTime);
				tmpTime.setMinutes(tmpTime.getMinutes() + e3._duration);
				finishTime.push(tmpTime);
			});
			tmpFinish = new Date(Math.max.apply(null,finishTime));
			tmpFinish.setMinutes(tmpFinish.getMinutes()+ defaultMargin);
			nextBegin = tmpFinish;
			tmpFinish = new Date(nextBegin)
			tmpFinish.setMinutes(tmpFinish.getMinutes() + e._duration);
			agentTimeTable._periodes.forEach(function(e4,i4,a4){
				tmpTime = new Date(e4._begin);
				tmpTime.setMinutes(tmpTime.getMinutes()+e4._duration)
				if(tmpFinish < e4._begin || nextBegin > tmpTime)
					count ++;
			});
			if(count == agentTimeTable._periodes.length){
				e._beginTime = nextBegin;
				possibleTime.push(nextBegin);
			}
			else{
				console.log(e._subTask + " not possible "+ count+" time :" + nextBegin)
				break;
			}
		}
		if(possibleTime.length > 0)
			decision.push(new ReturnElement(e._subTask, possibleTime[0]));
		else{
			break;
		}
	}
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
					if(preds[i]._beginTime == 0){
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
		if(subTask._predecessor.indexOf(arrangeElements[i]._subTask) != -1)
			preds.push(arrangeElements[i]);
	}
	return preds;
};
var ReturnElement = function(subTask, beginTime){
	this._subTask = subTask;
	this._beginTime = beginTime;
};

