module LastPeriods
  extend ActiveSupport::Concern
  included do
    scope :last_month, -> (count = 1) {where(created_at: (Date.today-count.month)..Date.today.end_of_day)}
  end
end