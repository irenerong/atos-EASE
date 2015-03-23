var test = require("./arrangeTimeNew");

//Start after 2 o'clock for example, so type = 0(start), option = 1(after)
//Initialization with the time table of agents not available
test.init(
{ _type: 0,
  _option: 1,
  _time: new Date("Sun Feb 01 2015 2:00:00 GMT+0100 (CET)") 
},

[ 
 { 
  _id: 0,
  _periodes: 
   [ 
   	 { _duration: 15,
       _begin: new Date("Sun Feb 01 2015 01:40:00 GMT+0100 (CET)")},
     { _duration: 30,
       _begin: new Date("Mon Feb 01 2015 04:00:00 GMT+0100 (CET)")}
   ]
 },

 {
  _id: 1,
  _periodes: 
   [ { _duration: 60,
       _begin: new Date("Sun Feb 01 2015 03:40:00 GMT+0100 (CET)")}
   ]
 },
 {
  _id: 2,
  _periodes: 
   [ { _duration: 20,
       _begin: new Date("Sun Feb 01 2015 04:40:00 GMT+0100 (CET)")}
   ]
 },
 {
  _id: 3,
  _periodes: 
   [ { _duration: 10,
       _begin: new Date("Sun Feb 01 2015 05:20:00 GMT+0100 (CET)")}
   ]
 },
 {
  _id: 4,
  _periodes: 
   [ { _duration: 19,
       _begin: new Date("Sun Feb 01 2015 06:00:00 GMT+0100 (CET)")  } 
   ] 
 }
]);

var res = test.arrange(
   [ { _subTask: 3,
    _duration: 5,
    _predecessor: [ 1 ],
    _beginTime: 0,
    _agentID: 0 },
  { _subTask: 5,
    _duration:   0,
    _predecessor: [ 4 ],
    _beginTime: 0,
    _agentID: 3 },
  { _subTask: 4,
    _duration: 10,
    _predecessor: [ 1, 2 ],
	_beginTime: 0,
	_agentID: 2 },
  { _subTask: 2,
    _duration: 20,
    _predecessor: [],
    _beginTime: 0,
    _agentID: 1 },
  { _subTask: 6,
    _duration: 15,
    _predecessor: [ 3, 5 ],
    _beginTime: 0,
    _agentID: 4 },
  { _subTask: 1,
    _duration: 10,
    _predecessor: [],
    _beginTime: 0,
    _agentID: 0 } ]
)
console.log(res);



