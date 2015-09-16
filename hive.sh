#!/bin/bash -e
echo 'Installing HIVE'
hive_version=1.2.1
target="/usr/local/hive"
temp="/tmp/hive-temp"

if [ ! -d '$temp' ]; then 
	mkdir -p "$temp" 
fi
cd "$temp"

if [ ! -f "apache-hive-$hive_version-bin.tar.gz" ]; then
    wget http://www.us.apache.org/dist/hive/hive-$hive_version/apache-hive-$hive_version-bin.tar.gz
fi

if [ -d  "apache-hive-$hive_version-bin" ]; then
	rm -rf "apache-hive-$hive_version-bin"
fi
tar -xf apache-hive-$hive_version-bin.tar.gz
if [ -d  "$target" ]; then
	sudo rm -rf "$target"
fi
sudo mkdir -p "$target"
sudo chmod -R 777 "$target"
mv apache-hive-$hive_version-bin/* "$target"

grep -q "export HIVE_HOME" "$HOME/.bashrc" && \
    sed "s|export HIVE_HOME.*|export HIVE_HOME=$target|" -i "$HOME/.bashrc" || \
    sed "$ a\export HIVE_HOME=$target" -i "$HOME/.bashrc"

grep -q "export PATH=.*\$HIVE_HOME" "$HOME/.bashrc" && \
    sed "s|export PATH=.*\$HIVE_HOME.*|export PATH=\$PATH:\$HIVE_HOME/bin|" -i "$HOME/.bashrc" || \
    sed "$ a\export PATH=\$PATH:\$HIVE_HOME/bin" -i "$HOME/.bashrc"

grep -q "export HADOOP_USER_CLASSPATH_FIRST" "$HOME/.bashrc" && \
    sed "s|export HADOOP_USER_CLASSPATH_FIRST.*|export HADOOP_USER_CLASSPATH_FIRST=true|" -i "$HOME/.bashrc" || \
    sed "$ a\export HADOOP_USER_CLASSPATH_FIRST=true" -i "$HOME/.bashrc"



$HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /tmp
$HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/hive/warehouse
$HADOOP_PREFIX/bin/hdfs dfs -chmod 777 /tmp
$HADOOP_PREFIX/bin/hdfs dfs -chmod 777 /user/hive/warehouse

echo ""
echo "*****************************************************"
echo "**                                                 **"
echo "**                DONE !!                          **"
echo "**                                                 **"
echo "*****************************************************"
echo ""
