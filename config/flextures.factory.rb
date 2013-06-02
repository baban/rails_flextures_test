# encoding: utf-8

Flextures::Factory.define :users do |f|
  f.items<< [ Item.new( master_item_id:1, count:5 ), Item.new( master_item_id:2, count:5 ) ]
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
  preferences:->(v){ p(:preferences); Base64.encode64(v) }
}
