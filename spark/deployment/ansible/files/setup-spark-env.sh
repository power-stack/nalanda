#!/bin/bash
set -x
HDFS_FS_HOST=${1:-hdfs-namenode:8020}
HDFS_HTTP_HOST=${2:-hdfs-namenode:50070}
SPARK_BIN_VERSION=${3-1.3.1-bin-cdh4}
SPARK_BIN_DOWNLOAD_URL=${4:-http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_BIN_VERSION}.tgz}
MESOS_NATIVE_JAVA_LIBRARY=${5:-/usr/lib/libmesos.so}

if [ -f ./spark-${SPARK_BIN_VERSION}.tgz ]; then
  echo "Find existing ./spark-${SPARK_BIN_VERSION}.tgz, will not download it."
else
  wget -O spark-${SPARK_BIN_VERSION}.tgz $SPARK_BIN_DOWNLOAD_URL && tar xzf spark-${SPARK_BIN_VERSION}.tgz
fi
/bin/cp -f spark-${SPARK_BIN_VERSION}/conf/spark-env.sh.template spark-${SPARK_BIN_VERSION}/conf/spark-env.sh

# Upload spark into hdfs
HDFS_PATH="mesos-executor"
curl -i -X DELETE "http://$HDFS_HTTP_HOST/webhdfs/v1/$HDFS_PATH/spark-${SPARK_BIN_VERSION}.tgz?op=DELETE&recursive=true"
curl -i -X PUT "http://$HDFS_HTTP_HOST/webhdfs/v1/$HDFS_PATH?op=MKDIRS"
UPLOAD_URL=$(curl --silent --output /dev/null -X PUT "http://$HDFS_HTTP_HOST/webhdfs/v1/$HDFS_PATH/spark-${SPARK_BIN_VERSION}.tgz?op=CREATE&overwrite=true" --write-out %{redirect_url})
echo "redirect to $UPLOAD_URL url"
curl -i -X PUT -T ./spark-${SPARK_BIN_VERSION}.tgz "${UPLOAD_URL}"

echo "export MESOS_NATIVE_JAVA_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY
export SPARK_EXECUTOR_URI="hdfs://$HDFS_FS_HOST/$HDFS_PATH/spark-${SPARK_BIN_VERSION}.tgz"
export MASTER=$SPARK_MASTER" >> spark-${SPARK_BIN_VERSION}/conf/spark-env.sh

#spark-${SPARK_BIN_VERSION}/bin/spark-shell --master $SPARK_MASTER
tailf /var/log/faillog
