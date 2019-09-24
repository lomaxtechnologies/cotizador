class CreateQuotationProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :quotation_products do |t|
      t.decimal :amount
      t.decimal :holgura

      t.timestamps
    end
  end
end
