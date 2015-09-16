# EasyHadoop
Installation scripts to install hadoop and its friends for a development environment for Linux Mint but it should work in Ubuntu and related distributions (Any feedback is welcomed).

## HADOOP

### hadoop.sh

This script download and install haddop in a **Pseudo-Distributed** configuration following the Getting Started tutorial: http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation.

The only prerequisites is to have a valid Java installation (Preferred Oracle Java 1.7)

This imply to have a JAVA_HOME environment variable set. If you are using "alternatives" to manage your java versions you can use the follow line in your **.bashrc** file:

```shell
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
```


You only need to grant execution permission to the script

```shell
sudo chmod +x hadoop.sh
```
and execute it in the terminal

```shell
./hadoop.sh
```

The script could ask you for your root password required to install some dependencies and to be able to work with the default target directory: **/use/local/hadoop**.

If it is necessary, the script will create a SSH key without password to allow the comunication between daemons and add it to the authorized_keys file.

At the end of the execution the script will try to open two web pages, one is the NameNode web application and the other is the REsourceManager wep application.

The script is configured to install Hadoop 2.7.1 on /usr/local/hadoop directory using /tmp/hadoop-temp directry to download and unpack the hadoop binaries. But you can change those parameters at the beginning of the script

```bash
hadoop_version=2.7.1
target="/usr/local/hadoop"
temp="/tmp/hadoop-temp"
```

I've tested the script with 2.6.0, 2.7.0 and 2.7.1. Other versions could be supported without warranty.

The script set the required environment variabeles in ~/.bashrc file. To start using hadoop commands, it's necessary to start an new terminal session to load the new parameters (or sourcing ~/.bashrc script)

the **bin** folder is included in the PATH, then you can execute hadoop commands in any place.

If you don't see the message:

```
*****************************************************
**                                                 **
**                DONE !!                          **
**                                                 **
*****************************************************
```

at the end of the script then something went wrong. Set the -x bash parameter to debug it (Change the first line of the script for: _#!/bin/bash -**x**e_).

**NOTE:** This script assume that it is the first time that you install hadoop in the machine, if it isn't the case please clean your previous configuration.

### start-hadoop.sh

This script start all the required daemons to use hadoop.

* dfs
* yarn
* jobhistory server

It **IS NOT** necessary to execute this script after the script **hadoop.sh**. hadoop.sh does the same at the end of the installation.

### stop-hadoop.sh

This script stop all the daemons started by the previous scripts.
