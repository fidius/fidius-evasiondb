class CreateIdsRules < ActiveRecord::Migration
  def self.up
    create_table :ids_rules do |t|
      t.integer :sort
      t.text :rule_text
      t.string :hash
      t.timestamps
    end
  end

  def self.down
    drop_table :ids_rules
  end
end
