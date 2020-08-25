class InviteMailer < ActionMailer::Base

  def new_invite(invite)
    @invite = invite
    mail(from: 'support@sc-c3.org', to: @invite.receiver_email, subject: @invite.subject)
  end 

end
