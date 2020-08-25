require 'prawn/labels'

ActiveAdmin.register User do
  menu parent: 'Users'

  config.batch_actions = true

  permit_params :email, :password, :password_confirmation, :name,
    :address_line1, :address_line2, :address_city, :address_state, :address_zip,
    :alliance_id, :business_id, :church_id, :expiration, :region_id, :stripe_user_id, role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :name
    column 'Roles' do |user|
      user.get_roles.join(',')
    end
    column :region
    column :expiration
    column :created_at
    # column :shipping_label_printed
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :region

  form do |f|
    allowed_roles = []
    if current_user.super_admin?
      allowed_roles = Role.all
    end
    if current_user.alliance_admin?
      allowed_roles |= [Role.member, Role.alliance_admin]
    end
    if current_user.business_admin?
      allowed_roles |= [Role.member, Role.business_admin]
    end
    if current_user.church_admin?
      allowed_roles |= [Role.member, Role.church_admin]
    end

    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :name
      f.input :expiration, as: :date_time_picker
      f.input :region
      f.input :stripe_user_id
      f.input :address_line1
      f.input :address_line2
      f.input :address_city
      f.input :address_state
      f.input :address_zip
      f.input :alliance, collection: Alliance.order(:name)
      f.input :business, collection: Business.order(:name)
      f.input :church, collection: Church.order(:name)
      if allowed_roles
        f.input :roles, collection: allowed_roles
      end
    end
    f.actions
  end

  csv do
    column :email
    column :name
    column 'Roles' do |user|
      user.get_roles.join(',')
    end
    column(:region) { |user| user.region.try(:name) }
    column :expiration
    column :address_line1
    column :address_city
    column :address_state
    column :address_zip
    column :created_at
  end

  batch_action :print_shipping_labels do |ids|

    labels = Prawn::Labels.render(ids, :type => "Avery7165",  :shrink_to_fit => true) do |pdf, id|
      user = User.find(id)
      user.shipping_label_printed = true;
      user.save

      logo = Rails.root.join "public", "blue-logo-with-address.jpg"
      pdf.image logo, :fit => [250,200], :position => :left, :vposition => :top
      pdf.text user.try(:name)
      pdf.text user.try(:address_line1)
      pdf.text "#{user.try(:address_city)}, #{user.try(:address_state)} #{user.try(:address_zip)}"
    end

    send_data labels, :filename => "labels.pdf", :type => "application/pdf"

    # redirect_to :back, alert: "Shipping Label(s) successfully created"
  end
end
