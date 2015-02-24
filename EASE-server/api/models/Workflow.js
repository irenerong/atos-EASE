/**
* Workflow.js
*
* @description :: Server-side Workflow
* @docs        :: http://sailsjs.org/#!documentation/models
*/

/*

- Générer workflow
- Regénéer workflow sous d'autres params
- Générer subtasks
- Regénérer subtasks sous d'autres params
- Tri des workflows
- Filtre des workflows

*/

module.exports = {

  attributes: {


  	generationParams: {
  		type: 'json', 
  	},

    tasks: {
      collection: 'Task',
      via: 'workflow'
    }, 

    metaworkflow : {
      model: 'Metaworkflow'
    },

    ticket: {
      model: 'WorkflowGeneratorTicket'
    }, 

     

    getSubWorkflows: function (cb) {

      var workflow = this
      var workflowJSONModel = {id: workflow.id, tasks: [], title: workflow.title}
      var infosConsumption = {}

      //console.log('MODEL : ' + JSON.stringify(workflowJSONModel))

      async.waterfall([

        function (cb2) {

          Task.find({workflow: workflow.id}).populate('taskAgentAdaptationInfos')
          .exec(function(err, tasks) {cb2(err, tasks)})

        }, 

        function (tasks, cb2) {


          async.map(tasks, 
            function (task, cb3) {
              workflowJSONModel.tasks.push({id: task.id})




              async.each(task.taskAgentAdaptationInfos, 

                function (infos, cb) {

                  infos.consumption(function (err, cons) {
                    infosConsumption[infos.id] = cons
                    cb(err)
                  })

                }, 
                function (err) {
                                cb3(err, task.taskAgentAdaptationInfos)

                }
                )



            }, 

            function (err, results) {

              cb2(null, results)


            }
            )
        
                

           


        }, 

        function (results, cb2) {

          var paths = MathService.cartesianProduct(results)


          cb2(null, paths)

        }, 

        function (paths, cb2) {



          async.map(paths, 
              function (path, cb3) {


                var W = JSON.parse(JSON.stringify(workflowJSONModel))

                var consumption = {}

                async.each(path, 
                  function (infos, cb4) {
                    for (var i = 0; i < W.tasks.length; i++)
                    {
                      if (W.tasks[i].id == infos.task)
                      {
                          W.tasks[i].subtaskTicket = infos.id
                          break;

                      }
                    }

                      MathService.sumKeysOfJSON(consumption, infosConsumption[infos.id])
                      cb4(null)

                    
                  }, 
                  function (err) {
                    W.consumption = consumption
                    cb3(null, W)

                  }
                  )

              }, 

              function (err, workflows) {


               cb2(err, workflows)


              }

            )



        }

        ], 

        function (err, workflows) {

          //console.log("workflows : " + JSON.stringify(workflows, null, 4))
          cb(err, workflows)


        }
        )


    }


  }, 

   afterDestroy: function (workflow, cb) {
    sails.log('Destroy workflow')
    Task.destroy({workflow: workflow.id}).exec(function (err) {return cb()})
   }


};

