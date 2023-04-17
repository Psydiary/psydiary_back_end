class ChangeFieldDailyLogEntries < ActiveRecord::Migration[7.0]
  def change
    change_column :daily_log_entries, :meditation, :string
  end
end
