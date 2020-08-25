ActiveAdmin.register Campaign do
  menu parent: 'NonProfit Entities'

  config.batch_actions = true

  permit_params :name, :description, :user_id, :goal_amount, :total_amount,
    :expiration_date, :image, :workflow_state, :campaign_category_id, :category,
    :video_link, :approved, :region_id

  index do
    selectable_column
    id_column
    column :name
    column :user
    column :region
    column :goal_amount
    column :total_amount
    column :workflow_state
    column :expiration_date
    column :approved
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :user
      f.input :region
      f.input :goal_amount
      f.input :total_amount
      f.input :expiration_date, as: :datepicker
      f.input :image
      f.input :workflow_state, collection: %w(open successful)
      f.input :campaign_category
      f.input :category
      f.input :video_link
      f.input :approved
    end
    f.actions
  end

  batch_action :approve do |ids|
    Campaign.find(ids).each do |camp|
      camp.approved = true unless camp.approved?;
      camp.save
    end
    redirect_to :back, alert: "Approval(s) successful"
  end
end
