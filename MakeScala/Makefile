scala: ini-scala config-scala

ini-scala:
	echo "Installing Scala $(scala-version)"

scala-clean-cache: $(temp-scala)
	rm -r $(temp-scala)

scala-remove:
	sudo rm -r $(target-scala)

scala-reinstall: scala-remove scala

$(temp-scala):
		mkdir -p "$(temp-scala)"

$(temp-scala)/scala-$(scala-version).tgz :
	echo "Downloading scala-$(scala-version)"
	wget -P $(temp-scala) "http://downloads.typesafe.com/scala/$(scala-version)/scala-$(scala-version).tgz"

$(temp-scala)/scala-$(scala-version): | $(temp-scala)/scala-$(scala-version).tgz
	echo "Uncompressing Scala";
	tar zxf $(temp-scala)/scala-$(scala-version).tgz -C $(temp-scala)

$(target-scala):  $(temp-scala)/scala-$(scala-version)
	echo "Copying SCALA from $(temp-scala)/scala-$(scala-version) TO $(target-scala)"
	sudo mv $(temp-scala)/scala-$(scala-version) $(target-scala)

SHELL = /bin/bash
config-scala: | $(target-scala)
	echo "Configuring Scala"
	grep -q "export SCALA_HOME" "$(HOME)/.bashrc" && \
	    sed "s|export SCALA_HOME.*|export SCALA_HOME=$(target-scala)|" -i "$(HOME)/.bashrc" || \
	    sed "$$ a\export SCALA_HOME=$(target-scala)" -i "$(HOME)/.bashrc";
	grep -q "export PATH=.*$(target-scala)" "$(HOME)/.bashrc" && \
			sed "s|export PATH=.*$(target-scala).*|export PATH=\$$PATH:$(target-scala)/bin|" -i "$(HOME)/.bashrc" || \
			sed "$$ a\export PATH=\$$PATH:$(target-scala)/bin" -i "$(HOME)/.bashrc"
