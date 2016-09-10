class AddHomepageToGame < ActiveRecord::Migration
  def change
    add_column :games, :homepage, :string
  end
end
