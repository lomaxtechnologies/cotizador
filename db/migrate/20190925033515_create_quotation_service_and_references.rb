class CreateQuotationServiceAndReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :quotation_services do |t|
      t.decimal :amount
      t.decimal :holgura
      t.datetime :deleted_at, index: true
      t.references :service, null: false, foreign_key: true
      t.references :quotation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
