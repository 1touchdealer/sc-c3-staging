class PasswordsController < Devise::PasswordsController
  layout "form_page"
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render :new
    else
      render :new
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   self.resource = resource_class.new
  #   set_minimum_password_length
  #   resource.reset_password_token = params[:reset_password_token]
  # end
  #
  protected
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   root_path
  # end
end
