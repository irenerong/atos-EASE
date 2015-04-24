var ricecooker2 = {}

ricecooker2.subtasks = function (task) {
		var subtask1 = {}
		subtask1.metatask =task.metatask;
		subtask1.waitFor = task.waitFor
		subtask1.id = task.id*10+1;
		subtask1.action = {action: "Steam Heat"}
		subtask1.consumption = {time: 20, CO2: Math.random()}

		var subtask2 = {}
		subtask2.metatask =task.metatask;
		subtask2.waitFor = task.waitFor
		subtask2.id = task.id*10+2;
		subtask2.action = {action: "Keep Warm"}
		subtask2.consumption = {time: 15, WATER: Math.random()}

		var subtask3 = {}
		subtask3.metatask =task.metatask;
		subtask3.waitFor = task.waitFor
		subtask3.id = task.id*10+3;
		subtask3.action = {action: "Soften Rice"}
		subtask3.consumption = {time: 5, CO2: Math.random()}

		return [subtask1, subtask2,subtask3]
	}

module.exports = ricecooker2
