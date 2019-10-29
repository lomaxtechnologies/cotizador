class CreateQuotationsAndReferences < ActiveRecord::Migration[6.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :quotations do |t|
      t.integer :quotation_type
      t.integer :state, default: 0
      t.date :quotation_date
      t.string :currency
      t.text :payment_condition
      t.text :warranty
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
    execute "ALTER SEQUENCE quotations_id_seq RESTART 100;"
  end
end
