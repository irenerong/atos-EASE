/**
* StartCondition.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {

  	type: {
  		type: 'string'
  	}, 
  	waitFor: {
  		collection: 'SubTask', 
  		via: 'nextStartConditions',
      dominant: true
  	}, 

  	startDate: {
  		type: 'datetime'
  	}, 

  	delay: {
  		type: 'integer'
  	}, 

    // When all the predecessors of a subtask are finished
  	conditionsMet: function(cb) {
      var thisID=this.id;
      var pending=true
  		if (this.type == 'time') {

  		}
  		else if (this.type == 'wait') {
        console.log('startcondition ID '+this.id);
        SubTask.find({status:{'!':'finish'}}).populate('nextStartConditions').exec(function(err,sts){

          if (err){console.log(err),cb(false)}

          else {
            async.each(sts,function(st,cb2){
               st.nextStartConditions.forEach(function(nsc,i,a){

              if (nsc.id ==thisID ){

                pending=false;

              }

            })
               cb2(null);
            },function(err){
              cb(pending);
            })

           
            
          } 
        })
  			

  				}

  				
  		
  	}

  }

};

