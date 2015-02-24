/**
* TaskAgentAdaptationInfos.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
  	task: {
  		model: 'Task'
  	}, 

  	subtasks: {
  		collection: 'SubTask', 
  		via: 'taskAgentAdaptationInfos'
  	}, 

  	params: {
  		type: 'json'
  	}, 

    consumption: function(cb) {

      var cons = {}
      SubTask.find({taskAgentAdaptationInfos: this.id})
      .exec(function (err, subtasks) {


        async.eachSeries(subtasks, 
          function (subtask, cb2) {


            MathService.sumKeysOfJSON(cons, subtask.consumption)
            cb2()
          }, 

          function (err) {

            cb(err, cons)

          }

          )

      })

    }

  }, 
  
  afterDestroy: function (infos, cb) {
    sails.log('Destroy infos : ' + JSON.stringify(infos))
    cb()
  }
};

