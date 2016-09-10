class User < ActiveRecord::Base
  is_impressionable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable 
  after_create :set_player_on_user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  #Removing Protected
  #attr_accessible :name , :email,:password ,:password_confirmation, :remember_me #, :new_password, :new_password_confirmation, :remember_me
  #attr_accessor :password, :new_password, :previous_email, :previous_username, :remember_me
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :socials
  has_one :player
  
def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
end

private
  def set_player_on_user
    player = Player.new(:name => self.name, :picture => URI.parse("http://placehold.it/56&text=noimage"))
    self.player = player
    role = Role.find_by_name("player".camelcase)
    self.roles << role
  end
  
end