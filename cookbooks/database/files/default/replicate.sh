#!/bin/bash

HOST1="$1"
HOST2="$2"
ROOTPASS="$3"



echo "set replication user on ${HOST1}"
mysql -h ${HOST1} -u root -p${ROOTPASS} -e "create user 'replicator'@'%' identified by '123123';"
mysql -h ${HOST1} -u root -p${ROOTPASS} -e "grant replication slave on *.* to 'replicator'@'%'; "

MYRESP=$(mysql -h ${HOST1} -u root -p${ROOTPASS} -e 'show master status;' | tail -n1 | sed -r 's/\s+/|/g')
BINLOG1=$(echo "${MYRESP}" | cut -f1 -d '|')
POSLOG1=$(echo "${MYRESP}" | cut -f2 -d '|')

echo "set replication user on ${HOST2}"
mysql -h ${HOST2} -u root -p${ROOTPASS} -e "create user 'replicator'@'%' identified by '123123';"
#mysql -h ${HOST2} -u root -p${ROOTPASS} -e "create database example;"
mysql -h ${HOST2} -u root -p${ROOTPASS} -e "grant replication slave on *.* to 'replicator'@'%'; "

echo "seting replication"
mysql -h ${HOST2} -u root -p${ROOTPASS} -e "slave stop; CHANGE MASTER TO MASTER_HOST = '${HOST1}', MASTER_USER = 'replicator', MASTER_PASSWORD = '123123', MASTER_LOG_FILE = '${BINLOG1}', MASTER_LOG_POS = ${POSLOG1}; slave start;"

MYRESP=$(mysql -h ${HOST2} -u root -p${ROOTPASS} -e 'show master status;' | tail -n1 | sed -r 's/\s+/|/g')
BINLOG2=$(echo "${MYRESP}" | cut -f1 -d '|')
POSLOG2=$(echo "${MYRESP}" | cut -f2 -d '|')

echo "seting replication"
mysql -h ${HOST1} -u root -p${ROOTPASS} -e "slave stop; CHANGE MASTER TO MASTER_HOST = '${HOST2}', MASTER_USER = 'replicator', MASTER_PASSWORD = '123123', MASTER_LOG_FILE = '${BINLOG2}', MASTER_LOG_POS = ${POSLOG2}; slave start;"

mysql -h ${HOST1} -u root -p${ROOTPASS} -e "create table example.pathlogs (`id` varchar(30) PRIMARY KEY, `path` text);"

echo "adding web users"
mysql -h ${HOST1} -u root -p${ROOTPASS} -e "CREATE USER 'webuser'@'%' IDENTIFIED BY 'webuser'; GRANT ALL PRIVILEGES ON example.* TO 'webuser'@'%' WITH GRANT OPTION;"
mysql -h ${HOST2} -u root -p${ROOTPASS} -e "CREATE USER 'webuser'@'%' IDENTIFIED BY 'webuser'; GRANT ALL PRIVILEGES ON example.* TO 'webuser'@'%' WITH GRANT OPTION;"

exit 0
