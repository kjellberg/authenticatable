# frozen_string_literal: true

require "active_support/concern"

module Authenticatable
  module Helpers
    extend ActiveSupport::Concern

    # Access the currently logged in user.
    # Use Warden's #authenticate instead of #user so that we can access the
    # current user on each request with auth methods JWT tokens or API keys.
    # :api: public
    def current_user
      @current_user ||= warden.authenticate scope: :user
    end

    # Check if there's a logged in user or not.
    # :api: public
    def user_signed_in?
      !!current_user
    end

    # Signs in the given resources.
    # :api: public
    def sign_in!(resource)
      warden.set_user resource, scope: :user
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
