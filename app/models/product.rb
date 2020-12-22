class Product < ApplicationRecord
  include Searchable

  validates :label, :vat_rate, :unit_price, :unit, presence: true

  has_many :invoice_lines
  before_save :compute_tax

  enum unit: {
    'piece': 'piece',
    'hour': 'hour',
    'day': 'day',
  }

  enum vat_rate: {
    '0': '0',
    '5.5': '5.5',
    '10': '10',
    '20': '20',
  }

  searchable_by any: %i[label]

  def unit_price_without_tax
    (unit_price / (1 + vat_rate.to_s.to_d / 100)).round(2)
  end

  before_destroy :before_destroy

  private

  def before_destroy
    errors.add(:base, 'Ce produit ne peut pas être supprimé car il est utilisé dans des factures') if invoice_lines.exists?
    throw :abort if errors.present?
  end


  def compute_tax
    self.unit_tax = unit_price - unit_price_without_tax
  end
end
