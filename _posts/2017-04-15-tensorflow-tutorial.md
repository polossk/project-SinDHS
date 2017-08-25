---
layout: post
title:  "[DeepLearning] Windows10 + TensorFlow 环境搭建"
date:   2017-04-15 18:59:08 +0800
categories: notebook machinelearning
tags: deeplearning tensorflow python machinelearning
---
先说下最后的开发环境配置

> OS: Windows 10 Home China 1703 Build 15063.138
>
> CPU: Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
>
> GPU: NVIDIA GeForce GT 720
>
> RAM: 8G DDR4 2133MHZ
>
> Microsoft Visual Studio Ultimate 2013 Version 12.0.40629.00 Update 5
>
> g++ (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 6.3.0
>
> CUDA /cuDNN: 8.0.61 / 5.1
>
> Python 3.5.2 :: Anaconda 4.2.0 (64-bit)
>
> TensorFlow 1.0.1

# 安装流程
经历了多次的源码编译失败之后，我最终连双系统也懒得装，直接按照官方给的安装文档走了最简单方便的 TensorFlow on Windows 的解决方案。

## MinGW64(g++ x64), Visual Studio

MinGW 和 VS 都是 C++ 的编译环境：前者主要用于 python 自己编译一些库，后者主要是为了 CUDA 。时过境迁，CUDA终于支持 VS2015 了，然而我这里还是在 VS2013 停留不动。

mingw-w64的话可以跑到SourceForge[[here](https://sourceforge.net/projects/mingw-w64/)]下一个，VS直接下2015的社区版就行了（暂时没有官方资瓷 VS2017 的信息）。

安装好之后由于新的g++已经全面普及 c++11 ，所以默认的编译方法已经是 `std=c++11` 了。安装之后可以简单的看下版本

{% highlight plain %}
>g++ --version
g++ (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 6.3.0
Copyright (C) 2016 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
{% endhighlight %}

## tuna 清华大学开源软件镜像站

国内的众所周知的网络环境总是会干扰正常的网络数据传输，所以急需梯子或者更好的源。清华大学有一个[开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn)，这样可以显著的加快安装速度，而且由于教育网环境的存在，可以享受 ipv6 网络（而且免流量！）

## Anaconda

懒癌晚期专用的 python 环境，但是现在 TensorFlow 还不支持python 3.6（没有编译好的Windows包），所以只好降级用 Anaconda 的 4.2.0 这个版本（内置 python 3.5.2）。

下载 Anaconda 可以去刚才提到的[镜像站](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)快速下载，并且配置好安装源

{% highlight plain %}
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
{% endhighlight %}

## CUDA & cuDNN

这两个是关键核心，所以需要额外注意，只有计算力在3.0以上的显卡才能使用。

找到 CUDA 的官网[here](https://developer.nvidia.com/cuda-downloads)，一步一步按部就班的下载然后安装就行。

安装就绪之后可以自己测试下运行环境和显卡能力。找到 `C:\ProgramData\NVIDIA Corporation\CUDA Samples\v7.5\1_Utilities` 直接用VS打开就行了。

<img src="{{ site.base }}/images/2017/04/20170415214622.png" width="90%" />

<img src="{{ site.base }}/images/2017/04/20170415214818.png" width="90%" />

随后再去申请一个 cuDNN 把压缩包放到CUDA的安装路径或者自己新开一个路径加到path里就行了。

## TensorFlow
找到 TensorFlow 的[安装文档](https://www.tensorflow.org/install/install_windows) 按部就班就行了。

用 Anaconda 先创建一个环境 `conda create -n tensorflow` ，随后激活它 `activate tensorflow` 并且在这个环境里安装 TensorFlow 。

文档中所给的CPU和GPU的链接分别是 `https://storage.googleapis.com/tensorflow/windows/cpu/tensorflow-1.0.1-cp35-cp35m-win_amd64.whl` 与 `https://storage.googleapis.com/tensorflow/windows/gpu/tensorflow_gpu-1.0.1-cp35-cp35m-win_amd64.whl`。 把 `whl` 路径中的 `storage.googleapis.com` 用清华大学的源 `mirrors.tuna.tsinghua.edu.cn` 替换掉，然后再安装 `pip install --ignore-installed --upgrade balabala.whl` 即可。

安装完之后用 TensorFlow 版的 hello world 测试下

{% highlight python %}
import tensorflow as tf;
hello = tf.constant('Hello, TensorFlow!');
sess = tf.Session();
print(sess.run(hello));
{% endhighlight %}

如果正确运行出结果 `Hello, TensorFlow!` 则说明安装完成