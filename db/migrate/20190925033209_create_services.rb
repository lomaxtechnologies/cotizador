class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.decimal :creation_price
      t.decimal :actual_price
      t.string :creator_user
      t.string :modifier_user
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
