# frozen_string_literal: true

require 'logger'
require 'middleman-core'
require 'middleman-blog'
require 'middleman-syntax'
require 'middleman-livereload'
require 'middleman-minify-html'
require 'middleman-imageoptim'
require 'redcarpet'

module Middleman
  class RoylDevExtension < ::Middleman::Extension
    option :name, nil, "The name of the package (e.g. 'roycom')"
    option :version, nil, 'The version of the package (e.g. 0.1.0)'
    option :markdown_engine, :redcarpet, 'Markdown engine to use'
    option :enable_image_optimization, false, 'Enable/Disable image optimization'

    option :markdown_config, {
      fenced_code_blocks: true,
      smartypants: true,
      autolink: true,
      strikethrough: true,
      highlight: true,
      footnotes: true
    }, 'Default markdown configuration'

    option :imageoptim_config, {
      manifest: true,
      skip_missing_workers: true,
      verbose: false,
      nice: true,
      threads: true,
      image_extensions: %w[.png .jpg .gif .svg],
      advpng: {level: 4},
      gifsicle: {interlace: false},
      jpegoptim: {strip: ['all'], max_quality: 65, allow_lossy: true},
      jpegtran: {copy_chunks: false, progressive: true, jpegrescan: true},
      optipng: {level: 6, interlace: false},
      pngcrush: {chunks: ['alla'], fix: false, brute: false},
      pngout: false,
      svgo: {}
    }, 'Default imageoptim configuration'

    option :minify_html_config, {
      remove_comments: true
    }, 'Default minify_html configuration'

    option :blog_config, {
      permalink: '{year}/{month}/{day}/{title}.html',
      sources: 'blog/{year}/{month}/{day}/{title}.html',
      layout: 'blog_layout',
      default_extension: '.md'
    }, 'Default blog configuration'

    option :livereload_config, {}, 'Default livereload configuration'

    def initialize(app, options_hash = {}, &block)
      super

      # Store options in local variable to access inside blocks
      extension_options = options

      # Organize assets like Rails
      app.config[:css_dir] = 'assets/stylesheets'
      app.config[:js_dir] = 'assets/javascripts'
      app.config[:images_dir] = 'assets/images'
      app.config[:fonts_dir] = 'assets/fonts'

      # Add gem's partials directory to Middleman's load paths
      app.files.watch :source,
                      path: File.expand_path('partials', __dir__),
                      prefix: 'partials'

      # Register the partials directory
      app.config[:partials_dir] = File.expand_path('partials', __dir__)

      # Add gem's layouts directory to Middleman's load paths
      # app.files.watch :source,
      #                 path: File.expand_path('../templates/layouts', __dir__),
      #                 prefix: 'layouts'

      # Set the markdown engine
      app.config[:markdown_engine] = extension_options.markdown_engine
      app.config[:markdown] = extension_options.markdown_config

      # Do not strip /index.html from directory indexes
      app.config[:strip_index_file] = false

      # Set the latest version
      app.config[:latest_version] = options.version

      # We always want relative links
      app.config[:relative_links] = true

      # Common extensions
      # Configure the development-specific environment
      app.configure :development do
        # Reload the browser automatically whenever files change
        require 'middleman-livereload'
        activate :livereload, extension_options.livereload_config
        activate :syntax
      end

      # Blog
      app.activate :blog, extension_options.blog_config

      app.configure :build do
        activate :syntax
        # app.activate :minify_css
        # app.activate :minify_javascript
        app.activate :asset_hash
        app.activate :gzip, exts: %w[.css .htm .html .js .svg .xhtml]
        app.activate :minify_html, extension_options.minify_html_config
        app.activate :imageoptim, extension_options.imageoptim_config if extension_options.enable_image_optimization
      end
    end

    def after_configuration
      # Common page configurations
      app.sitemap.resources.each do |resource|
        # Set the layout to false for common file types
        next unless resource.source_file && (
          resource.source_file.match?(/\.(xml|json|txt)$/) ||
          resource.source_file.match?(/humans\.txt/) ||
          resource.source_file.match?(/feed\.xml/)
        )

        resource.options[:layout] = false
      end
    end

    helpers do

      # Return a full absolute url.
      def absolute_url(path)
        site_url = config[:site_url] || 'http://localhost:4567'

        # Ensure the path starts with a slash and doesn't double slash
        path = "/#{path}" unless path.start_with?('/')
        path = path.squeeze('/')

        # Combine the site URL with the path
        "#{site_url}#{path}"
      end

      def button(url, additional_classes: '', &block)
        link_to url, class: "button #{additional_classes}", &block
      end

      def royldev_partial(name)
        partial name.to_s, layout: false
      end

      # Render seo meta tags
      def seo_meta(variables = {})
        variables = {
          show_humans: false,
          show_feed: false,
        }.merge(variables).dup

        partial '../partials/meta_tags', locals: variables
      end

      #
      # Generate an inline svg from the given asset name.
      #
      # @option options [String] :class
      # @option options [String] :width
      # @option options [String] :height
      #
      # @return [String]
      #
      def inline_svg(filename, options = {})
        filepath = File.join(app.root, 'source', config[:images_dir], "svg/#{filename}.svg")

        # If the file wasn't found, embed error SVG
        if File.exist?(filepath)
          file = File.read(filepath)
          doc = Nokogiri::HTML::DocumentFragment.parse(file)
          svg = doc.at_css('svg')

          if options[:class].present?
            svg['class'] = options[:class]
          end

          if options[:width].present?
            svg['width'] = options[:width]
          end

          if options[:height].present?
            svg['height'] = options[:height]
          end

          doc
        else

          %(
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 30"
            width="400px" height="30px"
          >
            <text font-size="16" x="8" y="20" fill="#cc0000">
              Error: '#{filename}' could not be found.
            </text>
            <rect
              x="1" y="1" width="398" height="28" fill="none"
              stroke-width="1" stroke="#cc0000"
            />
          </svg>
        )
        end

      end

    end
  end
end
