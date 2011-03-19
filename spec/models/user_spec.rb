require 'spec_helper'

describe User do
  subject { Factory.build :user }
  
  it { should be_valid }
  
  it { should validate_presence_of :login }
  it { should validate_uniqueness_of :login }
  it { should validate_length_of :login, :maximum => 30 }
  
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }
  it { should validate_length_of :password, :minimum => 3, :maximum => 20 }
end
