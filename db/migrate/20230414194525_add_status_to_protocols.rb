class AddStatusToProtocols < ActiveRecord::Migration[7.0]
  def change
    add_column :protocols, :status, :integer, default: 0
  end
end
