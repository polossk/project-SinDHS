---
layout: post
title:  "[python] 某不科学的美工的瞎搞-3"
date:   2018-02-14 20:59:08 +0800
categories: battle hitorigoto
tags: python image hoshizora
---
2月14号又来了！又到了撸美工的时间！(这句话说了好几遍了233)

这次带来的伪星空图(pseudo starry sky).

初衷是起源于知乎转载的很出名的[《用三段 140 字符以内的代码生成一张 1024×1024 的图片》](#ref-1). 原本任务的代码是 C++ 代码生成 ppm 文件, 不过我嫌麻烦换 python 的 PIL 库直接撸 png 文件了.

星空图最麻烦的是背景色的选取, 纯黑色效果一般, 所以就从一家一直在用的[网站](#ref-2)找了一些喜闻乐见的颜色: <span style="background-color: #0B1013; color: #0B1013;">233</span> 黒橡（くろつるばみ, #0B1013）, <span style="background-color: #0C0C0C; color: #0C0C0C;">666</span> 呂（ろ, #0C0C0C）, <span style="background-color: #080808; color: #080808;">998</span> 黒（くろ, #080808）, <span style="background-color: #000000; color: #000000;">110</span> 纯黑色（#000000）.

在获取到背景色之后, 这里需要做一个简单的明暗判断即可, 大于阈值的直接按照光亮设置, 反之设置为背景色即可. 明暗判断时进行一下灰度转换, 由于光亮点的三个通道值相同, 所以其灰度值不变, 而背景色有一个的三通道不相同, 需要额外设置其灰度, 具体转换公式为 `gray = 0.299 * R + 0.587 * B + 0.114 * G`, 更多的细节请参考[维基百科](#ref-3)

附赠python代码

{% highlight python %}
from PIL import Image
import math

def fit(_):
    _ = 255 if _ > 255 else _
    return 0 if _ < 0 else _

def spot(i, j):
    v = math.tan( i * math.pow(i, math.sqrt(j) * 0.1) )
    return fit(int(v))

def hoshizora(colorname, value):
    width, height = 1920, 1080
    filename = "hoshizora_{0}.png"
    im = Image.new("RGB", (width, height), "#000000")
    pixels = im.load()
    threshold = int(0.299 * value[0] + 0.587 * value[2] + 0.114 * value[1])
    for i in range(0, width):
        for j in range(0, height):
            _ = spot(i, j)
            if _ <= threshold:
                pixels[i, j] = value
            else:
                pixels[i, j] = (_, _, _)
    im.save(filename.format(colorname.lower()))
    print(filename.format(colorname.lower()), " done.")

def main():
    background = {
        "KUROTSURUBAMI": (11, 16, 19),
        "RO": (12, 12, 12),
        "KURO": (8, 8, 8),
        "NULL": (0, 0, 0),
    }
    for (k, v) in background.items():
        hoshizora(k, v)

if __name__ == '__main__':
    main()
{% endhighlight %}

## Result
自己调的结果, 从上到下依次为<span style="color: #0B1013;">233</span> 黒橡（くろつるばみ, #0B1013）, <span style="color: #0C0C0C;">666</span> 呂（ろ, #0C0C0C）, <span style="color: #080808;">998</span> 黒（くろ, #080808）, <span style="color: #000000;">110</span> 纯黑色（#000000）.

<img src="{{ site.base }}/images/2018/02/hoshizora_kurotsurubami.png" width="100%"/>

<img src="{{ site.base }}/images/2018/02/hoshizora_ro.png" width="100%"/>

<img src="{{ site.base }}/images/2018/02/hoshizora_kuro.png" width="100%"/>

<img src="{{ site.base }}/images/2018/02/hoshizora_null.png" width="100%"/>

## references
1. <a name="ref-1"></a>[用三段 140 字符以内的代码生成一张 1024×1024 的图片 \| Matrix67: The Aha Moments](http://www.matrix67.com/blog/archives/6039)
2. <a name="ref-2"></a>[NIPPON COLORS - 日本の伝統色](http://nipponcolors.com)
3. <a name="ref-3"></a>[Grayscale - Wikipedia](https://en.wikipedia.org/wiki/Grayscale)