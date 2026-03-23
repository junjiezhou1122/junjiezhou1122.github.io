document.documentElement.classList.add("js");

const navToggle = document.getElementById("nav-toggle");
const siteNav = document.getElementById("site-nav");
const header = document.querySelector(".site-header");
const revealNodes = document.querySelectorAll("[data-reveal]");
const sectionLinks = document.querySelectorAll('.site-nav a[href^="#"]');
const sections = document.querySelectorAll("main section[id]");

function closeNav() {
  if (!navToggle || !siteNav) return;
  navToggle.setAttribute("aria-expanded", "false");
  siteNav.classList.remove("is-open");
  navToggle.classList.remove("is-open");
}

function setupNavigation() {
  if (!navToggle || !siteNav) return;

  navToggle.addEventListener("click", () => {
    const isOpen = navToggle.getAttribute("aria-expanded") === "true";
    navToggle.setAttribute("aria-expanded", String(!isOpen));
    navToggle.classList.toggle("is-open", !isOpen);
    siteNav.classList.toggle("is-open", !isOpen);
  });

  sectionLinks.forEach((link) => {
    link.addEventListener("click", () => closeNav());
  });

  document.addEventListener("click", (event) => {
    if (!siteNav.classList.contains("is-open")) return;
    if (siteNav.contains(event.target) || navToggle.contains(event.target)) return;
    closeNav();
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeNav();
  });
}

function setupSmoothScrolling() {
  document.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener("click", (event) => {
      const targetId = link.getAttribute("href");
      const target = targetId ? document.querySelector(targetId) : null;

      if (!target) return;

      event.preventDefault();
      const headerOffset = header ? header.offsetHeight + 18 : 18;
      const top = target.getBoundingClientRect().top + window.scrollY - headerOffset;

      window.scrollTo({
        top,
        behavior: "smooth",
      });
    });
  });
}

function setupHeaderState() {
  const syncHeader = () => {
    if (!header) return;
    header.classList.toggle("is-scrolled", window.scrollY > 16);
  };

  syncHeader();
  window.addEventListener("scroll", syncHeader, { passive: true });
}

function setupReveal() {
  if (!revealNodes.length) return;

  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    revealNodes.forEach((node) => node.classList.add("is-visible"));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    },
    {
      threshold: 0.14,
      rootMargin: "0px 0px -6% 0px",
    }
  );

  revealNodes.forEach((node) => observer.observe(node));
}

function setupActiveSection() {
  if (!sections.length || !sectionLinks.length) return;

  const linkMap = new Map(
    Array.from(sectionLinks).map((link) => [link.getAttribute("href")?.slice(1), link])
  );

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const link = linkMap.get(entry.target.id);
        if (!link || !entry.isIntersecting) return;

        sectionLinks.forEach((item) => item.removeAttribute("aria-current"));
        link.setAttribute("aria-current", "true");
      });
    },
    {
      threshold: 0.45,
      rootMargin: "-18% 0px -35% 0px",
    }
  );

  sections.forEach((section) => observer.observe(section));
}

setupNavigation();
setupSmoothScrolling();
setupHeaderState();
setupReveal();
setupActiveSection();
