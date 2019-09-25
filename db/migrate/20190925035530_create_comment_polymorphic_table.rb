class CreateCommentPolymorphicTable < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :note
      t.datetime :deleted_at, index: true
      t.references :commentable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
