class CreateMicrodoseLogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :microdose_log_entries do |t|
      t.string :mood_before
      t.string :mood_after
      t.string :environment
      t.float :dosage
      t.integer :intensity
      t.integer :sociability
      t.string :journal_prompt
      t.string :journal_entry
      t.string :other_notes
      t.references :user

      t.timestamps
    end
  end
end
