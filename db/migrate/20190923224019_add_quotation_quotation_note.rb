class AddQuotationQuotationNote < ActiveRecord::Migration[6.0]
  def change
      add_reference :quotations_notes, :quotation, null: false, foreign_key: true
  end
end
