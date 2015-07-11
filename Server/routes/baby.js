var Baby = require('../models/baby');
var response = require('./util').response;

exports.register = function(req, res, next) {
	var data = req.body.baby;
	var avatar_path = null, background_path = null;
	if (req.files.avatar) {
		avatar_path = 'img/avatar/' + req.files.avatar.name;
	}
	if (req.files.background) {
		background_path = 'img/avatar/' + req.files.background.name;
	}
	// console.log(data);
	// console.log(req.files);

	var baby = new Baby({
		"name" : data.name,
		"birthday": data.birthday,
		"avatar": avatar_path,
		"background": background_path,
		"status": data.status
	});

	baby.register(function(err) {
		response(res, err, null);
	});
};

// /babies/123456
exports.getInfoByID = function(req, res, next) {
	var baby_id = parseInt(req.params.baby_id);
	var baby = new Baby({
		"id": baby_id
	});

	baby.getByID(function(err, result) {
		response(res, err, result);
	});
};