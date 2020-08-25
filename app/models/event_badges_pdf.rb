require "render_anywhere"

class EventBadgesPdf
  include RenderAnywhere

  def initialize(event)
    @event = event
  end

  def to_pdf
    kit = PDFKit.new(as_html, page_size: 'Letter',
                              margin_right: '0in',
                              margin_bottom: '0in',
                              margin_left: '0in',
                              margin_top: '0in')
    kit.to_file("#{Rails.root}/public/event.pdf")
  end

  def filename
    "EventBadges-#{event.id}.pdf"
  end

  private

    attr_reader :event

    def as_html
      render template: "events/badges_pdf", layout: "event_badges_pdf", locals: { event: event }
    end
end
