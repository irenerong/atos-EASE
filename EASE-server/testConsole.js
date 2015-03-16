var a = [1,2,3,4,5];
// // a.forEach(function(e,i,a){
// // 	console.log(i);
// // });
// // var ArrangeElement = function(subTask, duration, startCondition){ 
// // 	this._subTask = subTask;
// // 	this._duration = duration;
// // 	this._startCondition = startCondition;
// // };

// // var myObj = new ArrangeElement("cook",40,null);
// // console.log(myObj._subTask);
// var c = "out";
// var b = a.filter(function(e,i,a){
// 	console.log(c);
// 	if(e <3)
// 		return true;
// 	return false;
// });
// console.log(b);

// var d = a.reduce(function(previousValue, currentValue, index, array) {
//   		return previousValue + currentValue;
//   	}
// 	);
// console.log(d);

// var e = 1;
// e+=2;
// console.log(e);

// var f = [1: {a,c}, 2:{c,a}];
// var b = function(){
// 	this.name = "he";
// }
// b.prototype.say = function(){
// 	return "hello "+this.name;
// }
// var bb = new b();
// var c = bb.say();
// console.log(c);
// console.log(bb.name);

// console.log(typeof bb);
// console.log(Math.max.apply(null,a));
// var ArrangeElement = function(subTask, duration, predecessor, agentID){ 
// 	this._subTask = subTask;
// 	this._duration = duration;
// 	this._predecessor = predecessor;
// 	this._beginTime = 0;
// 	this._agentID = agentID;
// };
// ArrangeElement.prototype.getPreds = function(arrangeElements){
// 	var preds = new Array();
// 	for (var i = arrangeElements.length - 1; i >= 0; i--) {
// 		if(this._predecessor.indexOf(arrangeElements[i]._subTask) != -1)
// 			preds.push(arrangeElements[i]);
// 	}
// 	return preds;
// };
// ArrangeElement.prototype.getSuccs = function(arrangeElements){
// 	var succs = [];
// 	for (var i = arrangeElements.length - 1; i >= 0; i--) {
// 		if(arrangeElements[i]._predecessor.indexOf(this._subTask) != -1)
// 			succs.push(arrangeElements[i]);
// 	};
// 	return succs;
// };

// //Sort the sub tasks in oder that whichever of them is bebind his precedessors.
// function sortTasks(arrangeElements){
// 	var length = arrangeElements.length;
// 	var res = [];
// 	var predsDone = true;
// 	var preds = [];
// 	while(res.length != length){
// 		arrangeElements.forEach(function(e,i,a){
// 			predsDone = true;
// 			if(e.getPreds(arrangeElements).length == 0){
// 				res.push(e); // Push it into the final array
// 				arrangeElements.splice(arrangeElements.indexOf(e),1);
// 			}
// 			else{
// 				preds = e.getPreds(arrangeElements);
// 				for (var i = preds.length - 1; i >= 0; i--) {
// 					if(preds[i]._beginTime == 0){
// 						predsDone = false;
// 						break;
// 					}
// 				};
// 				if(predsDone){
// 					res.push(e);
// 					arrangeElements.splice(arrangeElements.indexOf(e),1);
// 				}

// 			}			
// 		});
// 	}
// 	return res;
// };

// var ae1 = new ArrangeElement(1, 10, [] , 0);
// var ae2 = new ArrangeElement(2, 20, [] , 1);
// var ae3 = new ArrangeElement(3, 5 , [1,4,5], 0);
// var ae4 = new ArrangeElement(4, 10, [1,2], 2);
// var ae5 = new ArrangeElement(5, 30, [4], 3);
// var ae6 = new ArrangeElement(6, 15, [3,5], 4);
// // var ae  = [ae1, ae2, ae3, ae4, ae5, ae6];
// var ae  = [ae5, ae4, ae1, ae3, ae6, ae2];
// // console.log(ae1.getSuccs(ae));
// var res1 = sortTasks(ae);
// res1.forEach(function(e,i,a){console.log(e._subTask)})
var Arrangement = function(){
	
};

Arrangement.afficher = function(){
	this.show();
}
Arrangement.show = function(){
	console.log("haha!!");
}

module.exports = Arrangement;

