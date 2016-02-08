#!/bin/bash -e
source $HOME/.bashrc
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver

nohup hiveserver2 > /usr/local/logs/hive.log &

cd /usr/local/hue
nohup /usr/local/hue/build/env/bin/hue runserver > /usr/local/logs/hue.log &

if [ -n "$BROWSER" ]; then
  $BROWSER 'http://localhost:50070' 2> /dev/null
  $BROWSER 'http://localhost:8088' 2> /dev/null
  $BROWSER 'http://localhost:8000' 2> /dev/null
elif which xdg-open > /dev/null; then
  xdg-open 'http://localhost:50070' 2> /dev/null
  xdg-open 'http://localhost:8088' 2> /dev/null
  xdg-open 'http://localhost:8000' 2> /dev/null
elif which gnome-open > /dev/null; then
  gnome-open 'http://localhost:50070' 2> /dev/null
  gnome-open 'http://localhost:8088' 2> /dev/null
  gnome-open 'http://localhost:8000' 2> /dev/null
else
  echo "Could not detect the web browser to use."
  echo "NodeManager - http://localhost:50070"
  echo "ResourceManager - http://localhost:8088"
  echo "Hue - http://localhost:8000"
fi
