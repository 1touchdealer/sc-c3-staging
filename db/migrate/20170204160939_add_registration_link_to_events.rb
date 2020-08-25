class AddRegistrationLinkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_url, :string
  end
end
