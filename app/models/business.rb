class Business < ActiveRecord::Base
  is_impressionable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_and_belongs_to_many :connects
  validates_uniqueness_of :name , :case_sensitive => false
  #Removing Protected
  #attr_accessible :email,:password ,:password_confirmation
  has_many :games
  
  
  def role?(role)
    return !!(self.role == role.to_s.camelize)
  end
  
  
end
