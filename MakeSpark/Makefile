spark: ini-spark config-spark

ini-spark:
	echo "Installing Spark $(spark-version)"

spark-clean-cache: $(temp-spark)
	rm -r $(temp-spark)

spark-remove:
	sudo rm -r $(target-spark)

spark-reinstall: spark-remove spark

$(temp-spark):
	mkdir -p "$(temp-spark)"

$(temp-spark)/spark-$(spark-version)-bin-without-hadoop.tgz:
	echo "Downloading spark-$(spark-version)"
	wget -P $(temp-spark) "http://www.eu.apache.org/dist/spark/spark-$(spark-version)/spark-$(spark-version)-bin-without-hadoop.tgz"; \

$(temp-spark)/spark-$(spark-version)-bin-without-hadoop: | $(temp-spark)/spark-$(spark-version)-bin-without-hadoop.tgz
		echo "Uncompressing Spark";
		tar zxf $(temp-spark)/spark-$(spark-version)-bin-without-hadoop.tgz -C $(temp-spark)

$(target-spark):  $(temp-spark)/spark-$(spark-version)-bin-without-hadoop
		echo "Copying Spark FROM $(temp-spark)/spark-$(spark-version) TO $(target-spark)"
		sudo mv $(temp-spark)/spark-$(spark-version)-bin-without-hadoop $(target-spark)

SHELL = /bin/bash
config-spark: | $(target-scala) $(target-spark)
	echo "Configuring Spark"
	grep -q "export SPARK_HOME" "$(HOME)/.bashrc" && \
		sed "s|export SPARK_HOME.*|export SPARK_HOME=$(target-spark)|" -i "$(HOME)/.bashrc" || \
		sed "$$ a\export SPARK_HOME=$(target-spark)" -i "$(HOME)/.bashrc";
	grep -q "export PATH=.*$(target-spark)" "$(HOME)/.bashrc" && \
		sed "s|export PATH=.*$(target-spark).*|export PATH=\$$PATH:$(target-spark)/bin|" -i "$(HOME)/.bashrc" || \
		sed "$$ a\export PATH=\$$PATH:$(target-spark)/bin" -i "$(HOME)/.bashrc"
	grep -q "export SPARK_DIST_CLASSPATH=.*" "$(HOME)/.bashrc" && \
		sed "s|export SPARK_DIST_CLASSPATH=.*|export SPARK_DIST_CLASSPATH=\$$(hadoop classpath)|" -i "$(HOME)/.bashrc" || \
		sed "$$ a\export SPARK_DIST_CLASSPATH=\$$(hadoop classpath)" -i "$(HOME)/.bashrc"
	echo "Done!!"
