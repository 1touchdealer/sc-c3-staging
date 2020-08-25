class ChamberDonationsController < ApplicationController
  layout "form_page"

  def new
    @chamber_donation = ChamberDonation.new
  end

  def create
    @chamber_donation = ChamberDonation.new(chamber_donation_params)

    charge_error = nil

    if @chamber_donation.valid?
      application_fee = ((@chamber_donation.donation_amount * 5.4) + 30).to_i
      super_admin = User.joins(:user_roles).where(user_roles:{role_id: Role.super_admin}).first

      begin
        customer = Stripe::Customer.create(
          :email => @chamber_donation.email,
          :card  => params[:stripeToken])

        charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => @chamber_donation.donation_amount * 100,
          :description => 'SC Christian Chamber of Commerce',
          :currency    => 'usd',
          :application_fee => application_fee,
          :destination => super_admin.stripe_user_id
          )

      rescue Stripe::CardError => e
        charge_error = e.message
      end
      if charge_error
        flash[:error] = charge_error
        render :new
      else
        #-- Update Charitable Donation With Stripe Details
        @chamber_donation.charge_id = charge.id
        @chamber_donation.card_token = charge.source.id
        @chamber_donation.save

        redirect_to root_path, notice: "Thanks for the contribution!"
      end
    else
      flash[:error] = 'One or more errors in your donation'
      render :new
    end
  end

  private
  def chamber_donation_params
    params.require(:chamber_donation).permit(:email, :donation_amount, :card_token, :charge_id, :message)
  end
end
