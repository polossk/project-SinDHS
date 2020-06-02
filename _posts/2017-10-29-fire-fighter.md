---
layout: post
title: "[FireFighter] 救火队员 强行修复分辨率"
date: 2017-10-29 16:42:00 +0800
categories: 笔记本 环境配置
tags: python xrandr tsukkomi
---

由于一波逗比的 VGA 线的问题, 导致了一大把电脑都直接跪了, 而且这一回的技术组直接索性没有开 ssh 没办法批量部署 patch ... 令人窒息的操作.

所以只好一个一个修.

而且由于每一次重启之后, xrandr 的临时配置就会失效, 所以直接扔到了 `rc.local` 和 `.profile` 两个文件里保证每一次重启之后都能在登录系统后变成"理应正确"的分辨率设置.

具体说来, 本来想用 python 粘一个从生成配置到应用配置的脚本出来, 后来发现机器生成的配置基本一样, 所以后期直接放弃 python 胶水, 而是直接写好一个 `.profile` 文件放在云端, 在 `rc.local` 中画蛇添足 `wget` 下来替换掉...
令人窒息的操作 +1.

## cvt & xrandr

其实整个修复流程很简单, 用 `cvt` 生成一个全新的"理应正确"的配置, 然后复制上文的配置, `new` 一份, `add` 一哈, `output` 设置一哈就行了. 具体可以看 python 胶水:

```python
import os

def main():
    os.system("cvt 1440 900 60.00 > tmp.txt")
    with open("tmp.txt", "rt") as fin:
        model = fin.read()
    model = model.strip().split('\n')
    model = model[-1].replace("Modeline", "")
    # model = '"1440x900_60.00" 106.50 1440 1528 1672 1904 900 903 909 934 -hsync +vsync'
    os.system("xrandr --newmode" + model)
    os.system("xrandr --addmode DVI-0 1440x900_60.00")
    os.system("xrandr --output DVI-0 --mode 1440x900_60.00")
    os.system("xrandr")
    os.system("rm -rf tmp.txt")

if __name__ == '__main__':
    main()
```