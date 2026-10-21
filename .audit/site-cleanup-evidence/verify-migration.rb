require 'json'
require 'yaml'
require 'date'
require 'digest'
require 'open3'
require 'nokogiri'
root = File.expand_path(ARGV[0] || File.join(__dir__, '../..'))
built = File.expand_path(ARGV[1] || File.join(root, '_site'))
contracts = JSON.parse(File.read(File.join(root, '.audit/site-cleanup-contracts.json')))
def split_content(text)
  _, front, body = text.split('---', 3)
  raise 'missing front matter' unless front && body
  data = YAML.safe_load(front, permitted_classes: [Time, Date], aliases: false)
  body = body.lines.reject { |line| line.match?(/\A<(?:link\b|a id="language-switcher"|script src=)/) }.join.lstrip
  [data, body]
end
contracts.fetch('posts').each do |item|
  original, status = Open3.capture2('git', '-C', root, 'show', "#{contracts.fetch('baseline_commit')}:#{item.fetch('file')}")
  raise "missing historical source: #{item.fetch('file')}" unless status.success?
  before, body_before = split_content(original)
  after, body_after = split_content(File.read(File.join(root, 'site', '_posts', File.basename(item.fetch('file')))))
  before.each { |key, value| raise "metadata changed #{item.fetch('file')} #{key}" unless after[key] == value }
  raise "body changed #{item.fetch('file')}" unless Digest::SHA256.hexdigest(body_before) == Digest::SHA256.hexdigest(body_after)
  path = File.join(built, item.fetch('route'), 'index.html')
  raise "missing post #{item.fetch('route')}" unless File.file?(path)
  document = Nokogiri::HTML(File.read(path))
  host = document.at_css('#giscus_thread')
  script = document.at_css('script[src="https://giscus.app/client.js"]')
  raise "comments missing #{path}" unless host && script
  expected = {'data-repo'=>'junjiezhou1122/junjiezhou1122.github.io','data-repo-id'=>'R_kgDOUDvAag','data-category-id'=>'DIC_kwDOUDvAas4DEU1q','data-mapping'=>'pathname','data-strict'=>'1'}
  expected.each { |key,value| raise "comment identity changed #{key} #{path}" unless script[key] == value }
end
archives = JSON.parse(File.read(File.join(root, '.audit/site-cleanup-archives.json')))
archives.each do |item|
  document = Nokogiri::HTML(File.read(File.join(built, item.fetch('route'), 'index.html')))
  links = document.css('a[href]').map { |a| a['href'].split('?').first }.select { |url| url.match?(%r{\A/(?:zh/)?blog/\d{4}/[^/]+/\z}) }.uniq
  raise "archive membership changed #{item.fetch('route')}: #{links}" unless links.sort == item.fetch('posts').sort
end
feed = Nokogiri::XML(File.read(File.join(built, 'feed.xml'))).remove_namespaces!
raise 'feed invalid' unless feed.errors.empty?
expected_urls = contracts.fetch('posts').map { |p| 'https://junjiezhou1122.github.io' + p.fetch('route') }.sort
actual_urls = feed.xpath('//entry/link[@rel="alternate"]/@href').map(&:value).sort
raise 'feed articles changed' unless actual_urls == expected_urls
raise 'feed includes old UI loaders' if feed.to_xml.include?('language-switcher') || feed.to_xml.include?('editorial-site.css')
puts "Migration contracts verified: #{contracts.fetch('posts').length} unchanged post bodies/metadata, #{archives.length} archive routes/memberships, stable comments and clean Atom entries."
