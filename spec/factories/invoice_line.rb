FactoryBot.define do
  factory :invoice_line do
    invoice
    product
    label { product.label }
    quantity { 1 }
    unit { product.unit }
    price { product.unit_price }
    vat_rate { product.vat_rate }
  end
end
