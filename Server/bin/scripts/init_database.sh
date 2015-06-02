#!/bin/bash

# need to create user firstly.
# 1) mysql -u root
# 2) create user test@localhost identified by 'test'
# 3) grant all privileges on hellobaby.* to test@localhost
# 4) flush privileges

mysql -u test -ptest < create.sql
mysql -u test -ptest < data.sql
