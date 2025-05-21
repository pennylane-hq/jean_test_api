# frozen_string_literal: true
class InvoicesController < ApplicationController
  ALLOWED_SORT_COLUMNS = %w[created_at updated_at customer_id date deadline total paid finalized id tax].freeze

  def index
    @invoices = Invoice
      .where(session_id: @session&.id)
      .left_joins(:customer, invoice_lines: :product)
      .preload(:customer, invoice_lines: :product)
      .search_by(search_params)
      .distinct
      .order(*sort_params)
      .paginate(pagination_params)
  end

  def show
    ActiveRecord::Associations::Preloader.new(
      records: [@invoice],
      associations: [invoice_lines: :product],
    ).call

    render 'invoices/_invoice', locals: { invoice: @invoice }
  end

  def update

    @invoice.update!(invoice_params)

    render 'invoices/_invoice', locals: { invoice: @invoice }
  end

  def create
    @invoice = Invoice.create!(invoice_params)

    render 'invoices/_invoice', locals: { invoice: @invoice }
  end

  def destroy
    @invoice.destroy!

    head :no_content
  end

  private

  def invoice_params
    result = params.require(:invoice)
      .permit(
        :customer_id,
        :finalized,
        :paid,
        :date,
        :deadline,
        invoice_lines_attributes: %i[
          id
          product_id
          quantity
          unit
          label
          vat_rate
          price
          _destroy
        ],
      )
    result[:session_id] = @session.id unless Rails.env.test?
    result
  end

  def sort_params
    return [{ created_at: :desc }] unless params[:sort].present?

    valid_sorts = params[:sort].split(',').filter_map do |sort_param|
      sort_param = sort_param.strip
      direction = sort_param.start_with?('-') ? :desc : :asc
      column = sort_param.gsub(/^[+-]/, '').strip

      next unless ALLOWED_SORT_COLUMNS.include?(column)

      { column => direction }
    end

    valid_sorts.empty? ? [{ created_at: :desc }] : valid_sorts
  end
end
