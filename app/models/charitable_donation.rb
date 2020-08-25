class CharitableDonation < ActiveRecord::Base
  belongs_to :charity, polymorphic: true
  belongs_to :user

  validates :donation_amount, presence: true
  validates :donation_amount, numericality: { only_integer: true, greater_than: 0 }

  def charity_name
    if self.charity_type == 'Alliance'
      return Alliance.find(self.charity_id).name
    else
      return Church.find(self.charity_id).name
    end
  end
end
