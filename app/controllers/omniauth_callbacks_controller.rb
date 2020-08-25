class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    @user = current_user
    if @user.update_attributes({
      stripe_user_id: request.env["omniauth.auth"].uid,
      stripe_refresh_token: request.env["omniauth.auth"].credentials.refresh_token,
      stripe_access_token: request.env["omniauth.auth"].credentials.token
    })
      # anything else you need to do in response..
      redirect_to dashboard_path, notice: "You have successfully connected your Stripe account"
    else
      redirect_to edit_user_path(@user), notice: "Error Updating Your Info. Please try again..."
    end
  end
end
