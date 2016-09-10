class AddAttachmentLogoToGames < ActiveRecord::Migration
  def self.up
    change_table :games do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :games, :logo
  end
end
