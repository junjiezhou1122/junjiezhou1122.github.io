document.addEventListener("DOMContentLoaded", () => {
  const switcher = document.getElementById("language-switcher");
  const navList = document.querySelector("#navbar .navbar-menu-list");
  const englishAboutUrl = switcher?.dataset.englishAboutUrl;
  const englishBlogUrl = switcher?.dataset.englishBlogUrl;
  const navLinks = navList ? Array.from(navList.querySelectorAll("a.nav-link")) : [];
  const aboutLink = navLinks.find((link) => link.getAttribute("href") === englishAboutUrl);
  const blogLink = navLinks.find((link) => link.getAttribute("href") === englishBlogUrl);

  if (
    !(switcher instanceof HTMLAnchorElement) ||
    !(navList instanceof HTMLUListElement) ||
    !englishAboutUrl ||
    !englishBlogUrl ||
    !aboutLink ||
    !blogLink
  ) {
    throw new Error("Language switcher initialization failed: required navigation elements are missing.");
  }

  const fallbackContainer = switcher.parentElement;
  const switcherItem = document.createElement("li");
  switcherItem.className = "nav-item language-switcher-item";
  switcher.classList.remove("language-switcher-fallback");
  switcher.classList.add("nav-link");
  switcherItem.append(switcher);
  navList.insertBefore(switcherItem, navList.querySelector(".toggle-container"));
  if (fallbackContainer instanceof HTMLParagraphElement && fallbackContainer.childElementCount === 0) fallbackContainer.remove();

  if (switcher.dataset.locale !== "zh") return;

  const aboutUrl = switcher.dataset.aboutUrl;
  const blogUrl = switcher.dataset.blogUrl;
  if (!aboutUrl || !blogUrl) throw new Error("Language switcher initialization failed: Chinese navigation URLs are missing.");

  aboutLink.href = aboutUrl;
  aboutLink.childNodes[0].textContent = "关于 ";
  blogLink.href = blogUrl;
  blogLink.childNodes[0].textContent = "博客 ";

  const brand = document.querySelector("#navbar .navbar-brand");
  if (brand instanceof HTMLAnchorElement) brand.href = aboutUrl;

  const activeLink = window.location.pathname.includes("/zh/blog/") ? blogLink : aboutLink;
  activeLink.closest(".nav-item")?.classList.add("active");
  activeLink.setAttribute("aria-current", "page");
});
