/**
* Agent.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	agentBehavior : {
  		model: 'AgentBehavior'
  	}, 

  	agentType : {
  		type: 'string'
  	}, 

  	subTasksForTask : function(task, cb) {

  		AgentBehavior.findOne(this.agentBehavior)
      .exec(function (err, behavior) {
        cb(err, behavior.subTasksForTask(task))
      })
  		
  	}, 

    isAvailable: function (cb) {
      var query = "SELECT COUNT(*) AS C FROM SubTask WHERE status = 'working' AND agent = " + this.id
      Agent.query(query, 

        function(err, rows) {

          cb(rows[0] == 0)

        }

        )
    }

  }
};

