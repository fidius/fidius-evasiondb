class CreateEnabledRules < ActiveRecord::Migration
  def self.up
    create_table :enabled_rules do |t|
      t.integer :attack_module_id
      t.text :bitstring
      t.timestamps
    end
  end

  def self.down
    drop_table :enabled_rules
  end
end
