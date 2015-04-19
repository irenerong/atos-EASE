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

  	
  	taskAgentAdaptationInfos: {
  		model: 'TaskAgentAdaptationInfos'
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
    finish: function() {
      console.log("dans finish")
      SubTask.update({id:this.id},{status:'finish'}).exec(function (err,updateds){
        if (err) console.log(err);
            SubTask.publishUpdate(updateds[0].id,{ status:updateds[0].status });
          });
      SubTask.findOne({id:this.id}).populate('nextStartConditions').exec(function (err,st){
        st.nextStartConditions.forEach(function(nsc,i,a){
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
                      SubTask.publishUpdate( updateds[0].id);
                      //socket reveived pending ,and subtask should be passed in to the window pending in application
                    }

                })

              })// end subtask findone

            }// finish == true
          })// end condition Met

        })// end foreach
      })
    },

    start: function() {
      // var subtask = this;
      // var duree= subtask.duration;
      // var myVar=setInterval(myTimer, 100);//1000
      // function myTimer() {
      //   if (duree > 0) {
      //     duree= duree-1;
      //     console.log(duree+ " left before finish");
      //   }
      //   else{
      //     console.log("avant d'entrer dans finish")
      //     clearInterval(myVar);
      //     subtask.finish();
      //     return;
      //   }
      // }
      var socket = sails.sockets.subscribers(this.agent+"")[0];
      // console.s(socket)
      // console.log(sails.sockets.id(socket)+" idsddd")
      sails.sockets.emit(socket, 'youcanstart',{duration: this.duration, subTaskID:this.id})
    },
   

    
    


    /*START CONDITION
      
    */
    

    startCondition: {
      model: 'StartCondition'
    }, 

    nextStartConditions: {
      collection: 'StartCondition', 
      via: 'waitFor'
    }

  }, 
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
      var querySQL = "SELECT * FROM (SELECT ST.WORKFLOW, ST.TASKID,ST.waitforID,ST.TaskAgentAdaptationInfos,ST.Agent,ST.action, ST.consumption, ST.STATUS,ST.DURATION, ST.StartCondition, ST.ID, SC.STARTDATE, SC.TYPE, SC.DELAY FROM SUBTASK ST JOIN STARTCONDITION SC ON SC.id = ST.STARTCONDITION) RES WHERE RES.STARTDATE REGEXP '"+jour+".*'  "
      SubTask.query(querySQL, function(err, result){
        if (err) {
              return cb(false)
        }
        cb(result);
      })



  },

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

  finishSubtask : function (id, cb){
    Subtask.update({id:id},{status:'finish'}).exec(function (err, subtasks) {

      console.log("subtask "+subtasks[0].id+" is finish");
      SubTask.publishUpdate(subtasks[0].id);

    })
  }
};

