require 'spec_helper'

describe Invitation do
  subject { Factory.build :invitation }
  
  it { should be_valid }
  it { should validate_presence_of :target_email }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :content }
  
  it "should not allow invalid email" do
    subject.target_email = 'invalid'
    subject.should_not be_valid
    subject.errors['target_email'].should include('is invalid')
  end
  it "should allow passing multiple emails" do
    subject.target_email = 'test@example.org,test2@example.org'
    subject.should be_valid
  end
  it "should ignore spaces when passing multiple emails" do
    subject.target_email = '     test@example.org     ,      test2@example.org      '
    subject.should be_valid
  end
  it "should no allow invalid email when passing multiple emails" do
    subject.target_email = 'test@example.org, invalid'
    subject.should_not be_valid
    subject.errors['target_email'].should include('one of provided emails is invalid')
  end
  it "should allow multiple emails when subject or content is not provided" do
    subject.subject = nil
    subject.content = nil
    subject.target_email = 'test@example.org,test2@example.org'
    subject.should_not be_valid
    subject.errors['target_email'].should be_empty
  end
  it "should not change email if validation don't pass" do
    subject.target_email = 'test@example.org,test2@example.org'
    subject.content = nil
    subject.valid?
    subject.target_email.should eql('test@example.org,test2@example.org')
  end
  it "should save with only one email when passing multiple emails" do
    subject.target_email = 'test@example.org,test2@example.org'
    subject.save
    subject.target_email.should eql('test@example.org')
  end
  it "should create onlu one invitation if one email is provided" do
    subject.target_email = 'test@example.org'
    lambda { subject.save }.should change(described_class, :count).by(1)
  end
  it "should create multiple invitations when multiple emails provided" do
    subject.target_email = 'test@example.org,test2@example.org,test3@example.org'
    lambda { subject.save }.should change(described_class, :count).by(3)
  end
  it "should copy own subject and content to child invitations" do
    subject.target_email = 'test@example.org,test2@example.org,test3@example.org'
    subject.save
    described_class.all.all? do |invitation|
      invitation.subject == subject.subject && invitation.content == subject.content
    end.should be_true
  end
end
