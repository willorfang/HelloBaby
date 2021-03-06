var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var multer  = require('multer');

var routes = require('./routes/index');
var user = require('./routes/user');
var post = require('./routes/post');
var baby = require('./routes/baby');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
// get user info 
app.get('/users/:user_id', user.getUserInfo);
// user login
app.post('/login', user.login);
// new a comment
app.post('/comments', post.newComment);
// add a good
app.post('/goods', post.addGood);
// new a post
app.post('/posts', [ multer({ dest: path.join(__dirname, "public/img/post")}), post.newRecord ]);
// get posts about a baby
app.get('/babies/:baby_id/posts', post.listPostsAboutBaby);
// new a baby
app.post('/babies', [ multer({ dest: path.join(__dirname, "public/img/avatar")}), baby.register]);
// get info of a baby
app.get('/babies/:baby_id', baby.getInfoByID);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
