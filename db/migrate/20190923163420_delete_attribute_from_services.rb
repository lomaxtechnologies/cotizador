class DeleteAttributeFromServices < ActiveRecord::Migration[6.0]
  def change
    remove_column :services, :status
  end
end
