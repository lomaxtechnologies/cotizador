class AddQuotationAttachment < ActiveRecord::Migration[6.0]
  def change
      add_reference :attachments, :quotation, null: false, foreign_key: true
  end
end
