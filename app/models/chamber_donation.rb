class ChamberDonation < ActiveRecord::Base
  validates :donation_amount, presence: true
  validates :donation_amount, numericality: { only_integer: true, greater_than: 0 }

  def charity_name
    "SC Chamber of Commerce"
  end
end
