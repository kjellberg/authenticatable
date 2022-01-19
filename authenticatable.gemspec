# frozen_string_literal: true

require_relative "lib/authenticatable/version"

Gem::Specification.new do |spec|
  spec.name        = "authenticatable"
  spec.version     = Authenticatable::VERSION
  spec.authors     = "KIQR"
  spec.email       = "hello@kiqr.dev"
  spec.homepage    = "https://github.com/kiqr/authenticatable"
  spec.summary     = "Authentication solution for Ruby on Rails"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 2.6"

  spec.files = Dir["{lib}/**/*", "LICENSE.md", "README.md"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/kiqr/authenticatable/issues",
    "documentation_uri" => "https://github.com/kiqr/authenticatable/issues",
    "source_code_uri" => "https://github.com/kiqr/authenticatable",
    "rubygems_mfa_required" => "true"
  }

  spec.add_dependency "dry-configurable", "~> 0.11.0"
  spec.add_dependency "warden", "~> 1.2"

  # spec.add_dependency "bcrypt", "~> 3.1.16"
end
