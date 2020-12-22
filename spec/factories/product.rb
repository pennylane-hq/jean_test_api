FactoryBot.define do
  factory :product do
    label { Faker::Vehicle.make_and_model }
    unit { Product.units.keys.sample }
    unit_price { (Random.rand(8_000 .. 30_000) / 5) * 5 }
    vat_rate { Product.vat_rates.keys.sample }
  end
end
