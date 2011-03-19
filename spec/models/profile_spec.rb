require 'spec_helper'

describe Profile do
  subject { Factory.build :profile }
  
  it { should be_valid }
  
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :address }
end
