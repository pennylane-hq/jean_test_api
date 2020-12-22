class AddSessions < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"')
      end
    end

    create_table :sessions do |t|
      t.string :name, null: false
      t.uuid :token, null: false, default: 'uuid_generate_v4()'
    end

    add_index :sessions, :name, unique: true
    add_index :sessions, :token, unique: true

    add_reference :invoices, :session, foreign_key: true
  end
end
