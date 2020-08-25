ActiveAdmin.register ToolBoxResource do
  menu parent: 'Tool Box'

  permit_params :title, :category, :link, :image, :document

  index do
    selectable_column
    id_column
    column :title
    column :category
    column :link
    column "Image" do |tbr|
      image_tag tbr.image.url, width: 200 unless tbr.image.blank?
    end
    column "Document" do |tbr|
      if tbr.document.present?
        link_to tbr.document_file_name, tbr.document.url, target: "_blank"
      else
        "Not present"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Tool Box Resource Details" do
      f.input :title
      f.input :category, as: :select, collection: ['City Director', 'Faith', 'Community']
      f.input :link
      f.input :image
      f.input :document
    end
    f.actions
  end

  show do |tbr|
    attributes_table do
      row :title
      row :category
      row :link
      row :image do
        image_tag tbr.image.url(:medium)
      end
      row :document do
        if tbr.document.present?
          link_to tbr.document_file_name, tbr.document.url, target: "_blank"
        else
          "Not present"
        end
      end
    end
  end
end
