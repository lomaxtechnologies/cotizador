class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :modifier_user
      t.string :creator_user
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
