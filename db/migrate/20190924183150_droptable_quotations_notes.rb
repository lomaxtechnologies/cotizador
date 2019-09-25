class DroptableQuotationsNotes < ActiveRecord::Migration[6.0]
  def change
    drop_table :quotations_notes
  end
end
