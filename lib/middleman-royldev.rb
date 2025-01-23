# frozen_string_literal: true

require "logger"
require "middleman-core"

require_relative "middleman-royldev/extension"

::Middleman::Extensions.register :royldev, ::Middleman::RoylDevExtension
