class AddIsReviewedToGames < ActiveRecord::Migration
  def change
    add_column :games, :is_reviewed, :int, :default => 0
  end
end
