require 'spec_helper'

describe InvitationsController do
  let(:user) { Factory :user }

  def mock_invitation(stubs = {})
    (@mock_invitation ||= mock_model(Invitation).as_null_object).tap do |invitation|
      invitation.stub(stubs) unless stubs.empty?
    end
  end
  
  describe "GET 'index'" do
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Factory(:profile, :user_id => user.id)
          get :index
        end

        its(:response) { should be_success }
        its(:response) { should render_template('index') }
      end
      context "and don't have profile" do
        before do
          get :index
        end

        its(:response) { should redirect_to profile_path }
      end
    end
    context 'user not signed in' do
      before { get :index }

      its(:response) { should redirect_to new_user_session_path }
    end
  end

  describe "GET 'show'" do
    let(:invitation) { Factory(:invitation, :creator_id => user.id) }
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Factory(:profile, :user_id => user.id)
          get :show, :id => invitation.id
        end
  
        its(:response) { should be_success }
        its(:response) { should render_template('show') }
      end
      context "and don't have profile" do
        before do
          get :show, :id => invitation.id
        end
  
        its(:response) { should redirect_to profile_path }
      end
    end
    context 'user not signed in' do
      context "unknown token" do
        before { get :show, :id => invitation.id }
  
        its(:response) { should redirect_to new_user_session_path }
      end
      context "known token" do
        before { get :show, :id => invitation.id, :token => invitation.token }
        
        its(:response) { should be_success }
        its(:response) { should render_template('show') }
      end
    end
  end

  describe "GET 'new'" do
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Factory(:profile, :user_id => user.id)
          get :new
        end
  
        its(:response) { should be_success }
        its(:response) { should render_template('new') }
      end
      context "and don't have profile" do
        before do
          get :new
        end
  
        its(:response) { should redirect_to profile_path }
      end
    end
    context 'user not signed in' do
      before { get :new }
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
  
  describe "POST 'create'" do
    context 'user signed in' do
      before do
        Factory(:profile, :user_id => user.id)
        sign_in user
      end
  
      context 'with valid data' do
        before { Invitation.stub(:new) { mock_invitation(:save => true, :creator_id => user.id) }}
        it 'assigns a newly created invitation as @invitation'  do
          post :create
          assigns(:invitation).should be mock_invitation
        end
  
        it 'redirect to the invitation index' do
          post :create, :invitation => {}
          response.should redirect_to invitations_path
        end
      end
  
      context 'with invalid data' do
        it 'assigns a newly created but unsaved invitation as @invitation'  do
          Invitation.stub(:new) { mock_invitation(:save => false) }
          post :create
          assigns(:invitation).should be mock_invitation
        end
  
        it 're-render the "new" tempalate' do
          Invitation.stub(:new) { mock_invitation(:save => false, :creator_id => user.id) }
          post :create, :invitation => {}
          response.should render_template 'new'
        end
      end
    end
    context 'user not signed in' do
      before { post :create }
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
  
  describe "GET 'accept'" do
    let(:invitation) { Factory(:invitation, :creator_id => user.id) }
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Factory(:profile, :user_id => user.id)
          get :accept, :id => invitation.id
        end
  
        its('response.response_code') { should eql(401) }
      end
      context "and don't have profile" do
        before do
          get :accept, :id => invitation.id
        end
  
        its('response.response_code') { should eql(401) }
      end
    end
    context 'user not signed in' do
      context "unknown token" do
        before { get :accept, :id => invitation.id }
  
        its(:response) { should redirect_to new_user_session_path }
      end
      context "known token" do
        before { get :accept, :id => invitation.id, :token => invitation.token }
        
        its(:response) { should redirect_to new_user_registration_path(:invitation_id => invitation.id, :invitation_token => invitation.token) }
      end
    end
  end
  
  describe "GET 'reject'" do
    let(:invitation) { Factory(:invitation, :creator_id => user.id) }
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Factory(:profile, :user_id => user.id)
          get :reject, :id => invitation.id
        end
  
        its('response.response_code') { should eql(401) }
      end
      context "and don't have profile" do
        before do
          get :reject, :id => invitation.id
        end
  
        its('response.response_code') { should eql(401) }
      end
    end
    context 'user not signed in' do
      context "unknown token" do
        before { get :reject, :id => invitation.id }
  
        its(:response) { should redirect_to new_user_session_path }
      end
      context "known token" do
        before { get :reject, :id => invitation.id, :token => invitation.token }
        
        its(:response) { should redirect_to root_path }
      end
    end
  end
  
end
