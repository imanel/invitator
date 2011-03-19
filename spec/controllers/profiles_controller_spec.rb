require 'spec_helper'

describe ProfilesController do
  let(:user) { Factory :user }

  def mock_profile(stubs = {})
    (@mock_profile ||= mock_model(Profile).as_null_object).tap do |profile|
      profile.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET 'show'" do
    context 'user signed in' do
      before { sign_in user }
      context 'and have profile' do
        before do
          Profile.stub!(:find).and_return(mock_profile)
          get :show
        end

        its(:response) { should be_success }
        its(:response) { should render_template('show') }
      end
      context "and don't have profile" do
        before do
          get :show
        end

        its(:response) { should redirect_to new_profile_path }
      end
    end
    context 'user not signed in' do
      before { get :show }

      its(:response) { should redirect_to new_user_session_path }
    end
  end

  describe "GET 'new'" do
    context 'user signed in' do
      before do
        sign_in user
        get :new
      end
  
      its(:response) { should be_success }
      its(:response) { should render_template('new') }
    end
    context 'user not signed in' do
      before { get :new }
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
  
  describe "POST 'create'" do
    context 'user signed in' do
      before { sign_in user }
  
      context 'with valid data' do
        before { Profile.stub(:new) { mock_profile(:save => true, :user_id => user.id) }}
        it 'assigns a newly created profile as @profile'  do
          post :create
          assigns(:profile).should be mock_profile
        end
  
        it 'redirect to the created profile' do
          post :create, :profile => {}
          response.should redirect_to profile_path
        end
      end
  
      context 'with invalid data' do
        it 'assigns a newly created but unsaved profile as @profile'  do
          Profile.stub(:new) { mock_profile(:save => false) }
          post :create
          assigns(:profile).should be mock_profile
        end
  
        it 're-render the "new" tempalate' do
          Profile.stub(:new) { mock_profile(:save => false, :user_id => user.id) }
          post :create, :profile => {}
          response.should render_template 'new'
        end
      end
    end
    context 'user not signed in' do
      before { post :create }
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
  
  describe "GET 'edit'" do
    context 'user signed in' do
      before { sign_in user }
      context 'user have profile' do
        before do
          Profile.stub!(:find).and_return(mock_profile)
          get :edit
        end
  
        its(:response) { should be_success }
        its(:response) { should render_template('edit') }
      end
      context "user don't have profile" do
        before do
          get :edit
        end
  
        its(:response) { should redirect_to new_profile_path }
      end
    end
    context 'user not signed in' do
      before { get :edit }
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
  
  describe "PUT 'update'" do
  
    context 'user signed in' do
      before do
        sign_in user
        Profile.stub!(:find).and_return(mock_profile)
      end
  
      context 'with valid data' do
        before { mock_profile.stub!(:update_attributes).and_return(true) }
        
        it 'update the requested profile' do
          mock_profile.should_receive(:update_attributes)
          put :update, :profile => {:some => :params}
        end
  
        it 'assigns the requrested profile as @profile' do
          put :update
          assigns(:profile).should be(mock_profile)
        end
  
        it 'redirects to profile' do
          put :update
          response.should redirect_to profile_path
        end
      end
  
      context 'with invalid data' do
        before { mock_profile.stub!(:update_attributes).and_return(false) }
        
        it 'assigns the profile as @profile' do
          put :update
          assigns(:profile).should be(mock_profile)
        end
  
        it 're-render the "edit" template' do
          put :update
          response.should render_template 'edit'
        end
      end
    end
  
    context 'user not signed in' do
      before do
        put :update
      end
  
      its(:response) { should redirect_to new_user_session_path }
    end
  end
end
