# vagrant-virtualbox

## Get Started

1. 进入 `vagrant-virtualbox` 目录
2. 运行 `vagrant up`

运行 `vagrant up` 命令后, vagrant 会根据虚拟机描述文件 `Vagrantfile` 启动一个 virtualbox 虚拟机, 并执行 deploy.sh 脚本. deploy.sh 
脚本将下载和安装 prometheus 和 grafana.

3. 打开 localhost:3000, 导入 grafana 模版：12633。

promethues 常用来监控主机、应用、中间件, 通过 agent 来收集主机、应用等的指标信息，汇总保存到时序
数据库，通过 grafana 做前端展示，提供了应用系统的观测性。

## 搭建规划
1. 手动下载安装 Virtualbox 虚拟机软件 https://www.virtualbox.org/wiki/Downloads
2. 手动下载安装 Vagrant 虚拟机管理软件 https://www.vagrantup.com/downloads
3. 开发脚本，脚本功能实现
   a. 通过脚本安装启动一个 ubuntu 虚拟机
   b. 在虚拟机里执行一个 ansible 剧本，剧本功能如下：
   ⅰ. 下载并安装 prometheus
   ⅱ. 下载并安装 grafana
   ⅲ. 安装一个 mysql 实例
   ⅳ. 下载一个 mysql agent 监控 mysql
   ⅴ. 配置 prometheus 接收 mysql 监控指标
   ⅵ. 配置 grafana  从模板市场安装一个 mysql 监控显示模板

通过以上步骤，我们通过自动化的脚本实现了在虚拟机里用 prometheus 监控 mysql 并可视化监控展示。

## 开发步骤

1. 初始化 vagrant 文件，指定虚拟机 `hashicorp/bionic64`, 对应了 ubuntu 18.04 64bit 版本

```bash
mkdir vagrant-virtualbox
cd vagrant-virtualbox

vagrant init hashicorp/bionic64 
# 执行完上述命令后,可以看到 vagrant-virtualbox 多了一个文本配置文件 Vagrantfile
```

2. 启动虚拟机环境

```bash
# 这条命令首先检查本地是否有 hashicorp/bionic64 的虚拟机镜像 box,如果没有, 则从 vagrantcloud.com 下载该镜像 box
# 下载完成1后,将启动该虚拟机
vagrant up
```

3. 连接到虚拟机 `vagrant ssh`
4. 销毁虚拟机 `vagrant destroy`

## 项目结构

```bash
Vagrantfile # 要启动的虚拟机配置文件
deploy.sh  # 虚拟机启动后运行的脚本：1. 下载安装 prometheus。2. 下载安装 grafana
```

## 参考

- https://dev.mysql.com/doc/refman/8.0/en/linux-installation.html
- 

