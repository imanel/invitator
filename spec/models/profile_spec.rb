require 'spec_helper'

describe Profile do
  subject { Factory.build :profile }
  
  it { should be_valid }
  
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :address }
  
  context "#avatar" do
    it "should accept jpg file" do
      subject.avatar = File.open(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/Example.jpg')
      subject.should be_valid
    end
    it "should accept gif file" do
      subject.avatar = File.open(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/Example.gif')
      subject.should be_valid
    end
    it "should accept png file" do
      subject.avatar = File.open(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/Example.png')
      subject.should_not be_valid
    end    
  end
end
