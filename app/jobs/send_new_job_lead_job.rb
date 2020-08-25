class SendNewJobLeadJob < ActiveJob::Base
  queue_as :default

  def perform(job_lead)
    JobLeadsMailer.new_job_lead(job_lead).deliver
  end

end