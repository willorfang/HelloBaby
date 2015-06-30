var mysql = require('mysql');

var db = mysql.createConnection({
	host: '127.0.0.1',
	user: 'test',
	password: 'test',
	database: 'HelloBaby' 
});

module.exports = Post;

/* 
{
	poster_id:              // post only
	content:
	img:
	relationship:           // get only
	pageNum:                // get only
	comments: [{            // get only
		username:
		content:
		},
		...
	]
	goodNum:                // get only
}
*/
function Post(obj)
{
	for (var key in obj) {
		this[key] = obj[key];
	}
}

Post.prototype.newRecord = function(callback) {
	var post = this;
	db.query("insert into Record (content, img, time, baby_id, poster_id) " +
      		" VALUES (?, ?, ?, ?, ?)",
     		[post.content, post.img, post.time, post.baby_id, post.poster_id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
    );
};

// required: record id
Post.prototype.getRecordByID = function(callback) {
	var post = this;
	db.query("select * from Record where id=?",
     		[post.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results);
      		}
    );
};

// required: record id
Post.prototype.getCommentsByID = function(callback) {
	var post = this;
	db.query("select Comment.content, Poster.username " +
			"from (Comment left join Poster on Comment.poster_id = Poster.id) " +
			"where Comment.record_id = ? ",
			[post.id],
			function(err, comments) {
				// console.log("Comment: id=%d, %s", post.id, JSON.stringify(comments));
				if (err) return callback(err);
				callback(null, comments);
			}
	);
};

// required: record id
Post.prototype.postComment = function(poster_id, content, callback) {
	var post = this;
	db.query("insert into Comment (content, record_id, poster_id) " +
			" values(?, ?, ?)",
			[content, post.id, poster_id],
			function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
	);
};

Post.prototype.postGood = function(poster_id, callback) {
	var post = this;
	db.query("insert into Good (record_id, poster_id) " +
			" values(?, ?)",
			[post.id, poster_id],
			function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
	);
};

// required: record id
Post.prototype.getGoodsByID = function(callback) {
	var post = this;
	db.query("select count(*) as count " +
			"from Good " +
			"where Good.record_id = ? ",
			[post.id],
			function(err, result) {
				// console.log("Good: id=%d, %s", post.id, JSON.stringify(result));
				if (err) return callback(err);
				callback(null, result[0].count);
			}
	);
};

// required: record id
Post.prototype.getRecordWithAllByID = function(callback) {
	var post = this;
	post.getRecordByID(function(err, results) {
		if (err) return callback(err);
		var post = results[0];
		post.getCommentsByID(function(err, result) {
			if (err) return callback(err);
			post = result;
			post.getGoodsByID(function(err, result) {
				if (err) return callback(err);
				post = result;
				callback(null, post);
			});
		});
	});
};

var per_page_count = 20;

// required: none
Post.prototype.listAboutBaby = function(baby_id, page_num, callback) {
	// get posts
	db.query("select Record.id, Record.content, Record.img, Record.time, Poster.relationship " +
			"from (Record left join Poster on Record.poster_id = Poster.id) " +
			"where Record.baby_id = ? " +
			"order by Record.time desc " +
			"limit ?, ?",
			[ baby_id, page_num * per_page_count, (page_num + 1) * per_page_count - 1 ],
			function(err, rows) {
				if (err) return callback(err);
				// get comments and goods
				var length = rows.length;
				var count = 0;
				for(var i = 0; i < length; ++i) {
					var post = new Post(rows[i]);
					// attention: cache i & post
					(function(index, post) {
						post.getCommentsByID(function(err, result) {
							if (err) return callback(err);
							post.comments = result;
							// console.log("Test: " + JSON.stringify(post));
							post.getGoodsByID(function(err, result) {
								if (err) return callback(err);
								post.goodNum = result;
								rows[index] = post;
								++count;
								if (count >= length) {
									callback(null, rows);
								}
							});
						});
					}(i, post));
				}
			}
	);
};