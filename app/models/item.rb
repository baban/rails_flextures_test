# encoding: utf-8

class Item < ActiveRecord::Base
  belongs_to :users
end
