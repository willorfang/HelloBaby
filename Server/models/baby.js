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
      			callback(null, results[0]);
      		}
      );
};

Baby.prototype.updateAvatar = function(callback) {
	var baby = this;
	db.query("update Baby set avatar=? " +
      		"where id=?",
     		[baby.avatar, baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

Baby.prototype.updateBackground = function(callback) {
	var baby = this;
	db.query("update Baby set background=? " +
      		"where id=?",
     		[baby.background, baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

Baby.prototype.updateStatus = function(callback) {
	var baby = this;
	db.query("update Baby set status=? " +
      		"where id=?",
     		[baby.status, baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

Baby.prototype.getByID = function(callback) {
	var baby = this;
	db.query("select * from Baby where id=?",
     		[baby.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

Baby.prototype.getByName = function(callback) {
	var baby = this;
	db.query("select * from Baby where name=?",
     		[baby.name],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};