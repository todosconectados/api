FactoryBot.define do
  sequence :unique_email do |n|
    "user_specs#{n}_#{Faker::Internet.safe_email}"
  end

  factory :user do
    name { Faker::Name.name }
    last_names { Faker::Name.last_name }
    email { generate :unique_email }
    phone { Faker::Number.number(10) }
    status { User::Status::STEP1 }
    target { User::Target::ORGANIZATION }
    industry { User::Industry::TBD }
    activation_code { Faker::Number.number(4) }
    business_name { Faker::Games::HalfLife.location }
    state { User::State::QRO }
  end
end
