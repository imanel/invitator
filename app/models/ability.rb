class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Profile, :user_id => user.id
      can :manage, Invitation, :creator_id => user.id
      cannot [:accept, :reject], Invitation
    else
      # Guest
    end
  end
  
end
