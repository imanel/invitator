include Rails.application.routes.url_helpers
class Menu

  SIGNED_OUT_HIERARCHY = [
    [ "home", "Home", root_path ],
    [ "sign_in", "Sign in", new_user_session_path ],
    [ "sign_up", "Sign up", new_user_registration_path ]
  ]

  SIGNED_IN_HIERARCHY = [
    [ "home", "Home", root_path ],
    [ "profile", "My Profile", profile_path ],
    [ "invitations", "Invitations", invitations_path ],
    [ "sign_out", "Sign out", destroy_user_session_path]
  ]

  def self.main(selected, options = {})
    menu = menu_tree(options).collect { |m| m[0..2] }
    menu.each { |m| m[3] = "selected" if m[0] == selected.to_s }
    menu.collect! { |m| Menu.new(m) }
    menu
  end

  attr_accessor :key,  :title, :url, :selected

  def initialize(options = [])
    @key = options[0]
    @title = options[1]
    @url = options[2]
    @selected = options[3]
  end

  protected

  def self.menu_tree(options = {})
    options[:scope].nil? ? HIERARCHY : const_get("#{options[:scope].to_s.upcase}_HIERARCHY") rescue []
  end

end
