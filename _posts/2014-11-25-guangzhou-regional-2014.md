---
layout: post
title: "敢死队"
date: 2014-11-25 15:18:55 +8000
categories: battle hitorigoto
tags: Regional tsukkomi
---
滚粗了！滚粗了！这个赛季之后我也退役了。

退役前还是把150多天的逗比日子还有被全国ACM群屌的不成样子的比赛实况，再给大家"澄清"一下。（我们就是水过了你们技艺不精出的题怎么地？反正不是我敲的你打我啊！）

# "敢死队"

当我们听到旺神和符宝选择了"西工大六队"的时候，我就醉了！

尼玛，你们借着计数上是第六支队伍就起六队是想搞基么？

而且，我已经报上了"敢死队"这个名字。

因为确实是去打铁的啊！确实不是什么特别有实力的队伍，然后报上这个假一队的队名简直就是作死啊。

然后就没有然后了。

# "通气会"

下面请主要犯罪嫌疑人出场，回答问题，交代事实。

Q：为什么一队起二队的名字，二队反而叫一队？

A：因为信息不发达，没有跟上一队的起名脚步。

Q：那你们下一场叫什么？

A：我们准备等所有队的名字出来之后，再做决定。

PS：当然这是明年的故事了。

PS2：当然明年我还不确定能不能拿到出战名额。。。

Q：比赛前你在做什么？

A：我么？我在补作业。

Q：请介绍下，你们是怎么拿到FB的。

A：No response. Please read problem statements.

# 初到广州

在讲比赛前，真的需要感谢富帅！免费伙食简直不能更棒。然后广州的气候确实太热情了，嗯，完完全全夏天的感觉，而且空气不知道比东大好到哪里去了！更关键的是，人也比较养眼，嗯，人之常情嘛，看到美丽的事物自然心情愉悦了。

所以说，南方就是南方，北方就是北方。

不慌不忙的热身赛，然后被北大的热身赛题目恶心到了。在23小时的火车之后，难得被夏日的热情拥抱，然后就看到了4个原题。

尼玛，三个区预赛真题，一个网赛题，还全是北大场的。真的是废(sang)物(xin)利(bing)用(kuang)啊。

当然，我怎么可能去做呢？因为一个也不会啊！但是热身赛爆零也不大好，所以我找出一个比较暴力并且丧心病狂的枚举所有最小生成树的题目标称给学弟敲。

当然样例没过。。。

为什么？因为等号敲成等于了。

但这个傻逼错误并没有阻止我们逗比的脚步！是的，我在搞一个逗比模拟，然后就知道宾馆晚上十点多另一个学弟过了我的代码还没过。。。

全当攒人品了！过了这个坑爹题之后，我对着我买的阿华田和赛区送的小音箱说。

# 比赛开始

开PC2，开CB，建文件，名字叫fst.cpp。

起完名字才发现，卧槽，这不是本弱打CF经常遇到的情况么？算了算了，名字都起了，就算最后failed system test也就罢了。

搞完基础的之后开始从后往前读题，guanxi，这个神奇的名字，简直是对qinghuai的拙劣的模仿。这个时候，我还没读完题，佳神突然对我说：

"A题能暴力过。"

"我没读题，你想搞就搞。"

"那我搞。"

"羊大师你看着点，别搞错了就行。"

其实我A题看都没看，他们既然说能搞，虽然是暴力，那也无所谓。暑假才开始玩，既然想搞就搞呗！我甚至连复杂度，数据量也没问。就简单的坐在最边上，接着读题。

然后，佳神说，样例过了。哦，那就交吧！

{% highlight cpp %}#include <cstdio>
#include <cstring>
#include <algorithm>
using namespace std;
typedef long long int64;
struct node
{
	int64 x, y;
	bool flag;
	node(int64 _ = 0LL, int64 __ = 0LL, bool f = 0)
		:x(_), y(__), flag(f){}
}que[50007];
int n, cnt = 1;

int main()
{
	int a;
	int64 b, c, ans;
	while (~scanf("%d", &n) && n)
	{
		cnt = 1;
		for (int i = 1; i <= n; i++)
		{
			scanf("%d%lld%lld", &a, &b, &c);
			if (a == 1)
				que[cnt++] = node(b, c, 1);
			else if (a == -1)
			{
				for (int j = 1; j < cnt; j++)
				{
					node& tmp = que[j];
					if (que[j].x == b && que[j].y == c && que[j].flag == 1)
					{
						que[j].flag = 0;
						break;
					}
				}
			}
			else
			{
				ans = 0xffffffffffffffff;
				for (int j = 1; j < cnt; j++)
				{
					node& tmp = que[j];
					if (tmp.flag == 0) continue;
					ans = max(ans, b * tmp.x + c * tmp.y);
				}
				printf("%lld\n", ans);
			}
		}
	}
	return 0;
}{% endhighlight %}

我真的以为这个是第一个题，因为一开始订的策略就是让他们过水题，手残的我确实不敢乱敲题。

然后等了好久，真的好久，他们甚至以为自己的代码WA了。就在这节骨眼上：

Yes。

卧槽，好兆头！16分钟一A，好兆头。果断看榜装装逼。

卧槽，大家都在过E题？K题也有人过了。

卧槽等等，为何是裁判送气球！

卧槽，FB啊！

卧槽！竟然过了一个FB。

至于全场都在评论西工大为何16分钟过了一个神题就是后话了。我是在比赛之后发现所有的微博，QQ群都在评论我们这个A题之后才看A题的。我甚至不知道他们是怎么A的。但是现在想来除了幸运，没有更好的词汇了。本身是一个神题，但是被我们暴力水过了，说出去都是一个天大的笑话。

卧槽西工大暴力搞过了！Why are you so diao?

后来听讲题的北大爷说：我们的那个出题人啊，技艺不精，标称跑了8s，暴力跑了4s。

至于被纳米还有叉姐在各种群中D我们的故事就不多说了，现在我才真真正正读懂了当时送气球的那位裁判爷送气球时的话语：

"恭喜你们。"

# 开始逗比吧

过了A题之后，我告诉两个学弟，I和K能搞，我先证明I的一个贪心结论，你们速度把E题过掉。

然后就WA了3发。

甚至我们在怀疑字典序的定义是什么。

但是在某一次偶然的关掉那个程序的进程的时候，我瞟到了一个全场的一个公告：

题面有错误啊！2333333333！

{% highlight cpp %}#include <cmath>
#include <string>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;

struct man
{
    string name;
    int x;
    bool operator>(const man& b) const
    {
        if (x == b.x) return name < b.name;
        else return x > b.x;
    }
};

int n, m;
man a[205];

void solve()
{
    for (int i = 0; i < n; i++)
        cin >> a[i].name >> a[i].x;
    sort(a, a + n, greater<man>());
    for (int i = 0; i < n; i++)
        printf("%s %d\n", a[i].name.c_str(), a[i].x);
    scanf("%d", &m);
    for (int i = 0; i < m; i++)
    {
        int j = 1, k = 1;
        string tmp; cin >> tmp;
        for ( ; j - 1 < n && tmp != a[j - 1].name; j++);
        int xx = a[j - 1].x;
        for (k = j - 2; k >= 0 && a[k].x == xx; k--);
        int res1 = k + 2, res2 = j - k - 1;
        if (res2 <= 1) printf("%d\n", res1);
        else printf("%d %d\n", res1, res2);
    }
}

int main()
{
	while (~scanf("%d", &n) && n) solve();
	return 0;
}{% endhighlight %}

过了E之后，我拿起早就搞好的I题，那个坑爹的三角形，直接敲，四分钟之后过掉。然后凭借一血的优势，勉勉强强在六七十名左右。

{% highlight cpp %}#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;

const int MaxN = 15;
int n, a[MaxN];

double calcArea(int a, int b, int c)
{
	double p = (a + b + c) / 2.0;
	double pa = p - double(a);
	double pb = p - double(b);
	double pc = p - double(c);
	return sqrt(p * pa * pb * pc);
}

inline bool isTri(int a, int b, int c)
{
	return (a + b > c)
		&& (b + c > a)
		&& (a + c > b);
}

void solve()
{
	for (int i = 0; i < n; i++)
		scanf("%d", &a[i]);
	sort(a, a + n, greater<int>());
	double res = 0.0;
	for (int i = 0; i < n - 2; i++)
	{
		if (isTri(a[i], a[i + 1], a[i + 2]))
        {
            res += calcArea(a[i], a[i + 1], a[i + 2]);
            i += 2;
        }
		else continue;
	}
	printf("%.2f\n", res);
}

int main()
{
	while (~scanf("%d", &n) && n)
		solve();
	return 0;
}{% endhighlight %}

看来至少要过掉两道题，才不会打铁。

这个时候我又要吐槽北大的题目了，什么东西！前些年暴力枚举最小生成树，今年就是暴力枚举最短路，搞的我们无言以对。而且，题目的描述还特别神，上来说能不能找到割点，找不到个点就输出最大的最短路，上来就被敲懵了。而且因为在西安裁判室执勤的时候，纳米的队友警报过我们不要乱跟榜，彻彻底底的被那个十几分钟过K的吓坏了。

后来想想，卧槽，不就是枚举答案么？

何逗！

{% highlight cpp %}#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;

const int INF = 0x3f3f3f3f;
int n, m, ans, g[32][32], d[32][32];

int floyd(int f)
{
	for (int i = 1; i <= n; i++) for (int j = 1; j <= n; j++)
        d[i][j] = g[i][j];
	for (int k = 1; k <= n; k++)
	{
		if (k == f) continue;
		for (int i = 1; i <= n; i++)
		{
			if (i == f) continue;
			for (int j = 1; j <= n; j++)
			{
				if (j == f) continue;
				d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
			}
		}
	}
	return d[1][n];
}
void solve()
{
	memset(g, 0x3f, sizeof(g));
	for (int i = 0; i < m; i++)
    {
        int u, v, t;
        scanf("%d%d%d", &u, &v, &t);
        g[u][v] = min(t, g[u][v]);
        g[v][u] = g[u][v];
    }
    int ans = 0;
    for (int i = 2; i < n; i++)
        ans = max(ans, floyd(i));
    if (ans == INF) puts("Inf");
    else printf("%d\n", ans);
}

int main()
{
	while (~scanf("%d%d", &n, &m))
	{
		if ((n == 0) && (m == 0)) return 0;
		else solve();
	}
	return 0;
}{% endhighlight %}

搞完K题之后，看下气球看下榜，铜牌已经稳了，现在才两个小时，排名27。除了有一个最丧病的一次比赛看到一个队100分钟掉50名，其他的一般是5分钟一名一名掉，所以应该没太大事，我这么给两个学弟说。然后看了看榜，一队B题WA了一次才过，一定是有坑点，D题感觉还行，但是现在就去搞我心里太虚，还有一个H题，样例推不出来，更不敢乱搞了。C题不会。连分数太神，暴力都不知道怎么暴力。

决定了，三个小时，先搞B题，要是能搞出来，要不弃疗，要不就去搞D。

然后就被B题D成狗了。

神坑B题，神坑！北大的题目也真是，还说自己的英语好，我们用的是fence，不是rectangle，所以我们的cross和touch是没有歧义的！所以回字形的情况是可能的。

没错！当我说有可能是回字形的时候，距离比赛结束还有6分钟。

虽然羊大师把代码很快改好了，但是我们算的是大矩形，不不不，根据现在的题意应该是，大栅栏减小栅栏。

然后正解是只算大的。

艹。

这就是命吧！

至于有的人说我们在藏题，呵呵，我们被某北大老师坑死了！抱歉愧对大家的期待。。。

结束了！结束了！这个赛季结束了！被坑了三个小时之后，带着怨念滚粗了。

最后一个小时，绝望的时候，我看了看一队的封榜前的状态，他们开了J题，D题没动，完了，我心想，完了，一定是符宝太自信了！

之所以这么说，是因为我们周围全是银牌爷，他们都没有做A题，是的，他们虽然看到我们那么早就过了，但是没有做，心理素质太好了。然后他们过了D题，但是我们死死活活被B坑死了。

结束后，一队他们被我们的暴力美学吓得坑了两个小时的A题。

我又想吐槽了，但是想起了纳米在群里说的一句话：

"如果我是裁判我肯定不给过。"

裁判的认真程度确实太重要了，向我们这种暴力美学真的是过不了的，真的不能给过的，太影响全场的队员了。而且，向这种题面的打印问题，怎么可能通过PC2的公告说明呢？明显应该全场说一下：我们的题目打印错了哈哈哈。又不是特别丢人的事，搞得好神秘的样子，而且全场不止一个被坑在E题的。

# 总之

我们就是捡了一个铜牌还有一个FB，滚粗了。

今年就这样结束了，旺神还有一场上海，如果旺神早日向前看就好了，这样工大的ACM终于能扬眉吐气了。

去年的时候，打了一坨铁，富帅在创建群的时候叫"工大ACM敢死队"。

现在敢死队已经解散了（学弟两场已经打完了，我的日常被数学系的逗比生活恶心着），还是希望明年能够有队伍一鸣惊人吧。像我这次的两个学弟明年说不定就要进Final了！而我们这一群人已经被拍死在沙滩上了。

还是很简单的道理，坚持与信念。去年的时候，我弱的全程酱油，完完全全是凭借着自己喜欢编程才苟延残喘的坚持下来。寒假打CF，等评测完都快四点了，但是还是会坚持去看大牛们的代码，涨姿势长见识。水进群中，默默围观神牛答疑解惑，又无比唏嘘自己为何如此之弱。想来想去大二被虚度，大三想好好搞一年，谁知道逗比学院的逗比课程作业堆积如山，为了出来比赛，提前补完两周的作业，甚至周三要走了，我还在写运筹学，学弟当时都不知说啥好。

我说，我可能没时间写计算方法和概率论的大作业了，但是想想比完赛更没时间了，所以匆匆忙忙去搞了搞高斯消元和概率期望，涨姿势的同时写完了大作业。但是写完后觉得自己的脑子还好没有退化，学得越多，用得越多，对数学中最基础的东西也就理解得越深刻。而数学建模软件使用什么什么课，我是真心想吐槽。数学建模有没有用？很有用，真的很有用，但是这种东西真的不是这样讲的。试想一下，如果老师，上课时给我们一个问题，然后大家一起研究，集思广益，不仅都能够参与进来，而且能切切实实的在实际中，在每一次手工操作中用得到。可惜实在太功利了，太逗比了。

哎，不吐槽了，我数模翘课两次被点到，所以再吐槽就要被老师D了！

滚粗睡觉了，明年接着和学弟搞起！

