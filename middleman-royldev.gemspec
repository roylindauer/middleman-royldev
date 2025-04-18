# frozen_string_literal: true

require_relative "lib/middleman-royldev/version"

Gem::Specification.new do |spec|
  spec.name = "middleman-royldev"
  spec.version = Middleman::RoylDev::VERSION
  spec.authors = ["Roy Lindauer"]
  spec.email = ["roy@royldevelopment.com"]

  spec.summary = "Common functionality for ROYL Development Middleman sites"
  spec.description = "Defines defaults and provides helpers for middleman sites"
  spec.homepage = "https://github.com/roylindauer/middleman-royldev"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/roylindauer/middleman-royldev"
  spec.metadata["changelog_uri"] = "https://github.com/roylindauer/middleman-royldev/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = []
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "middleman", "~> 4.6"
  spec.add_dependency "middleman-livereload", "~> 3"
  spec.add_dependency "middleman-syntax", "~> 3"
  spec.add_dependency "middleman-minify-html", "~> 3"
  spec.add_dependency "middleman-imageoptim", "~> 0.3"
  spec.add_dependency "middleman-autoprefixer", "~> 3"
  spec.add_dependency "middleman-blog", "~> 4"
  spec.add_dependency "image_optim", "~> 0.25"
  spec.add_dependency "image_optim_pack", "~> 0.2.1"
  spec.add_dependency "redcarpet", "~> 3.5"
  spec.add_dependency "rouge", "~> 3.30"
  spec.add_dependency "nokogiri", "~> 1.13"
  spec.add_dependency "execjs", "~> 2.8.1"
  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "builder", "~> 3.2"
  spec.add_dependency "haml", "~> 4.0"
  spec.add_dependency "coffee-script", "~> 2.2"
  spec.add_dependency "kramdown", "~> 2.3"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
