require 'md5'

class Invitation < ActiveRecord::Base
  
  STATUS_NAMES = {
    'new' => 'Waiting',
    'accepted' => 'Accepted',
    'rejected' => 'Rejected'
  }
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  before_validation :split_multiple_target_email
  
  validates_presence_of :target_email, :subject, :content, :creator_id
  validates_format_of :target_email, :with => Devise.email_regexp
  validate :validate_child_invitations
  
  after_validation :restore_starting_email
  before_save :use_first_provided_email
  after_save :save_child_invitations
  before_create :generate_token
  
  attr_accessible :target_email, :subject, :content
  
  def status_name
    STATUS_NAMES[self.status]
  end
  
  def generate_token
    self.token = MD5.new(rand.to_s).to_s
  end
  
  def allowed_access?(token)
    self.status == 'new' && token == self.token
  end
  
  def accept!
    self.status = 'accepted'
    self.save(:validate => false)
  end
  
  def reject!
    self.status = "rejected"
    self.save(:validate => false)
  end
  
  def self.check_for_new_user(id, token)
    self.find_by_id_and_token_and_status(id, token, 'new')
  end
  
  private
  
  def split_multiple_target_email
    @starting_email = self.target_email.to_s
    multiple_emails = @starting_email.split(',').collect(&:strip)
    self.target_email = multiple_emails.shift
    @child_invitations = []
    multiple_emails.each do |email|
      @child_invitations << Invitation.new(
                                            :creator_id => self.creator_id,
                                            :target_email => email,
                                            :subject => self.subject,
                                            :content => self.content
                                          )
    end  
  end
  
  def validate_child_invitations
    @child_invitations.collect(&:valid?)
    result = @child_invitations.all? { |invitation| invitation.errors['target_email'].empty? }
    unless result
      self.errors.add(:target_email, 'one of provided emails is invalid')
    end
  end
  
  def restore_starting_email
    self.target_email, @starting_email = @starting_email, self.target_email
  end
  
  def use_first_provided_email
    self.target_email = @starting_email if @starting_email
  end
  
  def save_child_invitations
    @child_invitations.each { |invitation| invitation.save(:validate => false) } if @child_invitations
  end
  
end
