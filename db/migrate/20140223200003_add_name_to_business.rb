class AddNameToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :name, :string
  end
end
