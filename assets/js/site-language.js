document.addEventListener("DOMContentLoaded", () => {
  const switcher = document.getElementById("language-switcher");
  const navContainer = document.querySelector("#navbar > .container");
  const navList = document.querySelector("#navbar .navbar-menu-list");
  const englishAboutUrl = switcher?.dataset.englishAboutUrl;
  const englishBlogUrl = switcher?.dataset.englishBlogUrl;
  const navLinks = navList ? Array.from(navList.querySelectorAll("a.nav-link")) : [];
  const aboutLink = navLinks.find((link) => link.getAttribute("href") === englishAboutUrl);
  const blogLink = navLinks.find((link) => link.getAttribute("href") === englishBlogUrl);

  if (
    !(switcher instanceof HTMLAnchorElement) ||
    !(navContainer instanceof HTMLDivElement) ||
    !(navList instanceof HTMLUListElement) ||
    !englishAboutUrl ||
    !englishBlogUrl ||
    !aboutLink ||
    !blogLink
  ) {
    throw new Error("Language switcher initialization failed: required navigation elements are missing.");
  }

  let brand = navContainer.querySelector(".navbar-brand");
  if (!(brand instanceof HTMLAnchorElement)) {
    const navToggle = navContainer.querySelector(".navbar-toggler-main");
    if (!(navToggle instanceof HTMLButtonElement)) {
      throw new Error("Language switcher initialization failed: navigation toggle is missing.");
    }

    brand = document.createElement("a");
    brand.className = "navbar-brand title";
    brand.textContent = "Junjie Zhou";
    navContainer.insertBefore(brand, navToggle);
  }

  const fallbackContainer = switcher.parentElement;
  const switcherItem = document.createElement("li");
  switcherItem.className = "nav-item language-switcher-item";
  switcher.classList.remove("language-switcher-fallback");
  switcher.classList.add("nav-link");
  switcherItem.append(switcher);
  navList.insertBefore(switcherItem, navList.querySelector(".toggle-container"));
  if (fallbackContainer instanceof HTMLParagraphElement && fallbackContainer.childElementCount === 0) fallbackContainer.remove();

  if (switcher.dataset.locale !== "zh") {
    brand.href = englishAboutUrl;
    return;
  }

  const aboutUrl = switcher.dataset.aboutUrl;
  const blogUrl = switcher.dataset.blogUrl;
  if (!aboutUrl || !blogUrl) throw new Error("Language switcher initialization failed: Chinese navigation URLs are missing.");

  const replaceVisibleLabel = (link, label) => {
    const textNode = Array.from(link.childNodes).find((node) => node.nodeType === Node.TEXT_NODE);
    if (!(textNode instanceof Text)) throw new Error(`Language switcher initialization failed: ${label} link label is missing.`);
    textNode.textContent = `${label} `;
  };

  aboutLink.href = aboutUrl;
  replaceVisibleLabel(aboutLink, "关于");
  blogLink.href = blogUrl;
  replaceVisibleLabel(blogLink, "博客");

  brand.href = aboutUrl;

  const activeLink = window.location.pathname.includes("/zh/blog/") ? blogLink : aboutLink;
  activeLink.closest(".nav-item")?.classList.add("active");
  activeLink.setAttribute("aria-current", "page");
});
