class CreateQuotationServices < ActiveRecord::Migration[6.0]
  def change
    create_table :quotation_services do |t|
      t.decimal :amount
      t.decimal :holgura

      t.timestamps
    end
  end
end
