class CreateQuotationProductAndReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :quotation_products do |t|
      t.decimal :amount
      t.decimal :percent
      t.references :quotation, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
