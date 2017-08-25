---
layout: post
title: "[图论] 最小树形图（朱-刘算法）"
date: 2014-08-14 19:02:37 +0800
categories: notebook algolearning
tags: MinimumArborescence
---
定义：一个有向图，存在从某个点开始的到达所有的的一个最小生成树，则它就是最小树形图。


# 朱-刘算法

大概过程如下：

<ol>
<li>找到除了root以为其他点的权值最小的入边。用In[i]记录</li>
<li>如果出现除了root以为存在其他孤立的点，则不存在最小树形图。</li>
<li>找到图中所有的环，并对环进行缩点，重新编号。</li>
<li>更新其他点到环上的点的距离，如：
<blockquote>
环中的点有（Vk1，Vk2，… ，Vki）总共i个，用缩成的点叫Vk替代，则在压缩后的图中，其他所有不在环中点v到Vk的距离定义如下：

<blockquote>gh[v][Vk]=min { gh[v][Vkj]-mincost[Vkj] } (1<=j<=i)</blockquote>

而Vk到v的距离为

<blockquote>gh[Vk][v]=min { gh[Vkj][v] } (1<=j<=i)</blockquote>

</blockquote>

</li>
<li>重复3，4知道没有环为止。</li>
</ol>

上面说的是定根的情况，如果是不定根的情况我们可以虚拟一个根，让虚拟根到每个节点的距离为图上所有边的权值之和加一。这样找到最小树形图后再减掉所有边的权值之和加一就可以了。

# Code Here

## POJ 3164
{% highlight cpp %}
struct node { double x, y; };
struct edg { int u, v; double cost; };

const int MaxN = 110;
const int MaxM = 10010;
const double eps = 1e-6;
const double inf = ~0u>>1;

node point[MaxN];
edg  E[MaxM];
double In[MaxN];
int ID[MaxN], vis[MaxN], pre[MaxN];
int NV, NE;

double SQ(int u, int v) {
    return sqrt((point[u].x - point[v].x)*(point[u].x - point[v].x)  
                (point[u].y - point[v].y)*(point[u].y - point[v].y));
}

double Directed_MST(int root) {
    double ret = 0;
    int i, u, v;
    while (true) {
        for (int i = 0; i < NV; i  ) In[i] = inf;
        for (int i = 0; i < NE; i  )
		{// 找最小入边
            u = E[i].u;
            v = E[i].v;
            if (E[i].cost < In[v] && u != v)
			{
                In[v] = E[i].cost;
                pre[v] = u;
            }
        }
        for (int i = 0; i < NV; i  )
		{// 如果存在除root以外的孤立点，则不存在最小树形图
            if (i == root) continue;
            if (In[i] == inf) return -1;
        }

        int cnt = 0;
		fill(ID, ID   MaxN, -1);
		fill(vis, vis   MaxN, -1);
        In[root] = 0;

        for (int i = 0; i < NV; i  )
		{// 找环
            ret  = In[i];
            int v = i;
            while (vis[v] != i && ID[v] == -1 && v != root)
			{
                vis[v] = i;
                v = pre[v];
            }
            if (v != root && ID[v] == -1)
			{// 缩点并且重新标号
                for (u = pre[v]; u != v; u = pre[u]) ID[u] = cnt;
                ID[v] = cnt  ;
            }
        }
        if (cnt == 0) break;
        for (int i = 0; i < NV; i  ) // 重新标号
            if (ID[i] == -1) ID[i] = cnt  ;
        for (int i = 0; i < NE; i  )
		{// 更新其他点到环的距离
            v = E[i].v;
            E[i].u = ID[E[i].u];
            E[i].v = ID[E[i].v];
            if (E[i].u != E[i].v) E[i].cost -= In[v];
        }
        NV = cnt;
        root = ID[root];
    }
    return ret;
}{% endhighlight %}

## HDU 2121

{% highlight cpp %}
// <!--encoding UTF-8 UTF-8编码--!>
/*****************************************************************************
*                      ----Stay Hungry Stay Foolish----                      *
*    @author    :   Shen                                                     *
*    @name      :   hdu 2121                                                 *
*****************************************************************************/

//#pragma GCC optimize ("O2")
//#pragma comment(linker, "/STACK:1024000000,1024000000")

//#include <bits/stdc  .h>
#include <map>
#include <list>
#include <queue>
#include <stack>
#include <cmath>
#include <vector>
#include <string>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <iostream>
#include <algorithm>
using namespace std;
typedef long long int64;
template<class T>inline bool updateMin(T& a, T b){ return a > b ? a = b, 1: 0; }
template<class T>inline bool updateMax(T& a, T b){ return a < b ? a = b, 1: 0; }
inline int    nextInt() { int x; scanf("%d", &x); return x; }
inline int64  nextI64() { int64  d; cin >> d; return d; }
inline char   nextChr() { scanf(" "); return getchar(); }
inline string nextStr() { string s; cin >> s; return s; }
inline double nextDbf() { double x; scanf("%lf", &x); return x; }
inline int64  nextlld() { int64 d; scanf("%lld", &d); return d; }
inline int64  next64d() { int64 d; scanf("%I64d",&d); return d; }

const int MaxN = 1024;
const int MaxM = MaxN * MaxN;
const int inf  = ~0u>>1;

struct edg { int u, v, cost; };
edg  E[MaxM];
int In[MaxN];
int ID[MaxN], vis[MaxN], pre[MaxN];
int NV, NE;
int Minroot;

int Directed_MST(int root) {
    int ret = 0;
    int i, u, v;
    while(true) {
        for (int i = 0; i < NV; i  ) In[i] = inf;
        for (int i = 0; i < NE; i  )
		{// 找最小入边
            u = E[i].u;
            v = E[i].v;
            if (E[i].cost < In[v] && u != v)
			{
                In[v] = E[i].cost;
				if (u == root) // 不能直接等于v，因为会缩边
                    Minroot = i;
                pre[v] = u;
            }
        }
        for (int i = 0; i < NV; i  )
		{// 如果存在除root以外的孤立点，则不存在最小树形图
            if (i == root) continue;
            if (In[i] == inf) return -1;
        }

        int cnt = 0;
		fill(ID, ID   MaxN, -1);
		fill(vis, vis   MaxN, -1);
        In[root] = 0;

        for (int i = 0; i < NV; i  )
		{// 找环
            ret  = In[i];
            int v = i;
            while (vis[v] != i && ID[v] == -1 && v != root)
			{
                vis[v] = i;
                v = pre[v];
            }
            if (v != root && ID[v] == -1)
			{// 缩点并且重新标号
                for (u = pre[v]; u != v; u = pre[u]) ID[u] = cnt;
                ID[v] = cnt  ;
            }
        }
        if (cnt == 0) break;
        for (int i = 0; i < NV; i  ) // 重新标号
            if (ID[i] == -1) ID[i] = cnt  ;
        for (int i = 0; i < NE; i  )
		{// 更新其他点到环的距离
            v = E[i].v;
            E[i].u = ID[E[i].u];
            E[i].v = ID[E[i].v];
            if (E[i].u != E[i].v) E[i].cost -= In[v];
        }
        NV = cnt;
        root = ID[root];
    }
    return ret;
}

int main() {
    int i, l, x;
    while (~scanf("%d%d", &NV, &NE))
    {
        l = 0; x = NE;
        for (int i = 0; i < NE; i  )
        {
            scanf("%d%d%d", &E[i].u, &E[i].v, &E[i].cost);
            l  = E[i].cost;
        }
        l  ;
        for (int i = 0; i < NV; i  )
        {
            E[NE].u = NV;
            E[NE].v = i;
            E[NE].cost = l;
            NE  ;
        }
        NV  ;
        int ans = Directed_MST(NV - 1);
        if (ans == -1 || ans  >= 2 * l)
            puts("impossiblen");
        else
            printf("%d %dnn", ans - l, Minroot - x);
    }
    return 0;
}{% endhighlight %}
