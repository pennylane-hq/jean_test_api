# frozen_string_literal: true
class ProductsController < ApplicationController
  def search
    query = params['query']

    @products = Product
      .search_by([{ operator: 'search_any', value: query }])
      .paginate(pagination_params)
  end

  def show
    render 'products/_product', locals: { product: @product }
  end
end
