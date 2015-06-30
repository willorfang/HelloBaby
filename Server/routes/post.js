var Post = require('../models/post');

exports.newRecord = function(req, res, next) {
	var data = req.body.record;
	var img_path = null;
	if (req.files.img) {
		img_path = 'img/post/' + req.files.img.name;
	}
	// console.log(req.headers);
	// console.log(req.body);
	// console.log(req.files);

	var post = new Post({
		"content": data.content || null,
		"img": img_path,
		"time": data.time,
		"baby_id": data.baby_id,
		"poster_id": data.poster_id
	});
	// console.log(post);

	post.newRecord(function(err) {
		if (err) return next(err);
		res.send('OK');
	});
};

exports.newComment = function(req, res, next) {
	var data = req.body;

	var post = new Post({
		"id": data.record_id
	});

	post.postComment(data.poster_id, data.content, function(err) {
		if (err) return next(err);
		res.send('OK');
	})
};

exports.addGood = function(req, res, next) {
	var data = req.body;

	var post = new Post({
		"id": data.record_id
	});

	post.postGood(data.poster_id, function(err) {
		var result = {};
		if (err) {
			result.status = false;
		} else {
			result.status = true;
		}
		res.send(JSON.stringify(result, null, 4));
	})
};

// /babies/123456/posts?num=2
exports.listPostsAboutBaby = function(req, res, next) {
	var baby_id = parseInt(req.params.baby_id);
	var page_num = parseInt(req.query.num);
	// console.log("List posts about baby: baby_id=%d, page_num=%d", baby_id, page_num);

	var post = new Post;
	post.listAboutBaby(baby_id, page_num, function(err, posts) {
		if (err) return next(err);
		res.set('Content-Type', "application/json");
		res.send(JSON.stringify(posts, null, 4));
	});
};