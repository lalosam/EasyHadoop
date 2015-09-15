#!/bin/bash -e
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh stop historyserver
$HADOOP_PREFIX/sbin/stop-yarn.sh
$HADOOP_PREFIX/sbin/stop-dfs.sh

