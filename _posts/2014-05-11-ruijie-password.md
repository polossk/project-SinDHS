---
layout: post
title: "[综合] 读懂锐捷密码的储存方式"
date: 2014-05-11 23:13:00 +0800
categories: battle
tags: Base64 password xorpw
---
## 被星号掩盖的密码

这几天突然想撸一发锐捷密码的储存方式。一般地说，为了方式最简单的那种通过拦截数据包的方法直接获取账号密码的攻击方式，基本上所有的密码在本机的客户端里都是选择本地加密之后再储存的，然后通讯时再按照另外的规则进行通信。

虽然这个方式十分安全，但是也会聪明反被聪明误。以前我们可以用一个小技巧（其实就是一个小程序）来获取当前登录窗口中的用星号掩盖的密码，但是现在这招已经不管用了。因为这个方法实在是太不安全了。一旦被木马入侵，仅仅一个小程序就可以撸到几乎是所有的账号密码，那就指不定发生些什么事情了，毕竟撸到你的密码也是十分轻松愉快的一件事。所以说，现在基本上为了方便用户的懒人登陆（也就是“记住我”这个选项），同时为了保证密码的安全，大致上现在的客户端都是这个流程（简化的）。


可以看到，通过加密的数据库和乱码的密码框，的确多多少少保证了数据的安全。QQ目前太高端，至少对我这个小白而言。所以我准备拿我们学校的锐捷客户端作为靶子，先撸一发。

通过查阅资料，我了解到了锐捷的密码数据库是存放在本机的安装目录里的（仅针对Windows下的，Linux不了解）。下面那个图便是锐捷存放你的账号密码还有消息日志的文件夹：

当然，为了方便我这里撸密码，我选了一个第三方的锐捷客户端。在他这里的存放的信息都在这个文件中：

这个文件中，内容如下：

{% highlight ini %}
[Parameters]
Caption=西北工业大学上网认证客户端
LinkURL=http://self.nwpu.edu.cn/
LinkTip=访问西北工业大学学生网络自助服务中心

AccountCount=2
CertFlag=0011100803000000
PackagePath=
DefaultAccount=Account0
DefaultAdapter=DeviceNPF_{1D5E92C5-D55D-4EA4-941D-464F3B38D4AB}
DefaultServiceType=1
[Account0]
Username=2012309999
Password=TxMJCxEc
IP=0.0.0.0{% endhighlight %}
可以看到密码了，当然是本机加密后的密码。我的任务就是撸通本机加密的方式。

## 密文分析

我这里的账号密码是随便搞的一个，密码是123456。如果是普通的恺撒密码（通过一个字符一一对应的方式进行加密的密码系统）和异或加密（下面会介绍），那么他应该保证密文和明文的长度相同。那么他肯定在密文长度上做了变换，所以我就开始了丧心病狂的实验= =

{% highlight ini %}
[Account1]
Username=2012100001
Password=TxALDhUbDRk=
IP=0.0.0.0
[Account2]
Username=2012100002
Password=TxALDhUbDQ==
IP=0.0.0.0
[Account3]
Username=2012100003
Password=TxALDhUb
IP=0.0.0.0
[Account4]
Username=2012100004
Password=TxALDhU=
IP=0.0.0.0
[Account5]
Username=2012100005
Password=TxALDg==
IP=0.0.0.0
[Account6]
Username=2012100006
Password=TxAL
IP=0.0.0.0
[Account7]
Username=2012100007
Password=TxA=
IP=0.0.0.0
[Account8]
Username=2012100008
Password=Tw==
IP=0.0.0.0{% endhighlight %}

我这些账号的密码明文分别是11111111，1111111，111111，…，11，1

注意下这些密文尾部的等号，这是一个很重要的标志。因为Base64编码方案中，不足位是要补上“=”的，所以我猜测这个密码系统使用到了Base64编码。

## Base64编码方案

Base64编码是一个简单的把所有拥有ASCII值，更普通的说，是只要在一个编码系统（UTF - 8，Unicode等等）里有值的字符，都可以通过这个编码方案来转化成一串具有实际字符值的字符串来进行交流通信。可能说的太抽象了，举一个简单的例子：回车符，嗯，在一般的编程语言里我们通常用n这个转义字符来表示。因为这是一个具有ASCII码值（13），但是不能通过一般的方式表示出来。因为在通信中，诸如此类的这些字符（更准确地说是控制字符）会产生歧义，简单的说就是在传递消息的时候（比如Email），我的正文里可以有很多的控制字符用来排版啊巴拉巴拉，但是如果直截了当地把这写控制字符传出去，那就有可能引发一些意想不到的故障，甚至是服务器宕机了这种天灾。所以在传输Email的时候，实际上是通过提前在本机将内容等等先进行Base64编码，然后在进行信息交互。

Base64编码的主要作用就是通过提前选择64个可打印字符，然后来表示二进制数据（其实也就是所有的数据了）。

一般的Base64所选取的基本字符串，也就是64个基础可打印字符，是由大小写字母（26 + 26），数字（10），还有加号（+）和左斜杠（/）所构成。另外等号（=）常常被用来当作后缀使用。

{% highlight cpp %}const string Base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";{% endhighlight %}

因为2的6次方是64，所以每6个位元为一个单元，对应某个可打印字符。三个字节有24个位元，对应于4个Base64单元，即3个字节需要用4个可打印字符来表示。当然，有的时候要求更高，比如在电子邮件中，根据RFC 822规定，每76个字符，还需要加上一个回车换行。不过一般来说都是认为近似长度会比明文长度多1/3。

Base64索引表：

<table style="width: 602px;" border="2" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td valign="top">Value</td>
<td valign="top">Char</td>
<td valign="top">Value</td>
<td valign="top">Char</td>
<td valign="top">Value</td>
<td valign="top">Char</td>
<td valign="top">Value</td>
<td valign="top">Char</td>
</tr>
<tr>
<td valign="top">0</td>
<td valign="top">A</td>
<td valign="top">16</td>
<td valign="top">Q</td>
<td valign="top">32</td>
<td valign="top">g</td>
<td valign="top">48</td>
<td valign="top">w</td>
</tr>
<tr>
<td valign="top">1</td>
<td valign="top">B</td>
<td valign="top">17</td>
<td valign="top">R</td>
<td valign="top">33</td>
<td valign="top">h</td>
<td valign="top">49</td>
<td valign="top">x</td>
</tr>
<tr>
<td valign="top">2</td>
<td valign="top">C</td>
<td valign="top">18</td>
<td valign="top">S</td>
<td valign="top">34</td>
<td valign="top">i</td>
<td valign="top">50</td>
<td valign="top">y</td>
</tr>
<tr>
<td valign="top">3</td>
<td valign="top">D</td>
<td valign="top">19</td>
<td valign="top">T</td>
<td valign="top">35</td>
<td valign="top">j</td>
<td valign="top">51</td>
<td valign="top">z</td>
</tr>
<tr>
<td valign="top">4</td>
<td valign="top">E</td>
<td valign="top">20</td>
<td valign="top">U</td>
<td valign="top">36</td>
<td valign="top">k</td>
<td valign="top">52</td>
<td valign="top">0</td>
</tr>
<tr>
<td valign="top">5</td>
<td valign="top">F</td>
<td valign="top">21</td>
<td valign="top">V</td>
<td valign="top">37</td>
<td valign="top">l</td>
<td valign="top">53</td>
<td valign="top">1</td>
</tr>
<tr>
<td valign="top">6</td>
<td valign="top">G</td>
<td valign="top">22</td>
<td valign="top">W</td>
<td valign="top">38</td>
<td valign="top">m</td>
<td valign="top">54</td>
<td valign="top">2</td>
</tr>
<tr>
<td valign="top">7</td>
<td valign="top">H</td>
<td valign="top">23</td>
<td valign="top">X</td>
<td valign="top">39</td>
<td valign="top">n</td>
<td valign="top">55</td>
<td valign="top">3</td>
</tr>
<tr>
<td valign="top">8</td>
<td valign="top">I</td>
<td valign="top">24</td>
<td valign="top">Y</td>
<td valign="top">40</td>
<td valign="top">o</td>
<td valign="top">56</td>
<td valign="top">4</td>
</tr>
<tr>
<td valign="top">9</td>
<td valign="top">J</td>
<td valign="top">25</td>
<td valign="top">Z</td>
<td valign="top">41</td>
<td valign="top">p</td>
<td valign="top">57</td>
<td valign="top">5</td>
</tr>
<tr>
<td valign="top">10</td>
<td valign="top">K</td>
<td valign="top">26</td>
<td valign="top">a</td>
<td valign="top">42</td>
<td valign="top">q</td>
<td valign="top">58</td>
<td valign="top">6</td>
</tr>
<tr>
<td valign="top">11</td>
<td valign="top">L</td>
<td valign="top">27</td>
<td valign="top">b</td>
<td valign="top">43</td>
<td valign="top">r</td>
<td valign="top">59</td>
<td valign="top">7</td>
</tr>
<tr>
<td valign="top">12</td>
<td valign="top">M</td>
<td valign="top">28</td>
<td valign="top">c</td>
<td valign="top">44</td>
<td valign="top">s</td>
<td valign="top">60</td>
<td valign="top">8</td>
</tr>
<tr>
<td valign="top">13</td>
<td valign="top">N</td>
<td valign="top">29</td>
<td valign="top">d</td>
<td valign="top">45</td>
<td valign="top">t</td>
<td valign="top">61</td>
<td valign="top">9</td>
</tr>
<tr>
<td valign="top">14</td>
<td valign="top">O</td>
<td valign="top">30</td>
<td valign="top">e</td>
<td valign="top">46</td>
<td valign="top">u</td>
<td valign="top">62</td>
<td valign="top">+</td>
</tr>
<tr>
<td valign="top">15</td>
<td valign="top">P</td>
<td valign="top">31</td>
<td valign="top">f</td>
<td valign="top">47</td>
<td valign="top">v</td>
<td valign="top">63</td>
<td valign="top">/</td>
</tr>
</tbody>
</table>
如果要编码的字节数不能被3整除，最后会多出1个或2个字节，那么可以使用下面的方法进行处理：先使用0字节值在末尾补足，使其能够被3整除，然后再进行base64的编码。在编码后的base64文本后加上一个或两个'='号，代表补足的字节数。也就是说，当最后剩余一个八位字节（一个byte）时，最后一个6位的base64字节块有四位是0值，最后附加上两个等号；如果最后剩余两个八位字节（2个byte）时，最后一个6位的base字节块有两位是0值，最后附加一个等号。


这个用解释性语言很容易实现的，当然，如果是最底层的语言就更容易实现了。我这里给一下C++的代码

{% highlight cpp %}
#include <iostream>
#include <cstring>
#include <string>
#include <cstdio>
using namespace std;

const string base64Tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

string encodePass(string osrc)
{
    string res;
    int sz = osrc.size();
    for (int i = 0; i < sz; i += 3)
    {
        string in; int len = 3;
        if (sz - i == 1)
        {
            len = 1; in += osrc[sz - 1];
            in += ''; in += '';
        }
        else if (sz - i == 2)
        {
            in = osrc.substr(i, 2);
            in += ''; len = 2;
        }
        else
            in = osrc.substr(i, 3);
        char ch1  = base64Tab[ in[0] >> 2 ];
        char ch2  = base64Tab[ ((in[0] << 4) | (in[1] >> 4)) % 64 ];
        char tch3 = base64Tab[ ((in[1] << 2) | (in[2] >> 6)) % 64 ];
        char tch4 = base64Tab[ in[2] ];
        char ch3 = (len > 1)? tch3: '=';
        char ch4 = (len > 2)? tch4: '=';
        res += ch1; res += ch2;
        res += ch3; res += ch4;
    }
    return res;
}

string decodePass(string osrc)
{
    string res; basic_string<int> oindex;
    int sz = osrc.size();
    for (int i = 0; i < sz; i++)
    {
        int t = 0;
        if (osrc[i] >= 'A' && osrc[i] <= 'Z')
            t = int(osrc[i] - 'A');
        else if (osrc[i] >= 'a' && osrc[i] <= 'z')
            t = int(osrc[i] - 'a') + 26;
        else if (osrc[i] >= '0' && osrc[i] <= '9')
            t = int(osrc[i] - '0') + 52;
        else if (osrc[i] == '+')
            t = 62;
        else if (osrc[i] == '/')
            t = 63;
        else t = 0;
        oindex += t;
    }
    for (int i = 0; i < sz; i += 4)
    {
        basic_string<int> in; int len = 4;
        in = oindex.substr(i, 4);
        char ch1 = char((in[0] << 2) | (in[1] >> 4));
        char ch2 = char((in[1] << 4) | (in[2] >> 2));
        char ch3 = char((in[2] << 6) |  in[3]);
        res += ch1; res += ch2; res += ch3;
    }
    return res;
}

int main()
{
    const string cipher1 = "950727";
    //string cipher2 = encodePass(cipher1);
    //cout << cipher1 << " -> " << cipher2 << endl;
    string encoded;
    encoded = encodePass(cipher1);
    cout << encoded << endl;
    return 0;
}{% endhighlight %}

就在我感觉上认为撸通了的时候，我发现了一个问题，那就是其实这个密码是双重加密的。因为我在Base64变换回来之后，发现所谓的“明文”中出现了控制字符，也就是说，这里又经过了一次加密。而且发现，如果你的密文，就像我一开始给的那样全是1，那么Base64编码的结果也一定是每四位每四位相同的。但是这里我们很明显的看到出现了问题。那么我们考虑，如果使用的是凯撒密码，应该保持这样的同一个明文同一个密文的不变性。但是如果用的是异或密码加密，就不会有这个特性了。所以我猜想，我们输入的密码是先经过一次异或加密之后，再用Base64编码输出。

## 异或密码

异或加密也是一个非常常见的加密方法，和凯撒密码一样，双方都需要密钥。

异或运算就是，对两个数据的每一个二进制位，如果在这个位置上，两个数相同，则这个位置的结果为0，如果不同，则为1。也就是 1 XOR 1 = 0 XOR 0 = 0，0 XOR 1 = 1 XOR 0 = 1。

因为异或运算满足这些运算特性，所以加密时，将明文与密钥进行一次异或运算，解密时，将密文与密钥进行一次异或运算，十分的简单方便。就像这样：（X为明文，Y为密文，S为密钥）
那么怎么获得密钥呢？同样的利用异或运算的特性（交换律和结合律）

所以我就撸了一发就破解了密钥，不得不说这是一个漏洞非常大的加密法。

最后密钥和异或加密解密的C++代码如下：

{% highlight cpp %}
#include <iostream>
#include <cstring>
#include <string>
#include <cstdio>
using namespace std;

const string xorRuijie = "~!:?$*<(qw2e5o7i8x12c6m67s98w43d2l45we82q3iuu1z4xle23rt4oxclle34e54u6r8m";
const int xorlen = xorRuijie.size();

string Encode(string osrc)
{
    string res;
    int sz = osrc.size();
    for (int i = 0; i < sz; i++)
        res += osrc[i] ^ xorRuijie[i % xorlen];
    return res;
}

string Decode(string osrc)
{
    return Encode(osrc);
}

int main()
{
    string cipher = "XOR";
    cout << Encode(cipher) << endl;
    return 0;
}{% endhighlight %}

## 总结

其实也没啥好总结的了。大概过程就是“密码明文->异或加密->Base64编码->传输”。其实密码破译是一个很困难的任务，我这里虽然看上去挺轻松愉快的，但是实际上是因为我这里有一个明文密文生成器，可以大量的实验，获得大量的明文和密文的组合。而且在现实中，我们手上的信息一般只有密文，所以这就需要不断地思考和演算了。总之撸通了一个加密方案，希望大家多注意自己的信息安全吧！
