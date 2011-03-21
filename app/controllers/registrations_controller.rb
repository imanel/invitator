class RegistrationsController < Devise::RegistrationsController
  menu :sign_up
  
  def create
    if params[:invitation_id] && params[:invitation_token]
      @invitation = Invitation.check_for_new_user(params[:invitation_id], params[:invitation_token])
      if @invitation.nil?
        flash[:error] = "Unknown invitation or invalid token. Please try again later"
        redirect_to root_path and return
      end
      super
    end
  end
  
  protected
  
  def sign_in_and_redirect(*args)
    if @invitation
      @invitation.accept!
    end
    super
  end
  
end