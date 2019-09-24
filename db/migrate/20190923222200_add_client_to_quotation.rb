class AddClientToQuotation < ActiveRecord::Migration[6.0]
  def change
    add_reference :quotations, :client, null: false, foreign_key: true
    add_reference :quotations, :user, null: false, foreign_key: true
  end
end
