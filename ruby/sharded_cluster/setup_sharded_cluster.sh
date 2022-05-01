#!/bin/bash

set -e

echo Remove "data" directory...
rm -rf ~/data
echo Complete Remove "data" directory...

echo
echo "########################################"
echo "# MongoDB Sharded Cluster Setup Script #"
echo "########################################"
echo
echo mkdir ~/data
mkdir ~/data

echo
echo To cleanup the data being used, just delete the "data" directory
echo




echo
echo "#####################"
echo "# Setting up Shards #"
echo "#####################"
echo
echo Creating all the data directories for the nodes in the Shard A replica set
mkdir ~/data/rs-a-1
mkdir ~/data/rs-a-2
mkdir ~/data/rs-a-3

echo Creating all the data directories for the nodes in the Shard B replica set
mkdir ~/data/rs-b-1
mkdir ~/data/rs-b-2
mkdir ~/data/rs-b-3


echo Starting all the mongod nodes in the Shard A replica set
mongod --shardsvr --replSet shard-a --dbpath ~/data/rs-a-1 --port 30000 --logpath ~/data/rs-a-1.log --fork
mongod --shardsvr --replSet shard-a --dbpath ~/data/rs-a-2 --port 30001 --logpath ~/data/rs-a-2.log --fork
mongod --shardsvr --replSet shard-a --dbpath ~/data/rs-a-3 --port 30002 --logpath ~/data/rs-a-3.log --fork

echo Starting all the mongod nodes in the Shard B replica set
mongod --shardsvr --replSet shard-b --dbpath ~/data/rs-b-1 --port 30100 --logpath ~/data/rs-b-1.log --fork
mongod --shardsvr --replSet shard-b --dbpath ~/data/rs-b-2 --port 30101 --logpath ~/data/rs-b-2.log --fork
mongod --shardsvr --replSet shard-b --dbpath ~/data/rs-b-3 --port 30102 --logpath ~/data/rs-b-3.log --fork


echo Initializing the Shard A replica set
mongo localhost:30000 --eval "printjson(rs.initiate())"
echo Waiting for the initialization to complete
sleep 60
echo Adding data node to replica set
mongo localhost:30000 --eval "printjson(rs.add(\"localhost:30001\"))"
echo Adding arbiter to replica set
mongo localhost:30000 --eval "printjson(rs.addArb(\"localhost:30002\"))"

echo Initializing the Shard B replica set
mongo localhost:30100 --eval "printjson(rs.initiate())"
echo Waiting for the initialization to complete
sleep 60
echo Adding data node to replica set
mongo localhost:30100 --eval "printjson(rs.add(\"localhost:30101\"))"
echo Adding arbiter to replica set
mongo localhost:30100 --eval "printjson(rs.addArb(\"localhost:30102\"))"




echo
echo "#############################"
echo "# Setting up Config Servers #"
echo "#############################"
echo

echo Creating all the data directories for the config server nodes
mkdir ~/data/config-1
mkdir ~/data/config-2
mkdir ~/data/config-3

echo Starting all the mongod config server nodes
mongod --configsvr --dbpath ~/data/config-1/ --port 27019 --logpath ~/data/config-1.log --fork --replSet conf
mongod --configsvr --dbpath ~/data/config-2/ --port 27020 --logpath ~/data/config-2.log --fork --replSet conf
mongod --configsvr --dbpath ~/data/config-3/ --port 27021 --logpath ~/data/config-3.log --fork --replSet conf

echo Waiting for config servers to finish starting up
sleep 60


mongo --port 27019 --eval "printjson(rs.initiate({_id: 'conf', configsvr: true, members: [{_id: 0, host:'localhost:27019'}, {_id: 1, host:'localhost:27020'}, {_id: 2, host:'localhost:27021'}]}))"
sleep 60




echo
echo "############################"
echo "# Setting up Mongos Router #"
echo "############################"
echo

echo Starting mongos router process
mongos --configdb "conf/localhost:27019,localhost:27020,localhost:27021" --logpath ~/data/mongos.log --fork --port 40000




echo
echo "############################"
echo "# Initializing the cluster #"
echo "############################"
echo

echo Adding Shard A to the cluster
mongo localhost:40000 \
    --eval "printjson(sh.addShard(\"shard-a/localhost:30000,localhost:30001\"))"

echo Adding Shard B to the cluster
mongo localhost:40000 \
    --eval "printjson(sh.addShard(\"shard-b/localhost:30100,localhost:30101\"))"
