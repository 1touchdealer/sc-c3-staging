class AddWorkflowStateToAbCs < ActiveRecord::Migration
  def change
    add_column :alliances, :approval_state, :string, :default => "new"
    add_column :businesses, :approval_state, :string, :default => "new"
    add_column :churches, :approval_state, :string, :default => "new"
  end
end
