---
layout: post
title: "[综合] 批改网英语作文不允许粘贴的解决方案"
date: 2014-04-28 17:00:00 +0800
categories: battle
tags: HTML Javascript
---
# 原因

这次英语老师布置了篇英语作文，要求在批改网上写，结果太呵呵了添加了一个“正文不允许粘贴”这个蛋疼的规矩。无奈，我都在Word上打了一遍了懒得动手再来一遍，所以就简单的破解了下。

# 原理

一般来说，网页上的这种“规矩”，都是用脚本语言写的。比如说最简单的“禁止复制”，如果用javascript很容易实现。同样，这里的这个“禁止粘贴”也是依靠一个js脚本来阻止用户的粘贴工作的。

有一个很一般地办法，就是只需要把js脚本的权限禁用就行了，这个不难实现（Internet选项 – > 安全 – > 最高级别，就可以禁用权限）。但是这样的话就会把所有的脚本全部禁止，包括上传作文是用到的脚本也会禁止。所以这一个方案不可行。

# 解决方案

我是这样想的，既然不能够直接单纯的限制掉这个“禁止粘贴”的脚本运行，我可以先检查这个网页是如何提交我的作文的。显然，这个提交过程也是由一个脚本完成的。

那么我们就查看网络源代码，去看看代码中都有什么。
为了方便搞，我先把网页源代码全部复制过来用Notepad++打开。

我最初发现了这个链接：

{% highlight html %}<script type="text/javascript" src="/res/javascript/ZeroClipboard.js"></script>{% endhighlight %}

顾名思义，这个就是禁用我们粘贴功能的脚本。

然后我们注意下最后的在网页里的那个脚本，我截取出来一部分：

{% highlight js %}
$(function(){
        var bzold = $('#beizhu').val(); 
         $('#dafen').click(function(){ 
        var cStr= $('#contents').val();
        var cTitle= $('#title').val();
        if( cTitle.trim()==''){ 
            //alert("请填写标题"); $('#title').focus() ; return false;
            var tre = confirm("题目为空，您确定继续提交这篇作文吗？");
            if( !tre ){$('#title').focus() ; return false; }
        }
        if( cStr.trim()==''){ alert("请填写内容"); $('#contents').focus() ; return false;}
        ...
}{% endhighlight %}

显然，这个就是提交我们作文的那个脚本了。

因为在网页里，“提交作文”这个按钮的标签如下：

{% highlight html %}<div class="fr"><INPUT TYPE="button" VALUE="提交作文" id="dafen" class="button4" ></div>{% endhighlight %}

也就是那个脚本中的

{% highlight js %}$('#dafen').click(function(){% endhighlight %}

这个语句的意思了。

下面一条语句

{% highlight js %}var cStr= $('#contents').val();{% endhighlight %}

从名字上看就是获取文章内容的语句。那么我就在网页元素上搜索这个#contents这个元素的定义：

{% highlight html %}<TEXTAREA NAME="contents" id="contents" style="width: 755px;border-bottom:0px" class="from_contents"></TEXTAREA>{% endhighlight %}

这就简单了，通过浏览器的“审查元素”，然后修改属性即可。把你的作文内容直接加在两个<><>之间即可

{% highlight html %}<TEXTAREA NAME="contents" id="contents" style="width: 755px;border-bottom:0px" class="from_contents">
                    <!--作文正文就直接写在这里，不需要添加任何东西-->
</TEXTAREA>{% endhighlight %}

随后，提交作文，搞定。
