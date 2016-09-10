class Task < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :name ,:source_type ,:rule_type, :rule_operand, :goal_count, :promotion_title, :promotion_url
  belongs_to :level
  validates :source_type, :presence => {:message => 'Select a Task'}
end
