class Incentive < ActiveRecord::Base
  belongs_to :game ,  :foreign_key => :owner_id
  belongs_to :level,  :foreign_key => :owner_id
  #Removing Protected
  #attr_accessible :title ,:code , :expirydate
  belongs_to :player
end
