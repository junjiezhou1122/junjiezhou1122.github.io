require 'jekyll'
require 'json'
require 'nokogiri'
require 'time'

module PublicPosts
  ROOT = File.expand_path('..', __dir__)

  def self.read(source: File.join(ROOT, 'site'), output: File.join(ROOT, '_site'))
    feed_path = File.join(output, 'feed.xml')
    feed = Nokogiri::XML(File.read(feed_path)) { |xml| xml.strict }
    updated = feed.at_xpath('/*[local-name()="feed"]/*[local-name()="updated"]')
    raise "#{feed_path}: missing build timestamp" unless updated

    config = Jekyll.configuration('config' => File.join(ROOT, '_config.yml'), 'source' => source, 'destination' => output, 'time' => Time.iso8601(updated.text), 'quiet' => true)
    site = Jekyll::Site.new(config)
    site.reset
    site.read
    site.posts.docs.select(&:write?).map { |post| { 'source' => post.path, 'url' => post.url } }
  end
end

if $PROGRAM_NAME == __FILE__
  source = ARGV[0] || File.join(PublicPosts::ROOT, 'site')
  output = ARGV[1] || File.join(PublicPosts::ROOT, '_site')
  puts JSON.generate(PublicPosts.read(source: source, output: output))
end
