

class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string   :name,         null: false
      t.text     :comment,      null: true
      t.integer  :rank,         default: 0, null: false
      t.integer  :guild_point,  default: 0, null: false
      t.integer  :money,        default: 0, null: false
      t.integer  :member_count, default: 0, null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :guilds
  end
end

