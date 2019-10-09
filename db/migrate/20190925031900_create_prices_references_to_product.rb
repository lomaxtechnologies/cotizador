class CreatePricesReferencesToProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.decimal :product_price
      t.references :product, null: false, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
