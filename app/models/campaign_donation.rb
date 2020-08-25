class CampaignDonation < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user

  validates :donation_amount, presence: true
  validates :donation_amount, numericality: { only_integer: true, greater_than: 0 }
end
