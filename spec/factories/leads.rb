FactoryBot.define do
  factory :lead do
    name { Faker::Name.name }
    company_name { Faker::Book.publisher }
    email { generate :unique_email }
    phone { Faker::Number.number(10) }
    comments { Faker::Games::WorldOfWarcraft.quote }
  end
end
