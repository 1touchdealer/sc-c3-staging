ActiveAdmin.register Region do
  permit_params :name, :lon, :lat

  index do
    column :name
    column :lon
    column :lat
    column :created_at
    column :updated_at
    actions
  end

  filter :name

  config.per_page = 20

  form do |f|
    f.inputs do
      f.input :name
      f.input :lon, as: :number
      f.input :lat, as: :number
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :lon
      row :lat
      row :created_at
      row :updated_at
    end
  end
end
