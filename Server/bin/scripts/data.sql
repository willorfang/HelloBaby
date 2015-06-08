use HelloBaby;

# Baby
insert into Baby(name, birthday, avatar, background, status)
		values	('豆豆', '2013-12-10', null, null, '豆豆是个好宝宝！'),
				('毛毛', '2013-08-14', null, null, '毛毛是个好宝宝！'),
				('花花', '2012-11-21', null, null, '花花是个好宝宝！');

# Poster
insert into Poster(username, password, baby_id, relationship)
		values	('mom1', 'mom1', 1, 1),
				('dad1', 'dad1', 1, 2),
				('mom2', 'mom2', 2, 1),
				('dad3', 'dad3', 3, 2),
				('uncle3', 'uncle3', 3, 3);

# Record
insert into Record(content, img, time, baby_id, poster_id)
		values('看我的舌头真好看!', 'img/post/baby1-1.jpg', '2009-08-03 10:20:13', 1, 1),
			('看我的舌头真好看!', 'img/post/baby1-2.jpg', '2010-10-03 10:20:13', 1, 1),
			('看我的舌头真好看!', 'img/post/baby1-3.jpg', '2009-09-13 00:21:10', 1, 1),
			('看我的舌头真好看!', 'img/post/baby1-4.jpg', '2013-05-24 13:20:13', 1, 1),
			('看我的舌头真好看!', 'img/post/baby1-5.jpg', '2009-11-23 22:34:22', 1, 2),
			('看我的舌头真好看!', 'img/post/baby2-1.jpg', '2011-04-09 07:43:54', 2, 3),
			('看我的舌头真好看!', 'img/post/baby2-2.jpg', '2011-12-24 16:22:25', 2, 3),
			('看我的舌头真好看!', 'img/post/baby2-3.jpg', '2015-01-05 19:11:15', 2, 3),
			('看我的舌头真好看!', 'img/post/baby3-1.jpg', '2014-08-15 11:21:14', 3, 5);

# Comment
insert into Comment(content, record_id, poster_id)
		values	('真可爱!', 1, 1),
				('赞!', 1, 2),
				('卡哇伊!卡哇伊!卡哇伊!卡哇伊!卡哇伊!卡哇伊!卡哇伊!卡哇伊!卡哇伊!', 1, 3),
				('呃呃呃呃呃呃', 1, 4),
				('真可爱真可爱真可爱真可爱真可爱!', 2, 1),
				('哇哇哇哇哇哇!', 2, 3);

# Good
insert into Good(record_id, poster_id)
		values	(1, 1),
				(1, 2),
				(1, 3),
				(1, 4),
				(1, 5),
				(3, 1),
				(3, 4);