class Invitation < ActiveRecord::Base
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  before_validation :split_multiple_target_email
  
  validates_presence_of :target_email, :subject, :content, :creator_id
  validates_format_of :target_email, :with => Devise.email_regexp
  validate :validate_child_invitations
  
  after_validation :restore_starting_email
  before_save :use_first_provided_email
  after_save :save_child_invitations
  
  attr_accessible :target_email, :subject, :content
  
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
    self.target_email = @starting_email
  end
  
  def save_child_invitations
    @child_invitations.each { |invitation| invitation.save(:validate => false) }
  end
  
end
