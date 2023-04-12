class CreateDailyLogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_log_entries do |t|
      t.string :mood
      t.integer :depression_score
      t.integer :anxiety_score
      t.integer :sleep_score
      t.integer :energy_levels
      t.integer :exercise
      t.integer :meditation
      t.integer :sociability
      t.string :notes
      t.references :user

      t.timestamps
    end
  end
end
