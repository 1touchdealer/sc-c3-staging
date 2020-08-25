ActiveAdmin.register CharlestonMasterMember do
  menu parent: 'Users'

  index do
	  column :email
	  column :first_name
	  column :last_name
	  column :status
	  column :date_added
	  column :last_changed
	 end
end