json.extract! invoice,
  :id,
  :customer_id,
  :finalized,
  :paid,
  :date,
  :deadline,
  :total,
  :tax

json.customer invoice.customer, partial: 'customers/customer', as: :customer

json.invoice_lines do
  json.array! invoice.invoice_lines, partial: 'invoice_lines/invoice_line', as: :invoice_line
end
