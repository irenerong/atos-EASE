var Arrangement = function(){
}
module.exports = Arrangement;

Arrangement.arrange = function(constraint, arrangeElements, agentDispo){
	//res is an array containing the returned information: couples like <subTaskID, beginTime>
	var res = new Array();
	var margin = 5; // A default margin(in advance or a delay according to the "type")
	var compatible = false;
	var coef1 = 0; // 0 if "at", -1 if "before" and 1 if "after"
	var coef2 = 0; // 0 if "Begin", 1 if "Finish"
	var length = arrangeElements.length;
	var comflit = [];
	var be;;
	var message = "";
	if(constraint._type == 1) // If Finish
		coef2 = 1;
	if(constraint._option == 0)// if Before
		coef1 = -1;
	else
		if(constraint._option == 1)// If after
			coef1 = 1;

	//Gets workflow's duration
	var sumDuration = new Array();
	arrangeElements.forEach(function(e,i,a){sumDuration.push(e._duration);});
	var wfDuration = sumDuration.reduce(function(previousValue, currentValue, index, array) {
  		return previousValue + currentValue;
  	});
	//Begin time of work flow 
	var beginWF = new Date(constraint._time);
	beginWF.setMinutes(beginWF.getMinutes() - coef2 * wfDuration - coef1 * margin);
	res = arrangeTime(sortTasks(arrangeElements), beginWF, agentDispo);
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

function arrangeTime(arrangeElements, time, agentDispo){
	var decision = new Array();
	arrangeElements.forEach(function(e,i,a){
		var agentTimeTable = agentDispo.filter(function(e2,i2,a2){if(e2._id == e._agentID) return true; return false;})[0] // Finds the agent doing this task and gets his time table
		var possibleTime = new Array(); // Possible begin times (for now, we use only the first possible time)
		var finishTime = new Array(); // Finish time of predecessors
		var tmpFinish;
		var defaultMargin = 5; // Margin 5min between the tasks
		agentTimeTable._periodes.forEach(function(e2,i2,a2){
			if(e._predecessor.length == 0){ // If no predecessor, meaninng the initial tasks
				if(e2._begin <= time){
					tmpTime = new Date(time);
					tmpTime.setMinutes(tmpTime.getMinutes() + e._duration);
					if(e2._end >= tmpTime){
						e._beginTime = time;
						possibleTime.push(time);
					}
				}
			}
			else{
				finishTime.length = 0;
				getPreds(e, arrangeElements).forEach(function(e3,i3,a3){ 
					tmpTime = new Date(e3._beginTime);
					tmpTime.setMinutes(tmpTime.getMinutes() + e3._duration);
					finishTime.push(tmpTime);
				});
				tmpFinish = new Date(Math.max.apply(null,finishTime)); // The latest finish time of this predecessor
				tmpFinish.setMinutes(tmpFinish.getMinutes() + defaultMargin);
				if(e2._begin <= tmpFinish){
					tmpTime = new Date(tmpFinish);
					tmpTime.setMinutes(tmpTime.getMinutes() + e._duration);
					if(e2._end >= tmpTime){
						e._beginTime = tmpFinish;
						possibleTime.push(tmpFinish);
					}
				}
			}	
		});
		// console.log(possibleTime)
		if(possibleTime.length > 0 ){
			decision.push(new ReturnElement(e._subTask, possibleTime[0]));
		}
	});
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
/*  *********************************************************************************************************  


//An arrangeElement contains the ID of a subTask, his duration and ID of his predecessor and the ID of the agent
var ArrangeElement = function(subTask, duration, predecessor, agentID){ 
	this._subTask = subTask;
	this._duration = duration;
	this._predecessor = predecessor;
	this._beginTime = 0;
	this._agentID = agentID;
};
ArrangeElement.prototype.getPreds = function(arrangeElements){
	var preds = new Array();
	for (var i = arrangeElements.length - 1; i >= 0; i--) {
		if(this._predecessor.indexOf(arrangeElements[i]._subTask) != -1)
			preds.push(arrangeElements[i]);
	}
	return preds;
};
ArrangeElement.prototype.getSuccs = function(arrangeElements){
	var succs = [];
	for (var i = arrangeElements.length - 1; i >= 0; i--) {
		if(arrangeElements[i]._predecessor.indexOf(this._subTask) != -1)
			succs.push(arrangeElements[i]);
	};
	return succs;
};
// type: is a parameter which indicates that temperal constraint of a workflow requires a Begin condition or Finish condition. 0 means begin and 1 means finish
// option: is a parameter which indicates that the relation to the given "time". 0 means before, 1 means after and 2 means at. //TODO maybe between?
var Constraint = function(type, option, time){
	this._type = type;
	this._option = option;
	this._time = time;
};

var ReturnElement = function(subTask, beginTime){
	this._subTask = subTask;
	this._beginTime = beginTime;
};

var Periode = function(duration, begin, end){
	this._duration = duration;
	this._begin = begin;
	this._end = end;
};

var AgentDispo = function(id, periodes){//Dictionnary
	this._id = id; // ID of the agent
	this._periodes = periodes;
};
//Sort the sub tasks in oder that whichever of them is bebind his precedessors.
function sortTasks(arrangeElements){
	var length = arrangeElements.length;
	var res = [];
	var predsDone = true;
	var preds = [];
	while(res.length != length){
		arrangeElements.forEach(function(e,i,a){
			predsDone = true;
			if(e.getPreds(arrangeElements).length == 0){
				res.push(e); // Push it into the final array
				arrangeElements.splice(arrangeElements.indexOf(e),1);
			}
			else{
				preds = e.getPreds(arrangeElements);
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
// This function aims to arrange time to the subtasks of one workflow
// constaints is of type Constraint, containing the temperal constraints
// arrangeElements ia an array containing the elements of type ArrangeElement
// agentDispo is an array containing the disponibility information of agents
var Arrangement = function(constraint, arrangeElements, agentDispo){
	//res is an array containing the returned information: couples like <subTaskID, beginTime>
	var res = new Array();
	var margin = 5; // A default margin(in advance or a delay according to the "type")
	var compatible = false;
	var coef1 = 0; // 0 if "at", -1 if "before" and 1 if "after"
	var coef2 = 0; // 0 if "Begin", 1 if "Finish"
	var length = arrangeElements.length;
	if(constraint._type == 1) // If Finish
		coef2 = 1;
	if(constraint._option == 0)// if Before
		coef1 = -1;
	else
		if(constraint._option == 1)// If after
			coef1 = 1;

	

	//Gets workflow's duration
	var sumDuration = new Array();
	arrangeElements.forEach(function(e,i,a){sumDuration.push(e._duration);});
	var wfDuration = sumDuration.reduce(function(previousValue, currentValue, index, array) {
  		return previousValue + currentValue;
  	});
	//Begin time of work flow 
	var beginWF = new Date(constraint._time);
	beginWF.setMinutes(beginWF.getMinutes() - coef2 * wfDuration - coef1 * margin);
	res = arrangeTime(sortTasks(arrangeElements), beginWF, agentDispo);
	if(res.length == length)
		return res;
	else
		return "comflit";};


//TODO: 还是需要metabegin，比如start before 10h，metabegin ＝ ［9h30， 9h55］，然后看是否compatible， wf始终compact，有一个task不行就否掉
//目前还是直接给定时间测是否compatible

function arrangeTime(arrangeElements, time, agentDispo){
	var decision = new Array();
	arrangeElements.forEach(function(e,i,a){
		var agentTimeTable = agentDispo.filter(function(e2,i2,a2){if(e2._id == e._agentID) return true; return false;})[0] // Finds the agent doing this task and gets his time table
		var possibleTime = new Array(); // Possible begin times (for now, we use only the first possible time)
		var finishTime = new Array(); // Finish time of predecessors
		var tmpFinish;
		var defaultMargin = 5; // Margin 5min between the tasks
		agentTimeTable._periodes.forEach(function(e2,i2,a2){
			if(e._predecessor.length == 0){ // If no predecessor, meaninng the initial tasks
				if(e2._begin <= time){
					tmpTime = new Date(time);
					tmpTime.setMinutes(tmpTime.getMinutes() + e._duration);
					if(e2._end >= tmpTime){
						e._beginTime = time;
						possibleTime.push(time);
					}
				}
			}
			else{
				finishTime.length = 0;
				e.getPreds(arrangeElements).forEach(function(e3,i3,a3){ 
					tmpTime = new Date(e3._beginTime);
					tmpTime.setMinutes(tmpTime.getMinutes() + e3._duration);
					finishTime.push(tmpTime);
				});
				tmpFinish = new Date(Math.max.apply(null,finishTime)); // The latest finish time of this predecessor
				tmpFinish.setMinutes(tmpFinish.getMinutes() + defaultMargin);
				if(e2._begin <= tmpFinish){
					tmpTime = new Date(tmpFinish);
					tmpTime.setMinutes(tmpTime.getMinutes() + e._duration);
					if(e2._end >= tmpTime){
						e._beginTime = tmpFinish;
						possibleTime.push(tmpFinish);
					}
				}
			}	
		});
		// console.log(possibleTime)
		if(possibleTime.length > 0 ){
			decision.push(new ReturnElement(e._subTask, possibleTime[0]));
		}
	});
	return decision;
};

var ae1 = new ArrangeElement(1, 10, [] , 0);
var ae2 = new ArrangeElement(2, 20, [] , 1);
var ae3 = new ArrangeElement(3, 5 , [1], 0);
var ae4 = new ArrangeElement(4, 10, [1,2], 2);
var ae5 = new ArrangeElement(5, 30, [4], 3);
var ae6 = new ArrangeElement(6, 15, [3,5], 4);
var ae  = [ae3, ae5, ae4, ae2, ae6, ae1];

var contrainte = new Constraint(0,1,new Date(2015, 1, 1, 0, 120, 0)); // 2015-1-1 T 0:0:0


var periode1 = new Periode(1000, new Date(2015, 1, 1, 0, 100, 0), new Date(2015, 1, 1, 0, 1100, 0));
var periode2 = new Periode(500, new Date(2015, 1, 1, 0, 1500, 0), new Date(2015, 1, 1, 0, 2000, 0));
var periodeUser = [periode1, periode2];
var userDispo = new AgentDispo(0, periodeUser);

var periode3 = new Periode(1900, new Date(2015, 1, 1, 0, 100, 0), new Date(2015, 1, 1, 0, 2000, 0));
var agent1Dispo = new AgentDispo(1, [periode3]);
var agent2Dispo = new AgentDispo(2, [periode3]);
var agent3Dispo = new AgentDispo(3, [periode3]);
var agent4Dispo = new AgentDispo(4, [periode3]);

var agentsDispo = [userDispo, agent1Dispo, agent2Dispo, agent3Dispo, agent4Dispo];

var arrangeExample = new Arrangement(contrainte, ae, agentsDispo);
console.log(arrangeExample);



*/

