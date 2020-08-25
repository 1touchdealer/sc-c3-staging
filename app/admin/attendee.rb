ActiveAdmin.register Attendee do

  permit_params :event_id, :user_id, :name, :email, :attendance_level_id, :paid, :charge_id, :card_token

  index do
    selectable_column
    id_column
    column :event
    column :name
    column :email
    column :inviting
    column :paid
    column :attendance_level do |attendee|
      level = attendee.attendance_level
      [level.try(:name), number_to_currency(level.try :cost)].compact.join ', '
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :user
      f.input :email
      f.input :event
      f.input :inviting
      f.input :attendance_level
      f.input :paid
    end
    f.actions
  end
end
