class Picture < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :picture
  belongs_to :puzzle
  has_attached_file :picture,
                    :styles => {:stage => "x290"}
end