class Alliance < ActiveRecord::Base
  include AASM
  include LastPeriods

  belongs_to :area_of_interest
  belongs_to :region
  has_many :users
  has_many :locations, as: :locationable
  has_many :charitable_donations, as: :charity

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  validates :name, presence: true, if: :user_exist?

  accepts_nested_attributes_for :locations

  aasm :approval_state do
    state :new, initial: true
    state :approved
    state :denied

    event :approve do
      transitions from: [:new], to: :approved
    end
  end

  def admin_users
    users.joins(:user_roles).where user_roles: {role_id: Role.alliance_admin.id}
  end

  def user_exist?
    persisted?
  end
end
