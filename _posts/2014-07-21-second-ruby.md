---
layout: post
title: "[Ruby] Ruby大法第二天——帮助生成Vim添加代码头的代码"
date: 2014-07-21 04:44:00 +0800
categories: notebook planguage
tags: ruby
---
脚本语言真是太强了。

我的目的是把我的默认代码头功能加到Vim里面。

{% highlight cpp %}
/******************************************************************************
*       COPYRIGHT NOTICE
*       Copyright (c) 2014 All rights reserved
*       ----Stay Hungry Stay Foolish----
*
*       @author       : Shen
*       @name         :
*       @file         : G:My Source CodeDefaultCode.cpp
*       @date         : 2014/06/14 02:44
*       @algorithm    :
******************************************************************************/

//#pragma GCC optimize ("O2")
//#pragma comment(linker, "/STACK:1024000000,1024000000")

#include <bits/stdc++.h>
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

/*//STL
#include <map>
#include <vector>
#include <list>
#include <stack>
#include <deque>
#include <queue>
*/

/*//Computational Geometry
#include <complex>
#define x real()
#define y imag()
typedef complex<double> point;
*/

typedef long long int64;

void solve()
{

}

int main()
{

    return 0;
}{% endhighlight %}
用Ruby10行就搞定了字符串的处理。简直爽爆了。

{% highlight ruby %}
def load( path )
    File.foreach(path) do |line|
        line["n"] = "
        str = "let l = l + 1 | call setline(l, '#{line}')"
        File.open("s.txt", "a") do |f|
            f << "#{str}n"
        end
    end
end

load("DefaultCode.cpp"){% endhighlight %}

最后人工把头尾一加，搞定了。

{% highlight plain %}
"F4 添加文件头
map <F4> :call TitleDet()<cr>
function AddTitle()
let l = 0
let l = l + 1 | call setline(l, '/******************************************************************************')
let l = l + 1 | call setline(l, '*       COPYRIGHT NOTICE')
let l = l + 1 | call setline(l, '*       Copyright (c) 2014 All rights reserved')
let l = l + 1 | call setline(l, '*       ----Stay Hungry Stay Foolish----')
let l = l + 1 | call setline(l, '*')
let l = l + 1 | call setline(l, '*       @author       : Shen')
let l = l + 1 | call setline(l, '*       @name         :')
let l = l + 1 | call setline(l, '*       @file         : '.expand("%:p:h")."\".expand("%:t"))
let l = l + 1 | call setline(l, '*       @date         : '.strftime("%Y/%m/%d %H:%M"))
let l = l + 1 | call setline(l, '*       @algorithm    :')
let l = l + 1 | call setline(l, '******************************************************************************/')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, '//#pragma GCC optimize ("O2")')
let l = l + 1 | call setline(l, '//#pragma comment(linker, "/STACK:1024000000,1024000000")')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, '#include <bits/stdc++.h>')
let l = l + 1 | call setline(l, '#include <cmath>')
let l = l + 1 | call setline(l, '#include <cstdio>')
let l = l + 1 | call setline(l, '#include <string>')
let l = l + 1 | call setline(l, '#include <cstring>')
let l = l + 1 | call setline(l, '#include <iomanip>')
let l = l + 1 | call setline(l, '#include <iostream>')
let l = l + 1 | call setline(l, '#include <algorithm>')
let l = l + 1 | call setline(l, 'using namespace std;')
let l = l + 1 | call setline(l, 'template<class T>inline bool updateMin(T& a, T b){ return a > b ? a = b, 1: 0; }')
let l = l + 1 | call setline(l, 'template<class T>inline bool updateMax(T& a, T b){ return a < b ? a = b, 1: 0; }')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, '/*//STL')
let l = l + 1 | call setline(l, '#include <map>')
let l = l + 1 | call setline(l, '#include <vector>')
let l = l + 1 | call setline(l, '#include <list>')
let l = l + 1 | call setline(l, '#include <stack>')
let l = l + 1 | call setline(l, '#include <deque>')
let l = l + 1 | call setline(l, '#include <queue>')
let l = l + 1 | call setline(l, '*/')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, '/*//Computational Geometry')
let l = l + 1 | call setline(l, '#include <complex>')
let l = l + 1 | call setline(l, '#define x real()')
let l = l + 1 | call setline(l, '#define y imag()')
let l = l + 1 | call setline(l, 'typedef complex<double> point;')
let l = l + 1 | call setline(l, '*/')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, 'typedef long long int64;')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, 'void solve()')
let l = l + 1 | call setline(l, '{')
let l = l + 1 | call setline(l, '    ')
let l = l + 1 | call setline(l, '}')
let l = l + 1 | call setline(l, '')
let l = l + 1 | call setline(l, 'int main()')
let l = l + 1 | call setline(l, '{')
let l = l + 1 | call setline(l, '    ')
let l = l + 1 | call setline(l, '    return 0;')
let l = l + 1 | call setline(l, '}')
endfunction

"更新最近修改时间和文件名
function UpdateTitle()
    call setline(8, '*       @file         : '.expand("%:p:h")."\".expand("%:t"))
    call setline(9, '*       @date         : '.strftime("%Y/%m/%d %H:%M"))
endfunction

"判断前10行代码里面，是否有COPYRIGHT NOTICE这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
function TitleDet()
    let n = 2
    "默认为添加
        let line = getline(n)
        let str = '^*       COPYRIGHT NOTICE$'
        if line =~ str
            call UpdateTitle()
            return
        endif
    call AddTitle()
endfunction{% endhighlight %}
