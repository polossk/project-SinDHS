---
layout: post
title: "[Ubuntu] 安装g++"
date: 2014-06-09 14:59:00 +0800
categories: notebook computeros
tags: Ubuntu gpp
---
有了Ubuntu怎么能不玩一下C/C++？但是默认的Ubuntu虽然自带了大部分的语言的编译器和标准库巴拉巴拉，但是并没有安装g++…

所以当你信心满满的想g++的时候，他会提醒你，没有这个应用程序。。。

呵呵呵呵

虽然这个提醒中有一个命令值得一试，但是在我这里是失败了，因为啥都没发生。。。

{% highlight shell %}sudo apt-get install g++{% endhighlight %}

嗯，我这里反正啥都没发生。。

建议直接使用一个全套服务命令

{% highlight shell %}sudo apt-get install build-essential{% endhighlight %}

这个命令会把所有的基本的语言啊标准库啊什么的一键安装。。

然后，g++就有反应了：

随后愉快地把C的测试程序写出来：

{% highlight cpp %}
#include <stdio.h>
int main()
{
    printf("Test in Ubuntu!n");
    return 0;
}{% endhighlight %}

还有C++的：

{% highlight cpp %}
#include <iostream>
using namespace std;
int main()
{
    cout << "Test g++ in Ubuntu!" << endl;
    return 0;
}{% endhighlight %}

接着打开终端，先编译C的

{% highlight shell %}cd Desktop
gcc test.c -o test{% endhighlight %}

运行之

{% highlight shell %}./test{% endhighlight %}

接着是C++

{% highlight shell %}cd Desktop
g++ testcpp.cpp -o testcpp{% endhighlight %}

运行之

{% highlight shell %}./testcpp{% endhighlight %}

搞定。
