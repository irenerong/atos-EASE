// var test = require("./arrangeTimeNew");

// //Start after 2 o'clock for example, so type = 0(start), option = 1(after)
// //Initialization with the time table of agents not available
// test.init(
// { type: 0,
//   option: 1,
//   time: new Date("Sun Feb 01 2015 2:00:00 GMT+0100 (CET)") 
// },

// [ 
//  { 
//   id: 0,
//   periodes: 
//    [ 
//    	 { duration: 15,
//        begin: new Date("Sun Feb 01 2015 01:40:00 GMT+0100 (CET)")},
//      { duration: 30,
//        begin: new Date("Mon Feb 01 2015 04:00:00 GMT+0100 (CET)")}
//    ]
//  },

//  {
//   id: 1,
//   periodes: 
//    [ { duration: 60,
//        begin: new Date("Sun Feb 01 2015 03:40:00 GMT+0100 (CET)")}
//    ]
//  },
//  {
//   id: 2,
//   periodes: 
//    [ { duration: 20,
//        begin: new Date("Sun Feb 01 2015 04:40:00 GMT+0100 (CET)")}
//    ]
//  },
//  {
//   id: 3,
//   periodes: 
//    [ { duration: 10,
//        begin: new Date("Sun Feb 01 2015 05:20:00 GMT+0100 (CET)")}
//    ]
//  },
//  {
//   id: 4,
//   periodes: 
//    [ { duration: 19,
//        begin: new Date("Sun Feb 01 2015 06:00:00 GMT+0100 (CET)")  } 
//    ] 
//  }
// ]);

// var res = test.arrange(
//    [ { subTask: 3,
//     duration: 5,
//     predecessor: [ 1 ],
//     beginTime: 0,
//     agentID: 0 },
//   { subTask: 5,
//     duration:   0,
//     predecessor: [ 4 ],
//     beginTime: 0,
//     agentID: 3 },
//   { subTask: 4,
//     duration: 10,
//     predecessor: [ 1, 2 ],
// 	beginTime: 0,
// 	agentID: 2 },
//   { subTask: 2,
//     duration: 20,
//     predecessor: [],
//     beginTime: 0,
//     agentID: 1 },
//   { subTask: 6,
//     duration: 15,
//     predecessor: [ 3, 5 ],
//     beginTime: 0,
//     agentID: 4 },
//   { subTask: 1,
//     duration: 10,
//     predecessor: [],
//     beginTime: 0,
//     agentID: 0 } ]
// )
// console.log(res);



