# frozen_string_literal: true

require "logger"
require "middleman-core"
require "middleman-blog"
require "middleman-syntax"
require "middleman-livereload"
require "middleman-minify-html"
require "middleman-imageoptim"
require "redcarpet"

require_relative "middlecore/version"
require_relative "middlecore/config"
require_relative "middlecore/helpers"
require_relative "middlecore/extension"

module Middlecore
  class Error < StandardError; end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end

::Middleman::Extensions.register(:middlecore) do
  ::Middlecore::Extension
end
