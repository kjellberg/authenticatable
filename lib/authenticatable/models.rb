# frozen_string_literal: true

require "active_support/concern"

module Authenticatable
  module Models
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :authenticatable_extensions, :authenticatable_loaded_extensions

      # Enables authenticatable for a model.
      # :api: public
      def authenticatable(*extensions)
        opts = extensions.extract_options!

        # Add default extensions to class variable @authenticatable_extensions. These are added to a global accessible
        # class var, so that we can access them from other places, like in extensions, views or controllers.
        @authenticatable_extensions = (Authenticatable.config.default_extensions + extensions).uniq

        # We'll add extensions here while they loaded. Can be useful for debugging
        @authenticatable_loaded_extensions = []

        # Remove extensions that are specified in the :skip attribute from the @authenticatable_extensions
        # array. This can be useful if you for example want to disable any of the default extensions.
        opts[:skip] = [opts[:skip]].flatten
        opts[:skip].each { |s| @authenticatable_extensions.delete(s) } if opts[:skip].present?

        # Load extensions into model
        load_model_extensions
      end

      # Returns a symbol representing this model.
      # :api: public
      def to_scope
        name.demodulize.underscore.to_sym
      end

      private

      # Loads extension concerns/mixins into the model class if it can find a module with
      # the classified extension name in the Authenticatable::Models namespace.
      #
      # Example:
      #   authenticatable extensions: { :email_validator }
      # will include a module with name (if it exists):
      #   Authenticatable::Models::EmailValidator
      #
      def load_model_extensions
        @authenticatable_extensions.each do |extension|
          module_name = "Authenticatable::Mixins::#{extension.to_s.classify}"
          next unless const_defined?(module_name)

          extension_module = const_get(module_name)
          include extension_module
          @authenticatable_loaded_extensions << module_name
        end
      end
    end
  end
end
