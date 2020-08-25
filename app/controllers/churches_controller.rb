class ChurchesController < ApplicationController
  def index
    scope = User.joins(:roles,:church).where("roles.name = ? AND users.expiration >= ? AND churches.approval_state = ?", "church_admin", Date.today, "approved").map(&:church)
    if params[:search]
      @churches = User.joins(:roles,:church).where("roles.name = ? AND users.expiration >= ? AND churches.approval_state = ? AND churches.name ILIKE ?", "church_admin", Date.today, "approved", "%#{params[:search]}%").map(&:church)
    elsif params[:category_search]
      @churches = User.joins(:roles,:church).where("roles.name = ? AND users.expiration >= ? AND churches.approval_state = ? AND churches.church_category_id = ?", "church_admin", Date.today, "approved", params[:category_search]).map(&:church)
    elsif params[:region_search]
      @churches = User.joins(:roles,:church).where("roles.name = ? AND users.expiration >= ? AND churches.approval_state = ? AND churches.region_id = ?", "church_admin", Date.today, "approved", params[:region_search]).map(&:church)
    else
      @churches = scope
    end
    render layout: "landing_page"
  end

  def show
    @church = Church.find(params[:id])
    @charitable_donation = @church.charitable_donations.new donation_amount: 20
    render layout: "landing_page"
  end

  def edit
    @church = Church.find(params[:id])
    authorize @church
    render layout: "form_page"
  end

  def update
    @church = Church.find(params[:id])
    authorize @church
    if @church.update_attributes(church_params)
     flash[:success] = "Church Updated!"
     redirect_to @church
    else
      render 'edit'
    end
  end

  private
  def church_params
    params.require(:church).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
