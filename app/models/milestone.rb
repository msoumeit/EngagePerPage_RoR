class Milestone < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :level_id, :player_id, :game_id ,:isPuzzleComplete, :isTaskComplete, :art_id
  belongs_to :player
  belongs_to :level
  belongs_to :game
end
