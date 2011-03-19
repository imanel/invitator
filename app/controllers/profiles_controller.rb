class ProfilesController < ApplicationController
  load_and_authorize_resource
  
  before_filter :check_profile_existence, :except => [:new, :create]
  
  def show
  end
  
  def new
    @profile = current_user.profile || current_user.build_profile
  end
  
  def create
    @profile = current_user.build_profile(params[:profile])
    if @profile.save
      flash[:notice] = "Profile created successfully"
      redirect_to profile_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Profile updated successfully"
      redirect_to profile_path
    else
      render 'edit'
    end
  end
  
  private
  
  def check_profile_existence
    @profile = current_user.profile
    redirect_to new_profile_path and return unless @profile
  end
  
end
