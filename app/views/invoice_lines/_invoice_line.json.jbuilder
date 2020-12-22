json.extract! invoice_line,
  :id,
  :invoice_id,
  :product_id,
  :quantity,
  :unit,
  :label,
  :vat_rate,
  :price,
  :tax

json.product invoice_line.product, partial: 'products/product', as: :product
