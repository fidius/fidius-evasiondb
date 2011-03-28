class CreatePackets < ActiveRecord::Migration
  def self.up
    create_table :packets do |t|
      t.integer :attack_id
      t.integer :attack_payload_id
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
