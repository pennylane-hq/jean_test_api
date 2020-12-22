class CreateInvoiceLines < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_lines do |t|
      t.references :invoice, foreign_key: true, index: true, null: false
      t.references :product, foreign_key: true, index: true

      t.integer :quantity, null: false
      t.text :unit, null: false

      t.text :label, null: false
      t.text :vat_rate, null: false
      t.decimal :price, null: false, precision: 15, scale: 2
      t.decimal :tax, null: false, precision: 15, scale: 2

      t.timestamps
    end
  end
end
