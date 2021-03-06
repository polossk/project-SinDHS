---
layout: post
title: "[ML] 机器学习课程 笔记本 (3) 聚类和其他"
date: 2015-10-18 00:29:00 +0800
categories: 笔记本 机器学习
tags: machinelearning
---
抱歉贪玩写晚了，而且今天讲的内容非常散，我还是捡自己感兴趣的或者有意思的写了。

## Rand Index

回顾昨天提到的TP, FP, TN, FN，在聚类分析中，对于一次聚类结果的评价同样有基于这种分类行为的评价方式，但是也同样有所区分。不妨假设我们已知三个类别'x', 'o', 'l'，再一次分类中，我们得到了如下的结果

> class1: xxxxxo
>
> class2: xloooo
>
> class3: xxlll

先解释下定义，针对N篇文档，共有$$\binom{N}{2}$$个文档对，针对上面的例子就是总共有$$\binom{17}{2} = 136$$个文档对。那么每一个文档对要么为阳性positive（也就是两篇文档本来就是一类的），要么就是阴性negative（两篇文档并不在同一个类别当中）。聚类的结果只有两类，判断正确就是True，错误就是False。所以可以类似的写出来这个表格。

计算流程如下：

$$P = TP + FP = \binom{6}{2} + \binom{6}{2} + \binom{5}{2} = 40$$

$$TP = \binom{5}{2} + \binom{4}{2} + \binom{3}{2} + \binom{2}{2} = 20$$

$$FP = (TP + FP) - TP= 20$$

$$N = TN + FN = \binom{6}{1}\binom{6}{1} + \binom{6}{1}\binom{5}{1} + \binom{6}{1}\binom{5}{1} = 96$$

$$FN = \binom{5}{1}\binom{3}{1} + \binom{1}{1}\binom{4}{1} + \binom{1}{1}\binom{3}{1} + \binom{1}{1}\binom{2}{2} = 24$$

$$TN = (TN + FN) - FN= 72$$

然后利用之前的数据可以计算rand index的值

$$RI = \frac{TP + TN}{TP + FP + FN + TN}$$

## k-means & k-means++

这两个都是非常有趣的想法，利用找重心的方法来确定聚类。但是两者的具体做法又不太一样。前者是因为最后结果收敛（证明不太好想，我想到了一个同样很naive的证明，但是太水了就不放上来了），所以随机选启动点，然后依据距离大小进行分类，开始找质心迭代。后者的启动点虽然也是随机先选一个，然后是通过概率添加的新节点，概率值正比于到中心点的距离。

目前我并不知道后者的方法的好坏，因为没有实现过。另外由于这两个方法基本类似，所以一定也是收敛的。但是收敛速度怎么样这个我就不确定了，等回头整理的时候实现以下看看代码的运行效率就好。

## HAC 质心法 堆优化

HAC, a.k.a Hierarchical Agglomerative Clustering，层次凝聚式聚类。通过实现定义类别之间的相似度函数，然后自底向上进行合并，最后得到一颗二叉树。

这里就有一些不错的相似度的方法，比如全连接，单连接，质心法，组平均四个。全连接和单连接正好相反，取两个类别种任意两篇文档之间的相似度，全连接取最小值为相似度，单连接取最大值为相似度。注意这里的最大最小，是指的是文档之间的相似度的大小属性。类比过来就是，如果两个文档的距离小，相似度就大。那么换言之，全连接选的是两个集合的最大距离，单连接选的是最近距离。

质心法和组平均就比较有趣，实际上上面的两个选择的距离函数是无穷范数，而这里的就是选取的是朴素范数。质心法是计算所有类别间的文档对之间的相似度的平均值。组平均法又比质心法多了一个自身类别当中的文档之间的相似度，所以相当于是计算了类间和类内的相似度。而质心法则实际上是一个典型的类间相似度。

更有趣的是，质心法等价于计算，类别A的质心到类别B的质心的相似度，所以得名质心法。也就是

$$S_1 = \frac{1}{mn}\sum^n_i \sum^m_j {\Vert p_i - q_j\Vert} = S_2= \Vert(\frac{1}{n}\sum^n_i {p_i}) - (\frac{1}{m}\sum^m_j {q_j})\Vert$$

当然这个证明也从略了，应该不难，我在纸上写了一会就差不多出来了。

最后一个就是堆优化了，因为每一次都是在连接最大或最小的，那么就很快的想到利用堆来对最大值最小值的检索进行优化。这样就可以把这里的$$O(N^2)$$的时间复杂度降低到$$O(N\log N)$$了。

当然今天还讲了回归和推荐的一些问题，不过由于我能力有限，对其理解不是很到位，不敢乱说话，所以先匿了。