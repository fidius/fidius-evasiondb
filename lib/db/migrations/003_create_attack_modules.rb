class CreateAttackModules < ActiveRecord::Migration
  def self.up
    create_table :attack_modules do |t|
      t.string :name
      t.string :options_hash
      t.boolean :finished, :default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :attack_modules
  end
end
