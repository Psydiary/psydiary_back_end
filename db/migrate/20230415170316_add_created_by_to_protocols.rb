class AddCreatedByToProtocols < ActiveRecord::Migration[7.0]
  def change
    add_column :protocols, :created_by, :integer, default: 0
  end
end
