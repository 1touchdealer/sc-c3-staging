class InvitesController < ApplicationController
  def new
    @invite = Invite.new
    @invite.body = params[:body]
  end  

  def create
    @invite = Invite.new(invite_params)
    @invite.status = "pending"
    if @invite.save
      InviteMailer.new_invite(@invite).deliver_now
      redirect_to documents_path, notice: 'Invitation has been sent'
    else
      redirect_to documents_path, notice: 'Cannot send invitation. Please try again later'
    end
  end  

  private
  def invite_params
    params.require(:invite).permit(:sender_email, :receiver_email, :subject, :body)
  end
end
