class CreateAttackPayloads < ActiveRecord::Migration
  def self.up
    create_table :attack_payloads do |t|
      t.string :name
      t.integer :attack_id
      t.timestamps
    end
  end

  def self.down
    drop_table :attack_payloads
  end
end
