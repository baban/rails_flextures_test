# encoding: utf-8

class User < ActiveRecord::Base
  has_many :items
  # ユーザーのステータスを上昇させます
  # @params [Integer] level レベルの上昇分
  # @return [Integer] 上昇後のレベル
  def levelup( level = 1 )
    level.times do
      self.level += 1
      self.max_hp += 5
      self.max_mp += 3
      self.base_attack += 3
      self.base_defence += 3
    end
    self.save
    self.level
  end 
end

