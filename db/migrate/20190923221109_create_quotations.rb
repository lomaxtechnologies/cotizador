class CreateQuotations < ActiveRecord::Migration[6.0]
  def change
    create_table :quotations do |t|
      t.integer :code
      t.date :quotation_date
      t.string :currency
      t.text :credits
      t.text :payment_condition
      t.text :warranty

      t.timestamps
    end
  end
end
