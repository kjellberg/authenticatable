# frozen_string_literal: true

require "warden"

module Authenticatable
  # Makes Authenticatable available to Rails on initializing by injecting the
  # Authenticatable manager into Rack middlewares.
  class Engine < ::Rails::Engine
    config.app_middleware.use Warden::Manager do |manager|
      manager.failure_app = proc do |_env|
        ["401", { "Content-Type" => "application/json" }, { error: "Unauthorized", code: 401 }]
      end
      manager.default_strategies :password # needs to be defined
    end

    initializer "authenticatable.setup" do
      config.autoload_paths += %W[#{Authenticatable::Engine.root}/lib/authenticatable]

      # Make authenticatable helpers available on controllers.
      ActionController::Base.include Authenticatable::Helpers

      # Register pre defined scopes and generate helpers like user_signed_in? and current_user for the model.
      Authenticatable.config.scopes.each { |scope| Authenticatable::Helpers.define_helpers scope }

      # Make authenticatable method available on models.
      ActiveRecord::Base.include Authenticatable::Models
    end
  end
end
