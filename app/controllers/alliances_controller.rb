class AlliancesController < ApplicationController
  def index
    scope = User.joins(:roles,:alliance).where("roles.name = ? AND users.expiration >= ? AND alliances.approval_state = ?", "alliance_admin", Date.today, "approved").map(&:alliance)
    if params[:search]
      @alliances = User.joins(:roles,:alliance).where("roles.name = ? AND users.expiration >= ? AND alliances.approval_state = ? AND alliances.name ILIKE ?", "alliance_admin", Date.today, "approved", "%#{params[:search]}%").map(&:alliance)
    elsif params[:category_search]
      @alliances = User.joins(:roles,:alliance).where("roles.name = ? AND users.expiration >= ? AND alliances.approval_state = ? AND alliances.area_of_interest_id = ?", "alliance_admin", Date.today, "approved", params[:category_search]).map(&:alliance)
    elsif params[:region_search]
      @alliances = User.joins(:roles,:alliance).where("roles.name = ? AND users.expiration >= ? AND alliances.approval_state = ? AND alliances.region_id = ?", "alliance_admin", Date.today, "approved", params[:region_search]).map(&:alliance)
    else
      @alliances = scope
    end
    render layout: "landing_page"
  end

  def show
    @alliance = Alliance.find(params[:id])
    @charitable_donation = @alliance.charitable_donations.new donation_amount: 20
    render layout: "landing_page"
  end

  def edit
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    render layout: "form_page"
  end

  def update
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    if @alliance.update_attributes(alliance_params)
     flash[:success] = "Alliance Updated!"
     redirect_to @alliance
    else
      render 'edit'
    end
  end

  private
  def alliance_params
    params.require(:alliance).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
