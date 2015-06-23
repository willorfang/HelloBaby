# HelloBaby
----------------------------------------------------------
## Introduction
A service to post, manage, share the most precious time and stories of your children.
  - daddy, mommy, grandpa, grandma, uncles, aunts post to the same space.
  - comment, good
  - read stories of other children.
  - more ...

## Version
0.0.0

----------------------------------------------------------
## Preparation
### Database
1. install mysql
```sh
brew install mysql
mysql.server start
```
2. create user
```sh
mysql -u root
create user 'test' identified by 'test';
```
3. initialize database
```sh
cd Server/bin/scripts
./init_database.sh
```

### Make it run
1. server
```sh
$ brew install npm
$ npm install
$  ./bin/www 
```
2. client
```sh
$ run HelloBaby/HelloBaby.xcodeproj
```
----------------------------------------------------------

## Todo's
* popular posts page
* https
* encrypt password in the database
* profile page
* activities
* ...

----------------------
## License
MIT
