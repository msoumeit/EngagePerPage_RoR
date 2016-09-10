class Puzzle < ActiveRecord::Base
    #Removing Protected
    #attr_accessible :name, :ptype, :hintbox, :winrules, :hinturl
    belongs_to :level
    has_one :picture, :dependent => :destroy
    accepts_nested_attributes_for :picture
    validates :picture, :presence => true
    validates_length_of :name, :minimum => 10, :maximum => 50, :allow_blank => false
    validates_length_of :hintbox, :minimum => 10, :maximum => 50, :allow_blank => false
end
