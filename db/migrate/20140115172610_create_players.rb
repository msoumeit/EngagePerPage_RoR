class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :netwonth
      t.string :name
      t.text   :aboutme
      t.attachment :picture
      t.integer :user_id
      t.timestamps
    end
  end
end
