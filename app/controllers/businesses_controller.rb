class BusinessesController < ApplicationController
  def index
    scope = User.joins(:roles,:business).where("roles.name = ? AND users.expiration >= ? AND businesses.approval_state = ?", "business_admin", Date.today, "approved").map(&:business)
    if params[:search]
      @businesses = User.joins(:roles,:business).where("roles.name = ? AND users.expiration >= ? AND businesses.approval_state = ? AND businesses.name ILIKE ?", "business_admin", Date.today, "approved", "%#{params[:search]}%").map(&:business)
    elsif params[:category_search]
      @businesses = User.joins(:roles,:business).where("roles.name = ? AND users.expiration >= ? AND businesses.approval_state = ? AND businesses.business_category_id = ?", "business_admin", Date.today, "approved", params[:category_search]).map(&:business)
    elsif params[:region_search]
      @businesses = User.joins(:roles,:business).where("roles.name = ? AND users.expiration >= ? AND businesses.approval_state = ? AND businesses.region_id = ?", "business_admin", Date.today, "approved", params[:region_search]).map(&:business)
    else
      @businesses = scope
    end
    render layout: "landing_page"
  end

  def show
    @business= Business.find(params[:id])
    render layout: "landing_page"
  end

  def edit
    @business = Business.find(params[:id])
    authorize @business
    render layout: "form_page"
  end

  def update
    @business = Business.find(params[:id])
    authorize @business
    if @business.update_attributes(business_params)
     flash[:success] = "Business Updated!"
     redirect_to @business
    else
      render 'edit'
    end
  end

  private
  def business_params
    params.require(:business).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
