class ToolBoxResource < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_attached_file :document
  validates_attachment_content_type :document, content_type: ["application/pdf",
              "application/vnd.ms-excel",
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              "application/msword", 
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
              "text/plain"]

  scope :city_director, -> { where(category: 'City Director') }
  scope :document_exist, -> { where.not(document_file_name: nil) }
end
