---
layout: post
title: "[综合] 天梯算法"
date: 2014-07-31 00:44:00 +0800
categories: battle
tags: RatingSystem ruby Algorithm
---
# 目标

今天听到有人说某学校的ACM队搞了一个Rating System，就是类似TopCoder和Codeforces的Rating一样，直观的积分更容易体现比赛的结果，以及大家的最近表现。而且据说他们把这个作为一个考核标准之一。

听上去好赞的样子！

可是我们学校木有啊！！！

紧接着我就想到了当时看《社交网络》时，扎克伯格搞得那个“点妹子”活动。

程序员木有点新创意简直是在玷污程序员的工作啊！

搞起一个自己的Rating System。

# 天梯算法简介

还是先恶补知识好了。所谓的天梯算法，其实很简单的，虽然数学证明很复杂。。。天梯算法的基础是建立在人群的水平基本满足正态分布上的。简单地说，就是假设大部分人旗鼓相当，同时存在少部分精英和部分水平较低的人。同时核心的操作也不言而喻，简单地说，同一水平的人比赛，胜者加分，败者减分。差距比较大的两个人比赛，爆冷之后加分减分会高出同水平的但是也不会暴涨。

这里我用的是Elo Rating System.

大致的算法如下：

1、假设这两个人的当前的分数已经给出：

$$R_A, R_B$$

2、计算其获胜的期望：

$$E_A = (1 + 10^{(R_B - R_A) / 400})^{-1}$$

$$E_B = (1 + 10^{(R_A - R_B) / 400})^{-1}$$

3、根据实际的结果来进行对分数的修正：

$$R'_A = R_A + K(S_A - E_A)$$

$$R'_B = R_B + K(S_B - E_B)$$

在这里，S表示的是结果，也就是胜平负代表的1, 0.5, 0；K表示的是比赛系数。通常一次比赛分值变动量不会太大。

# 实际实现

但是，这里和刚才的那个模型不一样。刚才的那个模型是为国际象棋棋手准备的，也就是两个人随意的交手，然后在涨分。换句话说，也许你的比赛场数越多，你的分数也就会更好看。

没听懂？Dota，LOL玩过吧，比赛永远是两个队在互相掐架。

但是Codeforces不一样，可能是上百人上千人同时在玩这个游戏，那么应该怎么搞？

我给的想法是最简单的想法：均摊比赛系数，每个人都参与比较，最后再和自己比较。

什么意思呢？我把一次比赛，假设有n个选手同时参赛，对于其中的选手i，相当于同时和n-1个选手进行了一场同样题目的比赛。所以我将比赛的系数均摊给参赛选手（当然有更好的分配方法，就是根据两者的赛前差距进行分配，这样更为接近现实），分配好之后，只需要让他们两两之间互相“比试”一番，就好了。

但是这样的话，就会造成有的人不停涨分，而且涨分幅度一次比一次大。所以必须引入自我比较法。简单地说，假设一个1700分的人参加一个800人参加的，所有参赛选手的最高分即为1700分的比赛，如果这个人，前一场是全场第2，这场全场第12。虽然他的排名很高，但是他输给了自己的上一场，还是会“下降”一些分数。但是这里的下降并不是绝对意义的下降，是指“涨幅”下降。也就是说，他的分数会基本保持在这个水平，但是不会突然跌下去或者突然涨分。

这就是我的大致思路了。毕竟不是大的项目，简单的做下就可以了。

# 代码

代码我使用的是Ruby，通过传入一个文本文档，上面记录参赛同学的四个属性：

<Rank><Name><Rating><SolvedProblem>

四个数据来进行计算。(其实那个出题数是没有必要的。。。)

最后输出一个文本文档，上面记录同学的三个属性：

<Rank><Name><NewRating>

{% highlight ruby %}
# encoding = UTF-8

class Student
  
  attr_accessor :name
  attr_accessor :rating
  attr_accessor :rank
  attr_accessor :_solve
  attr_accessor :_drating
  
  def initialize(name = "Unknown", rak = 100, rtg = 1500, solve = 0)
    @rank = rak.to_i
    @name = name
    @rating = rtg.to_i
    @_drating = 0
    @_solve = solve.to_i
  end
  
  def initialize(str2)
    str = str2.to_s
    data = str.split(' ')
    @rank = data[0].to_i
    @name = data[1]
    @rating = data[2].to_i
    @_solve = data[3].to_i
    @_drating = 0
  end
  
	def update(d) # 累加 rating 改变量
    @_drating  = d
	end
	
  def modify # 更新rating
    @rating  = @_drating
    @_drating = 0
		@rating = @rating.to_i
  end
  
	def toStringLine
		return "#{@rank}t#{@name}t#{@rating}n"
	end
	
  def print
    #puts "#{@rank}t#{@name}t#{@rating}"
		puts "#{@rating}"
  end
  
end

$Kcef = 60 # 比赛的系数

=begin
Rating算法：
针对两个参加比赛的人，互相比较，每次比较都更新一次_drating。

比较法则：
先比较题数：多者胜，少者负；
若平手，比较排名；
根据比较结果选取系数进行计算。

更新系数法则：
将本场的比赛系数按参赛人数分配给各个学生
计算方法如下：
  cef = $Kcef / sz

更新法则：
更新时，将两两同学互相比较，然后每次计算出的增量累加到_drating上即可
增量计算方法如下：
  A: dA = cef * (sA - eA)
  B: dB = cef * (sB - eB)
最后直接累加即可。
=end

def calc_eA_eB(rA, rB)
	da = (rB - rA) / 400.0
  db = -da
  ta = 10.0**da   1.0
  tb = 10.0**db   1.0
  ea = 1.0 / ta
  eb = 1.0 / tb
  return [ea, eb]
end

def calc_sA_sB(a, b)
  solveA = a._solve
  solveB = b._solve
  pA = a.rank
  pB = b.rank
  if solveA < solveB
    return [0.0, 1.0]
  elsif solveA > solveB
    return [1.0, 0.0]
  elsif pA < pB
    return [1.0, 0.0]
  else
    return [0.0, 1.0]
  end
end

def calc_cef(ra, rb, sz)
	return $Kcef / sz
end

def competition(a, b, sz) # 修改两人的增量
	eA, eB = calc_eA_eB(a.rating.to_f, b.rating.to_f)
  sA, sB = calc_sA_sB(a, b)
	cef = calc_cef(a.rank.to_f, b.rank.to_f, sz.to_f)
  dA = (sA - eA) * cef
	dB = (sB - eB) * cef
	a.update(dA)
	b.update(dB)
end

def read( path )
	items = Array.new
	File.open(path, :encoding => 'utf-8').each_line do |line|
		item = Student.new(line)
		items << item
	end
	sz = items.size
	# 逐一比较
	for i in 0...sz
		for j in 0...sz
			if i == j then
			  next
			else 
			  competition(items[i], items[j], sz.to_i);
			end 
		end
	end
	# 自身比较
	items.each do |data|
		temp = data
		temp.modify # 更新这场的rating
		competition(temp, data, sz)
		temp.modify # 自我比较后的rating
		data.modify # 对 rating 取平均值
		data.rating = ((temp.rating.to_i   data.rating.to_i ) / 2).to_i
	end
	
	file = File.new("result.txt", "w ")
	items.each do |data|
		data.modify
		file.print data.toStringLine
	end
end
read("contest1.txt"){% endhighlight %}
