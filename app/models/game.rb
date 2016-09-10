class Game < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  is_impressionable
  #Removing Protected
  #attr_accessible :name, :expirationdate
  validates_uniqueness_of :name
  has_many :levels
  has_many :milestones
  has_many :prizes, :foreign_key => :owner_id
  belongs_to :business
  validates :logo, :presence => true
  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      [:business_name, :name]
    ]
  end
  has_attached_file :logo,
                    :styles => {
                          :flogo => "111x74#",
                          :medium => "x74"},
                          :convert_options => { :all => "-unsharp 0.3x0.3+6+0" }
end
