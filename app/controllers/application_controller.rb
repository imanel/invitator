class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      render(:file => "public/404.html", :status => 401, :layout => false) and return
    else
      redirect_to new_user_session_path and return
    end
  end
  
  protected
  
  def self.menu(key)
    before_filter do
      @current_tab = key
    end
  end
  
end
