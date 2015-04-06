/**
 * WorkflowGeneratorController
 *
 * @description :: Server-side logic for managing Workflowgenerators
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */


module.exports = {

  validate: function (req, res){
    var waitforlist = []; 
    var WFC = this;
    var index = parseInt(req.body.index);
    //console.log(index);
    var params = req.session.generatedWorkflows[index];
    var subtasks=req.session.generatedWorkflows[index].subtasks;
    //subtasks = params.array;
    var consumption = parseFloat(params.consumption);
    var duration = parseInt(params.duration);
    console.log("consumption "+consumption+" duration "+duration)

    //console.log(params);
    subtasks.forEach(function(e,i,a){
      Agent.findOne(e.agentID).exec(function(err, agent){
        agent.updateNonDispo(e.beginTime,e.duration);
      })
    })
   
    Workflow.create({metaworkflow : params.metaworkflow,duration:duration,consumption:consumption}).exec(
      function(err, workflow){
        if (err) {console.log(err)}

        console.log('workflow '+workflow.id+ 'has been generate');

        async.waterfall([
          function (cb) {
            console.log('generating subtasks');
            //console.log(subtasks);
            WFC.createSubtask(workflow, subtasks);

            setTimeout(function(){cb(err,workflow)},300);
          },
          function(workflow,cb){
            //console.log('1 the number of workflow is '+workflow.id)

            SubTask.find({workflow:workflow.id}).populate('startCondition').exec(function(err,STs){

              //console.log(STs)
              // try to find already created subtask which are ST's Predecessor
             STs.forEach(function(e,i,a){WFC.assigneWaitfor(e)}) 
              //async.each(STs,function(ST,cb2){WFC.assigneWaitfor(ST,function(){cb2()})},function(){}) // end for each   
              
          })// end Subtask find
          cb();
          }// function(workflow,cb)
          ],function(err){

            res.json({"new created workflow":workflow.id});


          })// fin async waterfall

        

      })
    




  },

  createSubtask :function (wf, subtasks){
   // console.log(subtasks);
    var WFC=this;
    subtasks.forEach(function(subtask,i,a){

      SubTask.create({workflow:wf.id, waitforID:subtask.predecessor, taskID:subtask.subTask, 
        agent: subtask.agentID, action: subtask.action, consumption: subtask.consumption, duration:subtask.duration}).exec(
         // after create subtask , il faut creer son startcondition
         function(err,st){
          //console.log('st'+JSON.stringify(st,null,4));
          //console.log('subtask'+ JSON.stringify(subtask,null,4));
          WFC.createStartCondition(st,subtask); 
         }

        )

    })
  },

  createStartCondition: function(st,subtask){

    var type = 'time';
      if (st.waitforID.length!= 0){

        type = 'wait'
    }
    StartCondition.create({type: type, startDate: subtask.beginTime, delay:5}).exec(function(err, start){

      if (err) {console.log(err)}

     // console.log(st.id+ '  '+ start.id)

      //SubTask.update(st.id,{startCondition:start.id}).exec()
      SubTask.update(st.id,{startCondition:start.id}).populate('startCondition').exec(console.log)

      // console.log('start Condition'+start.id+ '//' + 'subtask'+ start.subtask);
    })
  },

  assigneWaitfor: function(ST){
      var waitforlist=[];
             async.waterfall([

                  function(cb2){
                    //console.log(ST);
                   // console.log('async Each the number of workflow is '+ST.workflow)
                    async.each(ST.waitforID,
                      function(waitFor,cb3){
                        SubTask.findOne({taskID:waitFor, workflow:ST.workflow}).exec(function(err,nextst){
                                  
                                  // asign each waitFor to ST's startcondition
                                 // console.log(nextst.id);
                                  waitforlist.push(nextst.id);
                                  setTimeout(function(){cb3()},30);
                                })//end Subtask.find(taskID:waitforID)
                    
                  },
                  function(err){
                    //console.log(waitFors)
                    cb2(null,waitforlist);
                  });

                  //console.log('hoho')
                  },
                    
                  function(waitforlist,cb2){
                    //console.log('2 waitforlist'+waitforlist);
                    StartCondition.findOne(ST.startCondition.id).exec(function(err,startcon){
                      while(waitforlist.length != 0){
                        startcon.waitFor.add(waitforlist.pop());
                        startcon.save(function(err){});
                      }
                   // console.log(startcon);
                      
                      cb2(null);
                    })}
                ],function(err){}
           )// end asynwaterfall 2
          },

 // } ; 





  generate: function(req, res) {

    var WFC = this;
    var userID = req.session.userID;
    var params = req.params.all();





    async.waterfall([
        function (cb) {

          //Create new ticket
          sails.log('Create new ticket');

          WorkflowGeneratorTicket.create({user: userID, status: 'GENERATING'}).exec(function (err, ticket) {cb(null, ticket)})


        },
        function (ticket, cb) {
          sails.log('Ticket created');

          //Get and save Metaworkflows
          sails.log('Getting Metaworkflows');

          console.time('Get Metaworkflows')

          WFC.getMetaworkflows(ticket.id, params, function () {          console.timeEnd('Get Metaworkflows')
; cb(null)})


        }
      ],
      function (err) {

        res.json({"sucecced" :'create workflow with intent :'+params.intent})

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
            WFC.importMetaworkflowFromOutside(metaworkflow.intent,ticketID, metaworkflow.data ,function () {cb3()});

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

  importMetaworkflowFromOutside: function (intent,ticketID, metaworkflow, cb) {
    var WFC = this;


    async.waterfall([
        function (cb2) {
          //Create the metaworkflow and link it to the ticket ++add ingredient
          Metaworkflow.create({intent : intent ,title: metaworkflow.title, ticket: ticketID, ingredient: metaworkflow.ingredient}).exec(function (err, metaworkflowCreated) {cb2(err, metaworkflowCreated)})

        },

        function (metaworkflowCreated, cb2) {

          //For each metatask in the created metaworkflow
          async.each(metaworkflow.metatasks,
            function (metatask, cb3) {

              //Import the metatask
              WFC.importMetataskFromOutside(metaworkflowCreated.id, metatask, function () {cb3()}); //Create this metatask and link it to the metaworkflow

            },
            function (err) {

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

    Metatask.create({idTask: metatask.idTask, metaworkflow: metaworkflowID, agentTypes: metatask.agentTypes, waitFor: metatask.waitFor})
      .exec(function(err, task) {
        cb(null)
      });  //Create the metatask and link it to the metaworkflow
  },



//   adaptMetaworkflows : function (ticketID, params, cb) {
//     var WFC = this;


//     async.waterfall([
//         function (cb2) {

//           console.time('Seek Metaworkflows')
//           Metaworkflow.find({ticket: ticketID}).populate('metatasks')
//             .exec(function (err, metaworkflows) {  cb2(err, metaworkflows)})
//         },
//         function (metaworkflows, cb2) {
//           console.timeEnd('Seek Metaworkflows')


//           async.each(metaworkflows, //For each metaworkflow
//             function (metaworkflow, cb3) {

//               //Adapt metaworkflow to agents
//               WFC.adaptMetaworkflowToAgents(params, ticketID, metaworkflow, function (err) {cb3(null)})


//             },
//             function (err) {
//               if (err == 'NoAgent')
//               {
//                 return cb2(err)
//               }

//               WFC.adaptMetaworkflowsToTime(function () {
//                 cb2(err)
//               })


//             }
//           )
//         }
//       ],

//       function (err) {
//         cb()
//       }

//     )

//     //Get the imported metaworkflows


//   },

//   adaptMetaworkflowToAgents : function (params, ticketID, metaworkflow, cb)
//   {

//     var WFC = this;


//     async.waterfall([

//         function (cb2) {
//           Workflow.create({metaworkflow: metaworkflow.id, ticket: ticketID})
//             .exec(function (err, workflow) { cb2(err, workflow) })

//         },

//         function (workflow, cb2) {

//           async.each(metaworkflow.metatasks,
//             function (metatask, cb3) {

//               //Create the task
//               Task.create({metatask: metatask.id, workflow: workflow.id, idTask: metatask.idTask , waitFor: metatask.waitFor})
//                 .exec(function (err, task) {
//                   //Adapt the task to the agent by creating subtasks
//                   console.time('Task Adaptation' + task.id)
//                   WFC.adaptTaskToAgents(task, metatask, function (err) { console.timeEnd('Task Adaptation' + task.id)
// ; cb3(err)})

//                 })


//             },
//             function (err) {
//               if (err == 'NoAgent') {
//                 Workflow.destroy(workflow.id)
//                 .exec(function (err) {

//                   Metaworkflow.destroy(metaworkflow.id)
//                   .exec(function (err) {
//                      cb2(err)
//                   })

//                 })
//               }
//               else
//               {
//                  cb2(err)

//               }

//             }
//           )

//         }

//     ],

//       function (err) {
//         cb(err)
//       }
//     )





//   },

//   adaptTaskToAgents : function (task, metatask, cb) {
//     var WFC = this;


//     async.waterfall([
//       function (cb2) {

//         Agent.find({agentType: metatask.agentTypes}) //Finding all the agents which might be able to perform this task
//           .exec(function (err, agents) { cb2(err, agents) })
//       },
//       function (agents, cb2) {

//         if (agents.length == 0) {
//           console.log('Task ' + task.id + ' cant be done')
//           return cb2('NoAgent')
//         }

//         //Ask subtasks to agents
//         WFC.askSubTasksToAgents(task, agents, function() {cb2(null)})
//       }

//     ],

//       function (err) {
//         cb(err)
//       }
//     )










//   },

//   askSubTasksToAgents : function (task, agents, cb) {
//     var WFC = this;

//     async.each(agents, //For each agents

//       function (agent, cb2) {


//         agent.subTasksForTask(task,

//           function (subtasks) {

//             if (subtasks) { //If this agent can do this task

//               console.log(subtasks)

//               WFC.importSubTasks(subtasks, task, agent.id, function () {cb2()}); //Import them
//             }
//             else
//             {

//               cb2()
//             }

//           }
//         )



//       },
//       function (err) {
//         cb()
//       })
//   },

//   importSubTasks : function (subtasks, task, agentID, cb) {

//     async.waterfall([

//         function (cb2) {
//           TaskAgentAdaptationInfos.create({task: task.id}) //Create an adaptation infos ticket
//             .exec(function (err, taskInfos) { cb2(err, taskInfos) })

//         },

//         function (taskInfos, cb2) {

//           async.each(subtasks, 	//For each subtask
//             function (subtask, cb3) {


//               async.waterfall([

//                   function (cb4) {
//                     SubTask.create({taskAgentAdaptationInfos: taskInfos.id, agent: agentID, action: subtask.action, consumption: subtask.consumption}) //Create the subtask
//                       .exec(function (err, subtask) { cb4(err, subtask) })
//                   },

//                   function (subtask, cb4) {

//                     taskInfos.subtasks.push(subtask.id);
//                     taskInfos.save(function (err, savedTaskInfos) {
//                       cb4()
//                     })
//                   }

//               ],

//                 function (err) {
//                   cb3()
//                 }
//               )

//             },
//             function (err) {
//               cb2(err)
//             }
//           )
//         }



//           ],
//       function (err) {
//         cb()
//       }
//     )


//   },

//   adaptMetaworkflowsToTime : function (cb)
//   {
//     sails.log('Adapt to time');
//     cb()
//   }



};
