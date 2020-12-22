require 'rails_helper'

describe Invoice do
  describe 'validation when finalized' do
    let(:invoice) { create(:invoice, invoice_lines: [build(:invoice_line)]) }
    let!(:invoice_line) { invoice.invoice_lines[0] }

    before { invoice.update!(finalized: true) }

    it 'allows changing paid status' do
      expect { invoice.update!(paid: !invoice.paid) }.not_to raise_error
    end

    it 'fails if changing date' do
      expect { invoice.update!(date: invoice.date + 1.day) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails if changing finalized' do
      expect { invoice.update!(finalized: false) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails if adding an invoice_line' do
      expect do
        invoice.update!(invoice_lines_attributes: [build(:invoice_line).as_json])
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails if removing an invoice_line' do
      expect do
        invoice.update!(invoice_lines_attributes:
          [{ id: invoice_line.id, invoice_id: invoice.id, _destroy: true }]
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails if changing an invoice_line' do
      expect do
        invoice.update!(invoice_lines_attributes:
          [{ id: invoice_line.id, price: invoice_line.price + 1 }]
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'searching by label' do
    it 'looks properly in invoice_lines' do
      invoices = (0..10).map do |i|
        create(
          :invoice,
          invoice_lines: [
            build(:invoice_line, label: "#{2 * i}"),
            build(:invoice_line, label: "#{2 * i + 1}"),
          ],
        )
      end

      result = Invoice
        .joins(:invoice_lines)
        .search_by([{ field: 'invoice_lines.label', operator: 'search', value: '12' }])
      expect(result.map(&:id)).to eq [invoices[6].id]
    end
  end
end
