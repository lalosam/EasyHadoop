#!/bin/bash -e
echo 'Installing hadoop'
hadoop_version=2.7.1
target="/usr/local/hadoop"
temp="/tmp/hadoop-temp"
sudo apt-get --assume-yes install ssh 
sudo apt-get --assume-yes install rsync
if [ ! -d '$temp' ]; then 
	mkdir -p "$temp" 
fi
cd "$temp"


if [ ! -f "hadoop-$hadoop_version.tar.gz" ]; then
    wget http://www.us.apache.org/dist/hadoop/common/hadoop-$hadoop_version/hadoop-$hadoop_version.tar.gz
fi

if [ -d  "hadoop-$hadoop_version" ]; then
	rm -rf "hadoop-$hadoop_version"
fi
tar -xf hadoop-$hadoop_version.tar.gz
if [ -d  "$target" ]; then
	sudo rm -rf "$target"
fi
sudo mkdir -p "$target"
sudo chmod -R 777 "$target"
mv hadoop-$hadoop_version/* "$target"
cd "$target/etc/hadoop"
mv core-site.xml core-site.xml.bak
sed 's_<configuration>_<configuration> \
    <property> \
        <name>fs.defaultFS</name> \
        <value>hdfs://localhost:9000</value> \
    </property> \
    <property> \
        <name>hadoop.tmp.dir</name> \
        <value>'$target'/data</value> \
    </property>_' core-site.xml.bak > core-site.xml
mv hdfs-site.xml hdfs-site.xml.bak
sed 's_<configuration>_<configuration> \
    <property> \
        <name>dfs.replication</name> \
        <value>1</value> \
    </property>_' hdfs-site.xml.bak > hdfs-site.xml
sed 's_<configuration>_<configuration> \
    <property> \
        <name>mapreduce.framework.name</name> \
        <value>yarn</value> \
    </property>_' mapred-site.xml.template > mapred-site.xml
mv yarn-site.xml yarn-site.xml.bak
sed 's|<configuration>|<configuration> \
    <property> \
        <name>yarn.nodemanager.aux-services</name> \
        <value>mapreduce_shuffle</value> \
    </property>|' yarn-site.xml.bak > yarn-site.xml


ssh -q -o "StrictHostKeyChecking no" -o "BatchMode yes" localhost exit
if [ $? == 255 ]; then
    echo 'Configuring localhost without passphrase on SSH'
    if [ ! -f "$HOME/.ssh/id_dsa" ]; then
      echo "Generating a SSH KEY. . ."
      ssh-keygen -t dsa -P '' -f "$HOME/.ssh/id_dsa"
      cat "$HOME/.ssh/id_dsa.pub" >> "$HOME/.ssh/authorized_keys"
    fi
    
fi
grep -q "export HADOOP_PREFIX" "$HOME/.bashrc" && \
    sed "s|export HADOOP_PREFIX.*|export HADOOP_PREFIX=$target|" -i "$HOME/.bashrc" || \
    sed "$ a\export HADOOP_PREFIX=$target" -i "$HOME/.bashrc"

grep -q "export PATH=.*$HADOOP_PREFIX" "$HOME/.bashrc" && \
    sed "s|export PATH=.*$HADOOP_PREFIX.*|export PATH=\$PATH:$HADOOP_PREFIX/bin|" -i "$HOME/.bashrc" || \
    sed "$ a\export PATH=\$PATH:$HADOOP_PREFIX/bin" -i "$HOME/.bashrc"

cd "$target"
source $HOME/.bashrc
bin/hdfs namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh
sbin/mr-jobhistory-daemon.sh start historyserver

if [ -n "$BROWSER" ]; then
  $BROWSER 'http://localhost:50070' 2> /dev/null
  $BROWSER 'http://localhost:8088' 2> /dev/null
elif which xdg-open > /dev/null; then
  xdg-open 'http://localhost:50070' 2> /dev/null
  xdg-open 'http://localhost:8088' 2> /dev/null
elif which gnome-open > /dev/null; then
  gnome-open 'http://localhost:50070' 2> /dev/null
  gnome-open 'http://localhost:8088' 2> /dev/null
else
  echo "Could not detect the web browser to use."
  echo "NodeManager - http://localhost:50070"
  echo "ResourceManager - http://localhost:8088"
fi

echo ""
echo "*****************************************************"
echo "**                                                 **"
echo "**                DONE !!                          **"
echo "**                                                 **"
echo "*****************************************************"
echo ""
