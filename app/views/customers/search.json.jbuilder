json.customers do
  json.array! @customers, partial: 'customers/customer', as: :customer
end

json.partial! 'pagination', locals: { elements: @customers }
