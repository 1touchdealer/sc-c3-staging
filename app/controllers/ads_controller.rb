class AdsController < ApplicationController
  layout 'form_page'

  def new
    @ad = Ad.new
  end

  def create
    @ad = current_user.ads.new(ad_params)
    authorize @ad

    handle_stripe_token

    if @ad.save
      flash[:notice] = "Ad created successfully"
      redirect_to edit_ad_path(@ad)
    else
      render('new')
    end
  end

  def edit
    @ad = current_user.ads.find(params[:id])
    authorize @ad
  end

  def update
    @ad = current_user.ads.find(params[:id])
    authorize @ad

    handle_stripe_token

    if params[:ad].present?
      @ad.update_attributes(ad_params)
    end

    flash[:notice] = "Your ad was successfully updated"
    redirect_to dashboard_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to edit_ad_path(@ad)
  end

  private
  def ad_params
    params.require(:ad).permit(:image, :region_id)
  end

  def handle_stripe_token
    if (params[:stripeToken].present?)
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @ad.monthly_fee,
        :description => 'SC Christian Chamber of Commerce - Web Advertisement',
        :currency    => 'usd'
      )

      @ad.update_attributes(
        :expiration => [@ad.expiration, Time.now].compact.max + 1.month,
        :charge_id => charge.id,
        :card_token => charge.source.id
      )
    end
  end
end
