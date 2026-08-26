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

list_paths = ["blog/index.html", "zh/blog/index.html"]

list_paths.each do |relative_path|
  path = File.join(site_dir, relative_path)
  abort "missing rendered blog list: #{relative_path}" unless File.file?(path)

  document = Nokogiri::HTML(File.read(path))
  arrows = document.css("svg.post-row-arrow")
  abort "blog list has no SVG arrows: #{relative_path}" if arrows.empty?
  abort "blog list arrow contains font-rendered text: #{relative_path}" unless arrows.all? { |arrow| arrow.text.strip.empty? }
  abort "blog list arrow path is missing: #{relative_path}" unless arrows.all? { |arrow| arrow.at_css('path[d="M3 13 13 3M6 3h7v7"]') }
end

puts "Personal blog rendering integration passed."
RUBY
