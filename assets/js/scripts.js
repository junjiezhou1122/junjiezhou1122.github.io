/**
 * Modern JavaScript for Junjie Zhou's Portfolio
 * Clean, minimal functionality with smooth interactions
 */

// DOM Elements
const navToggle = document.getElementById("nav-toggle");
const navMenu = document.getElementById("nav-menu");
const themeToggle = document.getElementById("theme-toggle");
const body = document.body;

// Theme Management
let isDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches;

/**
 * Initialize all functionality
 */
function init() {
  setupNavigation();
  setupThemeToggle();
  setupSmoothScrolling();
  setupScrollEffects();
  setupAnimations();
  setupKeyboardShortcuts();

  // Initialize Feather icons
  if (typeof feather !== "undefined") {
    feather.replace();
  }

  console.log("✨ Portfolio loaded successfully");
}

/**
 * Mobile Navigation
 */
function setupNavigation() {
  if (!navToggle || !navMenu) return;

  navToggle.addEventListener("click", () => {
    navMenu.classList.toggle("active");
    navToggle.classList.toggle("active");

    // Animate hamburger menu
    const spans = navToggle.querySelectorAll("span");
    spans.forEach((span, index) => {
      if (navToggle.classList.contains("active")) {
        if (index === 0)
          span.style.transform = "rotate(45deg) translate(5px, 5px)";
        if (index === 1) span.style.opacity = "0";
        if (index === 2)
          span.style.transform = "rotate(-45deg) translate(7px, -6px)";
      } else {
        span.style.transform = "none";
        span.style.opacity = "1";
      }
    });
  });

  // Close menu when clicking on links
  const navLinks = navMenu.querySelectorAll(".nav-link");
  navLinks.forEach((link) => {
    link.addEventListener("click", () => {
      navMenu.classList.remove("active");
      navToggle.classList.remove("active");
    });
  });

  // Close menu when clicking outside
  document.addEventListener("click", (e) => {
    if (!navToggle.contains(e.target) && !navMenu.contains(e.target)) {
      navMenu.classList.remove("active");
      navToggle.classList.remove("active");
    }
  });
}

/**
 * Theme Toggle Functionality
 */
function setupThemeToggle() {
  if (!themeToggle) return;

  // Set initial theme
  updateTheme();

  themeToggle.addEventListener("click", () => {
    isDarkMode = !isDarkMode;
    updateTheme();
    showNotification(isDarkMode ? "Dark mode enabled" : "Light mode enabled");
  });
}

function updateTheme() {
  if (isDarkMode) {
    body.classList.add("dark");
    themeToggle.innerHTML = '<i data-feather="moon"></i>';
  } else {
    body.classList.remove("dark");
    themeToggle.innerHTML = '<i data-feather="sun"></i>';
  }

  // Reinitialize Feather icons
  if (typeof feather !== "undefined") {
    feather.replace();
  }
}

/**
 * Smooth Scrolling
 */
function setupSmoothScrolling() {
  const links = document.querySelectorAll('a[href^="#"]');

  links.forEach((link) => {
    link.addEventListener("click", (e) => {
      e.preventDefault();
      const targetId = link.getAttribute("href");
      const target = document.querySelector(targetId);

      if (target) {
        const headerHeight = document.querySelector(".nav").offsetHeight;
        const targetPosition = target.offsetTop - headerHeight - 20;

        window.scrollTo({
          top: targetPosition,
          behavior: "smooth",
        });
      }
    });
  });
}

/**
 * Scroll Effects
 */
function setupScrollEffects() {
  // Navbar background on scroll
  const nav = document.querySelector(".nav");

  window.addEventListener("scroll", () => {
    if (window.scrollY > 50) {
      nav.style.background = "rgba(255, 255, 255, 0.95)";
      nav.style.backdropFilter = "blur(20px)";
    } else {
      nav.style.background = "rgba(255, 255, 255, 0.8)";
      nav.style.backdropFilter = "blur(20px)";
    }
  });

  // Intersection Observer for animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = "1";
        entry.target.style.transform = "translateY(0)";
      }
    });
  }, observerOptions);

  // Observe elements for animation
  const animatedElements = document.querySelectorAll(
    ".work-card, .thought-card, .stat-card, .resource-item"
  );
  animatedElements.forEach((el) => {
    el.style.opacity = "0";
    el.style.transform = "translateY(30px)";
    el.style.transition = "opacity 0.6s ease, transform 0.6s ease";
    observer.observe(el);
  });
}

/**
 * Setup Animations
 */
function setupAnimations() {
  // Typing effect for hero title
  const heroTitle = document.querySelector(".hero-title");
  if (heroTitle) {
    const text = heroTitle.textContent;
    heroTitle.textContent = "";
    heroTitle.style.borderRight = "2px solid var(--accent-primary)";

    let i = 0;
    const typeWriter = () => {
      if (i < text.length) {
        heroTitle.textContent += text.charAt(i);
        i++;
        setTimeout(typeWriter, 100);
      } else {
        setTimeout(() => {
          heroTitle.style.borderRight = "none";
        }, 1000);
      }
    };

    // Start typing after a short delay
    setTimeout(typeWriter, 500);
  }

  // Floating animation for the code card
  const floatingCard = document.querySelector(".floating-card");
  if (floatingCard) {
    floatingCard.style.animation = "float 6s ease-in-out infinite";
  }
}

/**
 * Keyboard Shortcuts
 */
function setupKeyboardShortcuts() {
  document.addEventListener("keydown", (e) => {
    // Ctrl/Cmd + T to toggle theme
    if ((e.ctrlKey || e.metaKey) && e.key === "t") {
      e.preventDefault();
      themeToggle.click();
    }

    // Escape to close mobile menu
    if (e.key === "Escape") {
      navMenu.classList.remove("active");
      navToggle.classList.remove("active");
    }
  });
}

/**
 * Show notification
 */
function showNotification(message) {
  // Remove existing notification
  const existing = document.querySelector(".notification");
  if (existing) {
    existing.remove();
  }

  // Create notification
  const notification = document.createElement("div");
  notification.className = "notification";
  notification.textContent = message;
  notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: var(--accent-primary);
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: var(--shadow-lg);
        z-index: 10000;
        font-weight: 500;
        font-size: 0.9rem;
        transform: translateX(100%);
        transition: transform 0.3s ease;
    `;

  document.body.appendChild(notification);

  // Animate in
  setTimeout(() => {
    notification.style.transform = "translateX(0)";
  }, 100);

  // Remove after 3 seconds
  setTimeout(() => {
    notification.style.transform = "translateX(100%)";
    setTimeout(() => {
      if (notification.parentNode) {
        notification.remove();
      }
    }, 300);
  }, 3000);
}

/**
 * Scroll to top function
 */
function scrollToTop() {
  window.scrollTo({
    top: 0,
    behavior: "smooth",
  });
}

/**
 * Utility function to debounce scroll events
 */
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Initialize when DOM is loaded
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init);
} else {
  init();
}

// Export functions for global access
window.scrollToTop = scrollToTop;
window.showNotification = showNotification;
