class AddProductoQuotationToQuotationProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :quotation_products, :quotation, null: false, foreign_key: true
    add_reference :quotation_products, :product, null: false, foreign_key: true
  end
end
