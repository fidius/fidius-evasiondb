class CreateIdsRules < ActiveRecord::Migration
  def self.up
    create_table :ids_rules do |t|
      t.integer :sort
      t.text :rule_text
      t.string :rule_hash
      t.timestamps
    end
    add_index :ids_rules, :rule_hash,:unique => true
  end

  def self.down
    drop_table :ids_rules
  end
end
