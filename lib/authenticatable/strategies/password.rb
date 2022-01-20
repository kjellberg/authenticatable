# frozen_string_literal: true

module Authenticatable
  module Strategies
    class Password < Authenticatable::Strategies::Base
      def valid?
        params[:email].present? && params[:password].present?
      end

      def authenticate!
        # user = User.find_by(email: params[:email])
        # if user&.authenticate(params[:password])
        #   success!(user)
        # else
        #   fail!("Could not log in")
        # end
      end
    end
  end
end
