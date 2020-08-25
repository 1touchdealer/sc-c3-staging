class UsersController < ApplicationController
  layout "form_page"
  before_filter :authenticate_user!

  def dashboard
    @user = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    @is_owner = current_user == @user
    @card = current_user.card

    if current_user.region_id.present?
      @local_campaigns = Campaign.where(region_id: current_user.region_id)
    else
      @local_campaigns = Campaign.all
    end

    if current_user.super_admin?
      redirect_to admin_root_path

    elsif @user.alliance_admin?
      @alliance = @user.alliance
      @prefix = 'Alliance'
      @pending_inkind = Resource.joins(:campaign).where(campaigns: {user_id: @alliance.admin_users})
      @total_funds_raised = @alliance.charitable_donations.sum(:donation_amount)
      @total_funds_raised += CampaignDonation.joins(:campaign).where(campaigns: {user_id: @alliance.admin_users.ids}).sum(:donation_amount)
      @active_campaigns = Campaign.where(user_id: @alliance.admin_users.ids)
      render "users/dashboard/alliance_admin"

    elsif @user.business_admin?
      @business = @user.business
      @prefix = 'Business'
      @pending_inkind = Resource.joins(:campaign).where(campaigns: {user_id: @business.admin_users})
      @inkind_donations = Resource.where(user_id: @business.users.ids)
      @campaign_donations = CampaignDonation.where(user_id: @business.users.ids)
      @charitable_donations = CharitableDonation.where(user_id: @business.users.ids)
      @active_campaigns = Campaign.where(user_id: @business.admin_users.ids)
      render "users/dashboard/business_admin"

    elsif @user.church_admin?
      @church = @user.church
      @prefix = 'Church'
      @pending_inkind = Resource.joins(:campaign).where(campaigns: {user_id: @church.admin_users})
      @total_funds_raised = @church.charitable_donations.sum(:donation_amount)
      @total_funds_raised += CampaignDonation.joins(:campaign).where(campaigns: {user_id: @church.admin_users.ids}).sum(:donation_amount)
      @active_campaigns = Campaign.where(user_id: @church.admin_users.ids)
      render "users/dashboard/church_admin"

    elsif @user.member?
      @matched_alliances = Alliance.where(area_of_interest: current_user.areas_of_interest.ids)
      @active_campaigns = Campaign.where(user_id: current_user.id)
      render "users/dashboard/member"

    elsif @user.city_director? && params[:user_id].blank?
      redirect_to root_path and return unless current_user.region
      @alliances = Alliance.where(region: current_user.region)
      @businesses = Business.where(region: current_user.region)
      @churches = Church.where(region: current_user.region)
      @events = Event.where(region: current_user.region)
      @users = User.where(region: current_user.region)
      @new_entities = {
        alliances:  @alliances.last_month.count,
        businesses:  @businesses.last_month.count,
        churches: @churches.last_month.count,
        members: @users.last_month.select{|u|u.member?}.count
      }
      @users = @users.select{|u|u.member?}
      render 'users/dashboard/city_director'

    elsif @user.state_director? && params[:user_id].blank?
      redirect_to root_path and return unless current_user.region
      @users = User.joins(:roles).where.not("roles.name = ?","super_admin").where("roles.name = ?","member").order('created_at DESC')
      @alliances = Alliance.all
      @businesses = Business.all
      @churches = Church.all
      @events = Event.all.order('created_at DESC')
      @new_entities = {
          alliances:  @alliances.last_month.count,
          businesses:  @businesses.last_month.count,
          churches: @churches.last_month.count,
          members: @users.last_month.select{|u|u.member?}.count
      }
      render 'users/dashboard/state_director'

    else
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
    render "users/edit"
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      flash[:notice] = 'User account updated successfully'
      redirect_to dashboard_path
    else
      flash[:error] = 'User account not updated; please fix errors and try again'
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :address_line1, :region_id,
      :church_id, :business_id, :alliance_id, :password,
      :current_password, area_of_interest_ids: [])
  end
end
