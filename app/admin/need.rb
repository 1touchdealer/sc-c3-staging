ActiveAdmin.register Need do
  menu parent: 'NonProfit Entities'

  permit_params :user_id, :category_id, :organization_id, :organization_type,
    :title, :description, :workflow_state, location_attributes: [
      :name, :address_line1, :address_line2, :address_city, :address_state,
      :address_zip
    ]

  index do
    column :user_id
    column :category
    column :organization
    column :title
    column :created_at
    column 'Status', :workflow_state
    actions
  end

  # filter :user
  filter :category
  filter :organization
  filter :created_at
  filter :workflow_state,
         :label      => 'Status',
         :as         => :select,
         :collection => Need.aasm(:workflow_state).states.map( &:name )

  config.per_page = 20

  form do |f|
    f.inputs "Need Details" do
      f.input :user_id
        # :collection => User.all.sort_by{ |user| user.display_name.downcase }
      f.input :category_id
      # f.input :organization,
      #   :collection => [
      #     Alliance.order(:name),
      #     Business.order(:name),
      #     Church.order(:name)
      #   ].flatten
      f.input :title
      f.input :description
      f.input :workflow_state,
         :label      => 'Status',
         :as         => :select,
         :collection => Need.aasm(:workflow_state).states.map( &:name )
      # f.inputs "Location", :for => [:location, f.object.location || Location.new] do |l|
      #   l.input :name
        # l.input :address_line1
        # l.input :address_line2
        # l.input :address_city
        # l.input :address_state
        # l.input :address_zip
      # end
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :user
      row :category
      row :organization
      row :title
      row :description
      row :location
      row :created_at
      row :updated_at
      row :workflow_state
      row :created_at
      row :updated_at
    end
  end
end
