# reset database
drop database if exists HelloBaby;
create database HelloBaby;
use HelloBaby;

# Baby
create table if not exists Baby (
	id INT unsigned NOT NULL AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	birthday DATE NOT NULL,
	avatar VARCHAR(255),
	background VARCHAR(255),
	status VARCHAR(255),
	PRIMARY KEY(id)
);

# Poster
create table if not exists Poster (
	id INT unsigned NOT NULL AUTO_INCREMENT,
	username VARCHAR(64) NOT NULL,
	password VARCHAR(20) NOT NULL,
	baby_id INT unsigned NOT NULL,
	# 1:mom, 2:dad, 3:uncle, 4:aunt
	relationship TINYINT unsigned NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (baby_id) REFERENCES Baby(id)
);

# Record
create table if not exists Record (
	id BIGINT unsigned NOT NULL AUTO_INCREMENT,
	content text,
	img VARCHAR(255),
	baby_id INT unsigned NOT NULL,
	poster_id INT unsigned NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (baby_id) REFERENCES Baby(id),
	FOREIGN KEY (poster_id) REFERENCES Poster(id)
);

# Comment
create table if not exists Comment (
	id BIGINT unsigned NOT NULL AUTO_INCREMENT,
	content text,
	record_id BIGINT unsigned NOT NULL,
	poster_id INT unsigned NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (record_id) REFERENCES Record(id),
	FOREIGN KEY (poster_id) REFERENCES Poster(id)
);

# Good
create table if not exists Good (
	record_id BIGINT unsigned NOT NULL,
	poster_id INT unsigned NOT NULL,
	PRIMARY KEY(record_id, poster_id),
	FOREIGN KEY (record_id) REFERENCES Record(id),
	FOREIGN KEY (poster_id) REFERENCES Poster(id)
);

