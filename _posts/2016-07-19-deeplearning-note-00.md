---
layout: post
title:  "[DeepLearning] 深度学习 (0) 环境搭建 python2.7+cuda+theano+keras"
date:   2016-07-19 20:51:00 +0800
categories: notebook machinelearning
tags: deeplearning keras python theano machinelearning
---
自从毕业一来颓废得跟咸鱼一样，嘛，本来就是咸鱼一条= =

但是还是准备好好写下瞎搞 deeplearning 的流水账，嘛，既然要搞♂个新东西，自然要从搭环境开始，先说下我这里的最后开发环境

> OS: Windows 10 Professional Build 10586 x64
>
> CPU: Intel64 Family 6 Model 58 Stepping 9 GenuineIntel ~2501 Mhz
>
> GPU: GeForce GT 635M
>
> Microsoft Visual Studio Ultimate 2013 Version 12.0.31101.00 Update 4
>
> g++ (x86_64-posix-seh, Built by MinGW-W64 project) 6.1.0
>
> CUDA Driver Version / Runtime Version 7.5 / 7.5
>
> Python 2.7.12 :: Anaconda 4.1.1 (64-bit)
>
> theano 0.8.2
>
> keras 1.0.6

关于为什么换 python3 到 python2 ，主要是因为不可抗力：自己的二逼电脑总是有稀奇古怪的问题。嘛，似乎 py2 和 py3 也没什么太大的区别。。。实在不行我 `import __future__`（逃

嘛还是老老实实得从搭环境讲起

# MinGW
由于 theano 还有 python 都需要额外独立编译一些东西，所以还是老老实实下一个新的 MinGW 好了。结果才知道，原来都TM 6.1.0 了……也就是说全面支持C++14咯看这版本号……嘛，M$大爷你看看人家！

先跑到SourceForge[[here](https://sourceforge.net/projects/mingw-w64/)]跑一个mingw-w64，因为32位的编译器会在后续的过程中编译不了theano。

安装好之后，测试一下

{% highlight plain %}
C:\Users\namae>g++ --version
g++ (x86_64-posix-seh, Built by MinGW-W64 project) 6.1.0
Copyright (C) 2016 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
{% endhighlight %}

注意安装过程中会让你选择平台，i686是32位，x86_64是64位，原因就不多提了，毕竟是amd64先搞出来的大新闻。安装好了之后务必加入path环境变量。如果之前有各种各样的mingw的话，请删干净（文件+环境变量设置）。

那么g++ 6.1.0必然是支持c++11与c++14的，光说不做没意思，让我们来测试下到底有没有支持新标准。

先试试Return type deduction for normal functions，[[reference](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2013/n3638.html)]，为此我们新建两个cpp，为了方便分别命名为cpp11.cpp与cpp14.cpp

{% highlight cpp %}
// cpp11.cpp
#include <bits/stdc++.h>

auto f(int a, int b) -> decltype( a + b )
{
    int i = a + b;
    return i;
}

int main()
{
    std::cout << f(1,2) << std::endl;
    return 0;
}
{% endhighlight %}

{% highlight cpp %}
// cpp14.cpp
#include <bits/stdc++.h>

auto f(int a, int b)
    int i = a + b;
    return i;
}

int main()
{
    std::cout << f(1,2) << std::endl;
    return 0;
}
{% endhighlight %}

然后分别编译

{% highlight shell %}
>g++ cpp11.cpp -o cpp11.exe -std=c++11
>cpp11.exe
3

>g++ cpp14.cpp -o cpp14.exe -std=c++14
>cpp14.exe
3
{% endhighlight %}

可见已经支持了c++14的关于auto的最新要求。

你问我为什么不用lambda来测试，因为

我玩不溜啊（逃

# Anaconda
由于懒癌晚期，所以我就吊儿郎当的用了anaconda[[here](https://www.continuum.io/downloads#_windows)]（虽然并不知道如何发音），唯一的好处就是这个货会帮你把最常用的科学计算库一并打包附赠，包括 numpy, scipy, matplotlib 等，当然还附赠 ipython，简直是懒癌晚期的救星。

但是这里有个很严肃的问题，就是 python 版本的问题。虽然 py2 的退役已经提上台面，而且我已经用 py3 有段时日，本想接着使用 py3 ，但是没想到就目前而言 py3 有问题：

theano的[[configparser.py](https://github.com/Theano/Theano/blob/master/theano/configparser.py)]这个文件中第75行的代码
{% highlight python %}
config_files = config_files_from_theanorc()
theano_cfg = ConfigParser.SafeConfigParser(
    {'USER': os.getenv("USER", os.path.split(os.path.expanduser('~'))[-1]),
{% endhighlight %}

此处的SafeConfigParser方法是py2专精，新的py3已经重写了。虽然说理论上没什么问题，但是在我的电脑上不知为何总是不能正确的import configparser这个包，因此所有代码，注意是所有代码运行到theano.__init__的时候都会崩掉，包括pip工具。网上的方法是如果用py3，最好使用py3.4这个版本，然后应该没问题。。。

（唉，这届py3.4不行啊

如果你选择的是新的py3.5版本，めでたしめでたし，libpython这个包并不支持py3.5，网上给的方法是重建一个py3.4的环境，然后来搞一个大迁徙……

（你开心就好

最懒癌的方法就是，找到py2.7对应的anaconda，果断下载就行了。

# CUDA
既然是搞这个，如果没有战术核显卡，简直就是浪费生命，因为

他根本算不出来啊！

找到cuda的官网[[here](https://developer.nvidia.com/cuda-downloads)]，一步一步按部就班的下载然后安装就行。

注意！所有用VS2015社区版的朋友们！CUDA不支持VS2015！正确的做法是找VS2010或VS2013，然后下载安装，并且注意整理下cl.exe的环境变量。（还好我一如既往的vs2013党

安装就绪之后就可以看看你的电脑有多渣了！找到C:\ProgramData\NVIDIA Corporation\CUDA Samples\v7.5\1_Utilities\deviceQuery，然后打开vs2013工程文件，编译运行一发就可以观察你的显卡能力了

<img src="{{ site.base }}/images/2016/07/screenshot20160719184655.png" width="90%" />

等吧，N厂的最新战术核显卡GTX1080又便宜又高效，虽然我钱包没钱，但是可以找老板求情啊！我绝对不知道什么是兽王咸丰、吓到列车、实名召唤是什么，我用战术核显卡是为了科学，对，为了科学！（亡语：将一个奥秘从你的牌库中置入战场。

# theano & keras

最后的大头，就是两个货了，其实很简单

{% highlight shell %}
pip install theano
pip install keras
{% endhighlight %}

在安装完theano之后，务必去加一个环境变量 PYTHONPATH，内容为D:\Anaconda2\Lib\site-packages\theano，其中前面是我安装的路径而已，务必自己调节。

等一切就绪，打开python，输入简单的一句

{% highlight python %}
import theano
{% endhighlight %}

如果啥都没发生，屏幕只是划出新的三个>>>提示符

恭喜你，安装成功。

至于样例，嘛，等下一篇吧。。。