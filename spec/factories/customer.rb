FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    country_code { Faker::Address.country_code }
  end
end
