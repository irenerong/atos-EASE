/**
* SubTask.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    workflow:{
      model: 'Workflow'
    },
    metatask:{
      model:'Metatask'

    },
    taskID :{

      type :'integer'

    },
    waitforID :{
      type: 'array'

    },

    agent: {
      model: 'Agent'
    }, 

    action: {
      type: 'JSON'
    }, 

    consumption : {
      type: 'JSON'
    },

    status :{
      type: 'string',
      enum:['waiting','pending','start','finish'],
      defaultsTo : 'waiting'
    },
    duration :{
      type :'integer',
      required : true 

    },
    timeLeft :{
      type :'integer',
      required: true
    },
    // When a subtask finishes, change his status and see if his successors could begin, if so, change the status of his successors to "pending"
     finish: function() {
      var at = "";
      var oldThis = this;
      // console.s(socket)
      // console.log(sails.sockets.id(socket)+" idsddd")
      Agent.findOne(oldThis.agent).exec(function(err,agent){
        if (err) 
          console.log(err) 
        else{
          at = agent.agentType;
          var socket = sails.sockets.subscribers(at+"")[0];
          // console.log(sails.sockets.id(socket)+" idsddd")
          if (socket)
              sails.sockets.emit(socket, 'stop', null)

        }
        
         })






      console.log("in finish "+this.id);
                SubTask.update({id:this.id},{status:'finish'}).exec(function(err,updateds){
        if (err) console.log(err);
            SubTask.publishUpdate(updateds[0].id,{ status:updateds[0].status });
          });
      SubTask.findOne({id:this.id}).populate('nextStartConditions').exec(function (err,st){
        st.nextStartConditions.forEach(function(nsc,i,a){
          console.log('in next start condition '+nsc);
          nsc.conditionsMet(function callback(finish){
            if (finish==true)
            {
              console.log("finish true!!!! nextstartCondition id "+ nsc.id)
              SubTask.findOne({startCondition:nsc.id}).exec(function (err,st2){
                //st2.pending TODO
                console.log(st2.id + ' should be in pending')
                SubTask.update({id:st2.id},{status:'pending'}).exec(function(err,updateds){
                  if (err) console.log(err)
                    else{
                      SubTask.publishUpdate( updateds[0].id,{status: updateds[0].status});
                      //socket reveived pending ,and subtask should be passed in to the window pending in application
                    }

                })

              })// end subtask findone

            }// finish == true
          })// end condition Met

        })// end foreach
      })
    },
    // Finds the right agent to start a subtask by using the socket
    start: function(cb) {

      var at = "";
      var oldThis = this;
      // console.s(socket)
      // console.log(sails.sockets.id(socket)+" idsddd")
      Agent.findOne(oldThis.agent).exec(function(err,agent){
        if (err) 
          console.log(err) 
        else{
          at = agent.agentType;
          var socket = sails.sockets.subscribers(at+"")[0];
          // console.log(sails.sockets.id(socket)+" idsddd")
          if (socket){
              sails.sockets.emit(socket, 'youcanstart',{duration: oldThis.duration, subTaskID:oldThis.id, action:oldThis.action})

                cb(true)
          }
          else{
            console.log(agent.agentType+' is not connected, please open the page http://localhost:1337/'+agent.agentType+'.html and try again');
               cb(false);   
          }
        }
        
      })
    
    },
   


    
    


    /*START CONDITION

    for each subtask , il has his own start condition which stores all condition need to be confirmed to start this task
    this startcondition contains: the precedors of the subtasks (which subtask need to wait before they finish execution )
                                : the estimated start time of this subtask

      
    */
    


    startCondition: {
      model: 'StartCondition'
    }, 
   /* NEXT START CONDITION
      in fact next start condition contains this subtask's succedors information, but two subtask  can't be linked toghether directely,
      because there're always their startcondition between them
      
      startcondt1 startcondt2
          |             |
        Subtask1    Subtask2
           \           /
             \       /
            startcondit3  (and here the startcondition3 is the nextstartconditions for subtask1 and subtask2)
                  |
              Subtask3


   */

    nextStartConditions: {
      collection: 'StartCondition', 
      via: 'waitFor'
    }

  }, 
  // Gets all the subtasks of a given day
  allSubTasks : function(date,cb){
      var jour = "";
      var day = new Date(date)
      jour = jour + day.getFullYear()+ "-";
      if(day.getMonth()<9)
        jour = jour + "0" + (day.getMonth()+1)
      else
        jour = jour + (day.getMonth()+1);
      jour = jour +"-";
      if(day.getDate() < 9)
        jour = jour + "0" + day.getDate();
      else
        jour = jour + day.getDate();
      console.log(jour)
      var subtasks = [];
      var querySQL = "SELECT * FROM (SELECT ST.WORKFLOW, ST.TASKID,ST.waitforID,ST.Agent,ST.action, ST.consumption, ST.STATUS,ST.DURATION, ST.StartCondition, ST.ID, SC.STARTDATE, SC.TYPE, SC.DELAY FROM SUBTASK ST JOIN STARTCONDITION SC ON SC.id = ST.STARTCONDITION) RES WHERE RES.STARTDATE REGEXP '"+jour+".*'  "
      SubTask.query(querySQL, function(err, result){
        if (err) {
              return cb(false)
        }
        cb(result);
      })



  },
  // Another function to get all the subtasks of a day
  allSubTasks2 : function(date, cb) {

    var day = new Date(date);
    day.setHours(0);
    day.setMinutes(0);
    day.setMilliseconds(0);

    var tomorrow = new Date(day);
    tomorrow.setDate(day.getDate()+1)

    console.log('Day : ' + day + ' - Tomorrow : ' + tomorrow);

    SubTask.find().populate('startCondition')
    .exec(function (err, results)
    {
      if (err)
      {
        return cb(err);
      }
      cb(results);
    })

  }

  ,

  afterDestroy: function (subtask, cb) {
    sails.log('Destroy subtask : ' + JSON.stringify(subtask))
    cb()
  },
  // After a subtask is finished
  finishSubtask : function (id, cb){
    Subtask.update({id:id},{status:'finish'}).exec(function (err, subtasks) {

      console.log("subtask "+subtasks[0].id+" is finish");
      SubTask.publishUpdate(subtasks[0].id,{status:subtasks[0].status});

    })
  }
};

