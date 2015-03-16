

var oven = {
}

oven.changeMarque()
oven.subtasks = function (task) {
		var subtask1 = {}
		subtask1.action = {action: "SUBTASK1"}
		subtask1.consumption = {time: Math.random()*60, CO2: Math.random()}

		var subtask2 = {}
		subtask2.action = {action: "SUBTASK2"}
		subtask2.consumption = {time: Math.random()*60, WATER: Math.random()*10}

		return [subtask1, subtask2]
	}

module.exports = oven



