ActiveAdmin.register Ad do

  config.batch_actions = true

  permit_params :image, :region_id, :expiration, :user_id, :approval_state

  index do
    selectable_column
    id_column
    column :image
    column :region_id
    column :user_id
    column :expiration
    column :approval_state
    actions
  end

  form do |f|
    f.inputs do
      f.input :image
      f.input :region
      f.input :user
      f.input :expiration, as: :date_time_picker
      f.input :approval_state, as: :select, collection: ['new', 'approved', 'denied']
    end
    f.actions
  end

  batch_action :approve do |ids|
    Ad.find(ids).each do |ad|
      ad.approve if ad.denied? || ad.new?
      ad.save
    end
    redirect_to :back, alert: "Approval(s) successful"
  end
end
