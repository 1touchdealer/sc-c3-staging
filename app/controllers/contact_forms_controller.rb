class ContactFormsController < ApplicationController
  def new
    @contact = ContactForm.new
    render layout: "form_page"
  end

  def create
    @contact = ContactForm.new(params[:contact_form])
    @contact.request = request
    if @contact.deliver
      redirect_to root_path, notice: 'Thank you for your message. We will contact you soon!'
    else
      flash.now[:error] = 'There has been a glitch in the Matrix. Cannot send message. Please try again later. If the problem continues please contact support at support@sc-c3.org'
      render :new
    end
  end
end
