---
layout: post
title: "[CentOS] 程序员之泪 nodejs mongodb nginx 不完全环境配置手册"
date: 2017-03-06 15:23:55 +0800
categories: 笔记本 环境配置
tags: CentOS nodejs mongodb nginx
---
时至今日终于把 project-Hagane-and-Mizuki 的所有任务折腾完了，先后经历了瞎搞用户登录验证，数据库一表包含森罗万象流，一发 update 清空了数据表，修改环境变量结果把整个服务器搞宕机等各种高光时刻。

然后在服务器宕机后经过我熟能生巧的重做系统安装配置操作后，赶在 deadline 之前成功上线。

啊，那我好棒啊！（棒読み）

所以把我最后的环境配置目标，以及配置路线整理一发出来：

> 目标
> 
> * Hagane.somewhere.com 存放各种静态页面
> * Mizuki.somewhere.com 用 nodejs 接管服务
> * 用 nginx 折腾静态资源的转发
> * nodejs 应用选择 mongodb 数据库

当然这台服务器是一个朴素的阿里云小机器，用的是 CentOS7 ，勉强能跑。

## 安装 nginx

一开始我以为需要编译安装（事实上我以前都是 `make && make install` 整得），后来发现 yum 可以直接安装。

真是灭m顶d之z灾z！

所以老生常谈了，更新系统然后直接 install

```shell
$ yum -y update upgrade
$ yum -y install nginx
```

默认的安装目录是 `/usr/local/nginx/`, 可执行文件路径是 `/usr/local/nginx/sbin/nginx`, 配置文件目录是 `/usr/local/nginx/conf/`。

具体的操作可以参阅[nginx文档](http://nginx.org/en/docs/)。一般来说只需要学会这几个就行了

```shell
$ /usr/local/nginx/sbin/nginx -s signal
```

其中 signal 可以是以下的这些内容

* stop: 快速关闭
* quit: 平滑关闭
* reload: 重载配置文件
* reopen: 重新打开 log 文件

当然也可以用 `kill` 命令去关，那么你需要一发 nginx 的主进程号。比如先用 `ps -ef | grep nginx` 并从结果中找到 master 进程，然后直接 `kill -s -QUIT pid` 或者 `kill -s -TERM pid` ，当然你也可以用 `kill -9`。

如果 `nginx.conf` 配置了 pid 文件的存放路径，那么也可以从文件中直接获取主进程号。默认的文件位置是 `/usr/local/nginx/logs/nginx.pid`。

如果对 nginx 的配置文件有过更新，则需要首先对配置文件进行检查

```shell
$ /usr/local/nginx/sbin/nginx -t -c /usr/nginx/conf/nginx.conf
```

如果配置文件没有换过位置，也可以直接简单的

```shell
$ /usr/local/nginx/sbin/nginx -t
```

检查无误之后，再重载配置文件即可

## 安装 mongodb

当然，一开始我的 mongodb 也是编译安装的，后来得知实际上有编译好的包可以直接用，所以改变策略直接 yum install.

首先配置 mongo 的 yum 源。

```shell
$ vim /etc/yum.repos.d/mongodb-org-3.4.repo
```

添加以下内容

```conf
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
```

随后安装

```shell
$ yum -y install mongod-org
```

另外关闭 SELinux

```shell
$ setenforce 0
```

默认的配置文件在 `/etc/mongod.conf` ，加管理员，ban掉外网ip，换端口都从这里设置好。处理完之后直接启动服务就好了

```shell
$ systemctl enable mongod.service    # 设置其开机启动
$ systemctl is-enable mongod.service # 检查是否允许启动
$ systemctl start mongod.service     # 立即启动
$ systemctl status mongod.service    # 检查当前状态
$ systemctl restart mongod.service   # 重启
$ systemctl stop mongod.service      # 关闭
```

mongo 控制台直接用 `mongo localhost:23333 -u whoami -p suineg --authenticationDatabase admin` 登录就行了。当然这些操作实在设置好了 admin 以及端口之后的，如果是第一次登陆，那就直接 `mongo` 就行了。

## nodejs

本地开发阶段结束后，将项目打包上传至服务器，然后配置服务器环境。

喜欢自己编译的可以从 node 官网下源码编译（速度真心慢），或者 `yum -y install nodejs` 一键安装即可。

之后进入项目文件目录执行 `npm install && npm start` 确认服务能直接跑起来。

当然直接这样跑也是可以的，就是容易崩。所以外面套一个守护进程以备不测。这里我用的是 pm2 。安装也很简单 `npm install -g pm2` 即可。安装完毕之后新建一个 json 文件负责配置启动信息，基本格式就像这样：

```json
[
    {
        "name"        : "Mizuki.somewhere.com",
        "script"      : "./bin/www",
        "watch"       : true,
        "instances"   : "1",
        "exec_mode"   : "fork",
        "env": {
            "NODE_ENV": "production"
        },
    }
]
```

`script` 标记着程序启动入口，因为我的项目使用 express 框架写的，默认的入口就是 `./bin/www` 。如果自己不确定的话可以查看自己项目的 `package.json` 文件，这里面详细说明了各类关键信息。

## nginx 静态资源转发

到现在为止， node 已经开始接管相关服务了，但是为了提高效率，外层用 nginx 将静态文件直接转发而不必经过 node 。具体操作如下：

先在自己的 nginx 的配置文件中添加

```conf
upstream nodejs { server 127.0.0.1:6666; }
```

随后去 vhost 找到自己配的虚拟主机的配置文件，添加转发代理和静态资源的设置
```conf
location / { proxy_pass http://nodejs; }

location ~^/(font/|javascript/|images/|css/|robots.txt|humans.txt|favicon.ico) {
    root /home/wwwroot/Mizuki.somewhere.com/;
    access_log off;
    expires max;
}
```

具体的讲，上面 `upstream nodejs { ... }` 配置了代理信息，下面的 `location ~^/( ... )` 设置了静态资源的位置信息。这样就实现了简单的转发配置，提升了服务器的效率。
