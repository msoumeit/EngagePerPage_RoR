class Level < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :name 
  belongs_to :game
  acts_as_list scope: :game
  has_many :milestones
  has_many :players, :through => :milestones
  has_one :puzzle
  has_one :task
  accepts_nested_attributes_for :puzzle
  accepts_nested_attributes_for :task
  has_many :rewards, :foreign_key => :owner_id
  validates :puzzle, :presence => true
  #validates :task, :presence => true
end
