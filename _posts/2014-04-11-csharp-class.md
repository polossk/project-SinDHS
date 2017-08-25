---
layout: post
title: "[C#] 类的使用笔记"
date: 2014-04-11 22:14:27 +0800
categories: notebook planguage
tags: Csharp
---
先声明，这个不是详细的那种一个一个的说明性文档，毕竟那种资料一抓一大把，我这个主要以自用的笔记为主。

# Notes:

<ul>
<li>数据private类型，大部分方法public类型；</li>
<li>如果有继承或者相互引用，注意数据的公有还是私有，保证数据的只读性质；</li>
<li>C#不能够像C++一样在数据声明时调用构造函数，必须使用Myclass temp = new Myclass()来调用构造函数；</li>
<li>C#不支持多重继承关系， 也就是说，一个派生类不允许有多个基类。简单点就是，父亲可能有好多儿子（父类可以派生出许多子类），但是一个孩子只能有一个爸爸（子类不允许多重继承关系）；</li>
<li>C#和其他面向对象一样，重载，多态，虚函数，抽象类这些特性都有；</li>
<li>重载和C++中的重载毫无区别，只有一个问题是在重载大小比较运算符（<, >=, >, <=, ==, !=）的时候，必须成对的重载；</li>
<li>虚函数需加virtual声明，派生类中需要重写，并且添加override声明；</li>
<li>抽象函数需加abstract声明，并且基类中没有执行代码，只能在继承类中添加；</li>
<li>如果需要传出多个值，需要用到ref声明或out声明；</li>
<li>ref声明的对象必须提前初始化；</li>
<li>out声明的对象不需要提前初始化；</li>
<li>如果类中有静态对象，可以使用静态构造函数对静态对象进行赋值操作。</li>
</ul>
# Example：

# ElemType.cs

{% highlight csharp %}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Test_Class
{
    class Program
    {
        static void Main(string[] args)
        {
            package p1 = new package(5, 5);
            package p0 = new package();
            p0.disp();
            p1.disp();
            p1.copyto(ref p0);
            p0.disp();
            p0.modify(10, 50);
            p0.disp();
            Console.ReadLine();
        }
    }
}{% endhighlight %}
