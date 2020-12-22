class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :customer, foreign_key: true, index: true
      t.boolean :finalized, null: false, default: false
      t.boolean :paid, null: false, default: false
      t.date :date
      t.date :deadline
      t.decimal :total, precision: 15, scale: 2
      t.decimal :tax, precision: 15, scale: 2

      t.timestamps
    end
  end
end
