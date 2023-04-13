class CreateProtocols < ActiveRecord::Migration[7.0]
  def change
    create_table :protocols do |t|
      t.string :name
      t.integer :days_between_dose
      t.string :dose_days
      t.float :dosage
      t.string :description
      t.integer :protocol_duration
      t.integer :break_duration
      t.string :other_notes
      t.timestamps
    end
  end
end
