var mysql = require('mysql');

var db = mysql.createConnection({
	host: '127.0.0.1',
	user: 'test',
	password: 'test',
	database: 'HelloBaby' 
});

module.exports = User;

function User(obj)
{
	for (var key in obj) {
		this[key] = obj[key];
	}
}

User.prototype.register = function(callback) {
	var user = this;
	db.query("insert into Poster (username, password, baby_id, relationship) " +
      		" VALUES (?, ?, ?, ?)",
     		[user.username, user.password, user.baby_id, user.relationship],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

User.prototype.getByID = function(callback) {
	var user = this;
	db.query("select id, username, baby_id, relationship from Poster " +
			" where id=?",
     		[user.id],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};

User.prototype.getByName = function(callback) {
	var user = this;
	db.query("select id, username, baby_id, relationship from Poster " +
			" where name=? and password=?",
     		[user.name, user.password],
     		function(err, results) {
      			if (err) return callback(err);
      			callback(null, results[0]);
      		}
      );
};