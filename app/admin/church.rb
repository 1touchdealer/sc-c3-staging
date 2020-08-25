ActiveAdmin.register Church do
  menu parent: 'Organizations'

  config.batch_actions = true

  permit_params :name, :contact_email, :logo, :description, :region_id,
    :church_category_id, :approval_state,
    :website_url, :facebook_url, :twitter_url, :gplus_url

  index do
    selectable_column
    id_column
    column :approval_state
    column :name
    column :region
    column :church_category
    column :created_at
    column "Admin Expiration" do |a|
      a.admin_users.present? ? a.admin_users.first.expiration : "No Admin Users"
    end
    column "Logo" do |image|
      image_tag image.logo.url, width: 200 unless image.logo.url.blank?
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :contact_email
      f.input :logo
      f.input :description
      f.input :region
      f.input :website_url
      f.input :facebook_url
      f.input :twitter_url
      f.input :gplus_url
      f.input :church_category, collection: ChurchCategory.order(:name)
      f.input :approval_state, as: :select, collection: ['new', 'approved', 'denied']
    end
    f.actions
  end

  show do |church|
    attributes_table do
      row('Admin User') { |b| b.admin_users.first }
      row('Admin Expiration') { |b| b.admin_users.first.expiration if b.admin_users.first.present? }
      row :name
      row :contact_email
      row :logo do
        image_tag church.logo.url(:medium)
      end
      row :description
      row :region
      row :church_category
      row :website_url
      row :facebook_url
      row :twitter_url
      row :gplus_url
    end
  end

  batch_action :approve do |ids|
    Church.find(ids).each do |church|
      church.approve
      church.save
    end
    redirect_to :back, alert: "Approval(s) successful"
  end
end
