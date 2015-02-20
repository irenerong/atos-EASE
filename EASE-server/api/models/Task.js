/**
* Task.js
*
* @description :: Server-Side Task
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    
   	metatask: {
  		model: 'Metatask'
  	}, 

    generationParams: {
      type: 'json'
    },

    idTask: {
      type: 'integer'
    },

  	workflow: {
  		model: 'Workflow'
  	}, 

    taskAgentAdaptationInfos: {
      collection: 'TaskAgentAdaptationInfos', 
      via: 'task'
    }
    
  }, 

  afterDestroy: function (tasks, cb) {

    if (!tasks) {
      return cb()
    }

    async.each(tasks, 
      function (task, cb2) {


            TaskAgentAdaptationInfos.findOne(task.taskAgentAdaptationInfos)
            .exec(function (err, taskInfos) {
              if (!taskInfos)
              {
                return cb2()
              }
              sails.log('Task infos : ' + JSON.stringify(taskInfos))

              SubTask.destroy(taskInfos.subtasks)
              .exec(function (err) {
                TaskAgentAdaptationInfos.destroy(taskInfos.id)
                .exec(function (err) {
                    cb2()
                })
              })

            })



      }, 

      function (err) {
        cb()
      }

      )



    
   }


};

