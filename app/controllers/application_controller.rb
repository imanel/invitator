class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def self.menu(key)
    before_filter do
      @current_tab = key
    end
  end
  
end
