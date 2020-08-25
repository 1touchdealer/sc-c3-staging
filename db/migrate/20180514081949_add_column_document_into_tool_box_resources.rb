class AddColumnDocumentIntoToolBoxResources < ActiveRecord::Migration
  def change
    add_attachment :tool_box_resources, :document
  end
end
