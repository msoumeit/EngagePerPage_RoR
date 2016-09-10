class Role < ActiveRecord::Base
  #Removing Protected
  #attr_accessible :name
  has_and_belongs_to_many :users
end
