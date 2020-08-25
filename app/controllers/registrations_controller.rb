class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new_alliance
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def new_business
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def new_church
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def create
    build_resource(sign_up_params)

    yield resource if block_given?

    if params[:user][:member_type].eql?("alliance")
      role = Role.alliance_admin
      action = :new_alliance
    elsif params[:user][:member_type].eql?("business")
      role = Role.business_admin
      action = :new_business
    elsif params[:user][:member_type].eql?("church")
      role = Role.church_admin
      action = :new_church
    else
      role = Role.member
      action = :new
    end

    resource.save

    if resource.persisted?
      resource.roles << role
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, action: action
    end
  end

  def edit_alliance
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def edit_business
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def edit_church
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  def update
    if sign_up_params.include?(:alliance_attributes)
      #-- Get location from alliance
      abc = params[:user][:alliance_attributes]
      action = :edit_alliance
    elsif sign_up_params.include?(:business_attributes)
      #-- Get location from alliance
      abc = params[:user][:business_attributes]
      action = :edit_business
    elsif sign_up_params.include?(:church_attributes)
      #-- Get location from alliance
      abc = params[:user][:church_attributes]
      action = :edit_church
    else
      action = :edit
    end

    #-- Check if user is a member or ABC admin
    if abc.present? and abc[:locations_attributes]

      #-- Set location for user to be identical to first or primary alliance address
      resource.address_line1 = abc[:locations_attributes]["0"][:address_line1]
      resource.address_line2 = abc[:locations_attributes]["0"][:address_line2]
      resource.address_city  = abc[:locations_attributes]["0"][:address_city]
      resource.address_state = abc[:locations_attributes]["0"][:address_state]
      resource.address_zip   = abc[:locations_attributes]["0"][:address_zip]
      resource.region_id     = abc[:region_id]

    end

    if current_user.update(sign_up_params)
      redirect_to dashboard_path
    else
      respond_with resource, action: action
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [
      :name,
      :member_type,
      :address_line1,
      :address_line2,
      :address_city,
      :address_state,
      :address_zip,
      :region_id,
      :alliance_id,
      :business_id,
      :church_id,
      :terms_accepted,
      :covenant_accepted,
      alliance_attributes: [:name, :contact_email, :description, :logo, :area_of_interest_id,
        :website_url, :facebook_url, :twitter_url, :gplus_url,
        :region_id, locations_attributes: [:address_line1, :address_line2, :address_city, :address_state, :address_zip]],
      business_attributes: [:name, :contact_email, :description, :logo,
        :website_url, :facebook_url, :twitter_url, :gplus_url,
        :business_category_id, :region_id, locations_attributes: [:address_line1, :address_line2, :address_city, :address_state, :address_zip]],
      church_attributes: [:name, :contact_email, :description, :logo,
        :website_url, :facebook_url, :twitter_url, :gplus_url,
        :church_category_id, :region_id, locations_attributes: [:address_line1, :address_line2, :address_city, :address_state, :address_zip]],
      area_of_interest_ids: []
    ]
  end
end
