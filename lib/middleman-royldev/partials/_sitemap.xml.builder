  xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
    sitemap.resources.each do |resource|
      if resource&.source_file&.match?(/html/)
        xml.url do
          xml.loc absolute_url(resource.url)
          xml.lastmod File.mtime(resource.source_file).iso8601
          xml.changefreq "weekly"
          xml.priority 0.8
          # TODO: add images
          # TODO: add videos
        end
      end
    end
  end

