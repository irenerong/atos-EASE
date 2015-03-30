

var oven = {
}

oven.subtasks = function (task) {
		var subtask1 = {}
		subtask1.waitFor = task.waitFor
		subtask1.id = task.id*10+1;
		subtask1.action = {action: "SUBTASK1"}
		subtask1.consumption = {time: 20, CO2: Math.random()}
		//subtask1.consumption = {time: Math.random()*60, CO2: Math.random()}

		var subtask2 = {}
		subtask2.waitFor = task.waitFor
		subtask2.id = task.id*10+2;
		subtask2.action = {action: "SUBTASK2"}
		subtask2.consumption = {time: 10, WATER: Math.random()*10}
		//subtask2.consumption = {time: Math.random()*60, WATER: Math.random()*10}


		return [subtask1, subtask2]
	}

module.exports = oven



