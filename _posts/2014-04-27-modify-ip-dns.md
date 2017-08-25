---
layout: post
title: "[cmd] Windows下命令行修改IP地址以及DNS服务器地址"
date: 2014-04-27 00:58:48 +0800
categories: notebook planguage
tags: cmd
---

每个星期都要周转于实验室与宿舍之间。实验室该死的公共路由器锁定IP。完事每次动态IP又总是错误地址，只能一次一次的手动修改。然后我又那么懒不想打开图形化界面去操作，索性学了一手。


命令格式：<span style="color: #0000ff;">netsh</span> <span style="color: #ff0000;">interface</span> <span style="color: #ff0000;">ip <span style="color: #0000ff;">set</span> address</span> "<span style="color: #00ff00;">网络连接</span>" <span style="color: #0000ff;">static</span> <span style="color: #00ff00;">IP地址 子网掩码 默认网关 跳数</span>


命令解释：

<table style="color: #000000;" border="2" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td valign="top" width="30%">参数</td>
<td valign="top" width="70%">解释</td>
</tr>
<tr>
<td valign="top" width="30%">网络连接</td>
<td valign="top" width="70%">网络连接名，从任务栏中的查看网络连接中可以找到</td>
</tr>
<tr>
<td valign="top" width=""30%>IP地址</td>
<td valign="top" width="70%">就是你的IP地址，像192.168.xxx.xxx</td>
</tr>
<tr>
<td valign="top" width="30%">子网掩码</td>
<td valign="top" width="70%">一般都是255.255.255.255</td>
</tr>
<tr>
<td valign="top" width=""30%>>默认网关</td>
<td valign="top" width="70%">一般都是结尾为.1或.254的那种</td>
</tr>
<tr>
<td valign="top" width="30%">跳数</td>
<td valign="top" width="70%">一般取1或者auto</td>
</tr>
</tbody>
</table>

比方说我在宿舍，IP是10.21.48.254，默认网关是10.21.48.1，那么我从实验室回来之后只需要运行这个命令：

{% highlight shell %}netsh interface ip set address "以太网" static 10.21.48.254 255.255.255.0 10.21.48.1 1{% endhighlight %}


然后如果我从宿舍到实验室的话就改成实验室的IP地址：

{% highlight shell %}netsh interface ip set address "以太网" static 192.168.13.23 255.255.255.0 192.168.13.254 1{% endhighlight %}


另外，修改DNS的方法类似，把address改成dns就行了


命令格式：<span style="color: #0000ff;">netsh</span> <span style="color: #ff0000;">interface</span> <span style="color: #ff0000;">ip <span style="color: #0000ff;">set</span> dns</span> "<span style="color: #00ff00;">网络连接</span>" <span style="color: #0000ff;">static</span> <span style="color: #00ff00;">DNS地址</span>


命令解释：

<table style="color: #000000;" border="2" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td valign="top" width="30%">参数</td>
<td valign="top" width="70%">解释</td>
</tr>
<tr>
<td valign="top" width="30%">网络连接</td>
<td valign="top" width="70%">网络连接名，从任务栏中的查看网络连接中可以找到</td>
</tr>
<tr>
<td valign="top" width="30%">DNS地址</td>
<td valign="top" width="70%">比如114.114.114.114</td>
</tr>
</tbody>
</table>

比如说我在实验室需要更换DNS服务器地址，只需要在命令提示符下输入：

{% highlight shell %}netsh interface ip set dns "以太网" static 114.114.114.114{% endhighlight %}

这样就行了。
