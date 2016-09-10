class Player < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :name, :aboutme, :picture
  belongs_to :user
  has_many :milestones
  has_many :levels, :through => :milestones
  has_many :incentives
  has_attached_file :picture,
                    :styles => {:avatar => "27x27>#", 
                                :thumb => "56x56>#",
                                :medium => "300x250^"},
                    :convert_options => { :all => "-unsharp 0.3x0.3+5+0" }
end
