#!/bin/bash -e
echo 'Installing PIG'
version=0.15.0
target="/usr/local/pig"
temp="/tmp/pig-temp"

if [ ! -d '$temp' ]; then 
	mkdir -p "$temp" 
fi
cd "$temp"

if [ ! -f "pig-$version.tar.gz" ]; then
    wget http://www.us.apache.org/dist/pig/pig-$version/pig-$version.tar.gz
fi

if [ -d  "pig-$version" ]; then
	rm -rf "pig-$version"
fi
tar -xf pig-$version.tar.gz
if [ -d  "$target" ]; then
	sudo rm -rf "$target"
fi
sudo mkdir -p "$target"
sudo chmod -R 777 "$target"
mv pig-$version/* "$target"

grep -q "export PIG_HOME" "$HOME/.bashrc" && \
    sed "s|export PIG_HOME.*|export PIG_HOME=$target|" -i "$HOME/.bashrc" || \
    sed "$ a\export PIG_HOME=$target" -i "$HOME/.bashrc"

grep -q "export PATH=.*$target" "$HOME/.bashrc" && \
    sed "s|export PATH=.*$target.*|export PATH=\$PATH:$target/bin|" -i "$HOME/.bashrc" || \
    sed "$ a\export PATH=\$PATH:$target/bin" -i "$HOME/.bashrc"

grep -q "export PIG_CLASSPATH" "$HOME/.bashrc" && \
    sed "s|export PIG_CLASSPATH=.*|export PIG_CLASSPATH=\$HADOOP_CONF_DIR:\$TEZ_CONF_DIR|" -i "$HOME/.bashrc" || \
    sed "$ a\export PIG_CLASSPATH=\$HADOOP_CONF_DIR:\$TEZ_CONF_DIR" -i "$HOME/.bashrc"

echo ""
echo "*****************************************************"
echo "**                                                 **"
echo "**                DONE !!                          **"
echo "**                                                 **"
echo "*****************************************************"
echo ""
