---
layout: post
title: "[排序算法] 四种排序算法的比较"
date: 2014-06-12 23:49:00 +0800
categories: notebook algolearning
tags: Algorithm
---
# 整理
<table border="2" width="800" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td valign="top" width="20%">算法</td>
<td valign="top" width="20%">快速排序</td>
<td valign="top" width="20%">堆排序</td>
<td valign="top" width="20%">希尔排序</td>
<td valign="top" width="20%">归并排序</td>
</tr>
<tr>
<td valign="top" width="20%">时间复杂度</td>
<td valign="top" width="20%">平均O(NlgN)，最差可能是O(N^2)</td>
<td valign="top" width="20%">O(NlgN)</td>
<td valign="top" width="20%">希尔序列会对时间复杂度有影响，但是基本在O(N)和O(N^2)之间。数据量小的话并且希尔序列选择得当，近似O(N^1.5)</td>
<td valign="top" width="20%">O(NlgN)</td>
</tr>
<tr>
<td valign="top" width="20%">是否稳定</td>
<td valign="top" width="20%">不稳定</td>
<td valign="top" width="20%">和代码实现有关，一般稳定</td>
<td valign="top" width="20%">稳定</td>
<td valign="top" width="20%">稳定</td>
</tr>
<tr>
<td valign="top" width="20%">核心思想</td>
<td valign="top" width="20%">随机性</td>
<td valign="top" width="20%">数据结构的特性</td>
<td valign="top" width="20%">依次缩小增量插入排序</td>
<td valign="top" width="20%">分治法的经典应用</td>
</tr>
<tr>
<td valign="top" width="20%">具体原理</td>
<td valign="top" width="20%">先设置一个flag，然后依据大小分成两类；针对每一类重复分类操作。</td>
<td valign="top" width="20%">建立一个二叉堆（最大或最小），插入元素时及时维护堆的性质即可。</td>
<td valign="top" width="20%">依据希尔序列，对元素进行“分类，排序，选取下一个增量”直到对希尔序列所有的元素（也就是增量）跑完为止。</td>
<td valign="top" width="20%">从中间劈开分成两半，再劈开直到只剩一个元素为止。然后依据元素大小合并，直到最后为止。</td>
</tr>
<tr>
<td valign="top" width="20%">代码实现复杂度</td>
<td valign="top" width="20%">较简单</td>
<td valign="top" width="20%">略难</td>
<td valign="top" width="20%">略难</td>
<td valign="top" width="20%">较简单</td>
</tr>
</tbody>
</table>
现在把这四种排序的代码给大家。数据储存是用vector，堆排序直接用了标准库的，希尔序列用的是最简单的序列（1, 2, 3, 5, 9, 17, 33, …)。

# 快速排序
{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights reserved
#
#       @author       :Shen
#       @name         :QuickSort.cpp
#       @file         :G:My Source Code比赛与日常练习612 - 数据结构排序算法QuickSort.cpp
#       @date         :2014-06-12 20:44
#       @algorithm    :Quick Sort
=============================================================================*/
#include <iostream>
#include <cstdio>
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;
vector<int> a;

void QuickSort(vector<int>& a, int n, int left, int right)
{
    int i = 0, j = 0, t = 0;
    if (left < right){
        i = left;
        j = right + 1;
        while (1){
            while (i <= n && a[++i] < a[left]);
            while (j >= 0 && a[--j] > a[left]);
            if (i >= j) break;
            swap(a[i], a[j]);
        }
        swap(a[left], a[j]);
        QuickSort(a, n, left, j - 1);
        QuickSort(a, n, j + 1, right);
    }
}

int main()
{
    int n = 0, tmp = 0;
    cout << "Input the Data Size. Maxinum data size = 2 ^ 20!" << endl;
    cout << "teg. the size is 10, input 10." << endl;
    cout << "n = ";
    cin >> n;
    cout << "n = " << n << endl;
    cout << "Now input the each data." << endl;
    for (int i = 0; i < n; i++)
    {
        cout << " element = ";
        cin >> tmp;
        a.push_back(tmp);
    }

    QuickSort(a, n, 0, n - 1);
    //库函数实现法
    //sort(a.begin(), a.end())
    cout << "Input Compelete." << endl;
    cout << "Now on print the sorted data, by Quick sort." << endl;
    for (int i = 0; i < n; i++)
    {
        printf("%8d", a[i]);
        if (i % 10 == 0 && i >= 10) puts("");
    }
    return 0;
}{% endhighlight %}

# 堆排序
{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights reserved
#
#       @author       :Shen
#       @name         :HeapSort.cpp
#       @file         :G:My Source Code比赛与日常练习612 - 数据结构排序算法HeapSort.cpp
#       @date         :2014-06-12 20:44
#       @algorithm    :Heap Sort
=============================================================================*/
#include <iostream>
#include <cstdio>
#include <queue>
#include <algorithm>
using namespace std;
priority_queue<int> heap;

int main()
{
    int n = 0, tmp = 0;
    cout << "Input the Data Size." << endl;
    cout << "teg. the size is 10, input 10." << endl;
    cout << "n = ";
    cin >> n;
    cout << "n = " << n << endl;
    cout << "Now input the each data." << endl;
    for (int i = 0; i < n; i++)
    {
        cout << " element = ";
        cin >> tmp;
        heap.push(tmp);
    }
    cout << "Input Compelete." << endl;
    cout << "Now on print the sorted data, by heap sort." << endl;
    for (int i = 0; i < n; i++)
    {
        printf("%8d", heap.top());
        if (i % 10 == 0 && i >= 10) puts("");
        heap.pop();
    }
    return 0;
}{% endhighlight %}

# 希尔排序
{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights reserved
#
#       @author       :Shen
#       @name         :ShellSort.cpp
#       @file         :G:My Source Code比赛与日常练习612 - 数据结构排序算法ShellSort.cpp
#       @date         :2014-06-12 20:44
#       @algorithm    :Shell Sort
=============================================================================*/
#include <iostream>
#include <cstdio>
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;
vector<int> a;
const int maxt = 20;
int Shell_d[maxt];


void ShellInsert(vector<int>& a, int d)
{
    int sz = a.size(), tmp = 0;
    int i = d, j = 0;
    for (i = d; i < sz; i++)
    {
        if (a[i] < a[i - d])
        {
            tmp = a[i];
            for (j = i - d; j >= 0 && tmp < a[j]; j -= d)
                a[j + d] = a[j];
            a[j + d] = tmp;
        }
    }
}

void ShellSort(vector<int>& a)
{
    int sz = a.size(), i = 1, t = 0;
    for (i = 1; i < sz; i *= 2, t++);
    for (int k = maxt - t; k < maxt; k++)
        ShellInsert(a, Shell_d[k]);
}

int main()
{
    Shell_d[maxt - 1] = 1;
    Shell_d[maxt - 2] = 2;
    for (int i = maxt - 3; i >= 0; i--)
        Shell_d[i] = (Shell_d[i + 1] * 2) - 1;
    int n = 0, tmp = 0;
    cout << "Input the Data Size. Maxinum data size = 2 ^ 20!" << endl;
    cout << "teg. the size is 10, input 10." << endl;
    cout << "n = ";
    cin >> n;
    cout << "n = " << n << endl;
    cout << "Now input the each data." << endl;
    for (int i = 0; i < n; i++)
    {
        cout << " element = ";
        cin >> tmp;
        a.push_back(tmp);
    }

    ShellSort(a);

    cout << "Input Compelete." << endl;
    cout << "Now on print the sorted data, by Shell sort." << endl;
    for (int i = 0; i < n; i++)
    {
        printf("%8d", a[i]);
        if (i % 10 == 0 && i >= 10) puts("");
    }
    return 0;
}{% endhighlight %}

# 归并排序
{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights reserved
#
#       @author       :Shen
#       @name         :MergeSort.cpp
#       @file         :G:My Source Code比赛与日常练习612 - 数据结构排序算法MergeSort.cpp
#       @date         :2014-06-12 20:44
#       @algorithm    :Merge Sort
=============================================================================*/
#include <iostream>
#include <cstdio>
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;
vector<int> a, c;

void Merge(vector<int> a, vector<int>& b, int s, int m, int n)
{
    int i = s, j = m + 1, k = s;
    for (; i <= m && j <= n; k++)
    {
        if (a[i] < a[j]) b[k] = a[i++];
        else             b[k] = a[j++];
    }
    while (i <= m) b[k++] = a[i++];
    while (j <= n) b[k++] = a[j++];
}

void Msort(vector<int> a, vector<int>& b, int s, int t)
{
    if (s == t) b[s] = a[s];
    else
    {
        int m = (s + t) / 2;
        Msort(a, c, s, m);
        Msort(a, c, m + 1, t);
        Merge(c, b, s, m, t);
    }
    return;
}

void MergeSort(vector<int>& a)
{
    int sz = a.size();
    Msort(a, a, 0, sz - 1);
}

int main()
{
    int n = 0, tmp = 0;
    cout << "Input the Data Size. Maxinum data size = 2 ^ 20!" << endl;
    cout << "teg. the size is 10, input 10." << endl;
    cout << "n = ";
    cin >> n;
    cout << "n = " << n << endl;
    cout << "Now input the each data." << endl;
    for (int i = 0; i < n; i++)
    {
        cout << " element = ";
        cin >> tmp;
        a.push_back(tmp);
        c.push_back(tmp);
    }

    MergeSort(a);

    cout << "Input Compelete." << endl;
    cout << "Now on print the sorted data, by a Merge sort." << endl;
    for (int i = 0; i < n; i++)
    {
        printf("%8d", a[i]);
        if (i % 10 == 0 && i >= 10) puts("");
    }
    return 0;
}{% endhighlight %}
