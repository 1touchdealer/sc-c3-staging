class JobLeadsController < ApplicationController
  layout  "landing_page"
  before_filter :authenticate_user!


  def new
    if current_user.job_lead
      flash[:error] = 'You have already submitted a Job Lead'
      redirect_to root_path and return
    else
      @job_lead = JobLead.new(user: current_user)
    end
  end


  def create
    @job_lead = JobLead.new(job_lead_params)
    if @job_lead.save
      redirect_to tool_boxes_path, notice: 'Job Lead successfully submitted!'
    else
      render :new
    end
  end

  private
  def job_lead_params
    params.require(:job_lead).permit(:email, :name, :profession_title, :user_id, :resume)
  end

end