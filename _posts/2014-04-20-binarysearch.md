---
layout: post
title: "[C++][STL] 二分查找函数"
date: 2014-04-20 07:32:00 +0800
categories: notebook planguage
tags: cpp bsearch STL
---

## binary_search

这个函数的返回值是布尔型，也就是最简单的找到了就为真，没找到就是假。

传入参数有三个，数据集合的左端点，数据集合的右端点，查找的值。

注意这些左端点右端点是要求左开右闭原则的，就是和数学上的左开右闭区间[a, b)一样，右端点是个不会被查阅的值。

一般来说写法类似：

{% highlight cpp %}
bool flag = false;
int data[n] = {...};///数据
sort(data, data + n);
flag = binary_search(data, data + n, val);
cout << flag << endl;
vector<int> datav(data, data + n);
sort(datav.begin(), datav.end());
flag = false;
flag = binary_search(datav.begin(), datav.end(), val);
cout << flag << endl;{% endhighlight %}

注意所有的数据集合必须是有序的，否则二分查找就没意义了。

## upper_bound & lower_bound

这两个函数的返回值是地址或迭代器，也就是标准库中的容器iterator。当然，实际运用中必须用返回值减去集合首地址才能正常的获取我们习惯的数组下标。如果没有检索到查找元，返回数据集合的首地址。参数什么的和binary_search一样。额外注意的是upper_bound返回的是下标真实值+1，换句话说，一个集合a = {1, 2, 3, 4, 4, 4, 5, 6, 7, 8}，如果数组下表从0开始记录，那么upper_bound(a, a + 10, 4)的返回值是第七个元素的地址。但是实际上第六个元素是最后一个4。

具体的函数使用可以看下面的代码示例

## 代码示例
{% highlight cpp %}
/****
    *@author    Shen
    *@title     Test STL Binary Search Function
    */

#include <iostream>
#include <algorithm>
using namespace std;

typedef long long int64;

int main()
{
    int build[10] = {1, 2, 3, 4, 4, 4, 5, 6, 7, 8};
    for (int i = 0; i < 10; i++)
        cout << "build[" << i << "] = " << build[i] << endl;
    cout << upper_bound(build, build + 10, 4) - build << endl;///6
    cout << lower_bound(build, build + 10, 4) - build << endl;///3
    cout << lower_bound(build, build + 10, 0) - build << endl;///0
    cout << upper_bound(build, build + 10, 0) - build << endl;///0
    cout << binary_search(build, build + 10, 4) << endl;///1
    cout << binary_search(build, build + 10, 9) << endl;///0
    return 0;
}{% endhighlight %}
