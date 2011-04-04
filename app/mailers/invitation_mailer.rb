class InvitationMailer < ActionMailer::Base
  default :from => Devise.mailer_sender
  
  def new_invitation(invitation)
    @invitation = invitation
    mail(:to => invitation.target_email, :subject => "You was invited to Invitator!")
  end
  
  def invitation_declined(invitation)
    @invitation = invitation
    mail(:to => invitation.creator.profile.email, :subject => "Your invitation was declined!")
  end
  
end