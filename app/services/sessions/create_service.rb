# frozen_string_literal: true

module Sessions
  class CreateService
    INVOICE_COUNT = 15

    def self.call(name)
      new(name).send(:call)
    end

    private

    def initialize(name)
      @name = name
    end

    def call
      ActiveRecord::Base.transaction do
        create_session!
        create_invoices!
        @session
      end
    end

    def create_session!
      @session = Session.create!(name: @name, token: SecureRandom.uuid)
    end

    def create_invoices!
      invoices = (1..INVOICE_COUNT).map do
        date = Date.current + Random.rand(-10..30).days

        Invoice.new(
          session_id: @session.id,
          customer: customers.sample,
          finalized: Random.rand(1..6) == 1,
          date: date,
          deadline: date + Random.rand(10..30).days,
          invoice_lines_attributes: Random.rand(1..3).times.map do
            product = products.sample
            quantity = Random.rand(1..7)
            {
              product_id: product.id,
              quantity: quantity,
              unit: product.unit,
              label: product.label,
              vat_rate: product.vat_rate,
              price: product.unit_price * quantity,
              tax: product.unit_price * quantity * product.vat_rate.to_i / 100
            }
          end
        )
      end

      Invoice.import!(invoices, recursive: true)
    end

    def customers
      @customers ||= Customer.all
    end

    def products
      @products ||= Product.all
    end
  end
end
