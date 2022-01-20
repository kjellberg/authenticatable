# frozen_string_literal: true

require "spec_helper"

class MockController < ApplicationController
  include Authenticatable::Helpers
  attr_accessor :env

  def request
    self
  end
end

module Authenticatable
  describe Helpers, type: :request do
    include Warden::Test::Helpers
    let(:user) { create(:user) }

    describe "generates scopes helper methods" do
      it { expect(MockController.instance_methods).to include :current_user, :user_signed_in? }
      it { expect(MockController.instance_methods).to include :sign_in!, :sign_out! }
    end

    describe "#current_user", type: :request do
      before { get "/" }

      it { expect(@controller.current_user).to be nil }

      it "does return the logged in user" do
        @controller.warden.set_user user, scope: :user
        expect(@controller.current_user).to be user
      end

      it "does not return a user after signing out" do
        @controller.warden.set_user user, scope: :user
        @controller.sign_out!
        expect(@controller.current_user).to be nil
      end
    end

    describe "#user_signed_in?", type: :request do
      before { get "/" }

      it { expect(@controller.user_signed_in?).to be false }

      it "does return the logged in user" do
        @controller.warden.set_user user, scope: :user
        expect(@controller.user_signed_in?).to be true
      end

      it "does return false signing out" do
        @controller.warden.set_user user, scope: :user
        @controller.sign_out!
        expect(@controller.user_signed_in?).to be false
      end
    end

    describe "#sign_in!", type: :request do
      before { get "/" }

      it "can sign in a user from resource" do
        @controller.sign_in! user
        expect(@controller.warden.user(scope: :user)).to be user
      end
    end

    describe "#sign_out!", type: :request do
      before { get "/" }

      it "can logout all users" do
        @controller.warden.set_user user, scope: :user
        @controller.sign_out!
        expect(@controller.user_signed_in?).to be false
      end

      it "can logout by scope" do
        @controller.warden.set_user user, scope: :user
        @controller.sign_out! :user
        expect(@controller.user_signed_in?).to be false
      end
    end
  end
end
