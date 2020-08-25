class HomeController < ApplicationController
  def index
    @events = Event.upcoming(7).group_by { |e| e.start.strftime '%B %Y' }
    @campaigns = Campaign.approved.open.limit(4)
    @businesses = Business.where('logo_file_name is not null').
      order('random()').
      limit(12)
    @about_categories = AboutCategory.includes(:about_paragraphs).order(:position)
    render layout: "landing_page"

    gibbon = Gibbon::Request.new
    # gibbon.lists.retrieve

  end

  def save_docs
    file = Rails.root.join('db', 'docs', "#{params[:file_name]}")
    File.open(file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'),
                filename: params[:file_name],
                disposition: 'attachment'
    end
  end
end
