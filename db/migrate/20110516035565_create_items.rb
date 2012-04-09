

class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer  :user_id,        null: false
      t.integer  :master_item_id, null: false
      t.integer  :count,          default: 0, null: false
      t.integer  :used_count,     default: 0, null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end

