# frozen_string_literal: true

require "spec_helper"

module Authenticatable
  describe Helpers, type: :request do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    describe "generates scopes helper methods" do
      it { expect(ApplicationController.instance_methods).to include :current_user, :user_signed_in? }
      it { expect(ApplicationController.instance_methods).to include :current_admin, :admin_signed_in? }
      it { expect(ApplicationController.instance_methods).to include :sign_in!, :sign_out! }
    end

    describe "#current_{scope}", type: :request do
      before { get "/" }

      it { expect(@controller.current_user).to be nil }

      it "does return a logged in user" do
        @controller.warden.set_user user, scope: :user
        expect(@controller.current_user).to be user
      end

      it "does return a logged in admin" do
        @controller.warden.set_user admin, scope: :admin
        expect(@controller.current_admin).to be admin
      end

      it "runs authenticate on Warden" do
        allow(@controller.warden).to receive(:authenticate)
        @controller.current_user
        expect(@controller.warden).to have_received(:authenticate).with(scope: :user)
      end

      it "runs authenticate on Warden with correct scope" do
        allow(@controller.warden).to receive(:authenticate)
        @controller.current_admin
        expect(@controller.warden).to have_received(:authenticate).with(scope: :admin)
      end
    end

    describe "{scope}_signed_in?", type: :request do
      before { get "/" }

      it { expect(@controller.user_signed_in?).to be false }

      it "does find that user is logged in" do
        @controller.warden.set_user user, scope: :user
        expect(@controller.user_signed_in?).to be true
      end

      it "does find that admin is logged in" do
        @controller.warden.set_user admin, scope: :admin
        expect(@controller.admin_signed_in?).to be true
      end

      context "when handling multiple scopes" do
        before do
          @controller.warden.set_user admin, scope: :admin
        end

        it { expect(@controller.user_signed_in?).to be false }
        it { expect(@controller.admin_signed_in?).to be true }
      end
    end

    describe "#sign_in!", type: :request do
      before { get "/" }

      it "can sign in a user from resource" do
        @controller.sign_in! user
        expect(@controller.warden.user(scope: :user)).to be user
      end

      it "can sign in an admin from resource" do
        @controller.sign_in! admin
        expect(@controller.warden.user(scope: :admin)).to be admin
      end

      context "when signing in multiple scopes" do
        before do
          @controller.warden.set_user user, scope: :user
          @controller.warden.set_user admin, scope: :admin
        end

        it { expect(@controller.warden.user(scope: :user)).to be user }
        it { expect(@controller.warden.user(scope: :admin)).to be admin }
      end
    end

    describe "#sign_out!", type: :request do
      before { get "/" }

      context "when logging out all scopes" do
        before do
          @controller.warden.set_user user, scope: :user
          @controller.warden.set_user admin, scope: :admin
          @controller.sign_out!
        end

        it { expect(@controller.warden.authenticated?(:user)).to be false }
        it { expect(@controller.warden.authenticated?(:admin)).to be false }
      end

      context "when logging out a specific scope" do
        before do
          @controller.warden.set_user user, scope: :user
          @controller.warden.set_user admin, scope: :admin
          @controller.sign_out! :admin
        end

        it { expect(@controller.warden.authenticated?(:user)).to be true }
        it { expect(@controller.warden.authenticated?(:admin)).to be false }
      end
    end
  end
end
