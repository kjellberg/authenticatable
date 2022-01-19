# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{Faker::Internet.unique.user_name}@mail.com" }
  end
end
