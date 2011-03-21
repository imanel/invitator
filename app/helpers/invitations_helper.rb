module InvitationsHelper
  
  def link_to_invitation(invitation)
    return "" if invitation.nil?
    link_to invitation.target_email, invitation
  end
  
end
