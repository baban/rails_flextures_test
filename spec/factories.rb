# encoding: utf-8

FactoryGirl.define do
  factory :user do
    name 'ブリトニー'
    sex  1
    profile_comment ""
    level 10
    exp 100
    guild_id 1
    hp 100
    mp 50
    max_hp 145
    max_mp 50
    attack 45
    defence 45
    base_attack 35
    base_defence 35
  end

  factory :item do
    user_id 1
    master_item_id 3
    count 5
    used_count 0
  end
end
