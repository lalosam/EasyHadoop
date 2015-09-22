  hdfs dfs -mkdir /input
  echo "the cat sat on the mat" | hadoop fs -put - /input/test.txt
