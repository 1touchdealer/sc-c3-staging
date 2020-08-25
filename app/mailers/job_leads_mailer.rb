class JobLeadsMailer < ActionMailer::Base

  def new_job_lead(job_lead)
    @job_lead = job_lead
    attachments[@job_lead.resume_file_name] = @job_lead.resume.path if @job_lead.resume.present?
    mail(from: 'support@sc-c3.org', to: 'support@sc-c3.org', subject: 'Job Lead')
  end

end