# encoding: utf-8

class User < ActiveRecord::Base
  has_many :items

  # @return [Integer] 上昇後のレベル
  def levelup!
    self.level += 1
    self.max_hp += 5
    self.max_mp += 3
    self.base_attack += 3
    self.base_defence += 3
    self.save
    self.level
  end

end

