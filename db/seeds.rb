# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(20 - Customer.count).times do
  Customer.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.street_address,
    zip_code: Faker::Address.zip_code,
    city: Faker::Address.city,
    country_code: Faker::Address.country_code,
  )
end

(10 - Product.count).times do
  Product.create!(
    label: Faker::Vehicle.make_and_model,
    unit: Product.units.keys.sample,
    unit_price: (Random.rand(8_000 .. 30_000) / 5) * 5,
    vat_rate: Product.vat_rates.keys.sample,
  )
end

invoice_count = Invoice.group(:session_id).count
Session.all.each do |session|
  (15 - invoice_count[session].to_i).times do
    date = Date.current + Random.rand(-10..30).days
    Invoice.create!(
      session_id: session.id,
      customer: Customer.all.sample,
      finalized: Random.rand(1..6) == 1,
      date: date,
      deadline: date + Random.rand(10..30).days,
      invoice_lines_attributes: Random.rand(1..3).times.map do
        product = Product.all.sample
        quantity = Random.rand(1..7)
        {
          product_id: product.id,
          quantity: quantity,
          unit: product.unit,
          label: product.label,
          vat_rate: product.vat_rate,
          price: product.unit_price * quantity,
        }
      end,
    )
  end
end
