class CreateDashboards < ActiveRecord::Migration
  def self.up
    create_table :dashboards do |t|
      t.column :name, :string, :null => false
      t.column :grp, :string, :null => false
      t.column :query, :blob, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :dashboards
  end
end
