class CreateIdmefEvents < ActiveRecord::Migration
  def self.up
    create_table :idmef_events do |t|
      t.column :payload, :binary
      t.datetime :detect_time
      t.string :dest_ip
      t.string :src_ip
      t.string :text
      t.string :severity
      t.string :analyzer_model
      t.column :ident, :bigint
      t.timestamps
    end
  end

  def self.down
    drop_table :idmef_events
  end
end
