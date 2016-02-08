#!/bin/bash -ex

PID=`ps -eaf | grep hue | grep -v grep | awk '{print $2}'`
if [[ "" !=  "$PID" ]]; then
  for fn in $PID; do
    echo "The process $fn will be killed"
    kill -9 $fn
  done
fi

PID=`ps -eaf | grep HiveServer2 | grep -v grep | awk '{print $2}'`
if [[ "" !=  "$PID" ]]; then
  echo "killing $PID"
  kill -9 $PID
fi

$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh stop historyserver
$HADOOP_PREFIX/sbin/stop-yarn.sh
$HADOOP_PREFIX/sbin/stop-dfs.sh

