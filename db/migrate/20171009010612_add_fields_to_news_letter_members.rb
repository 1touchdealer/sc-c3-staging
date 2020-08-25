class AddFieldsToNewsLetterMembers < ActiveRecord::Migration
  def change
    add_column :news_letter_members, :date_added, :datetime
    add_column :news_letter_members, :last_changed, :datetime
  end
end
