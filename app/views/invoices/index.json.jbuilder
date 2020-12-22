json.invoices do
  json.array! @invoices, partial: 'invoices/invoice', as: :invoice
end

json.partial! 'pagination', locals: { elements: @invoices }
