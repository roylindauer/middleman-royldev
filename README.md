# ROYL Development Middleman Common Configuration

A set of common configurations for Middleman.

## Installation

Add this line to your Gemfile:

```ruby
gem 'middleman-royldev', git: "https://github.com/roylindauer/middleman-royldev.git"
```

then run `bundle`


## Usage

Generate a new site as per the Middleman instructions. Then add the following to config.rb:

```ruby
require 'middleman-royldev'

activate :royldev do | royldev |
  royldev.name = "websitename"
  
  royldev.markdown_engine = :redcarpet
  royldev.markdown_config = {
    fenced_code_blocks: true,
    smartypants: true,
    autolink: true,
    strikethrough: true,
    highlight: true,
    footnotes: true
  }

  royldev.blog_config = {
    sources: "content/{year}/{month}/{day}/{title}.html",
    layout: "post",
  }

  royldev.minify_html_config = {
    remove_comments: true
  }
end
```

### Defaults 

* Syntax highlighting is automatically enabled 
* Assets are organized like rails:
  * `assets/fonts`
  * `assets/images`
  * `assets/javascripts`
  * `assets/stylesheets`
* HTML minification is enabled
* Live reload is enabled for development
* GZipped assets are created during build


This package includes a default feed and sitemap xml templates. 

To use them create `feed.xml.builder` in your source directory with the contents: 

```ruby
xml.instruct!
xml << roydev_partial("feed.xml")
```

and `sitemap.xml.builder` 

```ruby
xml.instruct!
xml << royldev_partial("sitemap.xml")
```

### Helpers

**seo_og_tags** Render Open Graph Tags

Pass in an object containing the tags and values you want.

By default will render 

* `og:url` from the current page url 
* `og:type` as "website"
* `og:description` if `site_description` is defined in the site config 
* `og:keywords` if `site_keywords` is defined in the site config 
* `og:image` if `og_image` is defined in the site config 

```ruby
<%= seo_og_tags og_data: current_page&.data&.open_graph_tags %>
```

**seo_meta_tags** Render common meta tags 

* title 
* description 
* keywords 
* link to humans.txt 
* link to RSS feed 

**inline_svg** render an svg from a file under `assets/images/svgs`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/roylindauer/middleman-royldev. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/roylindauer/middleman-royldev/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `middleman-royldev` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/roylindauer/middleman-royldev/blob/main/CODE_OF_CONDUCT.md).
