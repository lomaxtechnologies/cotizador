class CreateAttachmentAndReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.text :location
      t.datetime :deleted_at, index: true
      t.references :quotation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps

    end
  end
end
