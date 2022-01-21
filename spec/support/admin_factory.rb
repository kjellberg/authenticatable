# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { "#{Faker::Internet.unique.user_name}@admin.com" }
  end
end
