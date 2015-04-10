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

    // status: {
    // 	type: 'string'
    // }, 

    consumption : {
      type: 'JSON'
    },

    isDone :{
      type: 'boolean',
      defaultsTo : false
    },
    duration :{
      type :'integer',
      required : true 

    },
    finish: function() {

      SubTask.update({id:this.id},{isDone:true}).exec(function update(err,updated){
            SubTask.publishUpdate(updated[0].id,{ isDone:updated[0].isDone });
          });
    },

    start: function() {
      var duree= this.duration;
      var myVar=setInterval(function () {myTimer()}, 1000);
      function myTimer() {
        if (duree > 0) {duree= duree-1;
            console.log(duree+ " left before finish");}

        else {
          clearInterval(myVar);
          this.finish();
          return;
        }
      }

    },
    // valide: function() {
    //   console.log(this.agent);
    //   console.log(this.agent.)
    // }

    
    


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
    Subtask.update({id:id},{isDone:true}).exec(function (err, subtask) {

      console.log("subtask "+subtask.id+" is finish");

    })
  }
};

