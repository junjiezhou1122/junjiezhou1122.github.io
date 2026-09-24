---
layout: default
title: 关于
permalink: /zh/
lang: zh-CN
description: 周君杰的个人主页，研究方向包括自动化科研、医疗人工智能、长程运行智能体、认知科学与以人为中心的 AI。
---

<link rel="stylesheet" href="{{ '/assets/css/editorial-site.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/language-switcher.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/wechat-dialog.css' | relative_url }}">
<a id="language-switcher" class="language-switcher-fallback" href="{{ '/' | relative_url }}" lang="en" hreflang="en" data-locale="zh" data-english-about-url="{{ '/' | relative_url }}" data-english-blog-url="{{ '/blog/' | relative_url }}" data-about-url="{{ '/zh/' | relative_url }}" data-blog-url="{{ '/zh/blog/' | relative_url }}">EN</a>
<script src="{{ '/assets/js/site-language.js' | relative_url }}" defer></script>

<div class="editorial-page editorial-about">
  <section class="about-introduction" aria-labelledby="introduction-title">
    <div class="about-introduction-main">
      <p class="section-marker">关于 · 01</p>
      <div class="introduction-copy">
        <h1 class="introduction-lead" id="introduction-title">周君杰</h1>
        <p class="introduction-role">关注自动化科研、医疗人工智能，以及以人为中心的 AI。</p>
        <p>我本科就读于<strong>安徽建筑大学计算机科学与技术专业</strong>，目前在<strong>杭州电子科技大学智能科学与技术专业</strong>攻读硕士学位。</p>
        <p>我的研究方向主要是<strong>自动化科研（Auto Research）</strong>与<strong>医疗人工智能（AI4Med）</strong>。我也持续关注长程运行智能体、认知科学、复杂系统，以及这个世界上一切有趣的事物。</p>
        <p>我相信始终保持好奇，并把好奇心转化为值得创造的东西。</p>

        <nav class="contact-icons editorial-socials" aria-label="社交链接">
          <a href="https://github.com/junjiezhou1122" title="GitHub" aria-label="GitHub" rel="external nofollow noopener" target="_blank"><i class="fa-brands fa-github" aria-hidden="true"></i><span>GitHub</span></a>
          <a href="https://x.com/junjiezhou1122" title="X" aria-label="X" rel="external nofollow noopener" target="_blank"><i class="fa-brands fa-x-twitter" aria-hidden="true"></i><span>X</span></a>
          <a href="#wechat-qr-dialog" title="微信" aria-label="打开微信二维码"><i class="fa-brands fa-weixin" aria-hidden="true"></i><span>微信</span></a>
        </nav>
      </div>
    </div>

    <figure class="about-portrait">
      <img src="{{ '/assets/img/junjie-profile-800.webp' | relative_url }}" srcset="{{ '/assets/img/junjie-profile-480.webp' | relative_url }} 480w, {{ '/assets/img/junjie-profile-800.webp' | relative_url }} 800w" sizes="(max-width: 767px) 280px, 288px" alt="周君杰的个人头像" width="1086" height="1448" loading="eager" fetchpriority="high">
    </figure>

  </section>

  <section class="humanive" aria-labelledby="humanive-title">
    <header class="humanive-header editorial-reading-column">
      <p class="section-marker">长期方向 · 02</p>
      <h2 id="humanive-title">Humanive</h2>
      <p class="humanive-tagline">AI 时代，以人为中心的基础设施。</p>
      <p>AI 不应该只让机器变得更强，也应该帮助<strong>人本身变得更有能力</strong>。</p>
      <p>Humanive 是我想长期探索的方向：构建自适应、以人为中心的认知系统。它理解人的情境，把经历转化为有用的认知，减轻认知负担，并帮助人持续学习、做出判断与采取行动。</p>
    </header>

    <div class="humanive-directions" aria-label="Humanive 的三个方向">
      <article class="direction-row">
        <span class="direction-number" aria-hidden="true">01</span>
        <h3>理解人</h3>
        <p>形成对个人目标、知识、情境、模式、优势与盲点的有效理解。</p>
      </article>
      <article class="direction-row">
        <span class="direction-number" aria-hidden="true">02</span>
        <h3>发展人</h3>
        <p>帮助人更有效地学习、更深入地理解、改善判断，并增强元认知能力。</p>
      </article>
      <article class="direction-row">
        <span class="direction-number" aria-hidden="true">03</span>
        <h3>延伸人</h3>
        <p>扩展一个人在研究、创造、组织、沟通、协作与行动上的能力。</p>
      </article>
    </div>

    <div class="humanive-loop editorial-reading-column" aria-label="Humanive 核心循环">
      <p class="loop-label">核心循环</p>
      <p class="loop-flow"><span>理解</span><i aria-hidden="true">→</i><span>发展</span><i aria-hidden="true">→</i><span>延伸</span><i aria-hidden="true">→</i><span>观察</span><i aria-hidden="true">→</i><span>更好地理解</span></p>
      <p class="loop-principle">形式是次要的，人的问题始终优先。</p>
    </div>

  </section>

{% assign home_posts = site.posts | where: "lang", "zh-CN" | slice: 0, 3 %}

  <section class="editorial-writing" aria-labelledby="writing-title">
    <header class="section-header editorial-reading-column">
      <div>
        <p class="section-marker">写作 · 03</p>
        <h2 id="writing-title">最近的笔记</h2>
      </div>
      <a class="section-link" href="{{ '/zh/blog/' | relative_url }}">全部文章 <span aria-hidden="true">↗</span></a>
    </header>

    <div class="editorial-post-list home-post-list">
      {% for post in home_posts %}
        {% assign read_time = post.content | number_of_words: "cjk" | divided_by: 500 | plus: 1 %}
        <article class="editorial-post-row home-post-row">
          <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
          <div class="post-row-copy">
            <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
            {% if post.description %}<p>{{ post.description }}</p>{% endif %}
            <span>约 {{ read_time }} 分钟</span>
          </div>
          <svg class="post-row-arrow" viewBox="0 0 16 16" aria-hidden="true" focusable="false">
            <path d="M3 13 13 3M6 3h7v7" />
          </svg>
        </article>
      {% endfor %}
    </div>

  </section>
</div>

<dialog id="wechat-qr-dialog" class="wechat-dialog" aria-labelledby="wechat-dialog-title">
  <div class="wechat-dialog-content">
    <button id="wechat-dialog-close" class="wechat-dialog-close" type="button" aria-label="关闭微信二维码">
      <i class="fa-solid fa-xmark" aria-hidden="true"></i>
    </button>
    <p class="dialog-kicker">保持联系</p>
    <h2 id="wechat-dialog-title">微信</h2>
    <p>扫描二维码添加我的微信。</p>
    <img data-src="{{ '/assets/img/wechat-qr.JPG' | relative_url }}" alt="周君杰的微信二维码" width="888" height="1191">
  </div>
</dialog>
<script src="{{ '/assets/js/wechat-dialog.js' | relative_url }}" defer></script>
