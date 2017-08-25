---
layout: post
title:  "[C++] OJ提交题目中的语言选项里G++与C++的区别"
date:   2014-05-09 10:47:00 +0800
categories: notebook planguage
tags: cpp gpp
---
# G++？

首先更正一个概念，C++是一门计算机编程语言，G++不是语言，是一款编译器中编译C++程序的命令而已。

那么他们之间的区别是什么？

在提交题目中的语言选项里，G++和C++都代表编译的方式。准确地说，选择C++的话，意味着你将使用的是最标准的编译方式，也就是ANSI C++编译。如果你使用的是G++的话，意味着你将使用GNU项目中最平凡适用人群最多的编译器（其实也就是我们熟悉的Code::Blocks的自带的编译器，Windows环境里一般是MinGW下的gcc，Linux中的gcc和前者基本是一个东西）进行编译。类似的还有选择C和GCC，前者是标准C编译器编译，后者同样是用gcc来编译。

# 编译器的差别——编译器的优化

当然，很多时候我们有的代码用C++提交通过了，但是G++却失败了呢？众所周知，不同的编译器，会对代码做出一些不同的优化。举一个最简单的例子。针对单个语句（注意，是单个语句，不是包含在语句中的那种前++和后++）：

{% highlight cpp %}
a: a++;
b: ++a;
{% endhighlight %}

一般的讲，我们都知道，这两条语句的最终结果是一样的，就是a自己增加了1。但是，两者的差距还是有的。如果从标准C的角度去理解。a++这个语句等同于

{% highlight cpp %}
a: a = a + 1;
{% endhighlight %}

也就是说，我是先调用，再自增。在调用过程中，会申请一个新的数据地址，用于存放临时的变量a'，然后在把a'加1，之后在把a'赋值给a。

但是++a这个语句不需要这么麻烦。因为他是先自增，后调用，也就是省去了申请新地址的功夫。所以理论上，二者的时间消耗是有差异的，如果你是使用标准C的编译方式，就可以发现这个差异。毕竟，申请临时内存这个操作耗费的时间，远远比令已知内存的数据进行一个改变要长的多。

但是编译器的优化就体现在了这种本身结果相同却耗时有差异的地方。如果你使用gcc来编译，结果你会发现前++与后++二者基本上没有差异。这就是编译器的优化中的冰山一角了。事实上还有很多优化的地方。

# 为什么G++提交WA了？

好吧回到现实中来。我昨天在做poj 3122这道题的时候，再一次的遇到了G++WA；C++AC的尴尬局面。

为什么呢？其实这个也算是编译器优化的一部分，那就是精度缺省。

众所周知，long long类型，作为一个在C/C++11才被确认为基本数据类型的一个数据类型，在不同的环境下，他的类型标识符是不同的。也就是我们津津乐道的%lld 和 %I64d了。同样，double类型也是一个有趣的类型。double类型其实准确地说是双精度型，他的内存长度一般是比float类型（单精度型）的多了一倍，有的时候很早的标准里是把double称为long float的。所以说就有了为什么float类型用%f，double用%lf。但是由于现在不是以前的那种一个内存条就几兆，多开一个double就会超内存的年代了，所以double还有float在gcc中被自动优化。

在用scanf读数据时，为了与float区分，使用%lf。

在用printf写数据时，由于实质上，double和float是同一个类型，只不过内存占用有差异而已，他们的标识符都是%f，注意，这个和标准C不同，这里的都是%f。

当然对于另外一个特殊的类型long double虽然不常用，但是编译器依旧在支持，这里有个插曲，理论上long double应该是两倍的double（类似long long和int的关系，因为long和int其实是一个东西）。但是实际上，long double很奇怪的是一个10字节的怪物，他有两个空余字节，是怎么改动都不会发生变化的。输入输出的标识符都是%Lf，大写的L。

但是这里又有问题了，为什么我在本地用%f会WA，在OJ上用%f会AC？

因为我们本机如果使用的是Windows下的Code::Blocks这款IDE的话，编译器也就是MinGW这个东西。事实上，为了尽量保持gcc的跨平台性，MinGW在某些地方是直接用了MSVC的东西的，而对我们影响最大的就是这个标识符的问题。简单的说，如果你是要在本机测试，那么最好，请使用标准C的那个标识符系统；如果你要提交代码，那么请改成gcc的那一套标识符系统。

再有就是编译器版本的问题，现在的MinGW版本已经到了4.8，但是POJ上仍然使4.4，所以低版本的编译器同样会有一些不寻常的问题。

当然还有更简单的方法，就是直接用输入输出流在控制输入输出，这样更省事，而且跨平台性能更好，不会出现这种因为标识符而出错的情况。

列个表格出来就是这个样子的：

<table style="width: 100%;" border="2" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td valign="top" width="20%">double f;</td>
<td valign="top" width="20%">POJ G++提交</td>
<td valign="top" width="20%">POJ C++提交</td>
<td valign="top" width="20%">本机测试（MinGW GCC 4.8）</td>
<td valign="top" width="20%">最安全的方法</td>
</tr>
<tr>
<td valign="top" width="20%">输入</td>
<td valign="top" width="20%"><span style="font-family: consolas;">scanf("%lf", &amp;f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">scanf("%lf", &amp;f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">scanf("%lf", &amp;f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">cin &gt;&gt; f;</span></td>
</tr>
<tr>
<td valign="top" width="20%">输出</td>
<td valign="top" width="20%"><span style="font-family: consolas;">printf("<span style="color: #ff0000;">%f</span>", f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">printf("%lf", f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">printf("<span style="color: #ff0000;">%lf</span>", f);</span></td>
<td valign="top" width="20%"><span style="font-family: consolas;">cout &lt;&lt; f;</span></td>
</tr>
</tbody>
</table>

大概就是这么多了，希望大家避免这种错误的发生。