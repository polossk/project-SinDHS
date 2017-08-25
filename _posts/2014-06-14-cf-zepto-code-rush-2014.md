---
layout: post
title: "[比赛记录] Codeforces Zepto Code Rush 2014"
date: 2014-06-14 13:58:20 +0800
categories: contest solution
tags: codeforces
---
# A. Feed with Candy

一开始想的很native，就是想简单贪心排一下序去搞。。。然后玩脱了。。。先是无脑WA8，后来好不容易过了就被适牛hack了。。。

正解是，每次选取所有可能的糖果中，质量最大的那个。

具体实现的时候可以用优先队列去维护。

{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights rserved
#
#       @author       :Shen
#       @name         :A
#       @file         :G:My Source Code比赛与日常练习613 - CFA.cpp
#       @date         :2014-06-14 01:12
#       @algorithm    :Greedy
=============================================================================*/

#include <queue>
#include <cstdio>
#include <vector>
#include <algorithm>
using namespace std;

typedef long long int64;

int n, x, tmp;
int htmp, mtmp;
typedef pair<int, int> candy;
vector<candy> a[2];
priority_queue<int> f[2];

int work(int p)
{
    int h = x, j[2] = {0, 0}, ans = 0;
    for (int i = 0; i < 2; i++)
        while (!f[i].empty())
            f[i].pop();
    while (1)
    {
        while (j[p] < a[p].size() && a[p][j[p]].first <= h)
            f[p].push(a[p][j[p]++].second);
        if (f[p].empty()) break;
        h += f[p].top(), f[p].pop();
        ans++; p ^= 1;
    }
    return ans;
}

void solve()
{
    int rs1 = 0, rs2 = 0, ans = 0;
    for (int i = 0; i < 2; i++)
        if (a[i].size() > 0)
            sort(a[i].begin(), a[i].end());
    rs1 = work(1);
    rs2 = work(0);
    ans = max(rs1, rs2);
    printf("%dn", ans);
}

int main()
{
    scanf("%d%d", &n, &x);
    for (int i = 0; i < n; i++)
    {
        scanf("%d%d%d", &tmp, &htmp, &mtmp);
        a[tmp].push_back(make_pair(htmp, mtmp));
    }
    solve();
    return 0;
}{% endhighlight %}

# B. Om Nom and Spiders

模拟就行了，这个题目反而没有太大难度。

{% highlight cpp %}
/*=============================================================================
#       COPYRIGHT NOTICE
#       Copyright (c) 2014
#       All rights reserved
#
#       @author       :Shen
#       @name         :
#       @file         :G:My Source Code比赛与日常练习613 - CFB
#       @date         :2014/06/14 00:52
#       @algorithm    :
=============================================================================*/

//#pragma GCC optimize ("O2")
//#pragma comment(linker, "/STACK:1024000000,1024000000")

#include <cmath>
#include <cstdio>
#include <string>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <algorithm>
using namespace std;
template<class T>inline bool updateMin(T& a, T b){ return a > b ? a = b, 1: 0; }
template<class T>inline bool updateMax(T& a, T b){ return a < b ? a = b, 1: 0; }

char s[2005][2005];
int main()
{
    int n, m, k;
    scanf("%d%d%d", &n, &m, &k);
    for (int i = 0; i < n; i++)
        scanf("%s", s[i]);
    int ans = 0;
    for (int i = 0; i < m; i++)
    {
        ans = 0;
        for (int j = 1; j < n && i + j < m; j++)
        {
            if (s[j][i+j] == 'L')
                ans++;
        }
        for (int j = 1; j < n && (i - j) >= 0; j++)
            if (s[j][i-j] == 'R') ans++;
        for (int j = 1; j < n; j++)
            if (s[j][i] == 'U' && j % 2 == 0) ans++;
        printf("%d ",ans);
    }
    return 0;
}{% endhighlight %}

# C. Dungeons and Candies

最小生成树的题目

{% highlight cpp %}
/******************************************************
* author:xiefubao
*******************************************************/
#pragma comment(linker, "/STACK:102400000,102400000")
#include <iostream>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <queue>
#include <vector>
#include <algorithm>
#include <cmath>
#include <map>
#include <set>
#include <stack>
#include <string.h>
//freopen ("in.txt" , "r" , stdin);
using namespace std;


#define eps 1e-8
const double pi=acos(-1.0);
typedef long long LL;
const int Max=2010;
const int INF=1000000007 ;


int parent[Max];
LL count1[Max];
int num[Max];
int getparent(int t)
{
    if(t==parent[t])
        return t;
    return parent[t]=getparent(parent[t]);
}
struct point
{
    int u,v;
    LL value;
} points[Max*Max];
int p=0;
struct cao
{
    char num[11][11];
} caos[Max];
bool operator<(const point& a,const point& b)
{
    return a.value<b.value;
}
int n,m,k,w;
int com(int i,int j)
{
    int ans=0;
    for(int k=0; k<n; k++)
        for(int h=0; h<m; h++)
            if(caos[i].num[k][h]!=caos[j].num[k][h])
                ans++;
    return ans;
}
vector<int> vec[Max];
bool rem[2010];
vector<pair<int,int> > ps;
LL all=0;
void dfs(int t,int before)
{
    if(rem[t])
        return ;
    rem[t]=1;
    int tool=com(t,before)*w;
    if(before!=0&&tool>n*m)
    {
        all+=tool-n*m;
         ps.push_back(pair<int,int>(t,0));
    }
    else
       ps.push_back(pair<int,int>(t,before));
    for(int i=0; i<vec[t].size(); i++)
    {
        dfs(vec[t][i],t);
    }
}
int main()
{
    scanf("%d%d%d%d",&n,&m,&k,&w);
    for(int i=1; i<=k; i++)
    {
        for(int j=0; j<n; j++)
            scanf("%s",caos[i].num[j]);
    }
    for(int i=1; i<=k; i++)
        parent[i]=i;
    for(int i=1; i<k; i++)
        for(int j=i+1; j<=k; j++)
        {
            points[p].u=i;
            points[p].v=j;
            points[p++].value=com(i,j)*w;
        }
    sort(points,points+p);
    int tool=0;
    LL ans=n*m;
    for(int i=0; i<p; i++)
    {
        if(tool==k-1)
            break;
        int p1=getparent(points[i].u);
        int p2=getparent(points[i].v);
        if(p1==p2)
            continue;
        vec[points[i].v].push_back(points[i].u);
        vec[points[i].u].push_back(points[i].v);
        tool++;
        ans+=points[i].value;
        parent[p1]=parent[p2];
    }
    dfs(1,0);
    cout<<ans-all<<endl;
    for(int i=0;i<k;i++)
        cout<<ps[i].first<<" "<<ps[i].second<<endl;
    return 0;
}{% endhighlight %}
