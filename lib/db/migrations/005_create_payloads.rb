class CreatePayloads < ActiveRecord::Migration
  def self.up
    create_table :exploits do |t|
      t.string :name
      t.integer :exploit_id
      t.timestamps
    end
  end

  def self.down
    drop_table :exploits
  end
end
