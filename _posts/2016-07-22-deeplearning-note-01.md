---
layout: post
title:  "[DeepLearning] 深度学习 (1) CNN on MNIST"
date:   2016-07-19 20:51:00 +0800
categories: notebook machinelearning
tags: deeplearning keras python theano machinelearning cnn
---
上一篇终于把环境搭完了，这一把玩一下测试例子，将CNN应用到手写数字识别上，用mnist数据集

# CUDA Test

在上一篇中，只提到了安装CUDA之后可以观察自己的显卡的能力，实际上CUDA还给了很多的例子供我们使用。

嘛，在我的电脑里，所有的例子是在文件夹 "C:\ProgramData\NVIDIA Corporation\CUDA Samples\v7.5" 当中。这里我使用了下 "1_Utilities\bandwidthTest" 这个例子用于观察其IO的效率。直接找到*.sln文件打开工程，然后编译运行即可，如图即为我的电脑的运行结果：

<img src="{{ site.base }}/images/2016/07/screenshot20160721221449.png" width="90%" />

看着很吓人，几乎是6Gb/s的速度，不过转念一想，这个数字好熟悉啊！这不是某根线的带宽么，满速运转理所当然啊。

# Theano on CUDA

通过看文档，可以大概知道theano的各种坏毛病，比如需要指定很多的环境参数。但是需要提前说明一点：

务必删干净临时文件，在这 C:\Users\%USERNAME%\AppData\Local\Theano 你会看到各种各样的小东西，嘛，直接删干净就行了。

最后是设置theano的运行环境了。文档中讲到有很多种设置方式，比如文件设置，或者import os通过os设置THEANO_FLAG的方法，后者更灵活一些。但是考虑到我基本不会瞎搞，所以就用了普通的配置文件配置。目前我的配置文件如下

{% highlight ini %}
# .theanorc
[blas]
ldflags =

[gcc]
cxxflags = -ID:\Anaconda2\MinGW

[cuda]
root=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v7.5

[nvcc]
fastmath = True
flags = -LD:\Anaconda2\libs

[global]
floatX = float32
device = gpu0
{% endhighlight %}

再有就是这里的文件全名是".theanorc"，是不能通过新建文件夹搞出来的。正确的做法是Win+R直接打开cmd，就到了个人文件夹，然后

{% highlight shell %}
echo off
cd.>.theanorc
{% endhighlight %}
用了一些微小的技巧，蟹蟹大家！

# >jupyter notebook

最后就是直接照抄代码上去跑结果就行了。嘛，他说的是

{% highlight plain %}
'''Trains a simple convnet on the MNIST dataset.
Gets to 99.25% test accuracy after 12 epochs
(there is still a lot of margin for parameter tuning).
16 seconds per epoch on a GRID K520 GPU.
{% endhighlight %}

实际上我的渣电脑几乎是130 s/epoch。原因不明。

嘛最终还是能搞出来一个好结果，我已经很开心了。附上链接

[[model](http://bookcode.polossk.com/Deep-Learning-Notebook/model/mnist_cnn_weights.hdf)] [[html](http://bookcode.polossk.com/Deep-Learning-Notebook/html/note01-mnist-cnn.html)] [[ipynb](http://bookcode.polossk.com/Deep-Learning-Notebook/ipynb/note01-mnist-cnn.ipynb)]