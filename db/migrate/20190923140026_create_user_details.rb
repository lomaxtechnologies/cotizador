class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.string :name
      t.string :last_name
      t.string :phone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
