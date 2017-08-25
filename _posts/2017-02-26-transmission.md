---
layout: post
title:  "[CentOS7] 废物利用 搭建transmission做种机"
date:   2017-02-26 22:05:31 +0800
categories: notebook computeros
tags: CentOS7 transmission
---
教研室的老电脑退役之后，一度被我改造成 web server 大材小用。后来想起实际上老机器配置十分强劲，何不做成一个做种机放在教研室方便 PT 用户。

然而在经历了安装 utorrent server 的失败之后，最终转向了 transmission 的怀抱。

主要任务包括两个：安装并运行 transmission ，开启 ipfilter 阻止 ipv4 外网流量。

## TRANSMISSION

当然首先需要更新一下环境。我现在使用的系统环境如下

系统版本
```shell
$ cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
```

CPU信息
```shell
$ grep 'model name' /proc/cpuinfo|awk -F: '{print $2}'|sed 's# ##g'|uniq -c
8 Intel(R)Core(TM)i7-2600CPU@3.40GHz
```

内存信息与交换空间信息
```shell
$ sed -n '/MemTotal\|MemFree/p' /proc/meminfo
MemTotal:        3767164 kB
MemFree:          223264 kB
$ sed -n '/SwapTotal\|SwapFree/p' /proc/meminfo
SwapTotal:       4063228 kB
SwapFree:        3442020 kB
```

在操作之前，首先先对系统做一次更新
```shell
$ yum -y update upgrade
```

然后直接下载编译好的版本即可
```shell
$ yum -y install transmission transmission-daemon
```

然后启动，这样会把配置文件初始化
```shell
$ transmission-daemon -g /usr/local/transmission
```

由于修改配置文件需要关闭服务，所以这里强制 kill 掉
```shell
$ killall transmission-daemon
```

如果 killall 不支持则安装工具包
```shell
$ yum -y install psmisc
```

随后编辑配置文件
```
$ vim /usr/local/transmission/settings.json
```

修改掉这些条目
```json
{
    "rpc-authentication-required": true,
    "rpc-password": "password",
    "rpc-username": "username",
    "rpc-port": 9091,
    "rpc-whitelist-enabled": false
}
```

重新启动，登录`http://<ip-address>:9091`即可
```shell
$ transmission-daemon -g /usr/local/transmission
```

## IPFILTER
然而校园网做种主要靠内网和ipv6，所以安装 ipfilter 势在必行。这里直接用 transmission 自带的黑名单就行了。需要做的事情有两个，修改刚才的配置文件打开黑名单，额外添加一个 blocklist 文件保证 IP 被过滤掉。

修改该条目
```json
{
    "blocklist-enabled": true
}
```

在刚才的配置文件所在的目录里，新建 blocklist 文件夹，并且在里面新建 ip 文件，把禁用的 ip 输入进去。在重新启动之后，会编译出一个 ip.bin 的文件，用于加速判断。
```plain
ipv4:0.0.0.0-9.255.255.255
ipv4:11.0.0.0-172.15.255.255
ipv4:172.32.0.0-192.167.255.255
ipv4:192.169.0.0-202.117.79.255
ipv4:202.117.96.0-222.24.191.255
ipv4:222.25.0.0-255.255.255.255
```

大功告成，安心做种吧。