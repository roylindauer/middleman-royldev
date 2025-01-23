# frozen_string_literal: true

module Middlecore
  module Helpers
    def button(url, additional_classes: "", &block)
      link_to url, class: "button #{additional_classes}", &block
    end

    def middlecore_partial(name)
        partial name.to_s, layout: false
      end

      def seo_og_tags(og_data: {})
        og_data = {} if og_data.nil?
        og_data[:url] = URI.join(config[:host], current_page.url)
        og_data[:type] = "website" unless og_data[:type].present?
        og_data[:description] = config[:site_description] unless og_data[:description].present?
        og_data[:keywords] = config[:site_keywords] unless og_data[:keywords].present?
        og_data[:image] = url_for(URI.join(config[:host], image_path(config[:og_image]))) unless og_data[:image].present?
        o = []
        unless og_data.empty?
          og_data.each do | k, v |
            o << tag(:meta, property: "og:#{k}", content: v)
          end
          o.join("\n")
        end
      end

      def seo_meta_tags
        middlecore_partial "meta_tags"
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
        filepath = File.join(app.root, "source", config[:images_dir], "svg/#{filename}.svg")

        # If the file wasn't found, embed error SVG
        if File.exist?(filepath)
          file = File.read(filepath)
          doc = Nokogiri::HTML::DocumentFragment.parse(file)
          svg = doc.at_css("svg")

          if options[:class].present?
            svg["class"] = options[:class]
          end

          if options[:width].present?
            svg["width"] = options[:width]
          end

          if options[:height].present?
            svg["height"] = options[:height]
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
