class AddWinRulesToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :winrules, :text
    add_column :puzzles, :hintbox, :text
    add_column :puzzles, :hinturl, :text
    add_column :puzzles, :level_id, :integer
  end
end
