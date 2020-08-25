class JobLead < ActiveRecord::Base
  belongs_to :user
  has_attached_file :resume
  validates_attachment_content_type :resume, content_type:
      %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)
  validates_attachment_file_name :resume, matches: [/.(pdf|(docx?)|odt)\z/]
  validates :user, :name, :email, :profession_title, presence: true


  after_create :send_to_support


  private
  def send_to_support
    SendNewJobLeadJob.perform_later(self)
  end
  
end
