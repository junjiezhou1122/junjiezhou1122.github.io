const { test, expect } = require("@playwright/test");
const { execFileSync } = require("node:child_process");
const postRoutes = JSON.parse(execFileSync("bundle", ["exec", "ruby", "test/public_posts.rb"], { encoding: "utf8" })).map((post) => post.url);
const routes = ["/", "/zh/", "/blog/", "/zh/blog/", ...postRoutes];

for (const width of [375, 1280]) {
  for (const route of routes) {
    test(`${width}px ${route}`, async ({ page }) => {
      const errors = [];
      page.on("pageerror", (error) => errors.push(error.message));
      page.on("response", (response) => {
        if (response.url().startsWith("http://127.0.0.1:4187") && response.status() >= 400) errors.push(`${response.status()} ${response.url()}`);
      });
      await page.route("https://giscus.app/**", (request) => request.fulfill({ contentType: "application/javascript", body: "" }));
      await page.setViewportSize({ width, height: 900 });
      await page.goto(route);
      await expect(page.locator("h1")).toBeVisible();
      await page.evaluate(() => document.fonts.ready);
      expect(await page.evaluate(() => [...document.fonts].some((font) => font.family === "Hanken Grotesk" && font.status === "loaded"))).toBe(true);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
      if (route === "/" || route === "/zh/") {
        const portrait = page.locator(".about-portrait img");
        expect(await portrait.evaluate((img) => img.complete && img.naturalWidth > 0)).toBe(true);
        if (width === 375) {
          const image = await portrait.boundingBox();
          const title = await page.locator("h1").boundingBox();
          expect(title.x).toBeGreaterThan(image.x + image.width);
          expect(Math.abs(title.y + title.height / 2 - image.y - image.height / 2)).toBeLessThan(5);
        }
      }
      for (const arrow of await page.locator(".reading-arrow").all()) {
        const box = await arrow.boundingBox();
        expect(box.width).toBe(14);
        expect(box.height).toBe(14);
        expect(await arrow.evaluate((node) => getComputedStyle(node).color)).toBe("rgb(26, 115, 232)");
      }
      if (width === 375) {
        const menu = page.locator(".menu-toggle");
        await menu.click();
        await expect(menu).toHaveAttribute("aria-expanded", "true");
        await expect(page.locator(".site-nav")).toBeVisible();
        await page.keyboard.press("Escape");
        await expect(menu).toHaveAttribute("aria-expanded", "false");
        await expect(menu).toBeFocused();
        await menu.click();
        await page.locator(".site-nav a").first().focus();
        await page.keyboard.press("Escape");
        await expect(menu).toBeFocused();
        await expect(menu).toHaveAttribute("aria-expanded", "false");
      }
      expect(errors).toEqual([]);
    });
  }
}

for (const route of ["/", "/zh/"]) {
  test(`QR is lazy and accessible ${route}`, async ({ page }) => {
    const qrRequests = [];
    page.on("request", (request) => {
      if (request.url().includes("wechat-qr.JPG")) qrRequests.push(request.url());
    });
    await page.setViewportSize({ width: 375, height: 900 });
    await page.goto(route);
    expect(qrRequests).toHaveLength(0);
    const trigger = page.locator('.editorial-socials a[href="#wechat-qr-dialog"]');
    const dialog = page.locator("#wechat-qr-dialog");
    await trigger.click();
    await expect(dialog).toBeVisible();
    await expect(dialog.locator("img")).toHaveJSProperty("complete", true);
    expect(qrRequests).toHaveLength(1);
    await page.keyboard.press("Escape");
    await expect(dialog).not.toBeVisible();
    await expect(trigger).toBeFocused();
    await trigger.click();
    await page.mouse.click(5, 5);
    await expect(dialog).not.toBeVisible();
    await expect(trigger).toBeFocused();
    await trigger.click();
    await dialog.locator("button").click();
    await expect(dialog).not.toBeVisible();
    await expect(trigger).toBeFocused();
    expect(qrRequests).toHaveLength(1);
  });
}
