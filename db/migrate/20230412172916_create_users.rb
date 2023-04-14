class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :ip_address
      
      t.references :protocol

      t.timestamps
    end
  end
end
