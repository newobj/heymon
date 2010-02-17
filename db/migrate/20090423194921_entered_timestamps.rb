class EnteredTimestamps < ActiveRecord::Migration
  def self.up
      add_column :alarms, :entered_critical_at, :timestamp
      add_column :alarms, :entered_warning_at, :timestamp
      add_column :alarm_defs, :critical_duration_threshold, :integer, :null => false, :default => 0
      add_column :alarm_defs, :warning_duration_threshold, :integer, :null => false, :default => 0
  end

  def self.down
      remove_column :alarms, :entered_critical_at
      remove_column :alarms, :entered_warning_at
      remove_column :alarm_defs, :critical_duration_threshold
      remove_column :alarm_defs, :warning_duration_threshold
  end
end
