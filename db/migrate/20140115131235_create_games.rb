class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :expirationdate
      t.timestamps
    end
  end
end
