class AddInvitingIdIntoAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :inviting_id, :integer
  end
end
