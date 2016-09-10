class AddPictureToPuzzle < ActiveRecord::Migration
  def change
    add_column :pictures, :puzzle_id, :integer
  end
end
