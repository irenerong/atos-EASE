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
     if (req.session.generatedWorkflows != null)
     {
      console.log('req.session.generatedWorkflows is not null');
    var params = req.session.generatedWorkflows[index];
    var subtasks=req.session.generatedWorkflows[index].subtasks;
    //subtasks = params.array;
    var consumption = parseFloat(params.consumption);
    var duration = parseInt(params.duration);
    var color = parseInt(params.color)
    // console.log("consumption "+consumption+" duration "+duration)
   
    Workflow.create({metaworkflow : params.metaworkflow,duration:duration,consumption:consumption, color:color}).exec(
      function(err, workflow){
        if (err) {console.log(err)}

//  send message to socket which watch Workflow model and subscribe the socket to the new instance
        Workflow.publishCreate(workflow);

        console.log('workflow '+workflow.id+ 'has been generate');

        async.waterfall([
          function (cb) {
            console.log('generating subtasks');
            //console.log(subtasks);
            WFC.createSubtask(workflow, subtasks, function(){cb(err,workflow)});
          },
          function(workflow,cb){
            //console.log('1 the number of workflow is '+workflow.id)

            SubTask.find({workflow:workflow.id}).populate('startCondition').exec(function(err,STs){

              console.log(STs)
              // try to find already created subtask which are ST's Predecessor
      
             async.each(STs,function(e,cb2){WFC.assigneWaitfor(e,function(){cb2(null)})},function(err){cb(null)})
              //async.each(STs,function(ST,cb2){WFC.assigneWaitfor(ST,function(){cb2()})},function(){}) // end for each   
              
          })// end Subtask find
          }// function(workflow,cb)
          ],function(err){
            req.session.generatedWorkflows = null;
                subtasks.forEach(function(e,i,a){
                Agent.findOne(e.agentID).exec(function(err, agent){
                  agent.updateNonDispo(e.beginTime,e.duration);
                })
              })

            res.json({"new created workflow":workflow.id});
            


          })// fin async waterfall

        

      })
    } // fin if req.session not null
    else {
      res.json({error:'you do not have any workflow to be validated'});
    }
    




  },

  createSubtask :function (wf, subtasks,callback){
   // console.log(subtasks);
    var WFC=this;
    async.each(subtasks,function(subtask,cb){
     SubTask.create({workflow:wf.id, waitforID:subtask.predecessor, taskID:subtask.subTask, metatask:subtask.metatask,
        agent: subtask.agentID, action: subtask.action, consumption: subtask.consumption, duration:subtask.duration,timeLeft:subtask.duration}).exec(
         // after create subtask , il faut creer son startcondition
         function(err,st){
          SubTask.publishCreate(st);
          //console.log('st'+JSON.stringify(st,null,4));
          //console.log('subtask'+ JSON.stringify(subtask,null,4));
          WFC.createStartCondition(st,subtask,function(){cb(null)}); 
         })
      },function(err){

        callback();

      })

  },

 createStartCondition: function(st,subtask,callback){

    var type = 'wait'; // for subtask with precedors
    async.waterfall([function(cb){
     if (st.waitforID.length== 0){
      console.log('this task has no precedors')

        type = 'time';// for subtask without precedors, il can be passed to pending directely

         SubTask.update({id:st.id},{status:'pending'}).exec(function(err,updateds){
                  if (err) console.log(err)
                    else{
                      SubTask.publishUpdate( updateds[0].id,{status:updateds[0].status});

                      cb(null);
                      //socket reveived pending ,and subtask should be passed in to the window pending in application
                    }

    })
       }else {
        cb(null);
       }

    }],function(err){
      StartCondition.create({type: type, startDate: subtask.beginTime, delay:5}).exec(function(err, start){

      if (err) {console.log(err)}

     // console.log(st.id+ '  '+ start.id)

      //SubTask.update(st.id,{startCondition:start.id}).exec()
      SubTask.update(st.id,{startCondition:start.id}).populate('startCondition').exec(function (err,update){
        SubTask.publishUpdate(update[0].id,{startcondition:update[0].startCondition});
        callback()
      }

      )

      // console.log('start Condition'+start.id+ '//' + 'subtask'+ start.subtask);
    })
    })
     

    
  },

  assigneWaitfor: function(ST,callback){
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
                    console.log(waitforlist);
                    cb2(null,waitforlist);
                  });

                  //console.log('hoho')
                  },
                    
                  function(waitforlist,cb2){
                    //console.log('2 waitforlist'+waitforlist);
                    StartCondition.findOne(ST.startCondition.id).exec(function(err,startcon){
                      while(waitforlist.length != 0){
                        var wf = waitforlist.pop()
                        console.log('st: '+startcon.id+' wf: '+wf);
                        startcon.waitFor.add(wf);
                       
                        // var query = "INSERT INTO startcondition_waitFor__subtask_nextstartconditions(subtask_nextstartconditions,startcondition_waitFor) VALUES ("+startcon.id+","+wf+")";
                        //  StartCondition.query(query,
                        //   function(err,row){if (err){console.log(err)} else {console.log(row[0])}}) 

                      }
                       startcon.save(function(err,res){console.log(res),cb2(null);});
                   //console.log(startcon);
                      
                      
                    })}
                ],function(err){callback()}
           )// end asynwaterfall 2
          },








  generate: function(req, res) {

    var WFC = this;
    var userID = req.session.userID;
    var params = req.params.all();





    async.waterfall([
        function (cb) {

          WFC.getMetaworkflows( params, function () {cb(null)})


        }
      ],
      function (err) {

        res.json({status :'create workflow with intent :'+params.intent})

      }
    )






  },

  getMetaworkflows : function ( params, cb) {
    var WFC = this;

    async.waterfall([
        function (cb2) {

          //Get metaworkflows from "ExternalMetaworkflow" database
          ExternalMetaworkflow.create({intent: params.intent, data: params.data}).exec( function(err, metaworkflow) { cb2(err, metaworkflow) })
        },
        function (metaworkflow, cb2) {


            //Import this metaworkflow in the db
            WFC.importMetaworkflowFromOutside(metaworkflow.intent,metaworkflow.data ,function () {cb2(null)});

        }
      ],

      function (err) {
        cb()
      }

    )




  },

  importMetaworkflowFromOutside: function (intent, metaworkflow, cb) {
    var WFC = this;


    async.waterfall([
        function (cb2) {
          //Create the metaworkflow and link it to the ticket ++add ingredient
          Metaworkflow.create({intent :intent ,title: metaworkflow.title,image:metaworkflow.image}).exec(function (err, metaworkflowCreated) {
            async.each(metaworkflow.ingredient,
              function(ingredient,cb3){
                  Ingredient.create({name:ingredient.name, quantity:ingredient.quantity, unit:ingredient.unit,metaworkflow:metaworkflowCreated.id}).exec(function(err,ingre){cb3(null)});
              },
              function(err){cb2(err, metaworkflowCreated)})
          })
          

            

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

    Metatask.create({idTask: metatask.idTask, metaworkflow: metaworkflowID, agentTypes: metatask.agentTypes, waitFor: metatask.waitFor, name :metatask.name, description:metatask.description })
      .exec(function(err, task) {
        cb(null)
      });  //Create the metatask and link it to the metaworkflow
  }




};
