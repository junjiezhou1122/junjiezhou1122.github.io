#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
tmp_dir="$(mktemp -d)"
site_dir="${tmp_dir}/site"

cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT INT TERM

bundle exec jekyll build --source "${repo_root}" --destination "${site_dir}" --quiet

bundle exec ruby -rnokogiri - "${site_dir}" <<'RUBY'
site_dir = ARGV.fetch(0)

article_paths = [
  "blog/2026/no-history-no-personal-ai/index.html",
  "zh/blog/2026/no-history-no-personal-ai/index.html",
]

article_paths.each do |relative_path|
  path = File.join(site_dir, relative_path)
  abort "missing rendered article: #{relative_path}" unless File.file?(path)

  document = Nokogiri::HTML(File.read(path))
  abort "Bayesian expression rendered as a table: #{relative_path}" unless document.css("article table").empty?
  abort "Bayesian expression is missing: #{relative_path}" unless document.at_css("article")&.text&.include?("P(you | your history)")
end

feedback_paths = [
  "blog/2026/no-history-no-personal-ai/index.html",
  "zh/blog/2026/no-history-no-personal-ai/index.html",
  "blog/2026/the-network-comes-later/index.html",
  "zh/blog/2026/the-network-comes-later/index.html",
]

feedback_paths.each do |relative_path|
  path = File.join(site_dir, relative_path)
  abort "missing rendered article: #{relative_path}" unless File.file?(path)

  html = File.read(path)
  document = Nokogiri::HTML(html)
  abort "Giscus host is missing: #{relative_path}" unless document.at_css("#giscus_thread")
  abort "Giscus client is missing: #{relative_path}" unless html.include?("https://giscus.app/client.js")
  abort "Giscus is misconfigured: #{relative_path}" if html.include?("giscus comments misconfigured")
end

post_pages = Dir.glob(File.join(site_dir, "blog", "20*", "*", "index.html")) + Dir.glob(File.join(site_dir, "zh", "blog", "20*", "*", "index.html"))
abort "no rendered article pages found" if post_pages.empty?
post_pages.each do |path|
  html = File.read(path)
  abort "article page does not load editorial styles: #{path}" unless html.include?("assets/css/editorial-site.css")
end

list_cases = [
  ["blog/index.html", "Blog", "Read"],
  ["zh/blog/index.html", "博客", "阅读"],
]

list_cases.each do |relative_path, heading, action_label|
  path = File.join(site_dir, relative_path)
  abort "missing rendered blog list: #{relative_path}" unless File.file?(path)

  document = Nokogiri::HTML(File.read(path))
  hero = document.at_css(".blog-hero")
  abort "blog hero is missing: #{relative_path}" unless hero
  abort "blog hero heading is missing: #{relative_path}" unless hero.at_css("h1")&.text == heading
  abort "blog hero description is missing: #{relative_path}" unless hero.css("p").length > 1
  rows = document.css(".editorial-post-row")
  abort "blog list has no post rows: #{relative_path}" if rows.empty?
  actions = document.css("a.post-row-action")
  abort "blog list read actions are missing: #{relative_path}" unless actions.length == rows.length
  abort "blog list read action label is missing: #{relative_path}" unless actions.all? { |action| action.text.include?(action_label) }
end

homepage_cases = [
  ["index.html", "Recent notes", "Who Gets to Define", "信息流不是世界"],
  ["zh/index.html", "最近的笔记", "信息流不是世界", "Who Gets to Define"],
]

homepage_cases.each do |relative_path, heading, expected_title, unexpected_title|
  path = File.join(site_dir, relative_path)
  abort "missing rendered homepage: #{relative_path}" unless File.file?(path)

  document = Nokogiri::HTML(File.read(path))
  section = document.at_css(".editorial-writing")
  abort "homepage writing section is missing: #{relative_path}" unless section
  abort "homepage writing heading is missing: #{relative_path}" unless section.text.include?(heading)
  abort "homepage has no recent writing rows: #{relative_path}" if section.css(".home-post-row").empty?
  abort "homepage recent writing link is missing: #{relative_path}" unless section.at_css("a.section-link")
  abort "homepage contains a post from the wrong language: #{relative_path}" if section.text.include?(unexpected_title)
  abort "homepage expected recent post is missing: #{relative_path}" unless section.text.include?(expected_title)
end

puts "Personal blog rendering integration passed."
RUBY
