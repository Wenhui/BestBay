class AddAttachmentPictureToItems < ActiveRecord::Migration
  #add attached picture to items, by paperclip
  def self.up
    change_table :items do |t|
      t.has_attached_file :picture
    end
  end

  #remove attached picture to items
  def self.down
    drop_attached_file :items, :picture
  end
end
