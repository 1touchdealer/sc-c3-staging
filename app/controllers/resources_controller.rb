class ResourcesController < ApplicationController
  layout "form_page"

  def new
    @need = Need.find(params[:need_id])
    @resource = @need.resources.new
  end

  def create
    @need = Need.find(params[:need_id])
    @resource = @need.resources.new(resource_params)

    if @resource.valid?
      @resource.save
      redirect_to @need.campaign, notice: "Thanks for the contribution!"
    else
      flash[:error] = 'One or more errors in your donation'
      render :new
    end
  end

  def accept
    @resource = Resource.find(params[:id])
    authorize @resource
    @resource.accept
    @resource.save
    redirect_to dashboard_path
  end

  private
  def resource_params
    params.require(:resource).permit(:user_id, :category_id, :title, :description, :image, :value, :contact_email)
  end
end
