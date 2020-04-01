# frozen_string_literal: true

FactoryBot.define do
  factory :dialer do
    status { Dialer::Status::RESERVED }
    did { Faker::Number.number(10) }
    conference_code { Faker::Number.number(4) }
    assigned_at { Time.current }
  end
end
