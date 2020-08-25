class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit

  before_filter :populate_ads
  before_filter :redirect_to_payment

  def after_sign_in_path_for(resource)
    dashboard_path || stored_location_for(resource) || root_path
  end

  def populate_ads
    if current_user.try :region_id
      @regional_ad_urls = Rails.cache.fetch("ads/#{current_user.region_id}", expires_in: 24.hours) do
        Ad.active.all_in_region(current_user.region_id).map { |a| a.image.url(:medium) }
      end
    else
      @regional_ad_urls = Rails.cache.fetch("ads/all", expires_in: 24.hours) do
        Ad.active.map { |a| a.image.url(:medium) }
      end
    end
    @regional_ad_urls.shuffle!
  end

  def redirect_to_payment
    if current_user && !current_user.paid?
      redirect_to new_payment_path
    elsif current_user && !current_user.save && current_user.include_any_edit_action?(params)
      if current_user.roles.first.name.eql?("alliance_admin")
        redirect_to alliance_edit_path 
      elsif current_user.roles.first.name.eql?("business_admin")
        redirect_to business_edit_path
      elsif current_user.roles.first.name.eql?("church_admin")
        redirect_to church_edit_path
      elsif current_user.roles.first.name.eql?("member")
        redirect_to edit_user_registration_path
      end       
    end
  end
end

