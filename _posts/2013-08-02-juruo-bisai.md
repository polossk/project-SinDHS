---
layout: post
title:  "[比赛记录] 弱菜们的自娱自乐"
date:   2013-08-02 22:17:00 +0800
categories: contest solution
tags: codeforces realcombat
---
弱菜们的自娱自乐

地址：<http://acm.hust.edu.cn/vjudge/contest/view.action?cid=28059>

本来自娱自乐正high，结果天降大牛，16分钟AK了=。=我嘞个篮子的，坑爹的吧=。=

# A

二分搜索，不解释。

{% highlight cpp %}
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>
using namespace std;
int mm[10005];
int num[10005];
bool search(int a,int b,int  key){
    if (a>b) return 0;
    int mid=(a+b)/2;
    if (mm[mid]==key) return 1;
    if (mm[mid]>key)
        return search(a,mid-1,key);
    else
        return search(mid+1,b,key);
}

int main(){
    for (int i=1;i<=10000;i++)
        mm[i]=i*i;
    for (int i=10000;i>=1;i--){
        for (int j=i-1;j>=1;j--){
            int tt=i*i-j*j;
            if (tt>j*j)break;
            if (search(1,10000,tt)){
                num[i]++;
            }
        }
    }
    int n;
    scanf("%d",&n);
    int sum=0;
    for (int i=1;i<=n;i++)
        sum+=num[i];
    printf("%dn",sum);
    return 0;
}
{% endhighlight %}

# B

一开始想麻烦了，分了好几种情况，后来干脆以1900年1月1日为原点，分别计算“距离”。注意最后的结果必须是正数，差点WA了。

{% highlight cpp %}
#include <iostream>
#include <cmath>
#include <string>
#include <cstring>
#include <cstdio>
using namespace std;

int isLeapyear(int yy){
    return yy%(yy%100?4:400)?0:1;
}
int day[2][12]={
    {31,28,31,30,31,30,31,31,30,31,30,31},
    {31,29,31,30,31,30,31,31,30,31,30,31}
};
int calday(int yy,int mm,int dd){
    int i;
    int sum=0;
    for (i=1900; i<yy; i++){
        if (isLeapyear(i))
            sum+=366;
        else
            sum+=365;
    }
    int p=isLeapyear(yy);
    for (i=1; i<mm; i++)
        sum+=day[p][i-1];
    sum+=dd;
    return sum;
}

int main(){
    char a[11];
    while (cin>>a){
        int yy=(a[0]-'0')*1000+(a[1]-'0')*100+(a[2]-'0')*10+(a[3]-'0');
        int mm=(a[5]-'0')*10+(a[6]-'0');
        int dd=(a[8]-'0')*10+(a[9]-'0');
        int pa=calday(yy,mm,dd);
        cin>>a;
        yy=(a[0]-'0')*1000+(a[1]-'0')*100+(a[2]-'0')*10+(a[3]-'0');
        mm=(a[5]-'0')*10+(a[6]-'0');
        dd=(a[8]-'0')*10+(a[9]-'0');
        int pb=calday(yy,mm,dd);
        int res=abs(pa-pb);
        cout<<res<<endl;
    }
    return 0;
}
{% endhighlight %}


# C

题目的意思不难理解，两个数字相加，每位至少有个0；考虑到题目中的条件，所给数据大小在0到100，所以就有了一个比较简单的选数思路：

1、有0，有100，直接选进去；

2、有属于(0,10)的数，选进去；

3、可以被10整除的数，选进去；

4、以上三种都没有，那就随便选一个进去；

5、重复。

hash的作用是指示该数字有没有被选进去，方便查找。

{% highlight cpp %}
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>

using namespace std;

const int maxn=100+5;
int ans[maxn];
int a[maxn];
bool hash[maxn];

int main(){
    int n;
    cin>>n;
    int cnt=0,x;
    bool flag2=0,flag3=0;
    memset(hash,0,sizeof(hash));
    for (int i=0; i<n; i++){
        cin>>a[i];
        x=a[i];
        if(x==0) ans[cnt++]=x,hash[x]=1;
        else if(x==100) ans[cnt++]=x,hash[x]=1;
        else if(x%10==0&&!flag2) ans[cnt++]=x,flag2=1,hash[x]=1;
        else if(x/10==0&&!flag3) ans[cnt++]=x,flag3=1,hash[x]=1;
    }
    if (!flag2 && !flag3){
        for (int i=0; i<n; i++)
            if (!hash[a[i]]){
                ans[cnt++]=a[i];
                break;
            }
    }
    cout<<cnt<<endl;
    for (int i=0; i<cnt; i++)
        cout<<ans[i]<<" ";
    cout<<endl;
    return 0;
}
{% endhighlight %}


# D

一开始不敢写，以后有什么公式能直接出结果的，后来感觉是模拟的题目，但是考虑到计算量会特别大，这时候突发奇想，方法就来了：

起初，我准备按照公式所给的，先算an分之一，然后再加再分之一……最后算出结果了，直接比较，printf。后来想，如果那个an分之一太大了太小了总之不正常了变成除0错误或者一直都是1的循环怎么办。这就有了从后往前面推，从答案开始，减，算倒数，减，算倒数……次数够了，比较结果，printf。果然，一次AC。

{% highlight cpp %}
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>
using namespace std;

typedef long long int64;
int main(){
    int64 p,q,n,a;
    cin>>p>>q>>n;
    while (n){
        cin>>a;
        if (q==0 || a>p/q) break;
        p=p-a*q;
        swap(p,q);
        n--;
    }
    if (n||q) cout<<"NO"<<endl;
    else cout<<"YES"<<endl;
    return 0;
}
{% endhighlight %}


# E

最坑爹的就是这道题，一上来完全被吓到了，全是2的几次方几次方=。=不过读题之后就会发现其实是很简单的。

首先，等比数列的通项公式告诉我们，2^n - 1 = sigma(2^i , i =0 , n-1)(懒得用公式编辑器了)

就是说：

2^5 -1 = 31 = 1 +2 +4 +8 +16;

2^6 -1 = 63 = 1 +2 +4 +8 +16 +32;

……

所以有：

2^n -1 = 2 ^ 0 +2 ^ 1 + 2 ^ 2 + … + 2 ^ max；

右边一共有max+1个数，用max+1减去已经有的就是答案。

{% highlight cpp %}
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>
#include <set>
using namespace std;

set<int>Set;
int main(){
    int n,x,Max=0;
    cin>>n;
    for (int i=0;i<n;i++){
        cin>>x;
        while (Set.count(x)){
            Set.erase(x);
            x++;
        }
        Max=max(Max,x);
        Set.insert(x);
    }
    cout<<Max+1-Set.size()<<endl;
    return 0;
}
{% endhighlight %}


# F

最后就剩下F这个难啃的骨头了，只有那个捣乱哥做了出来=。=题目的大概意思是有一种游戏叫做拆分字符串，其中，这个字符串是指一个或者多个字符所组成的结构，注意，不包含空字符串。对于一个字符串，如果能够被拆分成ABA‘的结构，其中，B是一个字符，A和A’关于B镜面对称。两个人一个接一个地进行这种操作，谁如果无法进行这种操作，就认为是失败。

先把捣乱哥的代码发出来

{% highlight cpp %}
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>

using namespace std;
typedef long long int64;

int grundy[5001],pos[10001];

int main() {
    string s;
    int n,i,j;
    for (i=3;i<=5000;i++) {
        for (j=1;j<=i/2;j++)
            pos[grundy[j]^grundy[i-j-1]]=i;
        for (j=0;pos[j]==i;j++);
        grundy[i]=j;
    }
    cin>>s;
    n=s.size();
    for (i=1;i<n-1;i++){
        if (s[i-1]==s[i+1]){
            int cont=0, ans=0;
            for(j=0;j<n;j++){
                if(j!=0 && j!=n-1
                    && ( j<i-1 || j>i+1 )
                    && s[j-1]==s[j+1]) cont++;
                else{
                    ans^=grundy[cont+1];
                    cont=1;
                }
            }
            if(ans==0) {
                cout<<"First"<<endl;
                cout<<i+1<<endl;
                return 0;
            }
        }
    }
    cout<<"Second"<<endl;
    return 0;
}
{% endhighlight %}
预处理出Grundy值，然后就没有然后了