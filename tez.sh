#!/bin/bash -e
echo 'Installing TEZ'
version=0.7.0
target="/usr/local/tez"
temp="/tmp/tez-temp"
hadoop_version=$(hadoop version | grep Hadoop | cut -d ' ' -f 2)
pig_version=$(pig -version | grep Apache | cut -d ' ' -f 4)

if [ -z "$hadoop_version" ]; then 
	echo "You need to specify 'hadoop_versio' or have 'hadoop' command available in your PATH"
	exit
else 
	echo "HADOOP version detected: $hadoop_version"
fi

sudo apt-get install git
sudo apt-get install maven
if [ -d $temp ]; then 
	echo "Deleting $temp"
	rm -rf $temp
else
	echo "$temp NOT DETECTED"
fi

mkdir -p "$temp"
cd "$temp"
git clone git@github.com:apache/tez.git 
cd "tez"
git checkout release-$version

sed "s|<hadoop.version>.*</hadoop.version>|<hadoop.version>$hadoop_version</hadoop.version>|" -i "pom.xml"

if [ -z "$pig_version" ]; then 
	echo "PIG version doesn't detected"
else 
	echo "PIG version detected: $pig_version"
	sed "s| <pig.version>.*</pig.version>| <pig.version>$pig_version</pig.version>|" -i "pom.xml"
fi
sed "s|<version>1.7.5</version>|<version>1.7.10</version>|" -i "pom.xml"
mvn clean package -DskipTests=true -Dmaven.javadoc.skip=true

if [ -d  "$target" ]; then
	sudo rm -rf "$target"
fi
sudo mkdir -p "$target"
sudo chmod -R 777 "$target"
mkdir -p "$target/libs"
mkdir -p "$target/hdfs-libs"

hdfs dfs -mkdir -p /apps/tez-$version
mv $temp/tez/tez-dist/target/tez-$version-minimal.tar.gz $target/libs/
mv $temp/tez/tez-dist/target/tez-$version.tar.gz $target/hdfs-libs/
cd $target/libs
tar -xf tez-$version-minimal.tar.gz
rm tez-$version-minimal.tar.gz

cd $target/hdfs-libs
tar -xf tez-$version.tar.gz
rm tez-$version.tar.gz

hdfs dfs -copyFromLocal -f ./* /apps/tez-$version/

cd $target
#touch tez-site.xml
echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
        <property>
            <name>tez.lib.uris</name>
            <value>${fs.defaultFS}/apps/tez-'$version',${fs.defaultFS}/apps/tez-'$version'/lib</value>
        </property>
    </configuration>' > tez-site.xml




grep -q "export TEZ_CONF_DIR" "$HOME/.bashrc" && \
    sed "s|export TEZ_CONF_DIR=.*|export TEZ_CONF_DIR=$target|" -i "$HOME/.bashrc" || \
    sed "$ a\export TEZ_CONF_DIR=$target" -i "$HOME/.bashrc"

grep -q "export HADOOP_CLASSPATH=.*$target" "$HOME/.bashrc" && \
    sed "s|export HADOOP_CLASSPATH=.*|export HADOOP_CLASSPATH=\$HADOOP_CLASSPATH:$target:$target/libs/*:$target/libs/lib/*|" -i "$HOME/.bashrc" || \
    sed "$ a\export HADOOP_CLASSPATH=$target:$target/libs/*:$target/libs/lib/*" -i "$HOME/.bashrc"

echo ""
echo "*****************************************************"
echo "**                                                 **"
echo "**                DONE !!                          **"
echo "**                                                 **"
echo "*****************************************************"
echo ""
