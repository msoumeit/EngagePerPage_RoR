class AddBusinessNameToGame < ActiveRecord::Migration
  def change
    add_column :games, :business_name, :string
  end
end
