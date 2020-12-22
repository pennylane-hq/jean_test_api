class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.text :label, null: false
      t.text :unit, null: false
      t.text :vat_rate, null: false
      t.decimal :unit_price, null: false, precision: 15, scale: 2
      t.decimal :unit_tax, null: false, precision: 15, scale: 2

      t.timestamps
    end
  end
end
