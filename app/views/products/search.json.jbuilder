json.products do
  json.array! @products, partial: 'products/product', as: :product
end

json.partial! 'pagination', locals: { elements: @products }
