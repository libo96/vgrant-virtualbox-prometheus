#!/usr/bin/env bash

# 安装 prometheus 和 grafana

# 默认文件下载目录
DEFAULT_DOWNLOAD_DIR="/vagrant/packages"

# 下载文件
# 参数1：文件下载地址
# 参数2： 下载后保存的文件名
downloadFile(){
  url=$1
  target="$DEFAULT_DOWNLOAD_DIR/$2"

  if [ -f "$target" ]; then
    echo "$target already exists, skip."
  else
    echo "$target not exists, download now."
    wget $url -O "$target"
  fi
}

# 下载安装 prometheus
installPrometheus(){
   url="https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-amd64.tar.gz"
   package="prometheus-2.38.0.linux-amd64.tar.gz"
   appDir="/app/prometheus-2.38.0.linux-amd64"

   downloadFile $url $package
   tar xf "$DEFAULT_DOWNLOAD_DIR/$package" -C "/app"

   # 启动 prometheus
   nohup "$appDir/prometheus" --config.file=/vagrant/config/prometheus.yml --storage.tsdb.path=/vagrant/PrometheusData/ >> /vagrant/logs/prometheus.log 2>&1 &
}

# 下载安装 grafana，适用于 ubuntu 系统
installGrafana(){
  sudo apt-get install -y adduser libfontconfig1
  downloadFile https://dl.grafana.com/enterprise/release/grafana-enterprise_9.1.3_amd64.deb grafana-enterprise_9.1.3_amd64.deb
  sudo dpkg -i $DEFAULT_DOWNLOAD_DIR/grafana-enterprise_9.1.3_amd64.deb
  service grafana-server start
}

installMySQL(){
  apt update && apt install -y mysql-server
  service mysql start
  cp /vagrant/config/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
  service mysql restart
  mysql -e "source /vagrant/sql/init.sql"
}

installNodeExporter(){
  url="https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz"
  package="node_exporter-1.3.1.linux-amd64.tar.gz"
  downloadFile $url $package

  # 解压到 /app 目录
  tar xf "$DEFAULT_DOWNLOAD_DIR/$package" -C "/app"

  # 启动 node_exporter agent
  nohup /app/node_exporter-1.3.1.linux-amd64/node_exporter >> /vagrant/logs/node_exporter.log &
}

installMySQLNodeExporter(){
  url="https://github.com/prometheus/mysqld_exporter/releases/download/v0.14.0/mysqld_exporter-0.14.0.linux-amd64.tar.gz"
  package="mysqld_exporter-0.14.0.linux-amd64.tar.gz"
  downloadFile $url $package

  # 解压到 /app 目录
  tar xf "$DEFAULT_DOWNLOAD_DIR/$package" -C "/app"

  # 启动 mysql node exporter
  nohup /app/mysqld_exporter-0.14.0.linux-amd64/mysqld_exporter >> /vagrant/logs/mysqld_node_expoter.log
}

initDirectory(){
   sudo mkdir /app

   # 创建包目录
   mkdir /vagrant/packages

   # 创建日志目录
   mkdir "/vagrant/logs"

   # 创建数据目录
   mkdir "/vagrant/PrometheusData"
}

install(){
  initDirectory
  installPrometheus
  installGrafana
  installNodeExporter
  installMySQL
  installMySQLNodeExporter

}

install
