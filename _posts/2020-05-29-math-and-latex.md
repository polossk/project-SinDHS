---
layout: post
title: "[LaTeX] 如何优雅地写数学公式"
date: 2020-05-29 21:39:00 +0800
categories: 笔记本 环境配置
tags: tsukkomi LaTeX MathJax VSCode
---

让我们直接切入正题，如何优雅地用 $$\LaTeX$$ 写数学公式。

## 要素察觉

我一般地习惯是，把电脑上的数学公式编辑任务限制在 **誊写（copy）** 和 **编辑（edit）** 这两个任务上。前者指的是将手稿上的数学公式转写成 $$\LaTeX$$ 格式，后者指的是将可能出现的错误通过后期的检查，不管是直接从代码上发现的，还是编译后发现的，直接在原有代码上修改的过程。而手稿上的数学公式任务则远远不止这两种情形，还包含 **汇总整理（compile）** 和 **公式推导化简（derive）** 这两种情况。汇总整理指的是把可能用到的式子按照特定顺序写在草稿纸上。而公式推导与化简则是借助已有的等式或不等式关系对已有式子的进一步加工处理。也就是说，把 **创作（writing）** 的部分留给草稿纸，把 **写作（typing）** 的部分交给 $$\LaTeX$$。

那么剩下的重点就在于如何优雅的写 tex 文稿了。这里又涉及了两个问题：何为优雅？何为写？

何为优雅？至少我觉得，除非是非常熟悉的数学公式，比如世人皆知的质能方程 $$E = mc^2$$ 这种，否则如果你让我只凭借大脑的记忆，直接在键盘上敲出公式对应的代码，这可能并不是一件那么优雅的事情。至少对于我而言，在茫茫多的数学符号当中，我只能记住最常用的一两组；在各种格式控制中，我可能只能熟练使用用的最多的 `aligned` 和 `cases` 两个环境；我甚至会一路 `\left( \right)` 来控制括号的大小而不是使用推荐的 `\bigl( \bigr)`。诸如此类，总是会有那么一两个的细枝末节的问题来**打断**你的创作过程，而这些问题，从来就没有出现在你的草稿纸推导过程中，我们从小也没有经历过这种在 tex 里推导公式的训练。所以，这里的优雅，应该定义在“如何减少写作过程中的不必要的打断”处为好，即让我们保持专心致志，而不是像风筝一样随时都有可能跑偏。

那么何为写呢？写文章是写，写代码是写，写公式也是写，但是三者的客观对象不同，实施的步骤不同，运用的技巧也不同。世人皆云，文章是作者与读者沟通的桥梁，一篇好的文章要么在内容上发人深省，要么在写作上平易近人。而对码农而言，可读性、代码架构，都不如把代码 run 起来那一刻激发的多巴胺带来的情感体验更为丰富。而公式的写作介于两者之间，既要保持一致、符号统一、形式规整，也要考虑读者——尤其是第一位读者——自己的阅读体验。所以，在回答了这两个问题之后，我们可以列举出一份简单的愿望清单，也可以叫做行为规范。

> 如无必要，誊写为妙
> 
> 常备资料，免被打扰
> 
> 符号统一，勿创勿造
> 
> 写完通读，通畅最好

## 工具选取

尺有所长，寸有所短。在面对大量重复性的公式推导时，我们都想复制粘贴只修改需要改动的部分。所以这个时候可以及时预览的公式编辑器就显得尤为重要。这里推荐的是 VSCode 当中的三个插件：`LaTeX Workshop`，[`Markdown All in One`][ref1]，[`Markdown+Math`][ref2]。前者是目前 VSCode 中最全面的 $$\LaTeX$$ 插件，集成了编写时的代码高亮、文档解析、公式预览，可自定义的编译流程。后者是两款 markdown 插件，不仅有语法高亮、文档实时预览，还可以导出到 html 网页或者 pdf 文档中，用来当电脑上的草稿本可谓是再恰当不过了。

> 高质量文档：$$\LaTeX$$
> 
> 普通文档： `markdown`

这里就有了一个细节问题：你的 markdown 文档到底是谁的中间件呢？举个例子，如果你是为了将来转移到 tex 文稿里面，那么你肯定希望两者的格式控制是很相近的。可是另一个例子，比如你现在看到的这篇文章是通过 jekyll 的 kramdown 工具完成的 markdown 语法解析，而不巧的是，kramdown 的语法下，公式的控制符与 tex 不同。然而更可怕的是，这个网页的公式渲染是通过另一个开源库 MathJax 完成的，它对数学公式的默认语法解析又和前两者不同，具体可以看表格。

| 语法格式                                  |   $$\TeX$$   |  $$\LaTeX$$  | markdown`*`  |      kramdown       |   MathJax    |
| ----------------------------------------- | :----------: | :----------: | :----------: | :-----------------: | :----------: |
| `$...$`                                   |   行内公式   |   行内公式   |   行内公式   |          -          |      -       |
| `\(...\)`                                 |      -       |   行内公式   |      -       |          -          |   行内公式   |
| `\begin{math}...\end{math}`               |      -       |   行内公式   |      -       |          -          |      -       |
| `$$...$$`                                 | 行间公式`**` |   行间公式   |   行间公式   | 行内或行间公式`***` |      -       |
| `\[...\]`                                 |      -       |   行间公式   |      -       |          -          |   行间公式   |
| `\begin{displaymath}...\end{displaymath}` |      -       |   行内公式   |      -       |          -          |      -       |
| `\begin{equation}...\end{equation}`       |      -       | 编号行间公式 |      -       |          -          |      -       |
| `$$...$$ (1)`                             |      -       |      -       | 编号行间公式 |    编号行间公式     |      -       |
| `\[...\] (1)`                             |      -       |      -       |      -       |          -          | 编号行间公式 |

* `*` 这里指的是基础的 markdown 语法，也就是大部分编译器所规定的语法格式
* `**` 行间公式是 $$\TeX$$ 中对 `displaymath` 格式的意义，指的是独立成一段的不编号的数学公式格式环境
* `***` 如果写做 `$$F=ma$$` 这种不换行的形式则表示行内公式，如果写做如下所示的换行的形式则表示为行间公式

```markdown
$$
F=ma
$$
```

所以根据你的目标的不同，你的格式也要不同。这里就需要插件来帮助我们的工作了。

由于我个人实际上绝大多数的公式都会转移到 tex 文稿中，所以实际上我希望公式的格式不要和 $$\LaTeX$$ 发生过多的冲突。而发表博客只是业余爱好，稍稍改动一下其实也无关紧要。所以本着特事特办的原则，借助 VSCode 的工作区设置来帮助完成。具体配置如下：

1. 在平时的环境中，保持 `Markdown All in One` 插件中的数学公式支持打开。流程：`File -> Preferences -> Settings`，确保自己安装好 `Markdown All in One` 之后，在搜索栏里直接输入 `math` 然后找到该插件的“启用基本的数学支持”，将选项打开，即 `"markdown.extension.math.enabled": true`
2. 默认关闭插件 `Markdown+Math`。流程：在插件栏找到这个插件，右键，选择“禁用”
3. 找到唯一一个可能使用到不同的分隔符模式的项目目录，右键空白处打开 VSCode，选择 `File -> Preferences -> Settings`，选择“工作区”
4. 把第一步中设置的 `true` 在工作区选项里更改为 `false`
5. 把第二部中设置的“禁用”更改为“启用（工作区）”
6. 在设置中搜索 `delimiters` 找到 `mdmath` 选项卡里的 `Mdmath: Delimiters` 选项，设置为 `kramdown` 或者其他分隔符设置

这样，只有在撰写博客时，公式全套都使用 `kramdown` 的格式要求。其他情形下全部使用默认的 tex 文稿中的格式要求。

## 不止如此

回归到最一开始的公式符号问题。这里为了方便快速查阅公式符号，推荐在 Google 中搜索 `latex math symbols` 找到一份 Rice University 网站内整理的一份[数学符号合集][ref3]。处于版权考虑这里就不额外提供了。除此之外，Overleaf 也有提供数学符号的一份[参考文档][ref4]。目前我会把这种整理好的 `符号-代码` 对照表打印一份放在手边随时查阅。

除此之外还有一种方案，那就是了解为什么把代码设置成这些字母。实际上，绝大多数的代码都是符号的发音、拼读、拼读缩写，也就是说如果能把公式读下来，那么基本上就能不借助这些工具书直接敲键盘了。而且，实际上只要发音准确，再加上编辑器自带的符号提示功能，基本上就可以完成个七七八八。所以两种方法，两种选择，看哪种更合适了。

## 更加快捷

即便如此，我们还缺少一份自动补齐的工具。这里就需要用到 VSCode 的用户代码片段 `Snippets` 功能。我们需要添加一份对于 $$\LaTeX$$ 而言最常用的一个代码片 `\begin{env}...\end{env}` 来更快捷的输入新建环境。依次打开 `File -> Preferences -> User Snippets`，选择 `New Global Snippets File` 来新建一份全局用户代码段，输入文件名之后，你的编辑器会创建一份默认用户代码片段模板。（这里之所以会有中文乱入是因为我已经预先安装了简体中文的语言包。）

```json
{
    // Place your 全局 snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
    // description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
    // is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
    // used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
    // $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
    // Placeholders with the same ids are connected.
    // Example:
    // "Print to console": {
    // 	"scope": "javascript,typescript",
    // 	"prefix": "log",
    // 	"body": [
    // 		"console.log('$1');",
    // 		"$2"
    // 	],
    // 	"description": "Log output to console"
    // }
}
```

可以模仿 `Example` 中的示例，完成我们的目标，这里给出了一份[参考答案（by lrtfm）][ref5]

```json
{
    "Environment": {
        "scope": "latex,markdown",
        "prefix": "begin",
        "body": [
            "\\begin{$1}\n\t$2\n\\end{$1}\n$0",
        ],
        "description": "Insert New Environment"
    }
}
```

保存之后，当你在 markdown 的数学环境里，或者平常的 $$\LaTeX$$ 文稿撰写过程中，就可以借助 `tab` 的自动补齐功能来快速新建环境

## Reference

1. <a name="ref1"></a> [Markdown All in One][ref1]
2. <a name="ref2"></a> [Markdown+Math][ref2]
3. <a name="ref3"></a> [LATEX Mathematical Symbols][ref3]
4. <a name="ref4"></a> [List of Greek letters and math symbols - Overleaf, Online LaTeX Editor][ref4]
5. <a name="ref5"></a> [Vscode Snippet \| lrtfm][ref5]

[ref1]: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
[ref2]: https://marketplace.visualstudio.com/items?itemName=goessner.mdmath
[ref3]: https://www.caam.rice.edu/~heinken/latex/symbols.pdf
[ref4]: https://www.overleaf.com/learn/latex/List_of_Greek_letters_and_math_symbols
[ref5]: https://blog.lrtfm.com/2020/05/vscode-snippet/
