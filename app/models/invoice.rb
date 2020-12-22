class Invoice < ApplicationRecord
  include Searchable

  before_save :compute_amounts
  before_destroy :before_destroy

  belongs_to :customer

  has_many :invoice_lines, dependent: :delete_all
  accepts_nested_attributes_for :invoice_lines, allow_destroy: true

  validate :cannot_modify_finalized_invoice

  searchable_by :paid, :date, :deadline, :customer_id, :'invoice_lines.product_id',
    any: %i[invoice_lines.label customer.first_name customer.last_name]

  private

  def before_destroy
    errors.add(:base, 'Une facture finalisée ne peut pas être supprimée')
    throw :abort if errors.present?
  end

  def compute_amounts
    invoice_lines.each { _1.compute_tax }
    self.total = invoice_lines.select { !_1.marked_for_destruction? }.sum(&:price)
    self.tax = invoice_lines.select { !_1.marked_for_destruction? }.sum(&:tax)
  end

  def cannot_modify_finalized_invoice
    return if new_record?
    if changes.key?('finalized')
      return unless finalized_was
    else
      return unless finalized
    end

    if invoice_lines.any? { |il| il.marked_for_destruction? || il.changes.present? }
      return errors.add(:finalized, 'invoice cannot be modified')
    end

    return if (changed - %w[paid]).empty?

    errors.add(:base, 'Une facture finalisée ne peut pas être modifiée')
  end
end
