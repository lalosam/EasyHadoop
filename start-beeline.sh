#!/bin/bash -e
source $HOME/.bashrc

$HIVE_HOME/bin/beeline -u jdbc:hive2://localhost:10000
