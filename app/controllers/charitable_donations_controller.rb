class CharitableDonationsController < ApplicationController
  layout "form_page"

  def new
    @charitable_donation = CharitableDonation.new
    @charitable_donation.charity_type = params[:charity_type]
    @charitable_donation.charity_id = params[:charity_id]
    @charity = @charitable_donation.charity
  end

  def create
    @charitable_donation = CharitableDonation.new(charitable_donation_params)
    @charity = @charitable_donation.charity
    @charitable_donation.user_id = current_user.try(:id)
    charge_error = nil

    if @charitable_donation.valid?
      application_fee = ((@charitable_donation.donation_amount * 5.4) + 30).to_i
      connected_account = @charity.admin_users.first.stripe_user_id

      begin
        customer = Stripe::Customer.create(
          :email => @charitable_donation.email,
          :card  => params[:stripeToken])

        charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => @charitable_donation.donation_amount * 100,
          :description => 'Charitable Donation - ' + @charity.name,
          :currency    => 'usd',
          :application_fee => application_fee,
          :destination => connected_account
          )

      rescue Stripe::CardError => e
        charge_error = e.message
      end
      if charge_error
        flash[:error] = charge_error
        render :new
      else
        #-- Update Charitable Donation With Stripe Details
        @charitable_donation.charge_id = charge.id
        @charitable_donation.card_token = charge.source.id
        @charitable_donation.save

        redirect_to @charity, notice: "Thanks for the contribution!"
      end
    else
      flash[:error] = 'One or more errors in your donation'
      render :new
    end
  end

  private
  def charitable_donation_params
    params.require(:charitable_donation).permit(:email, :user_id, :charity_id, :charity_type, :donation_amount, :card_token, :charge_id, :message)
  end
end
