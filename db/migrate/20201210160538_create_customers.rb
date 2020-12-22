class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false

      t.text :address, null: false
      t.text :zip_code, null: false
      t.text :city, null: false
      t.text :country_code, null: false

      t.timestamps
    end
  end
end
