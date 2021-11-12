class InvoicesController < ApplicationController
  def index
    @invoices = Invoice
      .where(session_id: @session&.id)
      .left_joins(:customer, invoice_lines: :product)
      .preload(:customer, invoice_lines: :product)
      .search_by(search_params)
      .distinct
      .order(created_at: :desc)
      .paginate(pagination_params)
  end

  def show
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
end
