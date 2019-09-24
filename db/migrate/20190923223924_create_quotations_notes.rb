class CreateQuotationsNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotations_notes do |t|
      t.text :note

      t.timestamps
    end
  end
end
