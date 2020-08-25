ActiveAdmin.register Resource do
  menu parent: 'NonProfit Entities'

  permit_params :resourceful_type, :resourceful_id, :category_id, :title,
    :value, :quantity, :quantity_claimed, :description, :workflow_state,
    location_attributes: [
      :name, :address_line1, :address_line2, :address_city, :address_state,
      :address_zip
    ]

  index do
    column 'Owner', :resourceful
    column :category
    column :title
    column :value
    column :created_at
    column 'Status', :workflow_state
    actions
  end

  filter :resourceful_type,
     :label      => 'Owner Type',
     :as         => :select,
     :collection => ['User', 'BusinessSponsor', 'MediaPartner']
  filter :category
  filter :created_at
  filter :workflow_state,
         :label      => 'Status',
         :as         => :select,
         :collection => Resource.aasm(:workflow_state).states.map( &:name )
  filter :value

  config.per_page = 20

  form do |f|
    f.inputs "Resource Details" do
      f.input :resourceful_type,
        as: :hidden,
        input_html: {value: 'User'}
      f.input :resourceful,
        :label      => 'User',
        :as         => :select,
        :collection => User.all.sort_by{ |user| user.display_name.downcase }
      f.input :category
      f.input :title
      f.input :value
      f.input :quantity
      f.input :quantity_claimed
      f.input :description
      f.input :workflow_state,
         :label      => 'Status',
         :as         => :select,
         :collection => Resource.aasm(:workflow_state).states.map( &:name )
      f.inputs 'Location', :for => [:location, f.object.location || Location.new] do |l|
        l.input :name
        l.input :address_line1
        l.input :address_line2
        l.input :address_city
        l.input :address_state
        l.input :address_zip
      end
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :resourceful
      row :category
      row :title
      row :value
      row :quantity
      row :quantity_claimed
      row :description
      row :location
      row :workflow_state
      row :created_at
      row :updated_at
    end
  end
end
