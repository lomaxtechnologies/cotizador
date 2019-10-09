class CreateProductsAndReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.references :material, null: false, foreign_key: true
      t.references :measure_unit, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
