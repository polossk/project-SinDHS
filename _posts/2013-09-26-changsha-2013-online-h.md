---
layout: post
title:  "长沙赛区网赛H Hypersphere"
date:   2013-09-26 18:36:00 +0800
categories: contest math
tags: acmicpc zoj realcombat mqmod
---
题目地址[->](http://acm.zju.edu.cn/changsha/showProblem.do?problemCode=H)

不懂的话看看这篇文章[[传送门]({% post_url 2013-09-26-hdu4565 %})]，这道题目和杭电的4565是一个类型。

唯一的变化是

{% highlight plain %}
    2*l
K1=(   )
     2
{% endhighlight %}

{% highlight plain %}
   2*l   -l
F=(        )
    1     0
{% endhighlight %}

# Code Here
{% highlight cpp %}
/****
	*@Polo-shen
	*
	*/
#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>
#include <cmath>
#include <vector>

using namespace std;
typedef long long int64;

const int MAXN = 3;
const int MAXM = 2;
/***
	*Title:
	*
	*/
struct Matrax{
	int n,m;
	int64 mat[MAXN][MAXM];
	Matrax():n(-1),m(-1){}
	Matrax(int _n,int _m):n(_n),m(_m){
		memset(mat,0,sizeof(mat));
	}
	void Unit(int _s){
		n=_s;m=_s;
		for (int i=0;i<n;i++){
			for (int j=0;j<n;j++){
				mat[i][j]=(i==j)?1:0;
			}
		}
	}
	void print(){
		cout<<write(n)<<write(m)<<endl;
		for (int i=0;i<n;i++){
			for (int j=0;j<m;j++){
				cout<<" "<<mat[i][j];
			}
			cout<<endl;
		}
	}
};

Matrax add_mod(const Matrax& a,const Matrax& b,const int64 mod){
	Matrax ans(a.n,a.m);
	for (int i=0;i<a.n;i++){
		for (int j=0;j<a.m;j++){
			ans.mat[i][j]=(a.mat[i][j]+b.mat[i][j])%mod;
		}
	}
	return ans;
}

Matrax mul(const Matrax& a,const Matrax& b){
	Matrax ans(a.n,b.m);
	for (int i=0;i<a.n;i++){
		for (int j=0;j<b.m;j++){
			int64 tmp=0;
			for (int k=0;k<a.m;k++){
				int64 res=a.mat[i][k]*b.mat[k][j];
				tmp+=res;
			}
			ans.mat[i][j]=tmp;
		}
	}
	return ans;
}

Matrax mul_mod(const Matrax& a,const Matrax& b,const int64 mod){
	Matrax ans(a.n,b.m);
	for (int i=0;i<a.n;i++){
		for (int j=0;j<b.m;j++){
			int64 tmp=0;
			for (int k=0;k<a.m;k++){
				tmp+=(a.mat[i][k]*b.mat[k][j])%mod;
			}
			ans.mat[i][j]=tmp%mod;
		}
	}
	return ans;
}

Matrax pow_mod(const Matrax& a,int64 k,int64 mod){
	Matrax p(a.n,a.m),ans(a.n,a.m);
	p=a;ans=a;
	ans.Unit(a.n);
	if (k==0){
		return ans;
	}
	else if (k==1){
		return a;
	}
	else {
		while (k){
			if (k&1){
				ans=mul_mod(ans,p,mod);
				k--;
			}
			else {
				k/=2;
				p=mul_mod(p,p,mod);
			}
		}
		return ans;
	}
}

void solve(int64 k,int64 l){
	/*
	   2*l   -l
	F=(        )
		1     0
	*/
	Matrax F(2,2);
	F.mat[0][0]=2*l;F.mat[0][1]=-l;
	F.mat[1][0]=1;F.mat[1][1]=0;
	//F.print();
	/*
		2*l
	K1=(   )
		 2
	*/
	Matrax K1(2,1);
	K1.mat[0][0]=2*l;
	K1.mat[1][0]=2;
	//K1.print();
	/*
		 Sn
	Kn=(    )
		Sn-1
	*/
	Matrax Kn(2,1);
	Matrax tmp(2,2);
	tmp=pow_mod(F,k-1,k);
	//tmp.print();
	Kn=mul_mod(tmp,K1,k);
	//cout<<"Kn";Kn.print();
	int64 ans=(Kn.mat[0][0]-1+k);
	cout<<(ans%k)<<endl;
	return;
}

int main(){
	int64 k,l;
	while (cin>>k>>l){
		solve(k,l);
	}
    return 0;
}
{% endhighlight %}
