class Profile < ActiveRecord::Base
  
  attr_accessible :full_name, :address, :city, :province, :country, :postal_code
  
  belongs_to :user
  
  validates_presence_of :full_name, :address
  
end
