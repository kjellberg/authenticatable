# frozen_string_literal: true

module Authenticatable
  # Makes Authenticatable available to Rails on initializing by injecting the
  # Authenticatable manager into Rack middlewares.
  class Engine < ::Rails::Engine
    # config.app_middleware.use(Authenticatable::Manager)

    initializer "authenticatable.setup" do
      # Make authenticatable helpers available on controllers.
      # ActionController::Base.include Authenticatable::Mixins::Controller

      # Make authenticatable method available on models.
      ActiveRecord::Base.include Authenticatable::Models
    end
  end
end
