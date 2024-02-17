_ = {
    predicateNameStack: [],
    predicateCounter: 0,
    predicateGensym : function () {
	let name = `pred_${_.predicateCounter}`;
	_.predicateCounter += 1;
	return name;
    },
    pushNewPredicateName : function () {
	_.predicateNameStack.push (_.predicateGensym ());
	return "";
    },
    topPredicateName : function () {
	return _.predicateNameStack [_.predicateNameStack.length - 1];
    },
    popPredicateName : function () {
	_.predicateNameStack.pop ();
	return "";
    }
}
,
