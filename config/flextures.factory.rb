# encoding: utf-8

Flextures::Factory.define :users do |f,mode,filename,ext|
  f.items<< [ Item.new( master_item_id:1, count:5 ), Item.new( master_item_id:1, count:5 ) ]
  f
end

