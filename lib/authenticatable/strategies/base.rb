# frozen_string_literal: true

module Authenticatable
  module Strategies
    class Base < ::Warden::Strategies::Base
      # Whenever CSRF cannot be verified, we turn off any kind of storage
      def store?
        false
      end
    end
  end
end
