class AboutParagraph < ActiveRecord::Base
  belongs_to :about_category

  has_attached_file :image, styles: { medium: "150x150>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :title, :text, presence: true
end
