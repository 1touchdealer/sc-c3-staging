class DownloadBadgesPdfsController < ApplicationController
  def show
      respond_to do |format|
        format.pdf { send_event_badges_pdf }

        # if Rails.env.development?
        #   format.html { render_sample_html }
        # end
      end
    end

    private

    def event_badges_pdf
      event = Event.find(params[:event_id])
      EventBadgesPdf.new(event)
    end

    def send_event_badges_pdf
      send_file event_badges_pdf.to_pdf,
        filename: event_badges_pdf.filename,
        type: "application/pdf",
        disposition: "inline"
    end

    def render_sample_html
      event = Event.find(params[:event_id])
      render template: "events/badges_pdf", layout: "event_badges_pdf", locals: { event: event }
    end

    # def download_attendees
    # end
end
