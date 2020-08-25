class SessionsController < Devise::SessionsController
  skip_before_filter :redirect_to_payment
end
