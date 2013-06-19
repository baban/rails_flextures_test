# encoding: utf-8

require "base64"

Flextures::Factory.define :users do |f|
  if f.name.blank?
    f.name=Faker::Japanese::Name.name
    f.sex=[0,1].sample
  end
  f.max_hp = f.hp = 100 unless f.max_hp.zero?
  f.max_mp = f.mp = 30 unless f.max_mp.zero?
  f.attack = 30 if f.attack.zero?
  f.defence = 30 if f.defence.zero?
  f.items<< [ Item.new( master_item_id:1, count:5 ), Item.new( master_item_id:2, count:5 ) ] if f.items.empty?
  f
end

Flextures::Factory.define :upload_images do |f|
  filename = Rails.root.to_path + "/" + f.name
  f.name = f.name
  f.content = IO.read("#{filename}")
  f
end

Flextures::Factory.define :admin_users do |f|
  f.preferences = Base64.decode64(f.preferences)
  f
end

Flextures::DumpFilter.define :admin_users, {
  preferences:->(v){ Base64.encode64(v) }
}
