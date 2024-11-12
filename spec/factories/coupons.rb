FactoryBot.define do
  factory :coupon do
    name { Faker::Name.first_name }
    code { Faker::Code.asin }
    value { Faker::Number.decimal(l_digits: 2) }
    active { 0 }
    merchant

    trait :bogo50 do
      name { "Buy One Get One 50" }
      code { "BOGO50" }
      value { 50 }  
    end
  end
end