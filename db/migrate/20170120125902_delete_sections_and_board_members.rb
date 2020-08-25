class DeleteSectionsAndBoardMembers < ActiveRecord::Migration
  def change
    drop_table :sections
    drop_table :board_members
  end
end
