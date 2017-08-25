---
layout: post
title: "[Makefile] 不完全指导手册"
date: 2017-03-13 14:05:43 +0800
categories: notebook computeros
tags: makefile g++
---
`make` 是最常用的也是最经典的 build 工具，然而我却现在才开始用这个家伙。简单地说，只要自行规范好 build 顺序，只需要一句简单的 `make` 就可以解决所有问题。正如其历史所言，一开始 `make` 常用于构建C项目，但实际上只需要提供好编译命令，任何项目都可以用 `make` 构建生成。

比如这里有一个简单的Windows环境下生成$$\LaTeX$$文档的例子

```makefile
TEX      = texify
MAIN     = assignment
TEXFLAGS = --pdf --engine=xetex --tex-option=-synctex=1

target: clean tex open

tex: $(MAIN).tex
	$(TEX) $(TEXFLAGS) $<

open: $(MAIN).pdf
	cmd /c start $(MAIN).pdf

clean:
	del -f *.aux *.bbl *.blg *.log *.out *.gz *.toc *.pdf

.PHONY: clean
```

每次写好最终的 assignment.tex 文档之后，只需要执行一个 `make` 就可以编译并打开生成的文档了。

# 上手

当然上面的那个例子有点过分了，实际上有更简单的一个例子

```makefile
main: main.cpp
	g++ -o main main.cpp
```

当我们写好自己的 main.cpp 文件之后，可以直接用 `make main` 命令制作出可执行文件 `main`，这里调用的命令便是 Makefile 文件的第二行 `g++ -o main main.cpp`。简而言之，所有的 Makefile 文件可以看做一个“制作名单”，每一个“作品”由三部分构成：名字，依赖项，制作方法。如下所示，其中 `()*` 表示可以有0个或多个。

```plain
<makeitem> := {
<target>: (<dependency>)*
(<TAB><Command>)*
}
```

自然，如果有多个依赖项， `make` 会先自行检查本地目录有没有，随后检查自己是否可以直接构建，如果都没有就会直接报错结束这次构建任务。如果成功构建（或寻得）了这次构建任务的依赖项，便会开始这次构建任务，即依次执行具体的编译指令。之所以叫具体的编译指令而不是命令，是因为 `make` 并不能完全接受大部分的命令，比如 Windows 下的 start 。由于 start 是一个命令而非文件，所以 make 会返回错误，这里应该使用 `cmd /c start` 来代替直接使用 `start` 。而 Linux 下，大部分所用的命令其本质为可执行文件，所以一般情况下不必担心这个问题。

```plain
>make start
start assignment.pdf
process_begin: CreateProcess(NULL, start assignment.pdf, ...) failed.
make (e=2): 系统找不到指定的文件。
makefile:14: recipe for target 'start' failed
make: *** [start] Error 2
```

正是由于依赖项的存在，使得 `make` 可以作为小型项目的构建工具，使得其有顺序的“制作”所需项目。比如这样一个简单的例子，我们手上有三个文件 a.h, a.cpp, main.cpp，其中 a.h a.cpp 是类 one_class 的定义与具体实现，main.cpp使用了这个类。我们的 Makefile 可以这样写

```makefile
main: main.o a.o
	g++ -o main main.o a.o

main.o: main.cpp
	g++ -c main.cpp

a.o: a.cpp a.h
	g++ -c a.cpp a.h
```

如此一来便可以通过 `make main` 直接构建出最后的可执行文件 main 。同样也可以只写 `make` ，因为 `make` 会默认构建 Makefile 文件中的第一个目标。


# 添加变量

有的时候你会发现你的代码用到了 C++11 ，所以你不得不在编译命令里加上一句
```makefile
main: main.cpp
	g++ -o main main.cpp -std=c++11
```

然后你发现你忘记了正确链接数学基本库
```makefile
main: main.cpp
	g++ -o main main.cpp -std=c++11 -lm
```

然后你发现所有的命令都要加上这两条
```makefile
main: main.o a.o
	g++ -o main main.o a.o -std=c++11 -lm

main.o: main.cpp
	g++ -c main.cpp -std=c++11 -lm

a.o: a.cpp a.h
	g++ -c a.cpp a.h -std=c++11 -lm
```

然后你发现你违反了DRY(Don't Repeat Yourself)原则，所以你设置了一个变量叫做 CXXFLAGS 用来记录所有的编译选项，
```makefile
CXXFLAGS = -std=c++11 -lm
main: main.o a.o
	g++ -o main main.o a.o $(CXXFLAGS)

main.o: main.cpp
	g++ -c main.cpp $(CXXFLAGS)

a.o: a.cpp a.h
	g++ -c a.cpp a.h $(CXXFLAGS)
```

紧接着你发现部署环境里用的是 clang ，开发环境用的是 g++
```makefile
CC       = g++ # clang
CXXFLAGS = -std=c++11 -lm
main: main.o a.o
	CC -o main main.o a.o $(CXXFLAGS)

main.o: main.cpp
	CC -c main.cpp $(CXXFLAGS)

a.o: a.cpp a.h
	CC -c a.cpp a.h $(CXXFLAGS)
```

这样只需要在不同的地方修改一处注释就行了。

除了这些基本用法意外，make还可以直接调用shell的变量
```makefile
test:
	echo $$JAVA_HOME
	@echo $$JAVA_HOME
```
在这里，两个 `$$` 表示正常环境下的一个 `$` ，也可以理解为， `$` 有转义字符的意思。而第三行的 `@...` 表示关闭 echo ，即没有命令回显。

另外针对变量 makefile 有一些运算符[[ref 1]]({% post_url 2017-03-13-markfile-tutorial %}#ref1)
```makefile
VARIABLE = value  # lazy
VARIABLE := value # immediate
VARIABLE ?= value # if absent
VARIABLE += value # append

```

除此之外， `make` 还提供了一些简单的内置变量，诸如 `$(CC)` 表示默认的C编译器(cc)， `$(CXX)` 表示默认的C++编译器(g++)具体的可以查看链接[[ref 2]]({% post_url 2017-03-13-markfile-tutorial %}#ref2)浏览。

# 自动变量

真正有意义的我觉得还是这个自动变量，因为你不可能为每一个目标单独写构建命令。常见的自动变量有这几个：

$@, $<, $^, $*，分别表示，构建目标，第一个前置条件，所有前置条件，和匹配符%匹配的部分。

```makefile
a.txt: b.txt c.txt
	echo $@ # => a.txt
	echo $< # => b.txt
	echo $^ # => b.txt c.txt

%.o: %.cpp %.h
	g++ -o $* %^ -std=c++11
```
这样相当于可以轻松地解决大量的重复工作。比如之前的C++项目就可以直接写成这种形式：
```makefile
CC       = g++ # clang
EXEC     = main
OBJ      = a.o b.o main.o
CXXFLAGS = -std=c++11 -lm

$(EXEC):$(OBJ)
	$(CC) -o $(EXEC) $(OBJ) $(CXXFLAGS)

main.o: main.cpp
	$(CC) -c main.cpp $(CXXFLAGS)

%.o: %.cpp %.h
	$(CC) -c $^ $(CXXFLAGS)

clean:
	rm -f *.o *.exe

.PHONY: clean
```

更多的自动变量可以查看链接[[ref 3]]({% post_url 2017-03-13-markfile-tutorial %}#ref3)浏览。

# Reference

<a name="ref1"></a>[1]: [Makefile variable assignment - stackoverflow](http://stackoverflow.com/questions/448910/makefile-variable-assignment)

<a name="ref2"></a>[2]: [Implicit-Variables](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html)

<a name="ref3"></a>[3]: [Automatic-Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)

<a name="ref4"></a>[4]: [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html)
