var ricecooker = {}

ricecooker.subtasks = function (task) {
		var subtask1 = {}
		subtask1.metatask =task.metatask;
		subtask1.waitFor = task.waitFor
		subtask1.id = task.id*10+1;
		subtask1.action = {action: "STEAMheat"}
		subtask1.consumption = {time: 20, CO2: Math.random()}
//subtask1.consumption = {time: Math.random()*60, CO2: Math.random()}

		var subtask2 = {}
		subtask2.metatask =task.metatask;
		subtask2.waitFor = task.waitFor
		subtask2.id = task.id*10+2;
		subtask2.action = {action: "keepwarm"}
		subtask2.consumption = {time: 10, WATER: Math.random()*10}
		//subtask2.consumption = {time: Math.random()*60, CO2: Math.random()}

		return [subtask1, subtask2]
	}

module.exports = ricecooker
