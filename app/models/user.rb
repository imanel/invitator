class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable
         #:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :password, :password_confirmation
  
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_format_of :login, :with => /^[\w\d]+$/, :message => "only letter, number or underscore allowed"
  validates_length_of :login, :maximum => 30
  
  validates_presence_of :password
  validates_confirmation_of :password
  validates_length_of :password, :within => 3..20
  
  attr_accessible :login, :password, :password_confirmation
  
  has_one :profile
  has_many :invitations, :class_name => "Invitation", :foreign_key => "creator_id"
  
end
