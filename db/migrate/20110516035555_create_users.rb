

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :name,           default: "", null: false
      t.integer  :sex,            default: 0,  null: false
      t.text     :profile_comment,default: ""
      t.integer  :level,          default: 1,  null: false
      t.integer  :exp,            default: 0,  null: false
      t.integer  :guild_id,       default: 0,  null: false
      t.integer  :hp,             default: 0,  null: false
      t.integer  :mp,             default: 0,  null: false
      t.integer  :max_hp,         default: 1,  null: false
      t.integer  :max_mp,         default: 1,  null: false
      t.integer  :attack,         default: 1,  null: false
      t.integer  :defence,        default: 1,  null: false
      t.integer  :base_attack,    default: 1,  null: false
      t.integer  :base_defence,   default: 1,  null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
