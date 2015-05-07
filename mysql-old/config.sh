#!/bin/bash

echo "create database eid; create database pcollecta" | mysql -uroot -p$MYSQL_ROOT_PASSWORD

mysql -uroot eid -p$MYSQL_ROOT_PASSWORD < /tmp/eid-1.3.7.dump
mysql -uroot pcollecta -p$MYSQL_ROOT_PASSWORD < /tmp/pcollecta-1.3.7.dump
