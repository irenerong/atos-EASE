
triggers = {};

module.exports = {

	

	TriggerStartCondition: function (startID) {

	}, 

	SubTaskDidEnd: function (subtaskID) {
		
		var query = "SELECT startcondition_waitfor AS waitFor FROM startcondition_waitfor__subtask_nextstartconditions WHERE subtask_nextstartconditions = " + subtaskID

		StartCondition.query(query, 
			function (err, rows) {

				async.each(rows, 
					function (row, cb) {

						StartCondition.findOne(row.waitFor)
						.exec(function(err, startCondition) {


							startCondition.conditionsMet(function (ok) {

								if (!ok) {
								}

								else if (startCondition.delay) {
									
								}

								else {
									MathService.TriggerSubTask(startCondition.id)

								}

								return cb()

							})


						})	

					}, 

					function (err) {

					}

					)
			}
			)
	}
	, 



};

