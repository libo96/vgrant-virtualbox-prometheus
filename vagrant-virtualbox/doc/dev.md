

## 开发步骤

1. 初始化 vagrant 文件，指定虚拟机 `hashicorp/bionic64`, 对应了 ubuntu 18.04 64bit 版本

```bash
mkdir vagrant-virtualbox
cd vagrant-virtualbox

vagrant init hashicorp/bionic64 
# 执行完上述命令后,可以看到 vagrant-virtualbox 多了一个文本配置文件 Vagrantfile
```
