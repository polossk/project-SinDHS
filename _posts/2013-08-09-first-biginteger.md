---
layout: post
title:  "[题解整理] 高精度运算入门水题选"
date:   2013-08-09 22:30:00 +0800
categories: contest solution
tags: acmicpc uva highprecision
---

同样是《算法竞赛入门经典》里面选的习题。其中，UVa 465 - Overflow 很有启发性，另外拿出来了，参见[[传送门]({% post_url 2013-08-09-uva465 %})]。其余的题目除了UVa748 - Exponentiation略麻烦以外，其他的都是考核你的大数模版是否强壮的测试型题目。其中UVa 424 - Integer Inquiry考察加法计算，UVa 10106 - Product考察乘法运算，UVa 10494 - If We Were a Child Again考察除法和求模运算，因此希望大家的大数模版足够强壮来满足用户的使用。

因此，建议大家的大数模版的基本构架如下

{% highlight cpp %}
class BigInt{
    private:
        char *digits;
        int capacity;		//数据的位数
        int sign;			//正数、负数、0
	public:
		BigInt(){};			//创建一个数据为0的大数
		BigInt(int n);		//从整数创建大数
		BigInt(string s);	//从字符串创建大数
		BigInt(const BigInt& n);//复制构造函数
		~BigInt(){}			//析构函数
		
		//+,-,*,/,%,基础运算
		BigInt operator+(const BigInt& b);
		BigInt operator-(const BigInt& b);
		BigInt operator*(const BigInt& b);
		BigInt operator/(const BigInt& b);
		BigInt operator%(const BigInt& b);
		
		//大小比较函数
		bool operator<(const BigInt& b);
		bool operator>(const BigInt& b);
		bool operator==(const BigInt& b);
		
		//输入输出函数
		friend istream& operator<<(istream& is,const BigInt& n);
		friend ostream& operator>>(ostream& os,const BigInt& n);
};
{% endhighlight %}

简而言之，用一个int64的后9位和另一个int64的其余位置表示一个数，就是我们所说的伪int128。

总而言之，一切服从设计需求，根据要求来合理选择模版才是正确的。

因而，不再提供UVa 424，UVa 10106，UVa 10494的代码。因为如果读者已经写好模版并且正确封装，相信我们的主函数将是非常简单的：

# UVa 424 - Integer Inquiry

考察加法计算
{% highlight cpp %}
int main(){
	int i=0;BigInt t,s;
	while (cin>>t && t){
		s=s+t;
	}
	cout<<s<<endl;
    return 0;
}
{% endhighlight %}

# UVa 10106 - Product

考察乘法运算
{% highlight cpp %}
int main(){
	int i=0;BigInt a,b;
	while (cin>>a>>b){
		BigInt c;
		c=a*b;
		cout<<c<<endl;
	}
    return 0;
}
{% endhighlight %}


# UVa 10494 - If We Were a Child Again

考察除法和求模运算
{% highlight cpp %}
int main(){
	int i=0;BigInt a,b;char op;
	while (cin>>a>>op>>b){
		BigInt c;
		switch (op){
			case '/':{c=a/b;break;}
			case '%':{c=a%b;break;}
			default :break;
		}
		cout<<c<<endl;
	}
    return 0;
}
{% endhighlight %}


# UVa 748 - Exponentiation

最后一个题目，求幂非常繁琐，希望大家能够在代码中理解。
{% highlight cpp %}
/****
	*@Polo-shen
	*
	*/
#include <iostream>
//#include <iomanip>
//#include <fstream>
//#include <algorithm>
//#include <cmath>
#include <string>
#include <cstring>
#include <cstdio>
//#include <cstdlib>
//#include <set>

using namespace std;
typedef long long int64;

#define DBG 0
#define ShowLine DBG && cout<<__LINE__<<">>| "
#define dout DBG && cout<<__LINE__<<">>| "
#define write(x) #x" = "<<(x)<<", "

int n,point,___index;//n次幂。point代表小数点后有几位。
int si[1000],res[1000],temp[1000],l2;//si[1000]存s变成的整数，一位一位存
string s;
void init(){//让s变成一个整数串，并且记录下小数点后有几位；
	point=0;//初始化point;
	___index=0;//si的下标变量
	int l=s.length();//字符串s的长度。
	int i=l-1;
	int flag=0;
	//for(i=l-1;s[i]!='0';i--);//除去后导0
	for(int j=0;j<=i;j++){
		if(s[j]=='0'&&!___index&&!flag)/*除去前导0，前导0满足3个要求
		1.为0  2.在.前面 3.在数前面*/
			continue;
		if(s[j]=='.'){
			for(i=l-1;s[i]=='0';i--);//除去后导0
			flag=1;
			continue;
		}
		if(flag){
			si[___index++]=s[j]-48;
			point++;
		}
		else
			si[___index++]=s[j]-48;
	}
}
void print(){
	int k=point*n;
	if(l2+1>k){
	for(int i=1;i<=l2+1;i++){
		if(i==l2+1-k+1)
			cout<<".";
		cout<<res[i-1];
	}
	cout<<endl;
	}
	else{
		cout<<".";
		for(int i=0;i<k-l2-1;i++)
			cout<<"0";
		for(int i=0;i<=l2;i++)
			cout<<res[i];
		cout<<endl;
	}
}
int main(){
	while(cin>>s>>n){
	init();
	memcpy(res,si,sizeof(res));
	l2=___index-1;//记录res的长度
	for(int times=0;times<n-1;times++){//进行n-1次迭代
		int tempsize;//记录中间过程的下标
		memset(temp,0,sizeof(temp));//把中间变量置为0
		for(int i=___index-1;i>=0;i--){//对于si的每一位
			tempsize=___index-i-2;//要把这位的结果从这里开始放。模拟竖式乘法
			for(int j=l2;j>=0;j--){//乘以res中的每一位
				tempsize++;
				temp[tempsize]+=si[i]*res[j];
				if(temp[tempsize]>=10){//进位
					int k=temp[tempsize]/10;
					temp[tempsize]%=10;
					temp[tempsize+1]+=k;
				}
			}
		}
		tempsize++;
		while(temp[tempsize]!=0){//最后的大进位。
			if(temp[tempsize]>=10){
			int k=temp[tempsize]/10;
				temp[tempsize]%=10;
				temp[tempsize+1]+=k;
			}
			tempsize++;
		}
		tempsize--;
		if(tempsize>l2)//拓展res的长度
			l2=tempsize;
		for(int i=0;i<=l2;i++)//准备下一次迭代;
			res[i]=temp[l2-i];
	}
	print();
	}
	return 0;
}
{% endhighlight %}
