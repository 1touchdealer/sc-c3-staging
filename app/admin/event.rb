ActiveAdmin.register Event do
  permit_params :name, :user_id, :description, :image, :start, :end, :region_id, :approved, :registration_url, attendance_levels_attributes: [:id, :name, :cost, :_destroy]

  config.batch_actions = true

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :end
    column :region
    column :approved
    column "Download Badges" do |event|
      link_to "Download PDF", event_download_badges_pdf_path(event, format: "pdf"), target: "_blank", class: "download_badges_pdfs"
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :description
      f.input :image
      f.input :start, as: :date_time_picker
      f.input :end,  as: :date_time_picker
      f.input :region
      f.input :registration_url
      f.input :approved
      f.has_many :attendance_levels, allow_destroy: true, new_record: 'Add Ticket' do |b|
        b.input :name
        b.input :cost
      end
      f.input :user_id, :input_html => { :value => current_user.id}, as: :hidden

    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :image do
        image_tag event.image.url
      end
      row :description
      row :start
      row :end
      row :created_at
      row :approved
      row :user
      row :registration_url

    end

    panel "Ticket Types:" do
      table_for event.attendance_levels do
        column :name
        column :cost
      end
    end

    panel "Attendees:" do
      table_for event.attendees do
        column :name
        column :email
        column :inviting
        column :paid
        column :attendance_level do |attendee|
          level = attendee.attendance_level
          [level.try(:name), number_to_currency(level.try :cost)].compact.join ', '
        end
        column '' do |attendee|
          link_to 'Delete', admin_attendee_path(attendee), method: :delete, confirm: 'Are you sure?'
        end
      end
    end
  end


  batch_action :approve do |ids|
    Event.find(ids).each do |event|
      event.approved = true unless event.approved?;
      event.save
    end
    redirect_to :back, alert: "Approval(s) successful"
  end
end
