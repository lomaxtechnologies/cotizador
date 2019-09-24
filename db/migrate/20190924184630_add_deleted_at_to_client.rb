class AddDeletedAtToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :deleted_at, :datetime, index: true
  end
end
