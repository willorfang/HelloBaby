var User = require('../models/user');
var Baby = require('../models/baby');

// /users/123456
exports.getUserInfo = function(req, res, next) {
	var user_id = parseInt(req.params.user_id);
	
	var user = new User({
		"id": user_id
	});
	user.getByID(function(err, user) {
		if (err) return next(err);
		// get baby info
		var baby = new Baby({
			"id": user.baby_id
		});
		baby.getByID(function(err, baby) {
			if (err) return next(err);
			user.baby = baby;
			user.baby_id = undefined;
			res.set('Content-Type', "application/json");
			res.send(JSON.stringify(user, null, 4));
		});
	});
};

// /login
exports.login = function(req, res, next) {
	var data = req.body;
	// console.log(data);

	var user = new User({
		"username": data.username,
		"password": data.password
	});
	// console.log(user);
	user.getByName(function(err, user) {
		if (err) return next(err);
		// get baby info
		var baby = new Baby({
			"id": user.baby_id
		});
		baby.getByID(function(err, baby) {
			if (err) return next(err);
			user.baby = baby;
			user.baby_id = undefined;
			res.set('Content-Type', "application/json");
			res.send(JSON.stringify(user, null, 4));
		});
	});
};