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
  		type: 'json'
  	},

    // tasks: {
    //   collection: 'Task',
    //   via: 'workflow'
    // }, 

    subtasks: {
      collection: 'SubTask',
      via: 'workflow'
    },

    metaworkflow : {
      model: 'Metaworkflow'
    },

    duration:{
      type : 'integer'
    },

    consumption :{
      type : 'float'
    },
    color :
    {
      type : 'integer'
    }
  },
     

   afterDestroy: function (workflow, cb) {
    sails.log('Destroy workflow')
    Task.destroy({workflow: workflow.id}).exec(function (err) {return cb()})
   }


};

