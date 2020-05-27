---
layout: post
title:  "[project-SinDHS] Update ABS: Automation Blog Site"
date:   2017-10-16 13:45:18 +0800
categories: battle hitorigoto
tags: python jekyll
---

之前虽然把 blog 升级为 project-SinDHS 版本, 但是每次有一篇新文章的时候就要重新生成再上传到网站服务器上, 一次还容易接受, 时间久了还是很麻烦 (虽然我更新频率几乎... ). 所以一直以来都有过自动化的想法: 自动将所有的生成的静态网页上传到服务器上, 简而言之就是三个词, "构建(build)", "上传(upload)", "部署(deploy)". 为此主要找到了三种方案: git, glynn/git-ftp, manual(or script) upload. 现在依次介绍下.

# git

git 的方案是最无脑的: 在网站服务器开设一个私人的 git 服务器, 然后把网页信息当做一个普通的小项目维护即可, 可以说是非常的物尽其用了. 不过需要注意的是 git 服务器虽然好, 比如支持回滚, 大部分图片文件不需要重复上传. 但是有两个小问题. 第一个是还是有点不够自动化, 如果选用 git 服务来作为自动化的上传核心组件的话, 那为什么不直接 ftp 到网站服务器的目标目录从而省去部署的问题呢. 另外一个问题是, 每当有新文章写好之后, jekyll 会重新生成所有的网页, 哪怕只有某一个计数器 +1, 这样等于, git 每一次都会先 diff 一把 html 文件的细小的差距, 然后发现这个人这有意思屁大个文件都有更新, 所以一把 push 直接把所有文件扔了上去, 所以为啥不直接一把直接把所有的文件 ftp 到目标文件夹呢?

# glynn/git-ftp

如果把 git 的"版本控制"特性忽略, 每次 upload 所有的文件到目标文件夹, 这个方案就是 glynn 的解决方案了. 在实施之前, 务必确保两个前提:

* 有一个 ftp 账号, 最好直达目的地(省事);
* 确保权限控制, 即保证扔上去之后还是 www/www 这个账户组的, 以防各种 permission denied.

准备就绪之后就可以安装 glynn 直接食用了.

找到 `Gmefile` 文件, 添加一句话 `gem "glynn"`, 然后执行 `bundle install` 安装这个包. 随后需要在 `_config.yml` 文件中添加一些配置声明:

``` yaml
ftp_host: 'polossk.com'
ftp_dir: '/home/'
ftp_passive: false
```

上面三行分别代表, 服务器地址, 存放路径, 以及传输模式, `true` 表示被动模式, `false` 表示主动模式. 之后每次更新网站的时候只需要 `bundle exec glynn` 即可.

同样需要说明的是, ftp 只会生硬的传输所有文件, 但是在自动化这一个方面无出其右. 不过其实是有 [git-ftp](https://github.com/git-ftp/git-ftp) 这种操作的, 具体不表.

# manual(or script) upload

最后一种其实也是我现在一直用的在用的最蠢的 manual upload 法: 打包, 上传, 解压.

当然是用 python 胶水粘的了, 当然也是可以用 Rake 粘, 看个人习惯. 具体说来就是用 `paramiko` 包来做 ssh, `ftplib` 做 ftp 上传, 把配置文件扔到一个 `json` 里面, 核心突出一个字: 莽.

``` python
import os
import json
import paramiko
from ftplib import FTP

class Bunch(object):
    def __init__(self, adict):
        self.__dict__.update(adict)

def echo(stdout):
    for e in stdout: print(e, end='')

def main():
    config = Bunch(json.load(open('project-SinDHS.json', 'r')))
    os.system('bundle exec jekyll build')
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(config.host, username=config.ssh["user"], password=config.ssh["password"])
    stdin, stdout, stderr = ssh.exec_command('cd ' + config.dir + '; rm -rf *.* *')
    echo(stdout)
    os.chdir('_site')
    os.system('zip _site.zip -r *.*')
    with FTP(config.host, user=config.ftp["user"], passwd=config.ftp["password"]) as ftp:
        ftp.storbinary('STOR _site.zip', open('_site.zip', 'rb'))
    stdin, stdout, stderr = ssh.exec_command('cd ' + config.dir + '; unzip _site.zip')
    echo(stdout)
    ssh.close()

if __name__ == '__main__':
    main()
```