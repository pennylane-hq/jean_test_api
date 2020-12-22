json.pagination do
  json.page elements.current_page
  json.page_size elements.per_page
  json.total_pages elements.total_pages
  json.total_entries elements.total_entries
end
