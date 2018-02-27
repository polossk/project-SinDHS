---
layout: default
title: 全站归档
permalink: /post-archive/
type: whole
---
<h1 class="page-heading">{% archive_page_title %}</h1>

从第一篇文章到最新一篇已经过去了 <i class="icon-quote-left"></i> {% rundays %} <i class="icon-quote-right"></i> 天, 共有 <i class="icon-quote-left"></i> {{ site.posts | size }} <i class="icon-quote-right"></i> 篇文章.

<ul class="post-list">
	{% for post in site.posts %}
	<li>
		<span>
			<span class="post-date">
			<i class="icon-time"></i>
			{{ post.date | date: "%Y-%m-%d"}}
			</span>
			<span>
			<i class="icon-file-alt"></i>
			<a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
			</span>
		</span>
	</li>
	{% endfor %}
</ul>