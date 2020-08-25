class AttendanceLevel < ActiveRecord::Base
  belongs_to :event
  has_many :attendees

  def name_with_cost
    self.name.to_s +  "    ($" + self.cost.to_s + ")"
  end
end
