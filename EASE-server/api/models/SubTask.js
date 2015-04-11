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

      SubTask.update({id:this.id},{isDone:true}).exec(function (err,updateds){
        if (err) console.log(err);
            SubTask.publishUpdate(updateds[0].id,{ isDone:updateds[0].isDone });
          });
      SubTask.findOne({id:this.id}).populate('nextStartConditions').exec(function (err,st){
        st.nextStartConditions.forEach(function(nsc,i,a){
          nsc.conditionsMet(function callback(finish){
            if (finish==true)
            {

              SubTask.findOne({startCondition:this.id}).exec(function (err,st2){
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
      var subtask = this;
      var duree= subtask.duration;
      var myVar=setInterval(myTimer, 100);//1000
      function myTimer() {
        if (duree > 0) {duree= duree-1;
            console.log(duree+ " left before finish");}

        else {
          clearInterval(myVar);
          subtask.finish();
          return;
        }
      }
      var socket = sails.sockets.subscribers(this.agent+"")[0];
      // console.s(socket)
      // console.log(sails.sockets.id(socket)+" idsddd")
      sails.sockets.emit(socket, 'youcanstart',{duration: this.duration})
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
  allSubTasks : function(date){
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
      var querySQL = "SELECT * FROM (SELECT STARTDATE, ST.ID FROM StartCondition SC JOIN SUBTASK ST ON SC.id = ST.STARTCONDITION) RES WHERE RES.STARTDATE REGEXP '"+jour+".*'  "
      SubTask.query(querySQL, function(err, result){
        if (err) {
              return cb(false)
        }
        console.log(result)
      })
  },

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

