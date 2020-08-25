class CampaignsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]

  def index
    scope = Campaign.approved
    if params[:search]
      @campaigns = scope.where('name ILIKE ?', "%#{params[:search]}%")
    elsif params[:category_search]
      @campaigns = scope.where(campaign_category_id: params[:category_search])
    elsif params[:region_search]
      @campaigns = scope.where(region_id: params[:region_search])
    else
      @campaigns = scope
    end
    render layout: "landing_page"
  end

  def new
    @campaign = current_user.campaigns.new
    @campaign.region_id = current_user.region_id
    if current_user.stripe_user_id.blank?
      redirect_to edit_user_path(current_user), notice: "You must connect your stripe account before creating a campaign."
    else
      render layout: "form_page"
    end
  end

  def create
    @campaign = current_user.campaigns.create(campaign_params)
    authorize @campaign

    if @campaign.save
      redirect_to @campaign, notice: "Campaign successfully submitted!"
    else
      flash[:error] = "Error submitting your campaign; please review and resubmit. Sorry."
      render :new, layout: "form_page"
    end
  end

  def show
    @campaign= Campaign.find(params[:id])
    render layout: "landing_page"
  end

  private
  def campaign_params
    params.require(:campaign).permit(:name, :description, :goal_amount, :region_id, :campaign_category_id, :image,
                                     needs_attributes: [
                                       :user_id, :category_id, :description, :title, :campaign_id, :image
                                     ])
  end
end
