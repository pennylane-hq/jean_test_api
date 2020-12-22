class InvoiceLine < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  validates :label, :quantity, :unit, :vat_rate, :price, presence: true

  before_save :compute_tax
  before_create :compute_tax

  enum unit: Product.units
  enum vat_rate: Product.vat_rates

  def price_without_tax
    (price / (1 + vat_rate.to_s.to_d / 100)).round(2)
  end

  def compute_tax
    self.tax = price - price_without_tax
  end
end
