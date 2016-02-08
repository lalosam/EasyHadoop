target-base=/usr/local
temp-base=/tmp

hadoop-version=2.7.2
target-hadoop=$(target-base)/hadoop
temp-hadoop=$(temp-base)/hadoop-temp

spark-version=1.5.0
target-spark=$(target-base)/spark
temp-spark=$(temp-base)/spark-temp

scala-version=2.11.7
target-scala=$(target-base)/scala
temp-scala=$(temp-base)/scala-temp

include MakeUtils/Makefile
include MakeHadoop/Makefile
include MakeScala/Makefile
include MakeSpark/Makefile

all: haddop scala spark
