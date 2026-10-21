const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");
const root = path.resolve("_site");
const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css",
  ".js": "text/javascript",
  ".svg": "image/svg+xml",
  ".webp": "image/webp",
  ".JPG": "image/jpeg",
  ".ttf": "font/ttf",
  ".xml": "application/xml",
};
http
  .createServer((request, response) => {
    const url = new URL(request.url, "http://localhost");
    const requested = decodeURIComponent(url.pathname);
    const file = path.resolve(root, "." + requested, requested.endsWith("/") ? "index.html" : "");
    if (!file.startsWith(root + path.sep) || !fs.existsSync(file) || !fs.statSync(file).isFile()) {
      response.writeHead(404).end("Not found");
      return;
    }
    response.writeHead(200, { "Content-Type": types[path.extname(file)] || "application/octet-stream" });
    fs.createReadStream(file).pipe(response);
  })
  .listen(4187, "127.0.0.1", () => process.stdout.write("Site test server http://127.0.0.1:4187\n"));
