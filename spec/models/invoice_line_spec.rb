require 'rails_helper'

describe InvoiceLine do
  describe 'associations' do
    it { should belong_to(:invoice) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
  end

  describe 'price calculations' do
    let(:invoice_line) { create(:invoice_line, price: 120, vat_rate: :'20') }

    it 'computes price without tax correctly' do
      expect(invoice_line.price_without_tax).to eq(100.00)
    end

    it 'computes tax amount correctly' do
      invoice_line.compute_tax
      expect(invoice_line.tax).to eq(20.00)
    end
  end

  describe 'product values inheritance' do
    let(:product) { create(:product, unit: :piece, vat_rate: :'20', unit_price: 100, label: 'Test Product') }
    let(:invoice_line) { build(:invoice_line, product: product) }

    it 'inherits values from product before validation' do
      invoice_line.valid?
      expect(invoice_line.unit).to eq('piece')
      expect(invoice_line.vat_rate).to eq('20')
      expect(invoice_line.price).to eq(100)
      expect(invoice_line.label).to eq('Test Product')
    end

    it 'computes tax on save' do
      invoice_line.save
      expect(invoice_line.tax).to eq(20.00)
    end
  end
end 
