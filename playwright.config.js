const { defineConfig } = require("@playwright/test");
module.exports = defineConfig({
  testDir: "./test/browser",
  fullyParallel: true,
  workers: 4,
  reporter: "list",
  use: { baseURL: "http://127.0.0.1:4187", screenshot: "only-on-failure", trace: "retain-on-failure" },
  projects: [
    { name: "chromium", use: { browserName: "chromium" } },
    { name: "webkit", use: { browserName: "webkit" } },
  ],
  webServer: { command: "node test/serve.cjs", url: "http://127.0.0.1:4187", reuseExistingServer: false },
});
