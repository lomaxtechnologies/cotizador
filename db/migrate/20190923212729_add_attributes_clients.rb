class AddAttributesClients < ActiveRecord::Migration[6.0]
  def change
      add_column :clients, :modifier_user, :string
      add_column :clients, :creator_user, :string

  end
end
