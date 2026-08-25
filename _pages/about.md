---
layout: about
title: about
permalink: /
subtitle: I work on Auto Research and AI for Medicine, with a broader interest in human-centered AI.

profile:
  align: right
  image: junjie-profile.PNG
  image_circular: false

selected_papers: false
social: true

announcements:
  enabled: false

latest_posts:
  enabled: false
---

Hi, I'm **Junjie Zhou (周君杰)**.

I earned my bachelor's degree in **Computer Science and Technology** from Anhui Jianzhu University and am pursuing a master's degree in **Intelligent Science and Technology** at Hangzhou Dianzi University. My research focuses on **Auto Research** and **AI for Medicine (AI4Med)**.

I am especially interested in **long-running agents**, **cognitive science**, **complex systems**, and all the interesting things in the world. I believe in staying curious—and turning that curiosity into things worth building.

---

# Humanive

> **Infrastructure for humans in the age of AI.**

Humanive is the direction I want to keep working on over the long term. Its starting belief is simple: AI should not only become more capable; it should help **humans become more capable**.

As the world grows more complex and information becomes abundant, the challenge is no longer simply accessing knowledge. We need human-centered cognitive and agentic systems that understand a person's goals, context, knowledge, and needs; transform experience into useful understanding; reduce cognitive burden; and help people learn, decide, and act with greater agency.

The work is organized around three connected directions:

- **Understand Human** — build useful representations of a person's goals, knowledge, context, patterns, strengths, and blind spots.
- **Develop Human** — help people learn more effectively, understand more deeply, improve judgment, and strengthen metacognition.
- **Extend Human** — expand what a person can research, create, organize, communicate, coordinate, and accomplish.

Together they form a continuous loop:

**Understand → Develop → Extend → Observe → Understand Better**

Research and real-world systems should strengthen each other inside this loop. The form—software, agents, devices, models, protocols, research, or new interfaces—is secondary. **The human problem comes first.**

**Understand Human. Develop Human. Extend Human.**

<dialog id="wechat-qr-dialog" class="wechat-dialog" aria-labelledby="wechat-dialog-title">
  <div class="wechat-dialog-content">
    <button id="wechat-dialog-close" class="wechat-dialog-close" type="button" aria-label="Close WeChat QR code">
      <i class="fa-solid fa-xmark" aria-hidden="true"></i>
    </button>
    <h2 id="wechat-dialog-title">WeChat</h2>
    <p>Scan the QR code to add me.</p>
    <img src="{{ '/assets/img/wechat-qr.JPG' | relative_url }}" alt="Junjie Zhou's WeChat QR code" width="280">
  </div>
</dialog>

<style>
  .wechat-dialog {
    width: min(22rem, calc(100vw - 2rem));
    padding: 0;
    overflow: hidden;
    color: var(--global-text-color);
    background: var(--global-bg-color);
    border: 1px solid var(--global-divider-color);
    border-radius: 0.75rem;
    box-shadow: 0 1.5rem 4rem rgb(0 0 0 / 24%);
  }

  .wechat-dialog::backdrop {
    background: rgb(0 0 0 / 56%);
    backdrop-filter: blur(0.2rem);
  }

  .wechat-dialog-content {
    position: relative;
    padding: 1.5rem;
    text-align: center;
  }

  .wechat-dialog-content h2 {
    margin: 0 0 0.25rem;
  }

  .wechat-dialog-content p {
    margin-bottom: 1rem;
    color: var(--global-text-color-light);
  }

  .wechat-dialog-content img {
    display: block;
    width: min(100%, 17.5rem);
    height: auto;
    margin: 0 auto;
    border-radius: 0.5rem;
  }

  .wechat-dialog-close {
    position: absolute;
    top: 0.75rem;
    right: 0.75rem;
    display: grid;
    width: 2.25rem;
    height: 2.25rem;
    padding: 0;
    color: var(--global-text-color);
    cursor: pointer;
    background: transparent;
    border: 0;
    border-radius: 50%;
    place-items: center;
  }

  .wechat-dialog-close:hover,
  .wechat-dialog-close:focus-visible {
    color: var(--global-theme-color);
    background: var(--global-hover-color);
    outline: none;
  }
</style>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const dialog = document.getElementById("wechat-qr-dialog");
    const closeButton = document.getElementById("wechat-dialog-close");
    const trigger = document.querySelector('.contact-icons a[href="#wechat-qr-dialog"]');

    if (!(dialog instanceof HTMLDialogElement) || !(closeButton instanceof HTMLButtonElement) || !(trigger instanceof HTMLAnchorElement)) {
      throw new Error("WeChat dialog initialization failed: required elements are missing.");
    }

    trigger.setAttribute("aria-haspopup", "dialog");
    trigger.setAttribute("aria-controls", dialog.id);

    trigger.addEventListener("click", (event) => {
      event.preventDefault();
      dialog.showModal();
    });

    closeButton.addEventListener("click", () => dialog.close());

    dialog.addEventListener("click", (event) => {
      const bounds = dialog.getBoundingClientRect();
      const clickedInside =
        event.clientX >= bounds.left && event.clientX <= bounds.right && event.clientY >= bounds.top && event.clientY <= bounds.bottom;

      if (!clickedInside) dialog.close();
    });
  });
</script>
