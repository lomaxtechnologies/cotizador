class AddServiceQuotationToQuotationService < ActiveRecord::Migration[6.0]
  def change
    add_reference :quotation_services, :service, null: false, foreign_key: true
    add_reference :quotation_services, :quotation, null: false, foreign_key: true
  end
end
