---
layout: post
title: "[Ruby] Ruby大法第一天"
date: 2014-07-21 04:28:00 +0800
categories: notebook planguage
tags: ruby
---
Ruby是一个神奇的脚本语言，语法简单，而且容易上手。

同时，基本上可以处理绝大多数的轻量级问题。

强烈推荐在线学习网站：<a href="http://tryruby.org/">http://tryruby.org/</a>

# 笔记：

<ol>
<li>Ruby会默认返回方法中的最后一个值。</li>
<li>如果需要返回多个值，可以用数组来实现。</li>
<li>可以通过强制声明return来返回值。</li>
<li>基础的输出方法是用puts(输出一行)，print(直接打印)。</li>
<li>基础的输入方法是gets(读入一行，包含行尾的'n'，可以用chomp方法消除)。</li>
<li>纯粹的现象对象语言，而且还是一个动态语言（虽然今天目前还没用到），所以老老实实面向对象去。</li>
<li>有两种简单粗暴的储存多个元素的方法。数组[]和哈希表{}，而且还有各种各样的函数。</li>
<li>强烈推荐新手入门在线学习网站：<a href="http://tryruby.org/">http://tryruby.org/</a>，简直爽到爆！</li>
</ol>
# 各种代码

## eg1: 建立一个哈希表

{% highlight ruby %}
ojs = {}
ojs["poj"] = :A
ojs["hdu"] = :A
ojs["uva"] = :B
ojs["zoj"] = :B
ojs["CF"] = :S
ojs["TC"] = :S
ratings = Hash.new(0)
ojs.values.each { |rate| ratings[rate] += 1 }
print ratings
puts "
puts "==============================="
print ojs
puts "
puts "==============================="
3.times {print "hey!"}
puts "
puts "==============================="

print ojs.length
puts "
print ojs.keys
puts "
print ojs.values
puts "
ojs.keys.each { |name| print name; print " "; print ojs[name]; puts ""; }
puts "==============================="
print File.read("x.txt")
puts "==============================="
File.open("x.txt", "a") do |f|
	f << "HACKED!n"
	end
print File.read("x.txt")
puts "==============================="
print File.mtime("x.txt")
puts "
print File.mtime("x.txt").hour
puts "
puts "==============================="{% endhighlight %}
## eg2: 从文件读数据建立一个哈希表

{% highlight ruby %}
# 读取一个文件的数据库并且输出
def load_oj( path )
	ojs = {}
		File.foreach(path) do |line|
		name, value = line.split(':')
		ojs[name] = value
	end
	print_oj(ojs)
end
def print_oj( data )
	puts "================================"
	print "nametvaluen"
	data.keys.each do |name|
		puts "#{name}t#{data[name]}"
	end
	puts "================================"
end
oj = load_oj("x.txt"){% endhighlight %}
## eg3: 从文件中读取学生信息并且输出

{% highlight ruby %}
# 从文件中读取学生信息并且输出
class Student
	#attr_accessor :name
	#attr_accessor :number
	def initialize(name = "Unknown", number = "2012309999")
		@name = name
		@number = number
	end
	def print
		puts "#{@name}t#{@number}"
	end
end
def load_stu( path )
	data = {}
	File.foreach(path) do |line|
		na, no = line.split(' ')
		s = Student.new(no, na)
		data[s] = 1
	end
	data
end
def print_stu( data )
	puts "================================"
	print "nametnumbern"
	data.keys.each do |stu|
		stu.print
	end
	puts "================================"
end
data = load_stu("y.txt")
print_stu(data){% endhighlight %}
## eg4: 一行内输入4个整数，计算这四个数的最大公约数

{% highlight ruby %}
# 一行内输入4个整数，计算这四个数的最大公约数
def gcd(a, b)
	if b === 0
		return a
	else return gcd(b, a % b)
	end
end
str = gets.chomp
a, b, c, d = str.split(" ")
g1 = gcd(a.to_i, b.to_i);
g2 = gcd(c.to_i, d.to_i);
g3 = gcd(g1, g2)
puts "gcd(#{a}, #{b}, #{c}, #{d}) = #{g3}"{% endhighlight %}
