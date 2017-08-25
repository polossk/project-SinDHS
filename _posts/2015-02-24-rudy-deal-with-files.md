---
layout: post
title: "[Ruby] 简单文件操作"
date: 2015-02-24 01:43:15 +0800
categories: notebook planguage
tags: ruby
---
<blockquote>好久不写博客，简直是罪过。
</blockquote>



最近被文件操作搞的很恶心，当然这一点和我的渣是分不开的。

<del>先把坑挖好，回头补上。</del>

一点点写，从最简单的开始。

# 目录遍历

起因是，我这个人有的时候不是很喜欢用EverNote、OneNote这类的软件，原因是打开太麻烦。尤其是在电脑旁边的时候，碰见一些需要拷贝下来的文档或文章或者琐碎的单词句子，往往会效率低下。因为我的处理方式是这样的：

网上的文章？——EverNote直接剪下来（印象笔记的插件还是很好用的说）。

部分段落？——Win + R, notepad, Ctrl + V, Ctrl + S, 新建文本文档.txt

这样一来，我的桌面上琐碎的文档就越来越多，慢慢的就铺满了整个桌面。效率低下不说，往往不记得以前的文档是shenmegui了。

所以我需要定期将所有的文档清理一遍。

但是打开太多的文本文档我又嫌烦。

所以需要整理到一个文本文档里。

<blockquote>需求：整理文本文档。
很多的文本文档整理到一个文档里，保留原文档的文件名和内容即可。
</blockquote>

那么我的思路就是，用一个脚本，分析当前目录下的文件，对每一个文本文件，读入，写进去。搞定。

第一个问题是目录分析。

还好万能的ruby有可以直接搞得库。pathname

{% highlight ruby %}require 'pathname'{% endhighlight %}

那么怎么搞出来当前目录的路径呢？其实因为ruby内置了__FILE__这个东西，所以可以这样来搞：

{% highlight ruby %}path = Pathname.new(File.dirname(__FILE__)).realpath
Dir.foreach(path) do |e|
	# balabala
end{% endhighlight %}

如此一来，就通过__FILE__定位了当前目录，并且创建了这个目录类。定位了目录，我们就可以遍历目录啊，乱搞文档了。

第二个问题就是文件分析了。第一部要获取文件的扩展名。其实很简单，定义就是最后一个.之后的单词就是扩展名，但是既然ruby内置了方法，就不要再重写代码了，影响开发效率。

{% highlight ruby %}def isTextFile( name )
	puts name
	File.extname(name) == ".txt"
end{% endhighlight %}

哦对了，ruby默认返回当前方法的最后一个命令的值，所以就这样就搞定了。

最后一个问题就是细节了，因为文本文档的格式不一定规范，有的有文件末尾空格有的没有，这个时候就需要搞一下

{% highlight ruby %}fsrc.each do |line|
	fdst << line.chomp << "\n"
end{% endhighlight %}

这样一来，就把一个多文件合并的脚本写好了。

# 复制，移动，删除

<blockquote>未成品声明
</blockquote>

用这个的原因是，我自己写了个两个小玩意，这两个小玩意的数据交流是通过文件搞得。然后这两个小玩意不在同一个文件夹。所以需要搞一下复制。

一开始我是这样想的，用shell或者bat脚本来搞，但是我被恶心了。

shell一点事没有，很正常，为什么呢？因为我的Ubuntu是在虚拟机里，这个好处就在于，文件少，易操作，而且大家都知道，基本上你的文件都是在这个目录下：

{% highlight plain %}#! /home/acm/crs/
balabala{% endhighlight %}

但是Windows，虽说我是寒假更新的Win10，文件清新了很多，而且平时也经常整理，但是我的文件目录的样子充满了空格。这就导致了引号引号引号的使用，然后我就弃疗了。另外昨天发现一个神奇的现象，大家肯定都知道神奇的Windows Command有两个预定义量%~dp0和%cd%，然后这两个东西，在Win10的环境里，也不知道为什么，%cd%一直有作用，但是前者%~dp0却脾气暴躁的飞起。

当然这是一个原因，更主要的原因是，因为我的那几个小东西是带命令行参数的。所以，

——我不知道命令行脚本带参数应该怎么搞了。。。

不要打我，我是认真的，我真的不知道该怎么搞了。。。

然后我就换成Ruby了。

当然，之所以我说，我这里用的是半成品，是因为和上面的完全没有关系，因为这里用的是另一个库fileutils，这个库比较厉害的一点就是，它相当于一个跨平台的命令行处理机制，基本上集合了简单的命令行上的文件与文件目录操作。

举个例子，比如你要在脚本中删除一个文件，我一般会选用调用命令行语句来完成这种工作。在Linux环境下你的命令是rm，但是Win环境就变成了del，搞不好自己为了跨平台还得写一个简单的解析器，费时费力。但是FileUtils这个库的好处就在于，本身就是一个跨平台的解析器，支持简单的文件与文件目录操作。至于命令？Linux和Win随便你，反正都兼容就是了。显然节省了大把的开发时间。

这个时候我又想表扬神奇的ruby了。ruby最简单的一个功能，字符串插值（#{}），实际上是ruby最实用的一个功能，也是我现在觉得比其他脚本语言，包括python在内，都觉得省心省力的一个功能。因为太实用了，太常见了。C++我用流，用sprintf_s，python用%来搞，都不如一个#{}来的方便快捷。

所以我的脚本，得益于神奇的#{}，简化成了这样：
{% highlight ruby %}
# Copy file for further usage
rfn = "Result@#{date}.txt" # Result File Name
FileUtils.cp("#{home}/#{crs}/#{rfn}", "#{home}/#{rps}/")
FileUtils.cd("#{rps}")
system("ruby main.rb #{type}")
FileUtils.cd(".."){% endhighlight %}

倒不是说，怎么怎么好看啊，怎么怎么牛啊，主要就是：

<blockquote>省心，不费事。
</blockquote>

就这就够了。
