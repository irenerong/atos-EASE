/**
 * WorkflowGeneratorController
 *
 * @description :: Server-side logic for managing Workflowgenerators
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */


module.exports = {




  generate: function(req, res) {

    var WFC = this;
    var userID = req.session.userID;
    var params = req.params.all();



    async.waterfall([
        function (cb) {

          //Create new ticket
          sails.log('Create new ticket');

          WorkflowGeneratorTicket.create({user: userID}).exec(function (err, ticket) {cb(null, ticket)})
        },
        function (ticket, cb) {
          sails.log('Ticket created');

          //Get and save Metaworkflows
          sails.log('Getting Metaworkflows');

          WFC.getMetaworkflows(ticket.id, params, function () {cb(null, ticket)})

        },
        function (ticket, cb) {
          sails.log('Got Metaworkflows');


          //Adapting Metaworkflows
          sails.log('Adapting Metaworkflows');

          WFC.adaptMetaworkflows(ticket.id, params, function() {cb(null, ticket)})
        },
        function (ticket, cb) {

          //Results
          res.status(200);
          res.json({ticket: ticket.id})
        }
      ],
      function (err) {

      }
    )






  },

  getMetaworkflows : function (ticketID, params, cb) {
    var WFC = this;

    async.waterfall([
        function (cb2) {

          //Get metaworkflows from "ExternalMetaworkflow" database
          ExternalMetaworkflow.find({intent: params.intent}).exec( function(err, metaworkflows) { cb2(err, metaworkflows) })
        },
        function (metaworkflows, cb2) {

          //For each Metaworkflow
          async.each(metaworkflows, function (metaworkflow, cb3) {

            //Import this metaworkflow in the db
            WFC.importMetaworkflowFromOutside(ticketID, metaworkflow.data ,function () {cb3()});

          }, function(err) {
            sails.log('End of metaworkflows importation');
            cb2(err)

          })



        }
      ],

      function (err) {
        cb()
      }

    )





  },

  importMetaworkflowFromOutside: function (ticketID, metaworkflow, cb) {
    var WFC = this;


    async.waterfall([
        function (cb2) {
          //Create the metaworkflow and link it to the ticket
          Metaworkflow.create({title: metaworkflow.title, ticket: ticketID}).exec(function (err, metaworkflowCreated) {cb2(err, metaworkflowCreated)})

        },

        function (metaworkflowCreated, cb2) {

          //For each metatask in the created metaworkflow
          async.each(metaworkflow.metatasks,
            function (metatask, cb3) {

              //Import the metatask
              WFC.importMetataskFromOutside(metaworkflowCreated.id, metatask, function () {cb3()}); //Create this metatask and link it to the metaworkflow

            },
            function (err) {

              sails.log('	Metaworkflow Imported !');
              cb2(err)



            })
        }
      ],
      function (err) {
        cb()
      }
    )



  },

  importMetataskFromOutside: function (metaworkflowID, metatask, cb) {

    Metatask.create({idTask: metatask.idTask, metaworkflow: metaworkflowID, agentTypes: metatask.agentTypes})
      .exec(function(err, task) {
        cb()
      });  //Create the metatask and link it to the metaworkflow
  },

  adaptMetaworkflows : function (ticketID, params, cb) {
    var WFC = this;


    async.waterfall([
        function (cb2) {
          Metaworkflow.find({ticket: ticketID}).populate('metatasks')
            .exec(function (err, metaworkflows) {cb2(err, metaworkflows)})
        },
        function (metaworkflows, cb2) {


          async.each(metaworkflows, //For each metaworkflow
            function (metaworkflow, cb3) {

              //Adapt metaworkflow to agents
              WFC.adaptMetaworkflowToAgents(params, ticketID, metaworkflow, function () {cb3(null)})


            },
            function (err) {
              WFC.adaptMetaworkflowsToTime(function () {
                sails.log('	Metaworkflow Imported !');
                cb2(err)
              })


            }
          )
        }
      ],

      function (err) {
        cb()
      }

    )

    //Get the imported metaworkflows


  },

  adaptMetaworkflowToAgents : function (params, ticketID, metaworkflow, cb)
  {

    var WFC = this;


    async.waterfall([

        function (cb2) {
          Workflow.create({metaworkflow: metaworkflow.id, ticket: ticketID})
            .exec(function (err, workflow) { cb2(err, workflow) })

        },

        function (workflow, cb2) {

          async.each(metaworkflow.metatasks,
            function (metatask, cb3) {

              //Create the task
              Task.create({metatask: metatask.id, workflow: workflow.id, idTask: metatask.idTask})
                .exec(function (err, task) {
                  //Adapt the task to the agent by creating subtasks
                  WFC.adaptTaskToAgent(task, metatask, function () {cb3()})

                })


            },
            function (err) {
              cb2(err)
            }
          )

        }

    ],

      function (err) {
        cb()
      }
    )





  },

  adaptTaskToAgent : function (task, metatask, cb) {
    var WFC = this;


    async.waterfall([
      function (cb2) {

        Agent.find({agentType: metatask.agentTypes}) //Finding all the agents which might be able to perform this task
          .exec(function (err, agents) { cb2(err, agents) })
      },
      function (agents, cb2) {

        //Ask subtasks to agents
        WFC.askSubTasksToAgents(task, agents, function() {cb2(null)})
      }

    ],

      function (err) {
        cb()
      }
    )










  },

  askSubTasksToAgents : function (task, agents, cb) {
    var WFC = this;

    async.each(agents, //For each agents

      function (agent, cb2) {


        agent.subTasksForTask(task,

          function (subtasks) {

            if (subtasks) { //If this agent can do this task
              sails.log('Agent ' + agent.id + ' can do task ' + task.id);
              WFC.importSubTasks(subtasks, task, agent.id, function () {cb2()}); //Import them
            }
            else
            {

              sails.log('Agent ' + agent.id + ' cant do task ' + task.id);

              cb2()
            }

          }
        )



      },
      function (err) {
        cb()
      })
  },

  importSubTasks : function (subtasks, task, agentID, cb) {

    async.waterfall([

        function (cb2) {
          TaskAgentAdaptationInfos.create({task: task.id}) //Create an adaptation infos ticket
            .exec(function (err, taskInfos) { cb2(err, taskInfos) })

        },

        function (taskInfos, cb2) {

          async.each(subtasks, 	//For each subtask
            function (subtask, cb3) {


              async.waterfall([

                  function (cb4) {
                    SubTask.create({taskAgentAdaptationInfos: taskInfos.id, agent: agentID, action: subtask.action}) //Create the subtask
                      .exec(function (err, subtask) { cb4(err, subtask) })
                  },

                  function (subtask, cb4) {

                    taskInfos.subtasks.push(subtask.id);
                    taskInfos.save(function (err, savedTaskInfos) {
                      cb4()
                    })
                  }

              ],

                function (err) {
                  cb3()
                }
              )

            },
            function (err) {
              cb2(err)
            }
          )
        }



          ],
      function (err) {
        cb()
      }
    )


  },

  adaptMetaworkflowsToTime : function (cb)
  {
    sails.log('Adapt to time');
    cb()
  }


};

