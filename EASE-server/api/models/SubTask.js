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
      type: 'json'
    }, 

    // status: {
    // 	type: 'string'
    // }, 

    consumption : {
      type: 'json'
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

