hadoop: ini-hadoop hadoop-dependencies format-hdfs start-hadoop

ini-hadoop:
	echo "Installing Hadoop $(hadoop-version)"

hadoop-clean-cache: $(temp-hadoop)
	rm -r $(temp-hadoop)

hadoop-remove:
	-@sudo rm -r $(target-hadoop)

hadoop-reinstall: hadoop-remove format-hdfs start-hadoop

hadoop-dependencies: | config-ssh
		sudo apt-get --assume-yes install ssh
		sudo apt-get --assume-yes install rsync

$(temp-hadoop):
	mkdir -p $(temp-hadoop)

$(temp-hadoop)/hadoop-$(hadoop-version).tar.gz:
	echo "Downloading HADOOP $(hadoop-version)"
	wget -P $(temp-hadoop) http://www.us.apache.org/dist/hadoop/common/hadoop-$(hadoop-version)/hadoop-$(hadoop-version).tar.gz

$(temp-hadoop)/hadoop-$(hadoop-version): | $(temp-hadoop)/hadoop-$(hadoop-version).tar.gz
	echo "Uncompressing HADOOP"
	tar zxf $(temp-hadoop)/hadoop-$(hadoop-version).tar.gz -C $(temp-hadoop)

$(target-hadoop): $(temp-hadoop)/hadoop-$(hadoop-version)
	echo "Copying HADOOP from $(temp-hadoop)/hadoop-$(hadoop-version) TO $(target-hadoop)"
	sudo mv $(temp-hadoop)/hadoop-$(hadoop-version) $(target-hadoop)


$(target-hadoop)/etc/hadoop/core-site.xml.bak:
	-sudo mv $(target-hadoop)/etc/hadoop/core-site.xml $(target-hadoop)/etc/hadoop/core-site.xml.bak

$(target-hadoop)/etc/hadoop/hdfs-site.xml.bak:
	-sudo mv $(target-hadoop)/etc/hadoop/hdfs-site.xml $(target-hadoop)/etc/hadoop/hdfs-site.xml.bak

$(target-hadoop)/etc/hadoop/yarn-site.xml.bak:
	-sudo mv $(target-hadoop)/etc/hadoop/yarn-site.xml $(target-hadoop)/etc/hadoop/yarn-site.xml.bak

backup-hadoop-conf: | $(target-hadoop) $(target-hadoop)/etc/hadoop/core-site.xml.bak $(target-hadoop)/etc/hadoop/hdfs-site.xml.bak $(target-hadoop)/etc/hadoop/yarn-site.xml.bak

SHELL=/bin/bash
config-hadoop: backup-hadoop-conf
	echo "Configuring HADOOP"
	sed 's_<configuration>_<configuration> \
	    <property> \
	        <name>fs.defaultFS</name> \
	        <value>hdfs://localhost:9000</value> \
	    </property> \
	    <property> \
	        <name>hadoop.tmp.dir</name> \
	        <value>'$(target-hadoop)'/data</value> \
	    </property>_' $(target-hadoop)/etc/hadoop/core-site.xml.bak > $(target-hadoop)/etc/hadoop/core-site.xml
	sed 's_<configuration>_<configuration> \
      <property> \
          <name>dfs.replication</name> \
          <value>1</value> \
      </property>_' $(target-hadoop)/etc/hadoop/hdfs-site.xml.bak > $(target-hadoop)/etc/hadoop/hdfs-site.xml
	sed 's_<configuration>_<configuration> \
       <property> \
          <name>mapreduce.framework.name</name> \
          <value>yarn</value> \
       </property>_' $(target-hadoop)/etc/hadoop/mapred-site.xml.template > $(target-hadoop)/etc/hadoop/mapred-site.xml
	sed 's|<configuration>|<configuration> \
       <property> \
           <name>yarn.nodemanager.aux-services</name> \
           <value>mapreduce_shuffle</value> \
       </property>|' $(target-hadoop)/etc/hadoop/yarn-site.xml.bak > $(target-hadoop)/etc/hadoop/yarn-site.xml
	grep -q "export HADOOP_PREFIX" "$(HOME)/.bashrc" && \
		sed "s|export HADOOP_PREFIX.*|export HADOOP_PREFIX=$(target-hadoop)|" -i "$(HOME)/.bashrc" || \
		sed "$ a\export HADOOP_PREFIX=$(target-hadoop)" -i "$(HOME)/.bashrc"
	grep -q "export PATH=.*$(target-hadoop)" "$(HOME)/.bashrc" && \
		sed "s|export PATH=.*$(target-hadoop).*|export PATH=\$$PATH:$(target-hadoop)/bin|" -i "$(HOME)/.bashrc" || \
		sed "$ a\export PATH=\$$PATH:$(target-hadoop)/bin" -i "$(HOME)/.bashrc"
	grep -q "export HADOOP_CONF_DIR" "$(HOME)/.bashrc" && \
    sed "s|export HADOOP_CONF_DIR=.*|export HADOOP_CONF_DIR=$(target-hadoop)/etc/hadoop|" -i "$(HOME)/.bashrc" || \
		sed "$ a\export HADOOP_CONF_DIR=$(target-hadoop)/etc/hadoop" -i "$(HOME)/.bashrc"

.ONESHELL:
SHELL=/bin/bash
format-hdfs: | config-hadoop
	source $(HOME)/.bashrc
	$(target-hadoop)/bin/hdfs namenode -format

.ONESHELL:
SHELL=/bin/bash
start-hadoop:
	source $(HOME)/.bashrc
	$(HADOOP_PREFIX)/sbin/start-dfs.sh
	$(HADOOP_PREFIX)/sbin/start-yarn.sh
	$(HADOOP_PREFIX)/sbin/mr-jobhistory-daemon.sh start historyserver
	$(target-hadoop)/bin/hdfs dfs -mkdir -p /user/$(USER)

.ONESHELL:
SHELL=/bin/bash
stop-hadoop:
	source $(HOME)/.bashrc
	$(HADOOP_PREFIX)/sbin/mr-jobhistory-daemon.sh stop historyserver
	$(HADOOP_PREFIX)/sbin/stop-yarn.sh
	$(HADOOP_PREFIX)/sbin/stop-dfs.sh
