class CreateAlarms < ActiveRecord::Migration
  def self.up
    create_table :alarms do |t|
      t.column :severity, :string, :null => false
      t.column :host, :string, :null => false
      t.column :plugin, :string, :null => false
      t.column :type, :string, :null => false
      t.column :data_source, :string, :null => false
      t.column :value, :string, :null => false
      t.column :def_id, :integer, :null => false
      t.column :message, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :alarms
  end
end
