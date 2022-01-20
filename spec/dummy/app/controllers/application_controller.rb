# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticatable::Helpers

  def home
    render html: "", status: :ok
  end
end
