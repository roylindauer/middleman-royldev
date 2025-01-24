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

`#seo_meta`

Render common seo meta tags and links. This will create open graph tags, social tags, meta tags, and links to feed and humans files.

```ruby
seo_meta({
  title: current_page.data.seo_title || current_page.data.title, 
  description: current_page.data.seo_description || config[:site_description],
  keywords: current_page.data.seo_keywords || config[:site_keywords],
  show_humans: true,
  show_feed: true,
  fediverse_creator: "@r1y@ruby.social",
  image: absolute_url(image_path(config[:og_image])),
})
```

`#inline_svg`

Render an svg from a file under `assets/images/svgs`

eg we have an svg called `logo.svg`:

```ruby
inline_svg "logo", class: "", width: "100%", height: "100%"
```

`#absolute_url`

Returns a full absolute URL. Define `config[:site_url]` in `config.rb`. Site url defaults to dev url `http://localhost:4567`

```ruby
# config.rb
configure :build do
  config[:site_url] = "https://www.example.org"
end

# in your templates
absolute_url(image_path(config[:og_image])) # returns eg: https://www.example.org/assets/images/og_image.png
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/roylindauer/middleman-royldev. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/roylindauer/middleman-royldev/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `middleman-royldev` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/roylindauer/middleman-royldev/blob/main/CODE_OF_CONDUCT.md).
