class CustomersController < ApplicationController
  api!
  def search
    query = params['query']

    @customers = Customer
      .search_by([{ operator: 'search_any', value: query }])
      .paginate(pagination_params)
  end

  def show
    render 'customers/_customer', locals: { customer: @customer }
  end
end
