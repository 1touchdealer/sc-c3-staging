ActiveAdmin.register Category do
  menu parent: 'NonProfit Entities'

  permit_params :name, :active

  actions :all, :except => [:destroy]

  controller do
    def scoped_collection
      Category.unscoped.order('name ASC')
    end
    def resource
      params[:id] ? Category.unscoped.where(:id => params[:id]).first : Category.new
    end
  end

  index do
    column :name
    column :ancestry
    column :active
    column :created_at
    column :updated_at
    actions
  end

  filter :name

  config.per_page = 20

  form do |f|
    f.inputs 'Warning' do
      '<p>Please do not change Category Names once they have been assigned to Resources or Needs.' \
      '<br>This could cause matching issues.' \
      '<br>Thanks!</p>'.html_safe
    end

    f.inputs "Category Details" do
      f.input :name
      f.input :active
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :name
      row :ancestry
      row :active
      row :created_at
      row :updated_at
    end
  end
end
