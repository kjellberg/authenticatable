# frozen_string_literal: true

require "authenticatable/engine"

require "dry-configurable"
require "warden"

# Authenticatable is an authentication solution for Rails. All related modules,
# classes and methods will be namespaced under the namespace 'Authenticatable':
module Authenticatable
  extend Dry::Configurable

  autoload :Helpers, "authenticatable/helpers"
  autoload :Models, "authenticatable/models"

  module Strategies
    autoload :Base, "authenticatable/strategies/base"
    autoload :Password, "authenticatable/strategies/password"
  end

  # List of authenticatable model scopes for generation of helpers and strategies.
  setting :scopes, %i[user admin]

  # Default extensions to load into your authenticatable models. Feel free to develop
  # add publish your own extensions online. We'd be happy to see what you can accomplish.
  setting :default_extensions, %i[]

  # Range validation for password length
  setting :password_length, 6..128

  class << self
    # Reset Authenticatable configurations to default values.
    def reset_default_values!
      remove_instance_variable :@config
    end
  end
end

module Warden
  class SessionSerializer
    def serialize(user)
      [user.class.name, user.id]
    end

    def deserialize(key)
      klass, id = key
      klass = case klass
              when Class
                klass
              when String, Symbol
                klass.to_s.classify.constantize
              end
      klass.find_by(id: id)
    end
  end
end

# Register Warden strategies.
Warden::Strategies.add(:password, Authenticatable::Strategies::Password)
