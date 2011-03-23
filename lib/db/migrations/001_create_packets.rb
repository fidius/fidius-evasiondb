class CreatePackets < ActiveRecord::Migration
  def self.up
    create_table :packets do |t|
      t.integer :exploit_id
      t.integer :exploit_payload_id
      t.string :src_addr
      t.string :dest_addr
      t.string :src_port
      t.string :dest_port
      t.column :payload, :binary
      t.timestamps
    end
  end

  def self.down
    drop_table :packets
  end
end
