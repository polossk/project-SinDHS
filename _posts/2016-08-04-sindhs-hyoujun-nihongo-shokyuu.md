---
layout: post
title:  "[SinDHS] とある科学の標準日本語初級"
date:   2016-08-04 02:29:00 +0800
categories: battle SinDHS
tags: ffmpeg python SinDHS nihongo
---
恩，这几天瞎学日语中，碰巧了当时入门(keng)五十音的时候是葉子先生教的(@hujiang)，结果今日看B站才知道，原来老师去年每周五周六都在义务教学啊。。。(所以为何不提前一年入坑，额不，入门)

既然如此，那就把课程都拷下来吧。。。

嘛，还是要感谢老师，有需求的同志们可以自行去[av3060477][av3060477]观摩。

而且谈到B站，必然会提到一个神器bilibilijj，这个站会自动爬视频，并且转码+开放下载传送门，但是并不稳定。

所以嘞，就喜闻乐见的先正则匹配出这个视频集中每一个视频的编号，写了个爬虫，用来获取正确的mp4或flv下载地址，然后再用脚本把链接扔给万能的百度云让它去下载，最后在下载到我自己的电脑上，整理包装就可以上市了。

嘛，整个过程还好，主要就是有的时候会达到下载限制，所以，只好调用 `time.sleep()` 了。而且，一开始有的mp4经常下载到某一个幻数就gg了，然后就不得不走flv，或者flv的链接不能获取到正确的视频流了，只好切回mp4。

然而，最后发现一开始的视频质量也是参差不齐，各种参数都有，后来就不得不又用ffmpeg转了个码。嘛，先glob过来所有的视频文件，然后直接整理新文件名旧文件名，直接暴力命令行解决。

{% highlight python %}
#!/usr/bin/cnv python
from __future__ import absolute_import
from __future__ import print_function
import os, glob, datetime

def main():
	works = glob.glob('*.[mf]??')
	for task in works:
		input_name = task
		output_name = '[SinDHS][Hyoujun_Nihongo_Shokyuu][' + task[6:8] + '][720P].mp4'
		cmd = "ffmpeg -i {0} -b:a 128k -r 24 {1}".format(input_name, output_name)
		os.system(cmd)


if __name__ == '__main__':
	t1 = datetime.datetime.now()
	main()
	t2 = datetime.datetime.now()
	print("")
	print("cost: {0}".format(t2 - t1))
{% endhighlight %}

嘛，反正我的文件都是以lesson??.mp4 / lesson??.flv 命名的，我知道这个正则写得很蠢，能过就行。而且电脑，毕竟老爷机，转码封装的速度很慢，fps基本在40-60浮动，上55都很少见。（想买电脑就直说，别扯这些数据

另外还有一个插曲，就是媒体文件的info信息，窝一开始很想修改的，结果就找到了mediainfo这个库，然后发现，它的源码里，Get方法巴拉巴拉七八行，Set方法是一个块注释。。。后来就又找到了一个神奇的东西ExifTool，结果发现这个货并不支持某些属性的修改。。。算了我也不管了，反正是一些小细节没人会注意到的。

最后，至于那个中二的名字SinDHS，这个必然是缩写：

> 世界一の電撃姫様 -> sekai ichi no denngeki hime sama -> SinDHS

嘛，如此中二必然知道其所指了，就不多费口舌了。

这个东西目测并不会怎么流传。所以版权声明巴拉巴拉的就免了吧，毕竟只有我一个人再用。

以上です

[av3060477]: http://www.bilibili.com/video/av3060477/
