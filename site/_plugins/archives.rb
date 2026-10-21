module PersonalSite
  class Archives < Jekyll::Generator
    priority :high

    def generate(site)
      documents = site.pages.select { |page| page.output_ext == ".html" } + site.posts.docs
      routes = {}
      documents.each do |page|
        locale = page.data['lang']
        fail! page, "unsupported lang #{locale.inspect}" unless site.data['locales'].key?(locale)
        fail! page, 'missing title' if page.data['title'].to_s.strip.empty?
        if page.is_a?(Jekyll::Document)
          %w[description permalink date].each do |field|
            fail! page, "missing #{field}" if page.data[field].to_s.strip.empty?
          end
          %w[tags categories].each do |field|
            values = page.data[field]
            fail! page, "#{field} must be a list of route-safe names" unless values.is_a?(Array) && values.all? { |value| value.is_a?(String) && value.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) }
          end
        end
        route = page.url.sub(%r{/index\.html\z}, '/')
        fail! page, "invalid permalink #{route.inspect}" unless route.start_with?('/') && !route.include?('..') && (route.end_with?('/') || route.end_with?('.html'))
        fail! page, "duplicate route #{route} also owned by #{routes[route]}" if routes.key?(route)
        routes[route] = page.path
      end
      documents.select { |page| page.data['translation_key'] }.group_by { |page| page.data['translation_key'] }.each do |key, pages|
        fail! pages.first, "translation #{key.inspect} needs two different locales" unless pages.size == 2 && pages.map { |page| page.data['lang'] }.uniq.size == 2
        translations = pages.map { |page| { 'lang' => page.data['lang'], 'url' => page.url } }
        pages.each { |page| page.data['translations'] = translations }
      end
      archives = {}
      site.posts.docs.reverse.each do |post|
        year = post.date.strftime('%Y')
        add(archives, "/blog/#{year}/", year, post)
        { 'tags' => 'tag', 'categories' => 'category' }.each do |field, segment|
          post.data[field].each { |name| add(archives, "/blog/#{segment}/#{name}/", name, post) }
        end
      end
      archives.each do |route, archive|
        raise Jekyll::Errors::FatalException, "Archive route #{route} collides with #{routes[route]}" if routes.key?(route)
        page = Jekyll::PageWithoutAFile.new(site, site.source, route.delete_prefix('/'), 'index.html')
        page.data = { 'layout' => 'archive', 'title' => archive[:title], 'lang' => 'en', 'section' => 'blog', 'archive_posts' => archive[:posts] }
        site.pages << page
      end
      Jekyll.logger.info 'Personal site:', "#{site.posts.docs.size} posts, #{archives.size} archives, #{routes.size} authored routes validated"
    end

    private

    def add(archives, route, title, post)
      archive = archives[route] ||= { title: title, posts: [] }
      archive[:posts] << post
    end

    def fail!(page, message)
      raise Jekyll::Errors::FatalException, "#{page.path}: #{message}"
    end
  end
end
