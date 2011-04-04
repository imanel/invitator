class Profile < ActiveRecord::Base
  
  attr_accessible :full_name, :address, :city, :province, :country, :postal_code, :avatar, :email
  
  belongs_to :user
  
  validates_presence_of :full_name, :address, :email
  validates_format_of :email, :with => Devise.email_regexp
  
  has_attached_file :avatar,
                    :styles => { :thumb => '160x160#' },
                    :default_url => "/images/user_avatar.png"
  validates_attachment_content_type :avatar, :content_type => ['image/jpg', 'image/jpeg', 'image/gif']
  
end
