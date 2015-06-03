var mysql = require('mysql');

var db = mysql.createConnection({
	host: '127.0.0.1',
	user: 'test',
	password: 'test',
	database: 'HelloBaby' 
});

module.exports = Baby;

function Baby(obj)
{
	for (var key in obj) {
		this[key] = obj[key];
	}
}

Baby.prototype.register = function(callback) {
	var baby = this;
	db.query("insert into Baby (name, birthday, avatar, background, status) " +
      		" VALUES (?, ?, ?, ?, ?)",
     		[baby.name, baby.birthday, baby.avatar, baby.background, baby.status],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results);
      		}
      );
};

Baby.prototype.update = function(callback) {
	var baby = this;
	db.query("update Baby set avatar=?, background=?, status=? " +
      		"where id=?",
     		[baby.avatar, baby.background, baby.status, baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results);
      		}
      );
};

Baby.prototype.getByID = function(callback) {
	var baby = this;
	db.query("select * from Baby where id=?",
     		[baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results);
      		}
      );
};

Baby.prototype.getByName = function(callback) {
	var baby = this;
	db.query("select * from Baby where name=?",
     		[baby.name],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results);
      		}
      );
};

Baby.prototype.list = function(callback) {
	var post = this;
	// get posts
	db.query("select Record.id, Record.content, Record.img, Poster.relationship " +
			"from (Record left join Poster on Record.poster_id = Poster.id) " +
			"where Record.baby_id = ? " +
			"limit ?, ?",
			[ post.baby_id, post.pageNum * perPageCount, (post.pageNum + 1) * perPageCount - 1 ],
			function(err, rows) {
				if (err) return callback(err);
				// get comments and goods
				for(var item in rows) {
					db.query("select Comment.content, Poster.username " +
							"from (Comment left join Poster on Comment.poster_id = Poster.id) "
							"where Comment.record_id = ? ",
							[item.id],
							function(err, comments) {
								if (err) return callback(err);
								item.comments = comments;
							});
					db.query("select count(*) " +
							"from Good "
							"where Good.record_id = ? ",
							[item.id],
							function(err, goodNum) {
								if (err) return callback(err);
								item.goodNum = goodNum;
							});
				}
				//
				setTimeOut(function() {
					callback(null, rows);
				}, 3);
			}
	);
};