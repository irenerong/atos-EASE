var ricecooker2 = {}

ricecooker2.subtasks = function (task) {
		var subtask1 = {}
		subtask1.action = {action: "STEAMheat"}
		subtask1.consumption = {time: Math.random()*60, CO2: Math.random()}

		var subtask2 = {}
		subtask2.action = {action: "keepwarm"}
		subtask2.consumption = {time: Math.random()*60, WATER: Math.random()*10}

		var subtask3 = {}
		subtask3.action = {action: "softenrice"}
		subtask3.consumption = {time: Math.random()*60, WATER: Math.random()*10}

		return [subtask1, subtask2,subtask3]
	}

module.exports = ricecooker2
