class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.text :address
      t.string :nit
      t.string :phone

      t.timestamps
    end
  end
end
