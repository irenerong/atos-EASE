

module.exports = {
  cartesianProduct: function (array) {
    return _.reduce(array, function(a, b) {
        return _.flatten(_.map(a, function(x) {
            return _.map(b, function(y) {
                return x.concat([y]);
            });
        }), true);
    }, [ [] ]);
}, 

  sumKeysOfJSON: function (JSON1, JSON2) {

    var toReturn = JSON1

    for (key in JSON2) {
      if (!toReturn[key]) 
        toReturn[key] = JSON2[key]
      else
        toReturn[key] += JSON2[key]
    }

    return toReturn

  }
}

 