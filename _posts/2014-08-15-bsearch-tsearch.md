---
layout: post
title: "[数值计算] 二分法与三分法"
date: 2014-08-15 22:59:59 +0800
categories: notebook algolearning
tags: bsearch tsearch
---
二分法和三分法都是两个比较基础的数值计算方法，其核心思路基本一致，都是将可能存在解的区间分成两份，然后进行选取。不过在做题的过程中，也发现了很多的做题技巧编码技巧。

# 二分法

二分题目大概分以下几种：

<ol>
<li>纯粹的二分查找或者纯粹的二分法找函数零点（基础题）；</li>
<li>二分答案验证，也就是“最大化某最小值”，“最小化某最大值”之类的问题（简单题）；</li>
<li>浮点数的答案二分，尤其是在计算几何领域的二分题（中档题）；</li>
<li>将解空间分治成两部分，然后对其进行二分查找（中档偏难）；</li>
<li>二分套二分的题目，也就是多个量的二分，很难想，而且不容易做（难题）。</li>
</ol>
下面慢慢结合我做过的题一条一条的说明：

<ul>
<li>纯粹的二分查找题需要注意答案的正确性。举个例子，使用了STL的lower_bound或者upper_bound之后，他们的返回值，是最后一次检查的迭代器的值，不能完全确保答案的正确性，所以最好自己反过来检查一遍的好。</li>
<li>如果数学公式可以直接推出答案的题目，数学公式显然更方便，但是要考虑精度问题。比如 POJ1905，虽然可以通过推导公式转化成一个求函数零点的题目，但是如果你真的直接去搞就会跪掉，因为函数在不断地波动，而且精度也是个大问题。</li>
<li>最大化某最小值返回r，最小化某最大值返回l。如果实在不放心，可以随便返回一个值w，然后对整个集合[w-5, w 5]校验一遍。（论暴力打法的必要性）。</li>
<li>计算几何题更是大坑，不能一概而论，要逐一分析。比如LightOJ1196，已经说明了这个逗比在多边形内，所以可以用二分法来找三角形（憋了半天想到的解法）。还有LightOJ1358，这个则是稍微正经一点的二分题，验证部分是套用模板来计算，主要问题在于精度。</li>
<li>说道精度，不得不提两个细节。第一是不要用等号，浮点数不是整数，等号会有各种各样的问题。第二是尽量注意误差的累积。简单地说，就是如果两个数本身都携带了误差，这两个数在进行相乘、相除、或者其他更复杂的计算的时候，误差就不好玩了。这也是为什么有的时候浮点数二分卡pow函数的原因。</li>
<li>解空间分治法，推荐这几个题：LightOJ1127，LightOJ1235，LightOJ1276。这几个题目的共同点是，把解空间分成AB两部分，然后通过在A暴力，对每一个A的元素找B中符合要求的。AB的预处理基本上是暴力去搞（因为大部分的都是O(2^N)或者更小的，如果N变成一半时间复杂度会大大降低，比如LightOJ1127和1235），然后在通过一个暴力一个二分来搞。假设A与B的解空间的大小是M，则实际计算的时间复杂度是O(MlgM)，预处理出解空间为M的时间复杂度大概是O(M)，这样就基本保证问题可以在O(K * M), K ≈ lgM的时间复杂度解决。</li>
<li>二分套二分的题只做过一个（其实还是一个二分的。。。），注意点应该是有序。也就是二分的核心条件，必须是单调的才能二分。</li>
</ul>
# 三分法

既然讲到二分就不得不提三分。三分只能解决单峰或单谷的问题。具体的编码有三种，三等分法，midmid法，还有一种就是黄金分割法。

三等分法是最容易想到的，也是最容易实现的。

{% highlight cpp %}
double Tsearch_e(double l, double r)
{
    ///@return the x, not the f(x)
    double midl = 0, midr = 0;
    while (r - l > eps)
    {
        midl = (2 * l   r) / 3;
        midr = (2 * r   l) / 3;
        if (test(midl, midr)) l = midl;
        else r = midr;
    }
    return midl;
}{% endhighlight %}

这个肯定能保证正确。但是我想问，能不能通过任意的在区间同时选取两个点，通过这两个点的信息来确认下一个选取的区间呢？当然是可以的。所以就有了下面的midmid法，顾名思义，mid是l与r的中值，midmid是mid与r的中值。

{% highlight cpp %}
double Tsearch(double l, double r)
{
    ///@return the x, not the f(x)
    double mid = 0, midmid = 0;
    while (r - l > eps)
    {
        mid = (r   l) / 2;
        midmid = (mid   r) / 2;
        if (test(mid, midmid)) l = mid;
        else r = midmid;
    }
    return mid;
}{% endhighlight %}

还有一种是黄金分割法，也就是通过选取两个黄金分割线去计算。为什么单独说明这个方法呢？因为黄金分割法实际上会减少一次计算。假设我下一次选取的解空间是[l, midr]，左端点与靠右的黄金分割点，那么新的靠右的黄金分割点是不需要计算的，就是上一次的midl。这个性质保证了他的迭代次数的稳定，同时减少了计算量。

{% highlight cpp %}
double Tsearch_s(double l, double r)
{
    ///@return the x, not the f(x)
    double midl = r - (r - l) * cef;
    double midr = l   (r - l) * cef;
    while (r - l > eps)
    {
        if (test(midl, midr))
        {
            l = midl; midl = midr;
            midr = l   (r - l) * cef;
        }
        else
        {
            r = midr; midr = midl;
            midl = r - (r - l) * cef;
        }
    }
    return midr;
}{% endhighlight %}
