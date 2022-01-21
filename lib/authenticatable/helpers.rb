# frozen_string_literal: true

require "active_support/concern"

module Authenticatable
  module Helpers
    extend ActiveSupport::Concern

    class << self
      # Dynamically define helpers methods for the given scope
      # For example, current_user, authenticate_user! and user_signed_in? will
      # be generated for an authenticatable User model.
      def define_helpers(scope)
        scope = scope.to_s

        define_current_helpers(scope)
        define_signed_in_helpers(scope)

        # Make current_{scope} and {scope}_signed_in? available as helpers in views.
        ActiveSupport.on_load(:action_controller) do
          helpers = "current_#{scope}", "#{scope}_signed_in?"
          helper_method helpers if respond_to?(:helper_method)
        end
      end

      # Access the currently logged in user.
      # Note: We use Warden's #authenticate instead of #user so that we can access
      # the current user on each request with auth methods like JWT tokens or API keys.
      # :api: public
      def define_current_helpers(scope)
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
          # def current_user
          #   @current_user ||= warden.authenticate scope: :user
          # end
          def current_#{scope}
            @current_#{scope} ||= warden.authenticate scope: :#{scope}
          end
        METHOD
      end

      # Check if there's a logged in user or not.
      # :api: public
      def define_signed_in_helpers(scope)
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
          # def user_signed_in?
          #   !!current_user
          # end
          def #{scope}_signed_in?
            !!current_#{scope}
          end
        METHOD
      end
    end

    # Signs in the given resources.
    # :api: public
    def sign_in!(resource)
      scope = resource.class.to_scope
      warden.set_user resource, scope: scope
    end

    # Sign out the current user
    # :api: public
    def sign_out!(scope = nil)
      if scope
        warden.logout(scope)
        warden.clear_strategies_cache!(scope: scope)
      else
        warden.logout
        warden.clear_strategies_cache!
      end
    end

    # Access the Warden object
    # :api: public
    def warden
      request.env["warden"]
    end
  end
end
