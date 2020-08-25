class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :attendance_level
  belongs_to :inviting, class_name: 'Attendee'
  has_many :invitees, class_name:  'Attendee', foreign_key: :inviting_id

  accepts_nested_attributes_for :invitees

  before_create :set_fields, if: Proc.new{ |attendee| attendee.inviting.present? }

  after_create :add_to_mailing_list

  validates :email, uniqueness: { scope: :event , message: 'Attendee with this email has already been created for this event.' }, allow_blank: true

  def is_paid?
    paid? || inviting.try(:paid?) ? 'Yes' : 'No'
  end

  def seats_count
    invitees.count + 1
  end

  private
  def set_fields
    self.attendance_level_id = inviting.try(:attendance_level_id)
    self.event_id = inviting.try(:event_id)
  end

  def add_to_mailing_list
    SubscribeUserToMailingListJob.perform_later(email: self.email, name: self.name)
  end

end
