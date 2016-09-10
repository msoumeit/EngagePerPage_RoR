class AddPageToGame < ActiveRecord::Migration
  def change
    add_column :games, :page_id, :string
    add_column :games, :page_name, :string
    add_column :games, :page_access_token, :string
  end
end
