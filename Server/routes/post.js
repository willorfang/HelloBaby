var Post = require('../models/post');

exports.newRecord = function(req, res, next) {
	var data = req.body.record;

	var post = new Post({
		"content": data.content,
		"img": data.img,
		"baby_id": data.baby_id,
		"poster_id": data.poster_id
	});

	post.newRecord(function(err) {
		if (err) return next(err);
		res.send('OK');
	})
};

exports.listPostsAboutBaby = function(req, res, next) {
	var baby_id = parseInt(req.params.baby_id);
	var page_num = parseInt(req.query.num);
	console.log("List posts about baby: baby_id=%d, page_num=%d", baby_id, page_num);

	var post = new Post;
	post.listAboutBaby(baby_id, page_num, function(err, posts) {
		if (err) return next(err);
		res.set('Content-Type', "application/json");
		res.send(JSON.stringify(posts, null, 4));
	})
};