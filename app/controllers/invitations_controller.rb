class InvitationsController < ApplicationController
  load_and_authorize_resource :through => :current_user
  before_filter :check_profile_filled?
  
  def index
    grouped_invitations = @invitations.order(:id).group_by(&:status)
    @new = Array(grouped_invitations['new'])
    @accepted = Array(grouped_invitations['accepted'])
    @rejected = Array(grouped_invitations['rejected'])
    @invitations_size = [@new, @accepted, @rejected].collect(&:size).max
  end
  
  def new
    respond_to do |format|
      format.html
      format.js do
        @remote = true
        render :layout => nil
      end
    end
  end
  
  def create
    @invitation = current_user.invitations.new(params[:invitation])
    respond_to do |format|
      if @invitation.save
        flash[:notice] = "Invitation sent successfully"
        format.html { redirect_to invitations_path }
        format.js   { render 'success' }
      else
        format.html { render 'new' }
        format.js   { render 'failure' }
      end
    end
  end
  
  private
  
  def check_profile_filled?
    unless current_user.profile_filled?
      flash[:error] = "You must create profile before sending invitations"
      redirect_to profile_path and return
    end
  end
  
end
