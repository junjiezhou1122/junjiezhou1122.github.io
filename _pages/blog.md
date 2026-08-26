---
layout: default
permalink: /blog/
title: blog
lang: en
nav: true
nav_order: 1
description: Notes from Junjie Zhou on research, agents, cognition, complex systems, and things worth exploring.
---

<link rel="stylesheet" href="{{ '/assets/css/editorial-site.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/language-switcher.css' | relative_url }}">
<a id="language-switcher" class="language-switcher-fallback" href="{{ '/zh/blog/' | relative_url }}" lang="zh-CN" hreflang="zh-CN" data-locale="en" data-english-about-url="{{ '/' | relative_url }}" data-english-blog-url="{{ '/blog/' | relative_url }}">中文</a>
<script src="{{ '/assets/js/site-language.js' | relative_url }}" defer></script>

<div class="editorial-page editorial-blog">
{% assign english_posts = site.posts | where_exp: "post", "post.lang != 'zh-CN'" %}

  <section class="editorial-post-list" aria-label="Blog posts">
    <h1 class="sr-only">Blog</h1>
    {% if english_posts.size == 0 %}
      <div class="blog-empty-state">
        <span class="empty-index" aria-hidden="true">000</span>
        <div>
          <h2>Writing in progress.</h2>
          <p>This space is intentionally quiet for now. The first notes will appear here.</p>
        </div>
      </div>
    {% else %}
      {% for post in english_posts %}
        {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
        <article class="editorial-post-row">
          <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %d, %Y" }}</time>
          <div class="post-row-copy">
            <h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
            {% if post.description %}<p>{{ post.description }}</p>{% endif %}
            <span>{{ read_time }} min read</span>
          </div>
          <span class="post-row-arrow" aria-hidden="true">↗</span>
        </article>
      {% endfor %}
    {% endif %}
  </section>
</div>
