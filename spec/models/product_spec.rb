require 'rails_helper'

describe Product do
  describe 'unit_tax' do
    let(:product) { create(:product) }

    it 'computes properly when creating' do
      product = Product.create!(label: 'product', unit_price: 120, vat_rate: :'20', unit: :piece)
      expect(product.unit_tax).to eq 20
    end

    it 'computes properly when changing price' do
      product.update!(vat_rate: :'10', unit_price: 55)
      expect(product.unit_tax).to eq 5
    end
  end
end
