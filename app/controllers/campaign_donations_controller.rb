class CampaignDonationsController < ApplicationController
  layout "form_page"

  def new
    @campaign = Campaign.find(params[:campaign_id])
    @campaign_donation = @campaign.campaign_donations.new
  end

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @campaign_donation = @campaign.campaign_donations.new(campaign_donation_params)
    charge_error = nil

    if @campaign_donation.valid?
      #Stripe: 2.9% plus 30 cent
      application_fee = ((@campaign_donation.donation_amount * 7.9) + 30).to_i
      connected_account = @campaign.user.stripe_user_id

      begin
        customer = Stripe::Customer.create(
          :email => @campaign_donation.email,
          :card  => params[:stripeToken])

        charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => @campaign_donation.donation_amount * 100,
          :description => 'Campaign Donation - ' + @campaign.name,
          :currency    => 'usd',
          :application_fee => application_fee, # amount in cents
          :destination => connected_account)

      rescue Stripe::CardError => e
        charge_error = e.message
      end
      if charge_error
        flash[:error] = charge_error
        render :new
      else
        #-- Update Campaign Totals (if else is to catch total_amount = nil)
        if @campaign.total_amount.present?
          @campaign.total_amount += (@campaign_donation.donation_amount)
        else
          @campaign.total_amount = (@campaign_donation.donation_amount)
        end
        @campaign.save

          #-- Update Campaign Donation With Stripe Details
        @campaign_donation.charge_id = charge.id
        @campaign_donation.card_token = charge.source.id
        @campaign_donation.save

        redirect_to @campaign, notice: "Thanks for the contribution!"
      end
    else
      puts
      flash[:error] = "One or more errors in your donation: " + @campaign_donation.errors.full_messages.join(",")
      render :new
    end
  end

  private
  def campaign_donation_params
    params.require(:campaign_donation).permit(:email, :user_id, :campaign_id, :donation_amount, :card_token, :charge_id, :message)
  end
end
