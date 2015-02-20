

var oven = {}

oven.subtasks = function (task) {
		var subtask1 = {}
		subtask1.action = {action: "SUBTASK1"}

		var subtask2 = {}
		subtask2.action = {action: "SUBTASK2"}

		return [subtask1, subtask2]
	}

module.exports = oven
