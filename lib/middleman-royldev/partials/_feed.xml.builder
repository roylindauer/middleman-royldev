xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title config.site_name
  xml.subtitle config.site_description
  xml.id absolute_url(blog.options.prefix.to_s)
  xml.link "href" => config[:site_url]
  xml.link "href" => absolute_url('feed.xml'), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name config.author_name; xml.email config.author_email }

  # Add all blog articles to the feed
  blog.articles.each do |article|
    xml.entry do
      xml.title article.title != "" ? article.title : article.date.strftime("%d %B %Y %H:%M:%S")
      xml.link "rel" => "alternate", "href" => absolute_url(article.url)
      xml.id absolute_url(article.url)
      #xml.id Digest::UUID.uuid_v5(Digest::UUID::DNS_NAMESPACE, article.title)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      # xml.author { xml.name config.author_name }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html", "xml:lang" => "en"
    end
  end
end
