class EventsController < ApplicationController
  def new
    @event = current_user.events.new
    render layout: "form_page"
  end

  def create
    if current_user
      @event = current_user.events.new(event_params)
    else
      @event = Event.new(event_params)
    end

    if @event.save
      redirect_to @event, notice: "Event successfully submitted!"
    else
      puts @event.errors.full_messages
      flash[:error] = "Error submitting your Event please review and resubmit. Sorry."
      render :new, layout: "form_page"
    end
  end

  def index
    @events = Event.approved.order(:start)

    if params[:region_search].present?
      @region = Region.find(params[:region_search])
      @events = @events.where('region_id = ?', @region)
    end

    if params[:start_date].present?
      month = params[:start_date].to_date.month;
      year = params[:start_date].to_date.year;
      @events_this_month = @events.where('extract(month from start) = ? and extract(year from start) = ?', month, year)
    else
      @events_this_month = @events.where('extract(month from start) = ? and extract(year from start) = ?', Date.today.month, Date.today.year)
    end
    render layout: "landing_page"
  end

  def show
    @event = Event.find(params[:id]);
    render layout: "landing_page"
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :image, :start, :end, :region_id, :user_id, :registration_url, attendance_levels_attributes: [:name, :cost])
  end
end
