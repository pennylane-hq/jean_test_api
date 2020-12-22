class Customer < ApplicationRecord
  include Searchable

  has_many :invoices

  validates :first_name, :last_name, presence: true
  validates :address, :zip_code, :city, presence: true
  validates :country_code, inclusion: ISO3166::Country.all.map(&:alpha2)

  searchable_by any: %i[first_name last_name]

  before_destroy :before_destroy

  def country
    ISO3166::Country[country_code].name
  end

  private

  def before_destroy
    errors.add(:base, 'Ce client ne peut pas être supprimé car il possède des factures') if invoices.exists?
    throw :abort if errors.present?
  end
end
