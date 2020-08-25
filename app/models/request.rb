class Request < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :need
  belongs_to :resource
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :need_id, :resource_id, presence: true

  after_create :send_request_created_emails

  def send_request_created_emails
    CreativeChatterMailer.send_request_created_email_to_resource_owner(self).deliver
    CreativeChatterMailer.send_request_created_email_to_need_owner(self).deliver
  end

  def send_accepted_emails
    CreativeChatterMailer.send_request_accepted_email_to_resource_owner(self).deliver
    CreativeChatterMailer.send_request_accepted_email_to_need_owner(self).deliver
  end

  def send_declined_emails
    CreativeChatterMailer.send_request_declined_email_to_resource_owner(self).deliver
    CreativeChatterMailer.send_request_declined_email_to_need_owner(self).deliver
  end

  def send_cancelled_emails
    CreativeChatterMailer.send_request_cancelled_email_to_resource_owner(self).deliver
    CreativeChatterMailer.send_request_cancelled_email_to_need_owner(self).deliver
  end

  aasm :workflow_state do
    state :open, initial: true
    state :accepted, after_enter: :send_accepted_emails
    state :declined, after_enter: :send_declined_emails
    state :cancelled, after_enter: :send_cancelled_emails

    event :accept do
      transitions from: :open, to: :accepted
    end

    event :decline do
      transitions from: :open, to: :declined
    end

    event :cancel do
      transitions from: :open, to: :cancelled
    end
  end
end
