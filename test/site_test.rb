require 'date'
require 'fileutils'
require 'jekyll'
require 'nokogiri'
require 'open3'
require_relative 'public_posts'
require 'pathname'
require 'tmpdir'
require 'uri'
require 'yaml'

ROOT = File.expand_path('..', __dir__)
SOURCE = File.expand_path(ARGV[0] || File.join(ROOT, 'site'))
OUTPUT = File.expand_path(ARGV[1] || File.join(ROOT, '_site'))
CONFIG = YAML.load_file(File.join(ROOT, '_config.yml'))
LOCALES = YAML.load_file(File.join(SOURCE, '_data/locales.yml'))

$checks = 0
def check(condition, message)
  raise message unless condition
  $checks += 1
end

def output_path(route)
  File.join(OUTPUT, route.delete_prefix('/') + (route.end_with?('/') ? 'index.html' : ''))
end

def html(route)
  path = output_path(route)
  check(File.file?(path), "Missing page #{route}")
  Nokogiri::HTML5(File.read(path))
end

def normalize(text)
  text.gsub(/\s+/, ' ').strip
end

check(CONFIG['source'] == 'site', 'Publishing source must stay isolated under site/')

posts = PublicPosts.read(source: SOURCE, output: OUTPUT).map do |entry|
  path = entry.fetch('source')
  text = File.read(path)
  front, body = text.split(/^---\s*$\n?/, 3).drop(1)
  data = YAML.safe_load(front, permitted_classes: [Time, Date])
  check(data['permalink'] == entry.fetch('url'), "Source permalink differs from Jekyll URL at #{path}")
  data['date'] ||= Date.parse(File.basename(path)[0, 10])
  data.merge('body' => body, 'source' => path)
end
posts.each do |post|
  doc = html(post['permalink'])
  check(doc.at_css('h1').text == post['title'], "Title changed at #{post['permalink']}")
  expected = Nokogiri::HTML5.fragment(Kramdown::Document.new(post['body'], input: 'GFM').to_html)
  check(normalize(doc.at_css('.post-content').text) == normalize(expected.text), "Article text changed at #{post['permalink']}")
  check(!post['body'].match?(/<(?:script|link)\b/), "Presentation loader in #{post['source']}")
  check(doc.at_css('html')['lang'] == post['lang'], "Wrong article locale at #{post['permalink']}")
  giscus = doc.at_css('#giscus_thread script')
  check(!giscus.nil?, "Comments missing at #{post['permalink']}")
  { 'repo' => CONFIG['giscus']['repo'], 'repo-id' => CONFIG['giscus']['repo_id'], 'category' => CONFIG['giscus']['category'], 'category-id' => CONFIG['giscus']['category_id'], 'mapping' => 'pathname', 'strict' => '1', 'reactions-enabled' => '1', 'emit-metadata' => '0', 'input-position' => 'bottom' }.each do |key, value|
    check(giscus["data-#{key}"] == value, "Wrong Giscus #{key} at #{post['permalink']}")
  end
  counterparts = posts.select { |other| post['translation_key'] && other['translation_key'] == post['translation_key'] && other['lang'] != post['lang'] }
  check(doc.css('.language-switcher').map { |link| link['href'] } == counterparts.map { |other| other['permalink'] }, "False or missing translation at #{post['permalink']}")
  if post['permalink'].include?('no-history-no-personal-ai')
    check(doc.css('.post-content table').empty?, 'Bayes pipe became a table')
    check(doc.at_css('.post-content').text.include?('P(you | your history)'), 'Bayes pipe content changed')
  end
end

archives = {}
posts.each do |post|
  routes = ["/blog/#{post['date'].year}/"]
  { 'tags' => 'tag', 'categories' => 'category' }.each { |field, segment| post[field].each { |name| routes << "/blog/#{segment}/#{name}/" } }
  routes.each { |route| (archives[route] ||= []) << post['permalink'] }
end
archives.each do |route, members|
  actual = html(route).css('.post-row-copy h2 a').map { |link| link['href'] }
  check(actual.sort == members.sort, "Wrong archive members at #{route}")
end

LOCALES.each do |lang, locale|
  current_posts = posts.select { |post| post['lang'] == lang }
  home = html(locale['about_url'])
  blog = html(locale['blog_url'])
  check(home.at_css('h1').text == locale['name'], "Wrong profile name for #{lang}")
  check(home.at_css('.humanive').text.include?('Humanive'), "Humanive missing for #{lang}")
  check(home.css('.home-post-row').size == [current_posts.size, 3].min, "Wrong homepage post count for #{lang}")
  check(blog.css('.post-row-copy h2 a').map { |link| link['href'] }.sort == current_posts.map { |post| post['permalink'] }.sort, "Wrong blog membership for #{lang}")
  [home, blog].each do |page|
    empty_states = page.css('.blog-empty-state')
    if current_posts.empty?
      check(empty_states.size == 1, "Missing empty writing state for #{lang}")
      check(empty_states.first.at_css('h2')&.text == locale['empty_title'], "Wrong empty writing title for #{lang}")
      check(empty_states.first.at_css('p')&.text == locale['empty_note'], "Wrong empty writing note for #{lang}")
    else
      check(empty_states.empty?, "Unexpected empty writing state for #{lang}")
    end
  end
  check(home.at_css('.editorial-socials a[aria-label="X"]')['href'] == 'https://x.com/junjiechou1122', 'X handle changed')
  check(home.at_css('#wechat-qr-dialog img')['src'].nil?, 'QR fetched before activation')
  check(home.at_css('.about-portrait img')['srcset'].include?('480w'), 'Responsive portrait missing')
end

routes = ['/', '/zh/', '/blog/', '/zh/blog/', '/404.html'] + posts.map { |post| post['permalink'] } + archives.keys
routes.each do |route|
  doc = html(route)
  check(doc.css('link[rel="canonical"]').size == 1 && doc.at_css('link[rel="canonical"]')['href'] == CONFIG['url'] + route, "Invalid canonical at #{route}")
  check(doc.css('link[rel="stylesheet"]').size == 1, "Duplicate or remote stylesheet at #{route}")
  check(doc.at_css('.site-nav a[aria-current="page"]') || route == '/404.html', "Missing active nav at #{route}")
  check(doc.css('.reading-arrow').all? { |arrow| arrow.name == 'svg' }, "Invalid reading arrow at #{route}")
  doc.css('a[href], img[src], script[src], link[href]').each do |node|
    value = node['href'] || node['src']
    uri = URI.parse(value)
    next if uri.host && uri.host != URI(CONFIG['url']).host
    next if uri.scheme && !%w[http https].include?(uri.scheme)
    target = uri.path.empty? ? route : URI.join(CONFIG['url'] + route, uri.path).path
    target_path = output_path(target)
    check(File.file?(target_path), "Broken local resource #{value} from #{route}")
    if uri.fragment && target.end_with?('/')
      linked = target == route ? doc : Nokogiri::HTML5(File.read(target_path))
      check(!linked.at_css("[id='#{uri.fragment}']").nil?, "Broken fragment #{value} from #{route}")
    end
  end
end

expected_files = routes.map { |route| Pathname(output_path(route)).relative_path_from(Pathname(OUTPUT)).to_s }
expected_files += Dir[File.join(SOURCE, 'assets/**/*')].select { |file| File.file?(file) }.map { |file| Pathname(file).relative_path_from(Pathname(SOURCE)).to_s }
expected_files += %w[feed.xml sitemap.xml robots.txt]
actual_files = Dir[File.join(OUTPUT, '**/*'), File.join(OUTPUT, '**/.*')].select { |file| File.file?(file) }.map { |file| Pathname(file).relative_path_from(Pathname(OUTPUT)).to_s }
check(actual_files.sort == expected_files.sort, "Unexpected published files #{actual_files - expected_files}; missing #{expected_files - actual_files}")
feed = Nokogiri::XML(File.read(File.join(OUTPUT, 'feed.xml'))).remove_namespaces!
check(feed.css('entry').size == posts.size, 'Feed omitted posts')
check(feed.css('entry > link').map { |link| URI(link['href']).path }.sort == posts.map { |post| post['permalink'] }.sort, 'Wrong feed entry URLs')
check(feed.css('entry content').all? { |entry| !entry.text.match?(/<(?:link|script)\b/) }, 'Feed contains presentation loaders')
sitemap = Nokogiri::XML(File.read(File.join(OUTPUT, 'sitemap.xml'))).remove_namespaces!
check(sitemap.css('loc').map { |node| URI(node.text).path }.sort == (routes - ['/404.html']).sort, 'Sitemap differs from public pages')
check(File.read(File.join(OUTPUT, 'robots.txt')).include?(CONFIG['url'] + '/sitemap.xml'), 'Robots sitemap missing')

puts "Site checks passed: #{$checks} assertions, #{posts.size} posts, #{archives.size} archives."
exit if ARGV.include?('--skip-fixtures')

require File.join(SOURCE, '_plugins/archives.rb')
def fixture_build(verify: nil, time: nil)
  Dir.mktmpdir('personal-site-test') do |directory|
    source = File.join(directory, 'site')
    FileUtils.cp_r(SOURCE, source)
    post_directory = File.join(source, '_posts')
    FileUtils.rm_rf(post_directory)
    FileUtils.mkdir_p(post_directory)
    { 'en' => 'en', 'zh' => 'zh-CN' }.each do |suffix, lang|
      File.write(File.join(post_directory, "2020-01-01-fixture-#{suffix}.md"), "---\ntitle: Fixture #{suffix}\ndescription: Independent test article\nlang: #{lang}\ndate: 2020-01-01\npermalink: /blog/fixture-#{suffix}/\ntranslation_key: fixture-pair\ntags:\n  - personal-ai\ncategories: [testing]\n---\nFixture body.\n")
    end
    yield source
    config = Jekyll.configuration('config' => File.join(ROOT, '_config.yml'), 'source' => source, 'destination' => File.join(directory, 'output'), 'quiet' => true)
    config['time'] = time if time
    site = Jekyll::Site.new(config)
    site.process
    verify.call(site) if verify
    site
  end
end

def verify_fixture_output(site)
  output, errors, status = Open3.capture3(RbConfig.ruby, File.join(ROOT, 'test/site_test.rb'), site.source, site.dest, '--skip-fixtures')
  check(status.success?, "Fixture failed source/output checks:\n#{output}#{errors}")
end

def reject_fixture(message, &change)
  caught = nil
  begin
    fixture_build(&change)
  rescue Jekyll::Errors::FatalException => error
    caught = error.message
  end
  check(caught && caught.include?(message), "Expected build error #{message.inspect}, received #{caught.inspect}")
end

reject_fixture('unsupported lang') do |source|
  file = Dir[File.join(source, '_posts/*.md')].first
  File.write(file, File.read(file).sub(/lang: .*/, 'lang: invalid'))
end
reject_fixture('duplicate route') do |source|
  File.write(File.join(source, 'duplicate.html'), "---\nlayout: default\ntitle: Duplicate\nlang: en\npermalink: /\n---\n")
end
reject_fixture('duplicate route') do |source|
  File.write(File.join(source, 'duplicate.html'), "---\nlayout: default\ntitle: Duplicate\nlang: en\npermalink: /index.html\n---\n")
end
reject_fixture('translation') do |source|
  file = Dir[File.join(source, '_posts/*-zh.md')].first
  File.write(file, File.read(file).sub(/^translation_key: .*$/,'translation_key: unpaired'))
end
reject_fixture('collides') do |source|
  File.write(File.join(source, 'collision.html'), "---\nlayout: default\ntitle: Collision\nlang: en\npermalink: /blog/tag/personal-ai/\n---\n")
end
fixture = fixture_build do |source|
  file = Dir[File.join(source, '_posts/*.md')].first
  File.write(file, File.read(file).sub("tags:\n", "tags:\n  - new-topic\n"))
end
generated = fixture.pages.find { |page| page.url == '/blog/tag/new-topic/' }
check(generated && generated.data['archive_posts'].size == 1, 'New post tag did not generate an archive')
fixture_build(time: Time.iso8601('2024-01-01T00:00:00+08:00'), verify: lambda do |site|
  verify_fixture_output(site)
  manifest, errors, status = Open3.capture3(RbConfig.ruby, File.join(ROOT, 'test/public_posts.rb'), site.source, site.dest)
  check(status.success?, "Browser inventory failed: #{errors}")
  public_routes = JSON.parse(manifest).map { |entry| entry.fetch('url') }
  check(public_routes.include?('/blog/quoted-permalink/'), 'Quoted YAML permalink missing from browser inventory')
  %w[future-post scheduled-post unpublished-post].each do |slug|
    check(!public_routes.include?("/blog/#{slug}/"), "Hidden #{slug} reached browser inventory")
    check(!File.exist?(File.join(site.dest, 'blog', slug)), "Hidden #{slug} generated HTML")
    check(!Dir[File.join(site.dest, '**/*.{html,xml}')].any? { |path| File.read(path).include?("/blog/#{slug}/") }, "Hidden #{slug} leaked into public links, feeds, or archives")
  end
end) do |source|
  {
    '2099-01-01-future.md' => ['future-post', '2099-01-01', true],
    '2025-01-01-scheduled.md' => ['scheduled-post', '2025-01-01', true],
    '2020-01-01-unpublished.md' => ['unpublished-post', '2020-01-01', false],
    '2020-01-01-quoted.md' => ['quoted-permalink', '2020-01-01', true]
  }.each do |filename, (slug, date, published)|
    File.write(File.join(source, '_posts', filename), "---\ntitle: Publication fixture\ndescription: Publication regression\nlang: en\ndate: #{date}\npermalink: \"/blog/#{slug}/\"\npublished: #{published}\ntags: [publication-fixture]\ncategories: [testing]\n---\nFixture body.\n")
  end
end
fixture_build(verify: method(:verify_fixture_output)) do |source|
  FileUtils.rm_rf(File.join(source, '_posts'))
end
puts "Build fixtures passed: #{$checks} total assertions."
