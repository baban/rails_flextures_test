#encoding: utf-8

class CreateUploadImages < ActiveRecord::Migration
  def self.up
    create_table :upload_images do |t|
      t.string :name
      t.binary :content, length: 5.megabyte

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_images
  end
end
