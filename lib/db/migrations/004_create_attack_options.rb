class CreateAttackOptions < ActiveRecord::Migration
  def self.up
    create_table :attack_options do |t|
      t.integer :attack_module_id
      t.string :option_key
      t.string :option_value
      t.timestamps
    end
  end

  def self.down
    drop_table :attack_options
  end
end
