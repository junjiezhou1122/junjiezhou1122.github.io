---
layout: default
permalink: /zh/blog/
title: 博客
lang: zh-CN
nav: false
description: 周君杰关于科研、智能体、认知科学、复杂系统与有趣事物的笔记。
---

<link rel="stylesheet" href="{{ '/assets/css/editorial-site.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/language-switcher.css' | relative_url }}">
<a id="language-switcher" class="language-switcher-fallback" href="{{ '/blog/' | relative_url }}" lang="en" hreflang="en" data-locale="zh" data-english-about-url="{{ '/' | relative_url }}" data-english-blog-url="{{ '/blog/' | relative_url }}" data-about-url="{{ '/zh/' | relative_url }}" data-blog-url="{{ '/zh/blog/' | relative_url }}">EN</a>
<script src="{{ '/assets/js/site-language.js' | relative_url }}" defer></script>

<div class="editorial-page editorial-blog">
{% assign chinese_posts = site.posts | where: "lang", "zh-CN" %}

  <section class="editorial-post-list" aria-label="博客文章">
    <h1 class="sr-only">博客</h1>
    {% if chinese_posts.size == 0 %}
      <div class="blog-empty-state">
        <span class="empty-index" aria-hidden="true">000</span>
        <div>
          <h2>正在写。</h2>
          <p>这里暂时保持安静，第一篇笔记会在准备好之后出现。</p>
        </div>
      </div>
    {% else %}
      {% for post in chinese_posts %}
        {% assign read_time = post.content | number_of_words: "cjk" | divided_by: 500 | plus: 1 %}
        <article class="editorial-post-row">
          <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
          <div class="post-row-copy">
            <h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
            {% if post.description %}<p>{{ post.description }}</p>{% endif %}
            <span>约 {{ read_time }} 分钟</span>
          </div>
          <span class="post-row-arrow" aria-hidden="true">↗</span>
        </article>
      {% endfor %}
    {% endif %}
  </section>
</div>
