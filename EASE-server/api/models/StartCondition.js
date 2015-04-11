/**
* StartCondition.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	type: {
  		type: 'string'
  	}, 

  	waitFor: {
  		collection: 'SubTask', 
  		via: 'nextStartConditions',
      dominant: true
  	}, 

  	startDate: {
  		type: 'datetime'
  	}, 

  	delay: {
  		type: 'integer'
  	}, 

  	conditionsMet: function(cb) {
  		if (this.type == 'time') {

  		}
  		else if (this.type == 'wait') {
  			var query = "SELECT COUNT(*) AS C FROM SubTask JOIN startcondition_waitFor__subtask_nextstartconditions ON subtask.id = startcondition_waitFor__subtask_nextstartconditions.startcondition_waitFor WHERE status = 'finish' AND subtask_nextstartconditions =" + this.id
  			StartCondition.query(query, 

  				function (err, rows) {
  					if (err) {
  						return cb(false)
  					}
            console.log('need to wait for '+rows[0].C+'of task');
  					cb( rows[0].C == 0)

  				}

  				)
  		}
  	}

  }

};

