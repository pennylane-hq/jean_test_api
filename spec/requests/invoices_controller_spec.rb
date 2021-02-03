require 'rails_helper'

describe InvoicesController do
  describe '#index' do
    let!(:invoices) do
      (0..10).map do |i|
        create(
          :invoice,
          customer: build(:customer, first_name: "#{i}"),
          invoice_lines: [
            build(:invoice_line, label: "#{2 * i}"),
            build(:invoice_line, label: "#{2 * i + 1}"),
          ],
        )
      end
    end

    describe 'searching by customer' do
      it 'works' do
        get '/invoices', params: { search: [{
          field: 'customer.first_name',
          operator: 'search',
          value: '2',
        }].to_json }
        expect(response.status).to eq 200

        expect(response.parsed[:invoices].map { _1[:id] }).to eq [invoices[2].id]
      end

      it 'works with the customer_id' do
        get '/invoices', params: { search: [{
          field: 'customer_id',
          operator: 'eq',
          value: invoices[0].customer.id,
        }].to_json }
        expect(response.status).to eq 200

        expect(response.parsed[:invoices].map { _1[:id] }).to eq [invoices[0].id]
      end
    end

    describe 'search_any' do
      it 'works' do
        get '/invoices', params: { search: [{
          operator: 'search_any',
          value: '2'
        }].to_json }
        expect(response.status).to eq 200

        ids = response.parsed[:invoices].map { _1[:id] }
        # 4 results:
        # invoices[1] matches for invoice_line label 2
        # invoices[2] matches for customer first_name
        # invoices[6] matches for invoice_line label 12
        # invoices[10] matches for invoice_line label 20 and 21
        expect(ids.sort).to eq [invoices[1], invoices[2], invoices[6], invoices[10]].map(&:id)
      end
    end

    describe 'searching by customer_id' do
      it 'works with eq operator' do
        invoice2 = create(:invoice, customer_id: invoices[0].customer_id)

        get '/invoices', params: { search: [{
          field: 'customer_id',
          operator: 'eq',
          value: invoice2.customer_id,
        }].to_json }
        expect(response.status).to eq 200

        ids = response.parsed[:invoices].map { _1[:id] }
        expect(ids.sort).to eq [invoices[0], invoice2].map(&:id)
      end

      it 'works with in operator' do
        get '/invoices', params: { search: [{
          field: 'customer_id',
          operator: 'in',
          value: invoices[0..2].map(&:customer_id),
        }].to_json }
        expect(response.status).to eq 200

        ids = response.parsed[:invoices].map { _1[:id] }
        expect(ids.sort).to eq invoices[0..2].map(&:id)
      end
    end
  end

  describe '#update' do
    let(:invoice) { create(:invoice, invoice_lines: [build(:invoice_line)]) }

    describe 'destroying an invoice_line' do
      it 'works properly' do
        put "/invoices/#{invoice.id}", params: { invoice: {
          invoice_lines_attributes: [{
            id: invoice.invoice_lines[0].id,
            _destroy: true
          }]
        }}
        expect(response.status).to eq 200

        expect(invoice.reload.invoice_lines.size).to eq 0
      end
    end

    describe 'updating an invoice_line' do
      it 'works properly' do
        line = invoice.invoice_lines.first
        put "/invoices/#{invoice.id}", params: { invoice: {
          invoice_lines_attributes: [{
            id: invoice.invoice_lines[0].id,
            quantity: line.quantity + 1
          }]
        }}
        expect(response.status).to eq 200

        expect(invoice.reload.invoice_lines.first.quantity).to eq(line.quantity + 1)
      end
    end

    describe 'adding a new invoice_line' do
      it 'works properly' do
        line_count = invoice.invoice_lines.size

        put "/invoices/#{invoice.id}", params: { invoice: {
          invoice_lines_attributes: [{
            product_id: Product.take.id,
            label: 'New line',
            quantity: 1,
            unit: 'piece',
            vat_rate: '20',
            price: 100,
          }]
        }}
        expect(response.status).to eq 200

        expect(invoice.reload.invoice_lines.size).to eq(line_count + 1)
      end
    end
  end

  describe 'creating an invoice' do
    let(:customer) { create(:customer) }
    let(:product) { create(:product) }

    it 'works properly with only a customer' do
      post '/invoices', params: { invoice: {
        customer_id: customer.id,
      }}

      expect(response.status).to eq 200
    end

    it 'works properly when adding all information' do
      post '/invoices', params: { invoice: {
        customer_id: customer.id,
        finalized: false,
        paid: false,
        date: Date.current,
        deadline: Date.current + 30.days,
        invoice_lines_attributes: [{
          product_id: product.id,
          quantity: 1,
          unit: :piece,
          label: 'Produit',
          vat_rate: '20',
          price: 120,
          tax: 20,
        }]
      }}

      expect(response.status).to eq 200
      id = response.parsed[:id]

      invoice = Invoice.find(id)
      expect(invoice.customer_id).to eq customer.id
      expect(invoice.invoice_lines.size).to eq 1
      expect(invoice.invoice_lines.first.product_id).to eq product.id
    end
  end

  describe 'destroying an invoice' do
    let(:invoice) { create(:invoice) }

    it 'works properly' do
      delete "/invoices/#{invoice.id}"
      expect(response.status).to eq 204

      expect(Invoice.find_by(id: invoice.id)).to eq nil
    end

    it 'shows error when applicable' do
      invoice.update!(finalized: true)

      delete "/invoices/#{invoice.id}"
      expect(response.status).to eq 422
      expect(response.parsed[:message]).to eq 'Une facture finalisée ne peut pas être supprimée'

      expect(Invoice.find_by(id: invoice.id)).not_to eq nil
    end
  end
end
