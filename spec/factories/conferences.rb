FactoryBot.define do
  factory :conference do
    dialer
    started_at { Time.current }
    ended_at { Time.current.advance(minutes: 5) }
    pbx_id { Faker::Number.number(4) }
  end
end
